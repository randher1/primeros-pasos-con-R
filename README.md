# Primeros pasos con R en el análisis de datos.


<div style="text-align: center;"> 

![Banner Randolf Herrera.](banner.png)

</div>

<div style="text-align: center;"> 

[![Instagram](https://img.shields.io/badge/Instagram-%23E4405F.svg?style=for-the-badge&logo=Instagram&ogoColor=white)](https://www.instagram.com/randolfherrera/)
[![Facebook](https://img.shields.io/badge/Facebook-%231877F2.svg?style=for-the-badge&logo=Facebook&logoColor=white)](https://www.facebook.com/profile.php?id=100089453334909)
[![LinkedIn](https://img.shields.io/badge/linkedin-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/randolf-herrera-rinc%C3%B3n-/)
[![X](https://img.shields.io/badge/X-%23000000.svg?style=for-the-badge&logo=X&logoColor=white)](https://x.com/randolfherrera)
</div>

<a href="https://www.buymeacoffee.com/randherdatascience" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 50px !important;width: 217px !important;" ></a>

En este proyecto contará con una serie de 10 vídeos que abarcaran la parte fundamental del análisis de datos. Dichos vídeos serán los siguientes:



1. [📂🔍 ¡Explorando Datos! Cargando Archivos en R - 01 📊🔌](https://www.youtube.com/watch?v=beltQGIiLmc&t=149s)

2. [📊 Manipulación de datos en R: Transformando y limpiando tu conjunto de datos 🧹 - 02](https://www.youtube.com/watch?v=D8lY3euBz-8)

3. [Dominando la Magia de los Datos con R y ggplot2 📊✨ - 03](https://youtu.be/5EWWG5DvO98)

4. [🌳 Aprende a Crear Árboles de Decisión en R: ¡Domina el Análisis de Datos! 📊 - 04 
](https://youtu.be/aLG1FfhSOrA)


---

Luego de crear tu proyecto de R, te propongo el siguiente la siguiente estructura de carpetas para análisis de datos.


### Creción de las carpetas
1. Descarga en archivo estructuraCarpetas.py
2. Abre una terminal ta sea en Windows, Mac Os o Linux y corre lo siguiente.

```bash
pytohn estructuraCarpetas.py
```
Dependiendo de la estructura de tu proyecto en terminal te harán una serie de preguntas basicas, que seran las siguientes:

- ¿Trabajará con datos espaciales? (si/no):<br>
  en caso de colocar no, no se creara la carpeta SHP
- ¿Realizará algún tipo de aplicación web tipo Shiny App? (si/no): <br>
  en caso de colocar no, no se creara la carpeta web.
- ¿Desea crear un informe en formato Latex? (si/no): <br>
  En caso de colocar si, seguira el flujo de preguntas y creará una carpeta con el nombre que le den al informe y de igual manera, dos archivos uno con extencion .tex de $Latex$ y el correspondente archivo para las citas en $BibTex$, y pedirá lo siguiente.
    
    - Ingrese el nombre del informe:
    - Ingrese el nombre del autor:
    - Ingrese el correo del autor:
    - Ingrese la descripción del autor: (Profesión u ocupación)


En el caso de que haya contestado todas si, se creara una estructura de carpetas como las siguiente:





```
└── 📁primeros pasos con R
    └── 📁Data
        └── 📁db
            └── 📁Originales
            ├── 📁Procesados
        ├── 📁shapefiles
    └── 📁Presentacion
        └── 📁Informes
            └── 📁(nombre de su informe)
                └── (nombre de su informe).tex
                └── biblio.bib
        └── 📁pdf
        ├── 📁web
    └── README.md
    └── 📁Resultados
        └── 📁img
        ├── 📁pdf
    └── 📁Scripts
```