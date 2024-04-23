require(pacman)
pacman::p_load(ggplot2, tsibble, dplyr, lubridate)
rm(list = ls())
options(scipen = 999)

# Cargar archivo de Excel (requiere el paquete 'readxl')
data_gasolina <- read.csv("Data/db/Originales/gasolina-300.csv", sep=";")
mtcars <- mtcars


#Función para guardar graficos de diferentes ext

guardar_grafico <- function(grafico) {
  formatos <- c("ps", "svg", "pdf")  # Lista de formatos de archivo
  
  nombre_archivo_base <- deparse(substitute(grafico))  # Obtener el nombre del gráfico
  
  for (formato in formatos) {
    nombre_archivo <- paste0("Resultados/img/", nombre_archivo_base, ".", formato)  # Nombre del archivo con extensión correspondiente
    dispositivo <- switch(formato,
                          "ps" = postscript,
                          "svg" = svg,
                          "pdf" = pdf)
    
    # Abrir dispositivo de salida
    dispositivo(nombre_archivo, width = 11, height = 9)
    
    # Imprimir el gráfico
    print(grafico)  # Asegúrate de imprimir el gráfico
    
    # Cerrar dispositivo de salida
    dev.off()
  }
}




# Estructura
str(data_gasolina)
str(mtcars)


# Convertir la columna 'Mes' a tipo Date
data_gasolina$Mes <- dmy(data_gasolina$Mes)

# Convertir la columna 'Precio' a tipo numérico, reemplazando ',' por '.'
data_gasolina$Precio <- as.numeric(gsub(",", ".", data_gasolina$Precio))

# Crear un objeto tsibble para representar la serie temporal
ts_datos <- as_tsibble(data_gasolina)

# Graficar la serie temporal
ggplot(ts_datos) +
  geom_line(aes(x = Mes, y = Precio))


ggplot(ts_datos) +
  geom_line(aes(x = Mes, y = Precio))+ 
  labs(title = "Serie Temporal de Precios de Gasolina (1.999 - 2.022)",
       x = "Fecha",
       y = "Precio")


max_ocurrencias <- max(ts_datos$Precio)

serie_temporal <-ggplot(ts_datos) +
  geom_line(aes(x = Mes, y = Precio))+
  geom_vline(xintercept = as.Date(c("2008-03-01", 
                                    "2011-10-01",
                                    "2020-03-01")), 
             linetype = "dashed", 
             color = "red") +  # Línea vertical en la fecha específica
  annotate("text", 
           x = as.Date(c("2008-03-01", 
                         "2011-10-01",
                         "2020-03-01")), 
           y = max_ocurrencias + 2, 
           label = c("Crisis económica mundial",
                     "Firma TLC USA-Colombia", 
                     "Inicio COVID-19"), 
           vjust = c(-0.5, 2, -1), 
           hjust = -0.09, 
           color = "black")+
labs(title = "Serie Temporal de Precios de Gasolina (1999 - 2022)",
     x = "Años",
     y = "Miles de pesos (COP) / Galón",
     caption = "Elaboración propia con base a datos de Index Mundi \nAutor: Randolf Herrera (2024)") +
  theme_bw()+
  theme(axis.text.x = element_text(hjust = 1),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),
        text = element_text(size = 16))






#Gráfico de Barras de Precios de Gasolina por Año
ggplot(data_gasolina, aes(x = factor(year(Mes)), y = Precio, 
                          fill = factor(year(Mes)))) +
  geom_bar(stat = "summary", fun = "mean") +
  labs(title = "Precio Promedio de Gasolina por Año",
       x = "Año",
       y = "Precio") +
  theme_minimal()

#gasolina_anual <-
ggplot(data_gasolina, aes(y = factor(year(Mes)), x = Precio)) +
  geom_bar(stat = "summary", fun = "mean", position = "dodge", fill ="lightblue") +  # Usar position = "dodge" para que las barras estén lado a lado
  labs(title = "Precio de Gasolina por Año",
       x = "Precio X Galón",
       y = "Año",
       caption = "Elaboración propia con base a datos de Index Mundi \nAutor: Randolf Herrera (2024)") +  # Cambiar etiquetas de ejes
  theme_minimal()+
  theme(axis.text.x = element_text(hjust = 1),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),
        text = element_text(size = 16))


#Gráfico de Dispersión de Consumo de Gasolina vs. Caballos de Fuerza
ggplot(mtcars, aes(x = hp, y = mpg)) +
  geom_point() +
  labs(title = "Gráfico de Dispersión: Consumo de Gasolina vs. Caballos de Fuerza",
       x = "Caballos de Fuerza",
       y = "Consumo de Gasolina (mpg)") +
  theme_minimal()



# Definir la función para asignar la categoría de potencia
categorizar_potencia <- function(carb) {
  ifelse(carb %in% 1:2, "Bajo Consumo",
         ifelse(carb %in% 3:4, "Mediano Consumo", "Alto Consumo"))
}

# Aplicar la función a la columna "carb" y asignar los resultados a la nueva columna "carb_fact"
mtcars$carb_fact <- categorizar_potencia(mtcars$carb)


# Ajustar el modelo lineal
modelo <- lm(mpg ~ hp, data = mtcars)

# Obtener el resumen del modelo
resumen_modelo <- summary(modelo)

# Extraer los coeficientes del modelo
coeficientes <- resumen_modelo$coefficients

# Formatear los coeficientes en una cadena de texto
coeficientes_texto <- paste("Y =", round(coeficientes[1, 1], 2), "+", 
                            "(",round(coeficientes[2, 1], 2),")")

# Crear el gráfico base
dispersion <-ggplot(mtcars, aes(x = hp, y = mpg)) +
  geom_point(aes(color = carb_fact)) +
  geom_smooth(method = "lm", se = TRUE, color = "blue", fill = "lightblue") +
  annotate("text", x = max(mtcars$hp), y = max(mtcars$mpg), 
           label = coeficientes_texto, hjust = 1, vjust = 1) +
  labs(title = "Consumo de Gasolina vs. Caballos de Fuerza",
       x = "Caballos de Fuerza",
       y = "Consumo de Gasolina (mpg)",
       caption = "Elaboración propia con base a datos de mtcars \nAutor: Randolf Herrera (2024)") +
  theme_minimal() +
  theme(axis.text.x = element_text(hjust = 1),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),
        text = element_text(size = 16)) +
  guides(color = guide_legend(title = "Carburadores"))





guardar_grafico(serie_temporal)
guardar_grafico(dispersion)