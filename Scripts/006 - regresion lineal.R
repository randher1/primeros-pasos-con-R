# Modelos de precios viviendas en bogotá Colombia
# Con diversas pruebas de especificación econometricas
# Economista: Randolf Herrera R.
# Dudas o comentarios a Discords: https://discord.com/invite/AcAFkgbU


##################### UN ANÁLISIS ECONOMÉTRICO ###############

#################### SIGUIENDO EL METODO CIENTÍFICO ####################################


# 1. Realizaremos análisis estadístico preliminar

#2.  Estimaremos 1 modelo (solo para ámbitos pedagógicos)

#3.  Verificaremos los supuestos econométricos

#4.  Aplicaremos medidas de corrección en caso de existir violaciones econometricas

#5.  Compararemos los modelos

#6.  Reporte econométrico

#7.  Realizaremos pronósticos



# Cargar los paquetes necesarios
require(pacman)
pacman::p_load(ggplot2, olsrr, jtools, moments, lmtest, stargazer,kableExtra,
               PerformanceAnalytics, tseries, psych, car, FinTS, forecast,effects,
               dplyr,FinTS)

# Eliminar todas las variables en el entorno
rm(list = ls())

# Evitar notación científica en los números grandes
options(scipen = 99999)


#https://www.kaggle.com/datasets/pablobravo73/real-estate-bogota
# Leer los datos del archivo CSV
datos <- read.csv("Data/db/Originales/db - casas/inmuebles_bogota.csv")

# Ver los nombres de las columnas de los datos
colnames(datos)


# Eliminar filas con valores NA (no disponibles)
datos <- na.omit(datos)

# Eliminar símbolos de moneda y puntos de miles de la columna 'Valor' y convertirla a numérico
datos$valor_numerico <- gsub("[$.]", "", datos$Valor)
datos$valor_numerico <- as.numeric(datos$valor_numerico)

# Renombrar las columnas de los datos
colnames(datos) <- c("Tipo", "Descripcion", "Habitaciones", "Banos", "Area", 
                     "Barrio", "UPZ", "Valor", "valor_numerico")
datos <- datos[datos$Habitaciones > 0 & datos$Banos > 0 & datos$Area > 0 & datos$valor_numerico > 0, ]

datos <- datos %>% 
  filter(valor_numerico < 200000000) 

#############################  1  ###########################################
################# Estadísticas descriptivas #################################

##### PERCENTILES, QUANTILES, MOMENTOS ESTADÍSTICOS Y CORRELACIÓN #####

summary(datos)
attach(datos)
jarque.bera.test(valor_numerico)
jarque.bera.test(Area)
jarque.bera.test(Banos)
jarque.bera.test(Habitaciones)

chart.Correlation(datos[c(9,3,4,5)])

###############################   2    ########################################
###################### Estimación de modelos ##################################
###############################################################################
###############################################################################
###############################################################################
############## Supuesto de normalidad en los residuos #########################
###############################################################################




# Ajustar un modelo de regresión lineal con 'valor_numerico' como variable dependiente y 'Habitaciones' como variable independiente

modelo1 <- lm(log(valor_numerico) ~ Banos + log(Area)+ Habitaciones, 
              data = datos, na.action = na.omit)





summary(modelo1)





jarque.bera.test(modelo1$residuals)


###############################################################################
##### Identificamos observaciones atípicos (ouliers) ##########################
###############################################################################

outlirs1<-boxplot(modelo1$residuals)

# Contamos cuántos valores atípicos hay
num_outliers1 <-length(outlirs1$out)
# Imprimir el número de valores atípicos
cat("El número de valores atípicos (outliers), en el modelo es de:", num_outliers1)

#  Diagnóstico de outliers
# Los valores absolutos por encima de 3 son problemáticos

ols_plot_resid_stud(modelo1)

################################################################################
########## Eliminamos las observaciones atípicas (outliers) ####################
################################################################################


indices_outliers <- data.frame(outlirs1$out)

# Obtener los índices de fila (números de fila) de indices_outliers
indices_fila <- row.names(indices_outliers)

# Convertir a un vector numérico si es necesario (puede ser un vector de caracteres por defecto)
indices_fila <- as.numeric(indices_fila)

# Imprimir los índices
print(indices_fila)

# indices a eliminar
filas_a_eliminar <- indices_fila

# Filtrar el dataframe para eliminar las filas con los índices especificados
datos_mod <- datos[-filas_a_eliminar, ]



