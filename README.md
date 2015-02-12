streamgraph is an htmlwidget for making streamgraphs. Planned support for `xts` objects and also fixing the tooltip display (doesn't work with the [sample Rmd](http://rpubs.com/hrbrmstr/streamgraph_01))

The following functions are implemented: - `sg_axis_x` Modify streamgraph x axis formatting - `sg_axis_y` Modify streamgraph y axis formatting - `sg_colors` Modify streamgraph colors - `streamgraph` Create a new streamgraph

### News

-   Version 0.1 released

### Installation

``` r
devtools::install_github("hrbrmstr/streamgraph")
```

### Usage

``` r
library(streamgraph)

# current verison
packageVersion("streamgraph")

library(dplyr)

ggplot2::movies %>%
  select(year, Action, Animation, Comedy, Drama, Documentary, Romance, Short) %>%
  tidyr::gather(genre, value, -year) %>%
  group_by(year, genre) %>%
  tally() %>%
  ungroup %>%
  mutate(year=as.Date(sprintf("%d-01-01", year))) -> dat

streamgraph(dat, "genre", "n", "year", interactive=TRUE) %>%
  sg_axis_x(20, "year", "%Y") %>%
  sg_colors("PuOr")
```

### Test Results

``` r
library(streamgraph)
```

    ## Loading required package: htmlwidgets
    ## Loading required package: htmltools

``` r
library(testthat)

date()
```

    ## [1] "Wed Feb 11 22:23:43 2015"

``` r
test_dir("tests/")
```

    ## basic functionality :
