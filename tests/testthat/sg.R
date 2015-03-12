library(streamgraph)
library(rvest)
library(magrittr)
library(dplyr)

dat <- read.csv("data/vicstream.csv", stringsAsFactors=FALSE)
dat$week <- as.Date(dat$week, "%m-%d-%Y")
sg <- streamgraph(dat, "victim", "value", "week", interactive=TRUE)

sg %>% sg_axis_x(1) %>% sg_axis_y(0) %>% sg_colors("PuOr")

ggplot2::movies %>%
  select(year, Action, Animation, Comedy, Drama, Documentary, Romance, Short) %>%
  tidyr::gather(genre, value, -year) %>%
  group_by(year, genre) %>%
  tally(wt=value) -> dat

streamgraph(dat, "genre", "n", "year", interactive=TRUE) %>%
  sg_axis_x(20, "year", "%Y") %>%
  sg_colors(palette=NULL, "#1F77B4", "#1F77B4", "black") %>%
  sg_fill_tableau("tableau20") %>%
#   sg_fill_manual(c("red", "#00ff00", rgb(0,0,1))) %>%
#   sg_fill_brewer("Spectral") %>%
  sg_legend(TRUE, "Genre:")

str(ggplot2::movies)

dat <- read.csv("http://bl.ocks.org/mbostock/raw/1134768/crimea.csv")
dat %>%
  mutate(date=as.Date(sprintf("01/%s", dat$date), format="%d/%m/%Y")) %>%
  tidyr::gather(deaths, count, -date) -> dat

streamgraph(dat, "deaths", "count", offset="zero") %>%
  sg_axis_x(tick_interval = 3, tick_format = "%b %y")


ggplot2::movies %>%
  select(year, Action, Animation, Comedy, Drama, Documentary, Romance, Short) %>%
  tidyr::gather(genre, value, -year) %>%
  group_by(year, genre) %>%
  tally(wt=value) %>%
  ungroup %>%
  mutate(year=as.Date(sprintf("%d-01-01", year))) -> dat

streamgraph(dat, "genre", "n", "year", interactive=TRUE) %>%
  sg_axis_x(20, "year", "%Y") %>%
  sg_axis_y(tick_format="b") %>%
  sg_colors("Spectral")

library(streamgraph)
library(rvest)
library(magrittr)
library(dplyr)
library(babynames)
library(tidyr)

babynames %>%
  group_by(year, sex) %>%
  top_n(10, n) -> dat1

babynames %>%
  filter(sex=="F",
         name %in% dat1$name) -> dat

streamgraph(dat, "name", "n", "year") %>%
  sg_fill_tableau() %>%
#   sg_colors("Spectral") %>%
  sg_axis_x(tick_units = "year", tick_interval = 10, tick_format = "%Y") %>%
  sg_legend(TRUE, "Name: ")




babynames[babynames$name %in% dat1$name,]


dat <- read.table(text="week variable    value
    40     rev1  372.096
    40     rev2  506.880
    40     rev3 1411.200
   40     rev4  198.528
    40     rev5   60.800
    43     rev1  342.912
    43     rev2  501.120
    43     rev3  132.352
    43     rev4  267.712
   43     rev5   82.368
   44     rev1  357.504
   44     rev2  466.560", header=TRUE)

dat %>%
  streamgraph("variable","value","week", scale="continuous") %>%
  sg_axis_x(tick_format="d") %>%
  sg_fill_tableau() %>%
#   sg_annotate(label="annotation", x=40.05, y=200, color="white", size=16) %>%
#   sg_annotate(label="moar annotation", x=41, y=1500, color="black", size=24) %>%
#   sg_annotate(label="last one", x=42, y=900, color="white", size=18) %>%
  sg_add_marker(x=41, y=10, label="Hello There", stroke="#000000", color="#7f7f7f", size=16) %>%
  sg_add_marker(x=42, y=10, label="Hello There", stroke="#000000", color="#7f7f7f", size=16) %>%
  sg_add_marker(x=43, y=10, label="Hello There", stroke="#000000", color="#7f7f7f", size=16)