#Nuevo modelo
modelo1_mod <- lm(log(valor_numerico) ~ Banos + log(Area)+ Habitaciones, 
                  data = datos_mod, na.action = na.omit)

summary(modelo1_mod)

jarque.bera.test(modelo1_mod$residuals)

outlirs1_mod<-boxplot(modelo1_mod$residuals)


# Contamos cuántos valores atípicos hay
num_outliers1 <-length(outlirs1_mod$out)
# Imprimir el número de valores atípicos
cat("El número de valores atípicos (outliers) en el modelo es de:", num_outliers1)

ols_plot_resid_stud(modelo1_mod)


# Identificar los valores atípicos restantes
outlirs1_mod <- boxplot(modelo1_mod$residuals)$out

# Combina los valores atípicos restantes
combined_outliers_mod <- c(outlirs1_mod)

# Encontrar los índices de los residuos que coinciden con los valores atípicos combinados
outliers_indices_mod <- which(modelo1_mod$residuals %in% combined_outliers_mod)

# Filtrar el conjunto de datos original eliminando las filas con valores atípicos
datos_mod_final <- datos_mod[-outliers_indices_mod, ]

# Ajustar un nuevo modelo sin los valores atípicos restantes
modelo1_final <- lm(log(valor_numerico) ~ Banos + log(Area) + Habitaciones, 
                    data = datos_mod_final, na.action = na.omit)

# Ver el resumen del nuevo modelo final
summary(modelo1_final)


outlirs1_mod <- boxplot(modelo1_final$residuals)


# Contamos cuántos valores atípicos hay
num_outliers_final <-length(outlirs1_mod$out)
# Imprimir el número de valores atípicos
cat("El número de valores atípicos (outliers) en el modelo es de:", num_outliers_final)



dis <-ols_plot_resid_stud(modelo1_final)+
  labs(title="Residuos estudentizados",
       x="Observación",
       y="Residuos estudentizados eliminados",
       caption = "Fuente: datos de Kaggle (2024)\nAutor: Randolf Herera")+
  theme_classic()+
  theme(axis.text.x = element_text(hjust = 1),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),
        text = element_text(size = 16)) +
  guides(color = guide_legend(title = "Observación"))


#Función para guardar graficos de diferentes ext

