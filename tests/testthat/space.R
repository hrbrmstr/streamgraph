library(streamgraph)
library(dplyr)

dat <- read.table(text="date AllProperties   Office     oTotal      Industrial   oTotal       Retail      oTotal     Apartment     oTotal       Hotel          oTotal        Land         oTotal
2001                  89.6         39.0   43.5%            16.0   17.8%           14.0    15.6%           20.7    23.1%               NA       NA                  NA NA
2002                 106.1         40.1   37.8%            13.0   12.2%           28.5    26.9%           24.5    23.1%               NA       NA                  NA NA
2003                 131.2         47.4   36.1%            15.6   11.9%           36.2    27.6%           32.0    24.4%               NA       NA                  NA NA
2004                 213.3         74.4   34.9%            25.3   11.9%           61.1    28.6%           52.5    24.6%               NA       NA                  NA NA
2005                 365.4        107.6   29.4%            51.8   14.2%           58.0    15.9%           98.8    27.0%           29.8        8.2%           19.5       5.3%
2006                 426.8        144.3   33.8%            55.6   13.0%           63.8    15.0%           98.9    23.2%           43.2       10.1%           20.9       4.9%
2007                 573.4        213.7   37.3%            61.5   10.7%           81.4    14.2%          105.1    18.3%           80.7       14.1%           31.0       5.4%
2008                 174.9         59.3   33.9%            27.5   15.7%           25.4    14.5%           43.0    24.6%           11.6        6.6%               8.1    4.6%
2009                  68.4         17.8   26.0%            10.8   15.8%           16.3    23.9%           17.9    26.1%               3.2     4.7%               2.4    3.5%
2010                 146.5         46.8   31.9%            20.9   14.2%           23.1    15.8%           37.3    25.5%           14.4        9.8%               4.1    2.8%
2011                 234.1         66.9   28.6%            36.3   15.5%           44.6    19.0%           58.6    25.0%           20.1        8.6%               7.6    3.3%
2012                 297.5         79.4   26.7%            39.3   13.2%           57.0    19.2%           87.5    29.4%           20.6        6.9%           13.8       4.6%
2013                 362.2        103.5   28.6%            47.9   13.2%           62.9    17.4%          102.8    28.4%           27.3        7.5%           17.8       4.9%
2014                 423.9        118.8   28.0%            54.4   12.8%           82.6    19.5%          112.4    26.5%           34.6        8.2%           21.1       5.0%", stringsAsFactors=FALSE, header=TRUE)

dat %>%
  select(date, Office, Industrial, Retail, Apartment, Hotel, Land) %>%
  tidyr::gather(key, value, -date) %>%
  mutate(value=ifelse(is.na(value), 0, value),
         date=as.Date(sprintf("%d-01-01", date))) -> sg_dat

sg_dat %>%
  streamgraph() %>%
  sg_axis_x(1, "year", "%Y") %>%
  sg_colors("PuOr")

dat <- read.csv("http://asbcllc.com/blog/2015/february/cre_stream_graph_test/data/cre_transaction-data.csv")

dat %>%
  streamgraph("asset_class", "volume_billions", "year", interpolate="cardinal") %>%
  sg_axis_x(1, "year", "%Y") %>%
  sg_colors("PuOr")