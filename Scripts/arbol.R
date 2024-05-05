library(rpart)
library(rpart.plot)
library(rattle)


# Ajustar los parámetros de control para permitir más divisiones

control_arbol <- rpart.control(minsplit = 2,
                               cp = 0.00001,
                               maxdepth = 30)

#creamos el modelo de decisión con los parametros de control

arbol <- rpart(estado ~sexo + edad,
               data = datos,
               method = "class",
               control = control_arbol)


fancyRpartPlot(arbol)





svg_filename <- "Resultados/img/arbol_decision_normal.pdf"
pdf(file = svg_filename)

# Generar el gráfico con fancyRpartPlot()
plot(arbol, margin = 0.1, compress = TRUE)
text(arbol, cex = 0.6)

# Cerrar el dispositivo gráfico para guardar el archivo SVG
dev.off()
