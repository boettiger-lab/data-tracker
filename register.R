
urls <- paste0("https://github.com/boettiger-lab/data-tracker/raw/master/",
               list.files("store", full.names = TRUE, recursive = TRUE))

lapply(urls, contentid::register, registries = c("https://hash-archive.org", "store/"))
