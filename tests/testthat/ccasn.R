library("streamgraph")
library(pbapply)
library(dplyr)

logs <- list.files("/Users/bob/Development/tiq-test-Winter2015/data/enriched/public_inbound/", full.names=TRUE)

dat <- pblapply(logs, function(x) {
  dat <- read.csv(x)
})

dat2 <- bind_rows(dat)

# country view ------------------------------------------------------------

dat2 %>%
  group_by(date, country) %>%
  tally() %>%
  top_n(5, n) -> ccs

streamgraph(ccs, "country", "n") %>%
  sg_axis_x(tick_interval=1, tick_units="weeks", tick_format="%m-%d")

# asn view ----------------------------------------------------------------

dat2 %>%
  group_by(date, asnumber) %>%
  tally() %>%
  top_n(5, n) %>%
  mutate(asnumber=sprintf("AS%d", asnumber)) -> asns

streamgraph(asns, "asnumber", "n") %>%
  sg_axis_x(tick_interval=1, tick_units="weeks", tick_format="%m-%d")

# ips ---------------------------------------------------------------------

dat2 %>%
  group_by(date, entity) %>%
  tally() %>%
  top_n(5, n) -> ips

streamgraph(ips, "entity", "n") %>%
  sg_axis_x(tick_interval=1, tick_units="weeks", tick_format="%m-%d")

