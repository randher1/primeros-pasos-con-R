# Instalar y cargar el paquetes
require(pacman)
pacman::p_load(rpart, rattle, rpart.plot)
rm(list = ls())
#configurar las opciones, elimina la notación científica
options(scipen = 999)


# Cargar el conjunto de datos
datos <- read.csv("Data/db/Originales/datos_alumnos.csv")

#Crear modelo de clasificación
arbol <- rpart(
  formula = estado ~ sexo + edad,
  data = datos,
  method = "class"

)
# graficar modelo
fancyRpartPlot(arbol)

 

# Ajustar los parámetros de control para permitir más divisiones
control_arbol <- rpart.control(minsplit = 2, cp = 0.00001, maxdepth = 30)

# Crear el modelo de árbol de decisión con los parámetros de control ajustados
arbol <- rpart(estado ~ sexo + edad, 
               data = datos, 
               method = "class", 
               control = control_arbol)

fancyRpartPlot(arbol)


# Crear un archivo SVG para guardar el gráfico con resolución Full HD
svg_filename <- "Resultados/img/arbol_decision.svg"
svg(file = svg_filename, width = 1920 / 72, height = 1080 / 72)

# Generar el gráfico con fancyRpartPlot()
fancyRpartPlot(arbol)

# Cerrar el dispositivo gráfico para guardar el archivo SVG
dev.off()



pred_arbol <- predict(arbol, type = "class")


datos_pred <- cbind(datos,pred_arbol)


predict(object = arbol,
        newdata = data.frame(edad=20, sexo="female"),
        type = "class")


