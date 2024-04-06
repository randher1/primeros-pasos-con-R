require(pacman)
pacman::p_load(readxl,jsonlite,reticulate)
rm(list = ls())
options(scipen = 999)

# Cargar archivo CSV
datos_csv <- read.csv("Data/db/Originales/ventas.csv")

citation("base")


# Cargar archivo de Excel (requiere el paquete 'readxl')
datos_excel <- read_excel("Data/db/Originales/ventas.xlsx")

citation("readxl")
# Cargar archivo de texto plano (txt)
datos_txt <- read.table("Data/db/Originales/ventas.txt", header = TRUE,
                        sep = "\t")

# Cargar archivo JSON (requiere el paquete 'jsonlite')
datos_json <- fromJSON("Data/db/Originales/ventas.json")
# Convertir la columna de milisegundos a formato POSIXct
datos_json$Fecha <- as.POSIXct(datos_json$Fecha / 10000009, 
                               origin = "2018-01-01:00:00:00")

# Formatear la columna de fechas al formato "yyyy-mm-dd"
datos_json$Fecha <- format(datos_json$Fecha, "%Y-%m-%d")

citation("jsonlite")
