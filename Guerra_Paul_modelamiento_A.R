library(ggplot2)
library(dplyr)
library(ggpubr)

##Importacion de los datos##
data <- read.csv("student-por.csv", header = T, sep = ",")

##Cambio de nombres de las columnas##
colnames(data) <- c("escuela", "sexo", "edad", "zona_residencia", "tamano_familia",
                    "estado_padres", "educacion_madre", "educacion_padre",
                    "trabajo_madre", "trabajo_padre", "motivo_eleccion", "tutor",
                    "tiempo_viaje", "tiempo_estudio", "materias_reprobadas",
                    "apoyo_escolar", "apoyo_familiar", "clases_pagadas",
                    "actividades_extra", "preescolar", "desea_educ_superior",
                    "internet", "relacion_romantica", "relacion_familiar",
                    "tiempo_libre", "salidas_amigos", "alcohol_entre_semana",
                    "alcohol_fin_semana", "salud", "ausencias",
                    "nota_1", "nota_2", "nota_final")

##Exploracion de los datos##
glimpse(data)
summary(data)
sum(is.na(data))

plot(data$nota_2, data$nota_final)
boxplot(data$nota_final)
barplot(table(data$nota_final))

##Correlacion de Pearson##
cor(data$nota_2, data$nota_final)

##Modelo de regresion lineal##
modelo <- lm(nota_final ~ nota_2, data = data)
summary(modelo)

##Supuesto de normalidad##
residuos <- modelo$residuals
shapiro.test(residuos)

ggqqplot(residuos, ylab = "Residuos Modelo")

##Supuesto de homocedasticidad##
plot(modelo$fitted.values, modelo$residuals,
     xlab = "Valores predichos de la nota final",
     ylab = "Residuos",
     main = "Residuos vs. valores predichos")
abline(h = 0, col = "red", lty = 2)

##Grafico de la regresion##
coeficientes <- modelo$coefficients

intercepto <- coeficientes[1]
pendiente <- coeficientes[2]

ecuacion <- paste("y =", round(intercepto, 2), "+", round(pendiente, 2), "x")

ggplot(data, aes(x = nota_2, y = nota_final)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, col = "#FF4040") +
  theme_light() +
  labs(title = "Regresion lineal: nota del segundo periodo y nota final",
       x = "Nota del segundo periodo (0 - 20)",
       y = "Nota final (0 - 20)") +
  annotate("text", x = 4, y = 18, label = ecuacion, color = "blue", size = 4)