guardar_grafico <- function(grafico) {
  formatos <- c("svg", "pdf")  # Lista de formatos de archivo
  
  nombre_archivo_base <- deparse(substitute(grafico))  # Obtener el nombre del gráfico
  
  for (formato in formatos) {
    nombre_archivo <- paste0("Resultados/img/", nombre_archivo_base, ".", formato)  # Nombre del archivo con extensión correspondiente
    dispositivo <- switch(formato,
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

guardar_grafico(dis)



###############################################################################
################## Verificamos otros supuestos ################################
###############################################################################


###############################################################################
################ Supuesto de heterocedasticidad ###############################
###############################################################################
###############################################################################
#               Prueba de No heteroscedasticidad 
#
#             Ho: Existe homocedasticidad o varianza constante en los errores 
#             H1: Existe heteroscedasticidad o varianza distinta
#
#                          Goldfed-Quandt Test
################################################################################

modelo1_final_2 = lm(log(valor_numerico) ~ Banos+Habitaciones, 
                     data = datos_mod_final, na.action = na.omit)

gqtest(modelo1_final)
gqtest(modelo1_final_2)

###############################################################################
#                         Breusch-Pagan 
###############################################################################

bptest(modelo1_final)
bptest(modelo1_final_2)
###############################################################################
#                     White sin términos cruzados
###############################################################################

residuales1<-modelo1_final$residuals^2
residuales2<-modelo1_final_2$residuals^2


LAREA2<-datos_mod_final$Area^2
Banos2<-datos_mod_final$Banos^2
Habitaciones2<-datos_mod_final$Habitaciones^2

white1<-lm(residuales1~LAREA2+Banos2+Habitaciones2)
summary(white1)
linearHypothesis(white1,
                 "LAREA2+Banos2+Habitaciones2=0")


white2<-lm(residuales2~Banos2+Habitaciones2)
summary(white2)
linearHypothesis(white2,
                 "Banos2+Habitaciones2=0")


###############################################################################
#                    Harrison-McCabe test
#                    Ho: Los residuos son homoscedásticos
#                    H1: Los residuos no son homoscedásticos
###############################################################################

hmctest(modelo1_final)
hmctest(modelo1_final_2)

################################################################################
#                SUPUESTO DE NO MULTICOLINEALIDAD 
#                Factor inflacionario de varianza (VIF en inglés)
# no pasar de 10
###############################################################################



vif(modelo1_final)
vif(modelo1_final_2)


################################################################################
#               Especificación matemática del modelo
#             Ho: No existe especificación cuádratica o cúbica en el modelo
#             H1: existe especificación cuádratica o cúbica en el modelo
################################################################################

resettest(modelo1_final , power=2, type="fitted")
resettest(modelo1_final_2 , power=2, type="fitted")

################################################################################
#                 Análisis de arcoiris
#                 Ho: El modelo es lineal (en las variables)
#                 H1: El modelo no es lineal (en las variables)
################################################################################

raintest(modelo1_final)


raintest(modelo1_final_2)


################################################################################
#            Resolviendo problema de heterocedasticidad y especificación
#
#            Mínimos cuadrados ponderados (MCP)
################################################################################

mcp1<-lm(log(valor_numerico)~log(Area)+Banos+Habitaciones+
           I(log(Area)^2), datos_mod_final, weights = 1/log(Area))



mcp2<-lm(log(valor_numerico)~Banos+Habitaciones+
           I(log(Habitaciones)^2), datos_mod_final, weights = 1/Habitaciones)


################################################################################
#                 Estimación robusta de la regresión
################################################################################

norobust1<-lm(log(valor_numerico)~log(Area)+Banos+Habitaciones+
                I(log(Area)^2), datos_mod_final)

norobust2<-lm(log(valor_numerico)~Banos+Habitaciones+
                I(log(Habitaciones)^2), datos_mod_final)

robust1<-coeftest(norobust1, hccm)
robust2<-coeftest(norobust2, hccm) 

robust1
robust2

################################################################################
#          Mínimos cuadrados generalizados factibles (FGLS) 
################################################################################

residuales_r1<-log((norobust1$residuals)^2)
residuales_r2<-log((norobust2$residuals)^2)

mcgf1<-lm(residuales_r1~log(Area)+Banos+Habitaciones+
              I(log(Area)^2), datos_mod_final)


mcgf2<-lm(residuales_r2~Banos+Habitaciones+
              I(log(Habitaciones)^2), datos_mod_final)

################################################################################
#                         FGLS: WLS
################################################################################

w1<-1/exp(fitted(mcgf1))
w2<-1/exp(fitted(mcgf2))

fgls1<-lm(log(valor_numerico)~log(Area)+Banos+Habitaciones+
            I(log(Area)^2), datos_mod_final, weights = w1)
summary(fgls1)


fgls2<-lm(log(valor_numerico)~Banos+Habitaciones+
            I(Habitaciones^2), datos_mod_final, weights = w2)
summary(fgls2)


################################################################################
#                       Comparamos los modelos rivales
################################################################################

################################################################################
#               Razón de verosimilitud
################################################################################

lrtest(fgls1, fgls2)


################################################################################
#                          Precisión en los pronósticos
################################################################################

accuracy(fgls1)
accuracy(fgls2)

################################################################################
#                      Presentación de los modelos
################################################################################


stargazer(modelo1_final, modelo1_final_2, 
          mcp1, mcp2,
          robust1, robust2,
          fgls1, fgls2,
          type="latex",
          title = "Modelos de precios viviendas, dos modelos alternativos",
          dep.var.labels = "Precio de la vivienda",
          intercept.bottom = FALSE,
          column.labels = c("MCO", "MCO", "MCP", "MCP", "MCR", "MCR", "MCGF", 
                            "MCGF"),
          notes= "Elaboración propia")


################################################################################
#                      Realizamos pronósticos
################################################################################



# Para el mejor modelo, hacemos pronósticos

x0<-data.frame(Area=log(300),
               Banos=2,
               Habitaciones=3)
predict(fgls2, x0)           #en escala logarítmica
exp(predict(fgls2, x0))      #en pesos colombianos
quantile(datos_mod_final$valor_numerico,1:9/10)

# pronósticos con intervalos de confianza
exp(predict(fgls2, x0, interval="confidence")) #En pesos colombianos



plot(effect("Banos", fgls2),
     main="Relación entre Banos y precio del inmueble",
     xlab= "Banos",
     ylab= "Log(Precio)")


plot(effect("Habitaciones", fgls2),
     main="Relación entre N° de habitaciones y precio",
     xlab= "N° de Habitaciones",
     ylab= "Log(Precio)")
