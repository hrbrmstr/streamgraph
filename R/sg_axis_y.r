#' Modify streamgraph y axis formatting
#'
#' Change the tick count & format
#'
#' @param sg streamgraph object
#' @param tick_count number of y axis ticks, not tick interval (defaults to \code{5});
#'        make this \code{0} if you want to hide the y axis labels
#' @param tick_format d3 \href{https://github.com/mbostock/d3/wiki/Formatting#d3_format}{tick format} string
#' @return streamgraph object
#' @export
#' @examples \dontrun{
#' library(dplyr)
#' library(streamgraph)
#' ggplot2::movies %>%
#' select(year, Action, Animation, Comedy, Drama, Documentary, Romance, Short) %>%
#'   tidyr::gather(genre, value, -year) %>%
#'   group_by(year, genre) %>%
#'   tally(wt=value) %>%
#'   ungroup %>%
#'   mutate(year=as.Date(sprintf("%d-01-01", year))) -> dat
#'
#' streamgraph(dat, "genre", "n", "year") %>%
#'   sg_axis_x(20, "year", "%Y") %>%
#'   sg_axis_y(0)
#' }#' @export
sg_axis_y <- function(sg, tick_count=5, tick_format=",g") {

  sg$x$y_tick_count <- tick_count
  sg$x$y_tick_format <- tick_format

  sg

}
