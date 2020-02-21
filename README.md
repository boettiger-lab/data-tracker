
<!-- README.md is generated from README.Rmd. Please edit that file -->

# data-tracker

Proof of concept for Content-Identifier Based Registry for streaming
data sources

## Goal

Data at a given URL may change periodically. We want an automated job
that watches the URL and archives each new copy of the data that it
finds, noting the timestamp and file hash. We want the archive copies to
be publically discoverable.

## Process

This repository uses a scheduled CRON job on [GitHub
Actions](https://github.com/boettiger-lab/data-tracker/actions/) to
store the content found at a URL of a possibly dynamic data resource.

The [Action](.github/workflows/rocker.yml) file has 4 steps:

1.  `contenturi::store(url)`. Caches the content to local `data/`
    directory and updates the local registry.
2.  `git push` Commits the `data` dir and pushes it to GitHub, making
    this cache accessible at a public URL
3.  `contenturi::register()`. Register those GitHub URLs in both
    <https://hash-archive.org> and the local registry.
4.  `git push` Commit and push the local `registry.tsv.gz`

Obviously this workflow could be adapted to publish the local content
store and local registry somewhere else, (GitHub Release, AWS S3 bucket,
etc) rather than committing the data file directly to GitHub. That is
just a simple proof of principle.

## Application

We can now query either the local or a remote registry like
\<hash-archive.org\> by either the URL or the content identifier of a
specific version of interest, e.g.:

``` r
library(contenturi)
```

``` r
## look up by URL in the local registry
query("ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt", "data/")
#> # A tibble: 2 x 3
#>   identifier                         source                  date               
#>   <chr>                              <chr>                   <dttm>             
#> 1 hash://sha256/17b81c3c1c4a57e3037… ftp://aftp.cmdl.noaa.g… 2020-02-21 20:20:35
#> 2 hash://sha256/17b81c3c1c4a57e3037… ftp://aftp.cmdl.noaa.g… 2020-02-21 20:53:30
```

``` r
## look up by hash in the local & remote registries
query("hash://sha256/17b81c3c1c4a57e30371eaff008625f407116b38b3d679e547ac8fcbec73e1cb",
      c("https://hash-archive.org", "data/"))
#>                                                                       identifier
#> 1 hash://sha256/17b81c3c1c4a57e30371eaff008625f407116b38b3d679e547ac8fcbec73e1cb
#> 2 hash://sha256/17b81c3c1c4a57e30371eaff008625f407116b38b3d679e547ac8fcbec73e1cb
#> 3 hash://sha256/17b81c3c1c4a57e30371eaff008625f407116b38b3d679e547ac8fcbec73e1cb
#> 4 hash://sha256/17b81c3c1c4a57e30371eaff008625f407116b38b3d679e547ac8fcbec73e1cb
#> 5 hash://sha256/17b81c3c1c4a57e30371eaff008625f407116b38b3d679e547ac8fcbec73e1cb
#> 6 hash://sha256/17b81c3c1c4a57e30371eaff008625f407116b38b3d679e547ac8fcbec73e1cb
#> 7 hash://sha256/17b81c3c1c4a57e30371eaff008625f407116b38b3d679e547ac8fcbec73e1cb
#>                                                                                                                                 source
#> 1 https://github.com/boettiger-lab/data-tracker/raw/master/data/17/b8/17b81c3c1c4a57e30371eaff008625f407116b38b3d679e547ac8fcbec73e1cb
#> 2                                                                          ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt
#> 3                                                         data//17/b8/17b81c3c1c4a57e30371eaff008625f407116b38b3d679e547ac8fcbec73e1cb
#> 4 https://github.com/boettiger-lab/data-tracker/raw/master/data/17/b8/17b81c3c1c4a57e30371eaff008625f407116b38b3d679e547ac8fcbec73e1cb
#> 5                                                                          ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt
#> 6                                                         data//17/b8/17b81c3c1c4a57e30371eaff008625f407116b38b3d679e547ac8fcbec73e1cb
#> 7 https://github.com/boettiger-lab/data-tracker/raw/master/data/17/b8/17b81c3c1c4a57e30371eaff008625f407116b38b3d679e547ac8fcbec73e1cb
#>                  date
#> 1 2020-02-21 19:18:16
#> 2 2020-02-21 20:20:35
#> 3 2020-02-21 20:20:35
#> 4 2020-02-21 20:29:24
#> 5 2020-02-21 20:53:30
#> 6 2020-02-21 20:53:30
#> 7 2020-02-21 20:53:32
```

Note that the query reports sightings of this content at the ftp
address, our published git versions, and the local cache, each with
timestamps.
