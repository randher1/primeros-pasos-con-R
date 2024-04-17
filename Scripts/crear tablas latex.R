# Cargar bibliotecas necesarias

library(stargazer)

# Generar un conjunto de datos hipotético
set.seed(123) # Para reproducibilidad
n <- 100
educ <- rnorm(n, 12, 3) # Variable educación
exper <- rnorm(n, 8, 2) # Variable experiencia
wage <- 5 + 0.5 * educ + 0.2 * exper + rnorm(n, 0, 2) # Variable dependiente wage
wage1 <- data.frame(educ, exper, wage)

# Realizar los tres modelos de regresión lineal
result1 <- lm(wage ~ educ, data = wage1)
result2 <- lm(wage ~ educ + exper, data = wage1)
result3 <- lm(wage ~ educ + I(educ^2) + exper + I(exper^2), data = wage1)



stargazer(result1, result2, result3, 
          header=FALSE,
          type = "latex",
          title="Comparación de modelos",
          keep.stat="n",digits=2, 
          single.row=FALSE,
          intercept.bottom=FALSE)


stargazer(result1, result2, result3, 
          header=FALSE,
          type = "latex",
          title="Comparación de modelos",
          keep.stat="n",
          digits=2, 
          single.row=FALSE,
          intercept.bottom=FALSE,
          notes.label  ="Nota:",
          dep.var.caption="Variable dependiente:",
          dep.var.labels="Salario",
          covariate.labels=c("Educación", 
                             "Educación$^2$", 
                             "Experiencia", "
                             Experiencia$^2$", 
                             "Constante")
)




