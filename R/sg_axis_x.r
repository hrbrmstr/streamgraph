#' Modify streamgraph x axis formatting
#'
#' Change the tick interval, units and label text display format for the
#' streamgraph x axis.
#'
#' @param sg streamgraph object
#' @param ticks when \code{scale} is \code{date}, \code{ticks} is the interval
#'        between ticks. when \code{scale} is \code{continuous}, \code{ticks} is
#'        the total number of ticks (i.e. "tick count") [defaults to \code{10}]
#' @param tick_interval tick interval
#' @param tick_format how to show the labels (subset of \code{strftime}
#'        formatters for \code{date} scale, otherwise \code{sprintf} formats for
#'        \code{continuous} scale) (defaults to \code{\%b} - must specify if \code{continuous}).
#'        See \href{D3 formatting}{https://github.com/mbostock/d3/wiki/Formatting} for more details.
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
#'   sg_axis_x(20, "year", "%Y")
#' }
sg_axis_x <- function(sg,
                      tick_interval=NULL,
                      tick_units=NULL,
                      tick_format=NULL) {

  if (!is.null(tick_interval))sg$x$x_tick_interval <- tick_interval
  if (!is.null(tick_units)) sg$x$x_tick_units <- tick_units
  if (!is.null(tick_format)) sg$x$x_tick_format <- tick_format

  sg

}
