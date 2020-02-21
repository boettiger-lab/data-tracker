
urls <- paste0("https://github.com/boettiger-lab/data-tracker/raw/master/",
               list.files("data", full.names = TRUE, recursive = TRUE))

contenturi::register(urls)
