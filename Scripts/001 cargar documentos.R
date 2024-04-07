require(pacman)
pacman::p_load(readxl,jsonlite,reticulate)
rm(list = ls())
options(scipen = 999)

# Cargar archivo CSV
datos_csv <- read.csv("Data/db/Originales/ventas.csv", sep = ",")
str(datos_csv)
summary(datos_csv)
citation("base")


# Cargar archivo de Excel (requiere el paquete 'readxl')
datos_excel <- read_excel("Data/db/Originales/ventas.xlsx")

str(datos_excel)
summary(datos_excel)
citation("readxl")

# Cargar archivo de texto plano (txt)
datos_txt <- read.table("Data/db/Originales/ventas.txt", header = TRUE,
                        sep = "\t")

str(datos_txt)
summary(datos_txt)
# Cargar archivo JSON (requiere el paquete 'jsonlite')
datos_json <- fromJSON("Data/db/Originales/ventas.json")
summary(datos_json)
# Convertir la columna de milisegundos a formato POSIXct
datos_json$Fecha <- as.POSIXct(datos_json$Fecha / 10000009, 
                               origin = "2018-01-01:00:00:00")
str(datos_json)
summary(datos_json)
# Formatear la columna de fechas al formato "yyyy-mm-dd"
datos_json$Fecha <- format(datos_json$Fecha, "%Y-%m-%d")


str(datos_json)
summary(datos_json)
citation("jsonlite")
