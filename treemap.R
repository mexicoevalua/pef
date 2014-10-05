### Crea treemaps interactivos para los PEFs de 1980 a 2015
### Los datos fueron tomados de los Decretos del PEF publicados en el DOF
### La libreria interactiva utiliza d3 y se basa en el trabajo de Nathan Yu
### http://flowingdata.com/2014/07/02/jobs-charted-by-state-and-salary/

# Seleccionar directorio de trabajo
setwd("~/Dropbox/Consultoría/micrositios/pef")
# Leer como csv para evitar llegar al tope de memoria
data  <- read.csv("treemap-pef/data/raw/PEF_1980_2015.csv",encoding="utf8",stringsAsFactors=F)
names(data)
table(data$clase_text)
names(data)
str(data)

# Cargar paquetes
install.packages("treemap")
install.packages("rjson")

# Ejemplos de treemap
require(treemap)
treemap(data, index=c("clase_text","ramo"), vSize=
          "X2015", palette="Purples")
treemap(data, index=c("clase_text","ramo"), vSize=
          "X2013", palette="OrRd")
treemap(data, index=c("clase_text","ramo"), vSize=
          "X2001", palette="OrRd")

RColorBrewer::display.brewer.all()
# Simple treemaps
temp  <- names(data)[-1:-4]
for (input in temp){
  png(paste0("charts/tree_for_", input,".png"),width = 800, height = 600, units = "px")
  treemap(data, index=c("clase_text","ramo"), vSize=
            input, palette="Purples")
  dev.off()
} 

### Fix required
# Convertir datos a json
#require(rjson)
data  <- data[,-1,-3]
#sink("treemap-pef/data/data.json")
#toJSON(as.list(data))
#sink()

### Como el método descrito arriba tiene problemas con los caractéres especiales
### Se utilizó el sitio http://www.convertcsv.com/csv-to-json.htm para convertir el archivo a json



