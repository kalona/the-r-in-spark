

install.packages("ggplot2")
install.packages("corrr")
install.packages("dbplot")
install.packages("rmarkdown")


library(sparklyr)
library(dplyr)

spark_install_find()
spark_installed_versions()

sc <- spark_connect(master = "local", version = "3.0")

cars <- copy_to(sc, mtcars)

summarise_all(cars, mean)
