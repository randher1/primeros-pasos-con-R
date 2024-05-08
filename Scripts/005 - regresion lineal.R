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
               dplyr)

# Eliminar todas las variables en el entorno
rm(list = ls())

# Evitar notación científica en los números grandes
options(scipen = 99999)


#https://www.kaggle.com/datasets/pablobravo73/real-estate-bogota
# Leer los datos del archivo CSV
datos <- read.csv("Data/db/Originales/db - casas/inmuebles_bogota.csv")

# Ver los nombres de las columnas de los datos
colnames(datos)
attach(datos)

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

ols_plot_resid_stud(modelo1_final)+
  labs(title="Residuos estudentizados",
       x="Observación",
       y="Residuos estudentizados eliminados",
       caption = "Fuente: datos de Kaggle (2024)\nAutor: Randolf Herera")+
  theme_classic()+
  theme(axis.text.x = element_text(hjust = 1),
        plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),
        text = element_text(size = 16)) +
  guides(color = guide_legend(title = "Observación"))


