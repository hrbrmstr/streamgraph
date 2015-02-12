streamgraph is an htmlwidget for making streamgraphs. Planned support for `xts` objects.

[Sample Rmd](http://rpubs.com/hrbrmstr/streamgraph_01)

A streamgraph (or "stream graph") is a type of stacked area graph which is displaced around a central axis, resulting in a flowing, organic shape. Streamgraphs were developed by Lee Byron and popularized by their use in a February 2008 New York Times article on movie box office revenues. ([Wikipedia](http://en.wikipedia.org/wiki/Streamgraph))

The following functions are implemented:

-   `streamgraph` : Create a new streamgraph
-   `sg_axis_x` : Modify streamgraph x axis formatting
-   `sg_axis_y` : Modify streamgraph y axis formatting
-   `sg_colors` : Modify streamgraph colors

### News

-   Version `0.1` released
-   Version `0.2` released - working SVG tooltips; general code cleanup
-   Version `0.2.1` released - ok, working tool tips for realz now

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
  tally(wt=value) %>%
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

    ## [1] "Thu Feb 12 13:59:09 2015"

``` r
test_dir("tests/")
```

    ## basic functionality :
