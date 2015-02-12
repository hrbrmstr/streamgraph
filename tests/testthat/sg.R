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
  tally(wt=value) %>%
  ungroup %>%
  mutate(year=as.Date(sprintf("%d-01-01", year))) -> dat

streamgraph(dat, "genre", "n", "year", interactive=TRUE) %>%
  sg_axis_x(20, "year", "%Y") %>%
  sg_colors("Spectral")
