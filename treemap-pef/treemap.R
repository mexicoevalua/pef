# Treemaps para el Presupuesto de Egresos de la Federación 1980-2015
# El script organiza los datos y la visualización se hizo con Tableau Public

# Directorio de trabajo
setwd("D:/DATA.IDB/Documents/ME/PEF")

# Cargar datos armonizados que contienen dos series para 96, 97 y 00
data  <- read.csv("PEF_1980_2015.csv", encoding="UTF8",
                  stringsAsFactors=F)

# Reestructurad datos en formato long
head(data)
names(data)
require(reshape2)
temp  <- melt(data, id.vars=c("Clase","Clase_text","RR","RRc","RAMO..MDP.corrientes."),
              variable.name="Year", value.name="mdp")
names(temp)  <- c("clase","clase_texto","rr","rrC","ramo","year","mdp")
temp$year  <- gsub("X","",temp$year)

# Quitar espacios
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
temp$ramo  <- trim(temp$ramo)
temp$clase_texto  <- trim(temp$clase_texto)
temp$mdp  <- gsub(",","",temp$mdp)
temp$mdp  <- as.numeric(temp$mdp)
tail(temp$mdp)

unique(temp$ramo)
unique(temp$clase_texto)

head(temp)
ramos  <- temp
head(ramos)

# Agregar el porcentaje del gasto total que representa cada ramo
tot <- ddply(ramos, c("year"),
              summarize,
              tot = sum(mdp, na.rm=T)
              )
head(tot)
ramos  <- merge(ramos, tot)
head(ramos); tail(ramos)
ramos$pct  <- with(ramos, (mdp/tot)*100)
summary(ramos$pct)

# Agregar PIB a precios corrientes para calcular el % de gasto de acuerdo al
# PIB
source("gdp.R")
head(gdp)
gdp  <- gdp[,-2] # quitar gdp precios constantes

# Unir los dos archivos
ramos  <- merge(ramos, gdp)
head(ramos)

# Calcular gasto por ramo como % del pib
ramos$pctPib <- with(ramos, (mdp/gdpCorriente)*100)
summary(ramos$pctPib)
summary(ramos$pct)
# Exportar datos como csv
write.csv(ramos, "ramos_1980_2015.csv", fileEncoding="UTF8", row.names=F)

# Agregar datos por tipos de ramos para hacer uniformes las series con
# rubros similares

require(plyr)
str(ramos)
ramosRR  <- ddply(ramos, c("rr","year"),
  summarise, mdpRR =sum(mdp, na.rm=T) )
head(ramosRR); tail(ramosRR)


# Agregar nombres de ramos, gasto total y % del pib
head(ramos)
n  <- ramos[,c("rr","ramo")]
n  <- unique(n)
head(n)
ramosRR  <- merge(ramosRR,n)
head(ramosRR)

temp  <- ramos[,c("year","ramo","rr","rrC","tot","gdpCorriente","invPctGdp")]
temp  <- unique(temp)
head(temp); tail(temp)
head(ramosRR)
ramosRR  <- merge(ramosRR,temp, by=c("year","ramo","rr"))
head(ramosRR)
ramosRR$pct  <- with(ramosRR, (mdpRR / tot)*100)
ramosRR$pctGdp  <- with(ramosRR, (mdpRR / gdpCorriente)*100)

# Mantener solo las cabezas de ramo
ramosRR  <- subset(ramosRR, ramosRR$rrC ==1)

subset(ramosRR, rr==20)

# Exportar datos
write.csv(ramos, "ramosRR_1980_2015.csv", fileEncoding="UTF8")
gdp
