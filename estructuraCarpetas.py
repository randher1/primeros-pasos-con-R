import os

def crear_estructura_carpetas(datos_espaciales=False, aplicacion_web=False):
    estructura = {
        'Data': {
            'db': {
                'Originales': None,
                'Procesados': None
            },
            'shapefiles': None
        } if datos_espaciales else {'Data': {'db': {'Originales': None, 'Procesados': None}}},
        'Presentacion': {
            'Informes': None,  # Modificado para crear subcarpetas para informes
            'pdf': None,
            'web': None
        } if aplicacion_web else {'Presentacion': {'Informes': None, 'pdf': None}},
        'Resultados': {
            'img': None,
            'pdf': None
        },
        'Scripts': None
    }

    for carpeta_padre, subcarpetas in estructura.items():
        ruta_carpeta_padre = os.path.join(os.getcwd(), carpeta_padre)
        os.makedirs(ruta_carpeta_padre, exist_ok=True)
        if subcarpetas:
            crear_subcarpetas(ruta_carpeta_padre, subcarpetas)

    # Crear el archivo README.md en la raíz del proyecto
    with open(os.path.join(os.getcwd(), 'README.md'), 'w') as readme:
        readme.write("# Descripción\n\nEste es el directorio principal del proyecto.")

def crear_subcarpetas(ruta_padre, subcarpetas):
    for subcarpeta, contenido in subcarpetas.items():
        ruta_subcarpeta = os.path.join(ruta_padre, subcarpeta)
        os.makedirs(ruta_subcarpeta, exist_ok=True)
        if contenido:
            crear_subcarpetas(ruta_subcarpeta, contenido)

def agregar_codigo_tex(nombre_informe, nombre_autor, correo_autor, descripcion_autor):
    codigo_tex = f"""\\documentclass[12pt,a4paper]{{article}}
\\usepackage[left=2.54cm, right=2.54cm, top=2.54cm, bottom=2.54cm]{{geometry}}
\\usepackage[utf8]{{inputenc}}
\\usepackage[T1]{{fontenc}}
\\usepackage[spanish,es-tabla]{{babel}}
\\usepackage{{booktabs}}
\\usepackage{{svg}}
\\usepackage{{amsmath}}
\\usepackage{{amsfonts}}
\\usepackage{{amssymb}}
\\usepackage{{graphicx}}
\\usepackage{{multicol}}
\\usepackage{{changepage}}
\\usepackage{{float}}
\\usepackage{{url}}
\\usepackage{{natbib}}
\\usepackage{{multicol}}
\\usepackage{{color}}
\\usepackage[sc]{{mathpazo}}
\\usepackage{{multicol}}
\\usepackage{{titling}}
\\usepackage{{titlesec}}
\\usepackage{{listings}}
\\usepackage{{ragged2e}} % Añade el paquete ragged2e
\\graphicspath{{./imagenes/}}
\\DeclareGraphicsExtensions{{.eps}}
\\usepackage[colorlinks = true,
linkcolor = black,
urlcolor = blue,
citecolor = black ]{{hyperref}}
\\renewcommand{{\\bibname}}{{Bibliografía}}
\\renewcommand{{\\baselinestretch}}{{1.5}}

\\setlength{{\\droptitle}}{{-4.5\\baselineskip}}
\\title{{   \\begin{{center}}\\rule{{0.9\\textwidth}}{{0.1mm}} \\end{{center}}
    {{\\Huge\\textbf{{{nombre_informe}}}}}
    \\begin{{center}}\\rule{{0.9\\textwidth}}{{0.1mm}} \\end{{center}}
}}
\\author{{\\textsc{{{nombre_autor}}}
    \\thanks{{{descripcion_autor}}}\\\\
    \\normalsize 
    \\href{{mailto:{correo_autor}}}{{{correo_autor}}}   
}}

\\begin{{document}}
\\maketitle
\\tableofcontents
\\newpage
\\bibliography{{biblio}}
\\bibliographystyle{{apalike}}     
\\end{{document}}
"""

    ruta_informe = os.path.join(os.getcwd(), 'Presentacion', 'Informes', nombre_informe)
    os.makedirs(ruta_informe, exist_ok=True)  # Asegurar que la carpeta del informe exista

    with open(os.path.join(ruta_informe, f"{nombre_informe}.tex"), 'w') as f:
        f.write(codigo_tex)
    
    # Crear el archivo biblio.bib
    with open(os.path.join(ruta_informe, 'biblio.bib'), 'w') as biblio:
        biblio.write("@article{example,\n")
        biblio.write("  title={Example Title},\n")
        biblio.write("  author={Author},\n")
        biblio.write("  journal={Journal Name},\n")
        biblio.write("  year={2022},\n")
        biblio.write("  volume={1},\n")
        biblio.write("  number={1},\n")
        biblio.write("  pages={1-10},\n")
        biblio.write("}\n")

def main():
    datos_espaciales = input("¿Trabajará con datos espaciales? (si/no): ").lower() == 'si'
    aplicacion_web = input("¿Realizará algún tipo de aplicación web tipo Shiny App? (si/no): ").lower() == 'si'
    
    crear_estructura_carpetas(datos_espaciales, aplicacion_web)

    crear_informe = input("¿Desea crear un informe en formato Latex? (si/no): ").lower()
    if crear_informe == 'si':
        nombre_informe = input("Ingrese el nombre del informe: ")
        nombre_autor = input("Ingrese el nombre del autor: ")
        correo_autor = input("Ingrese el correo del autor: ")
        descripcion_autor = input("Ingrese la descripción del autor: ")
        agregar_codigo_tex(nombre_informe, nombre_autor, correo_autor, descripcion_autor)

if __name__ == "__main__":
    main()

