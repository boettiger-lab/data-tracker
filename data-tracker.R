dir.create("data/", FALSE)

id <- contenturi::store("ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt", "data/")


path <- contenturi::retrieve(id, registries = "data/")
path

## We could get the GitHub data address and register that to remote registry