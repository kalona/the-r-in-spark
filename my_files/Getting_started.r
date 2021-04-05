
# Set up Sparklyr and Spark

# Check R version

getRversion()

# Check java

# Sys.setenv(JAVA_HOME = "c:/jdk-11.0.10+9");

Sys.setenv(JAVA_HOME = "C:/Program Files/RedHat/java-11-openjdk-11.0.10-1");

system("java -version")

# Install Sparklyr

install.packages("sparklyr")

packageVersion("sparklyr")

# Install Spark

library(sparklyr)

spark_available_versions()

options(spark.install.dir = "./spark-install-3_0")

spark_install("3.0")

spark_installed_versions()

spark_uninstall(version = "3.0.1", hadoop = "3.2")

# Connect to local Spark cluster

library(sparklyr)

options(sparklyr.log.console = TRUE)

sc <- spark_connect(master = "local", version = "3.0")


cars <- copy_to(sc, mtcars)

cars

# Spark Web UI

spark_web(sc)


library(DBI)
dbGetQuery(sc, "SELECT count(*) FROM mtcars")


library(dplyr)
count(mtcars)


select(cars, hp, mpg) %>%
  sample_n(100) %>%
  collect() %>%
  plot(col="blue", type="p")

# Model example

model <- ml_linear_regression(cars, mpg ~ hp)
model


model %>%
  ml_predict(copy_to(sc, data.frame(hp = 250 + 10 * 1:10))) %>%
  transmute(hp = hp, mpg = prediction) %>%
  full_join(select(cars, hp, mpg)) %>%
  collect() %>%
  plot()


# Write and read to files

spark_write_csv(cars, "cars.csv")

cars <- spark_read_csv(sc, "cars.csv")

install.packages("sparklyr.nested")

sparklyr.nested::sdf_nest(cars, hp) %>%
  group_by(cyl) %>%
  summarise(data = collect_list(data))


cars %>% spark_apply(~round(.x))

# Streaming example

dir.create("input")
write.csv(mtcars, "input/cars_1.csv", row.names = F)


stream <- stream_read_csv(sc, "input/") %>%
  select(mpg, cyl, disp) %>%
  stream_write_csv("output/")


dir("output", pattern = ".csv")

write.csv(mtcars, "input/cars_2.csv", row.names = F)

stream_stop(stream)





spark_disconnect(sc)

