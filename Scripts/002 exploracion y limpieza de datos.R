# Cargar bibliotecas necesarias
require(pacman)
pacman::p_load(dplyr, kableExtra, knitr)

# Limpiar el entorno y configurar opciones
rm(list = ls())
options(scipen = 999)

# Cargar datos desde un archivo CSV
datos <- read.csv("Data/db/Originales/ventas_con_nan.csv")

# Renombrar columnas
names(datos) <- c("fecha", "empleado", "producto", "cantidad", "precio_unitario")

# Explorar la estructura de los datos
str(datos)

# Función para crear tabla APA a partir de la salida de str()
crear_tabla_apa <- function(str_output) {
  # Identificar las líneas que contienen información sobre las variables
  lineas_variables <- grep("^\\s*\\$\\s*", str_output, value = TRUE)
  
  # Extraer información de las variables
  nombres <- gsub("^\\s*\\$\\s*([^:]+):.*", "\\1", lineas_variables)
  tipos <- gsub("^.*?:\\s*([^[:space:]]+).*", "\\1", lineas_variables)
  ejemplos <- gsub("^.*?:\\s*(.*)", "\\1", lineas_variables)
  
  # Crear tabla
  tabla <- data.frame(
    Variable = nombres,
    Tipo_de_variable = tipos,
    Ejemplo = ejemplos
  )
  
  return(tabla)
}

# Generar tabla APA de descripción de variables
str_output <- capture.output(str(datos))
tabla_apa <- crear_tabla_apa(str_output)

# Imprimir tabla con formato APA
kable(tabla_apa, format = "latex", booktabs = TRUE, 
      caption = "Descripción de variables", 
      col.names = names(tabla_apa)) %>%
  kable_styling(latex_options = "hold_position", full_width = FALSE)

# Resumen de datos
summary(datos)

# Seleccionar columnas relevantes y limpiar datos
datos_seleccionados <- datos[, c("fecha", "empleado", "producto", "cantidad", "precio_unitario")]
datos_limpios <- na.omit(datos_seleccionados)

# convertir el tipo de datos de fecha de caracter a datatime
datos_limpios$fecha <- as.Date(datos_limpios$fecha, format = "%dd/%mm/%YY")

# convertir las cantidades de numeros a enteros
datos_limpios$cantidad <- as.integer(datos_limpios$cantidad)

#convertir los precios unitarios a valores decimales
datos_limpios$precio_unitario <- as.double(datos_limpios$precio_unitario)

# Resumen de datos limpios
summary(datos_limpios)

# Calcular columna de total
datos_limpios <- datos_limpios %>% 
  mutate(total = cantidad * precio_unitario)

# Análisis por empleados
empleados <- datos_limpios %>% 
  group_by(empleado) %>% 
  dplyr::summarise(cantidades = sum(cantidad)) %>% 
  ungroup() %>% 
  arrange(desc(cantidades))

# Imprimir tabla de cantidades vendidas por empleados
kable(empleados, format = "latex", booktabs = TRUE, 
      caption = "Cantidades vendidas por empleados", 
      col.names = names(empleados)) %>%
  kable_styling(latex_options = "hold_position", full_width = FALSE)

# Calcular monto total recaudado por empleado
tota_VXE <- datos_limpios %>% 
  group_by(empleado) %>% 
  summarise(total_cantidades_vendidas = sum(total)) %>% 
  ungroup() %>% 
  arrange(desc(total_cantidades_vendidas))

# Imprimir tabla de monto total recaudado por empleado
kable(tota_VXE, format = "latex", booktabs = TRUE, 
      caption = "Monto total recaudado por empleado", 
      col.names = names(tota_VXE)) %>%
  kable_styling(latex_options = "hold_position", full_width = FALSE)

# Análisis por productos
productos <- datos_limpios %>% 
  group_by(producto) %>% 
  dplyr::summarise(cantidades = sum(cantidad)) %>% 
  ungroup() %>% 
  arrange(desc(cantidades))

# Imprimir tabla de cantidades de productos
kable(productos, format = "latex", booktabs = TRUE, 
      caption = "Cantidad de productos vendidos", 
      col.names = names(productos)) %>%
  kable_styling(latex_options = "hold_position", full_width = FALSE)

# Calcular monto total recaudado por producto
productos_totalizados <- datos_limpios %>% 
  group_by(producto) %>% 
  summarise(total_cantidades_vendidas = sum(total)) %>% 
  ungroup() %>% 
  arrange(desc(total_cantidades_vendidas))

# Imprimir tabla de monto total recaudado por producto
kable(productos_totalizados, format = "latex", booktabs = TRUE, 
      caption = "Monto total recaudado por producto", 
      col.names = names(productos_totalizados)) %>%
  kable_styling(latex_options = "hold_position", full_width = FALSE)

# Calcular totales
totales <- data.frame(
  Categoria = c("Cantidades totales por producto", "Ventas por vendedores"),
  Total = c(
    sum(productos_totalizados$total_cantidades_vendidas),
    sum(tota_VXE$total_cantidades_vendidas)
  )
)

# Imprimir tabla de totales
print(totales)
