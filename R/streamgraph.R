#' Create a new streamgraph
#'
#' \code{streamgraph()} initializes the streamgraph html widget
#' and takes a data frame in "long" format with columns for the
#' category (by default, it looks for \code{key}) and its associated
#' \code{date}  and \code{value}. You can supply the names for those
#' columns if they aren't named as such in your data.\cr
#' \cr
#' By default, interactivity is on, but you can disable that by setting
#' the \code{interactve} parameter to \code{FALSE}.
#'
#' @param data data frame
#' @param key name of the category column (defaults to \code{key})
#' @param value name of the value column (defaults to \code{value})
#' @param date name of the date column (defaults to \code{date})
#' @param width Width in pixels (optional, defaults to automatic sizing)
#' @param height Height in pixels (optional, defaults to automatic sizing)
#' @param offset see d3's \href{https://github.com/mbostock/d3/wiki/Stack-Layout#offset}{offset layout} for more details.
#'        The default is probably fine for most uses but can be one of \code{silhouette} (default),
#'        \code{wiggle}, \code{expand} or \code{zero}
#' @param interpolate see d3's \href{https://github.com/mbostock/d3/wiki/SVG-Shapes#area_interpolate}{area interpolation} for more details.
#'        The default is probably fine fore most uses, but can be one of \code{cardinal} (default),
#'        \code{linear}, \code{step}, \code{step-before}, \code{step-after}, \code{basis}, \code{basis-open},
#'        \code{cardinal-open}, \code{monotone}
#' @param interactive set to \code{FALSE} if you do not want an interactive streamgraph
#' @import htmlwidgets htmltools
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
#' streamgraph(dat, "genre", "n", "year")
#' }
streamgraph <- function(data,
                        key="key",
                        value="value",
                        date="date",
                        width=NULL, height=NULL,
                        offset="silhouette",
                        interpolate="cardinal",
                        interactive=TRUE) {

  if (!(offset %in% c("silhouette", "wiggle", "expand", "zero"))) {
    warning("'offset' does not have a valid value, defaulting to 'silhouette'")
    offset <- "silhouette"
  }

  if (!(interpolate %in% c("cardinal", "linear", "step", "step-before",
                           "step-after", "basis", "basis-open",
                           "cardinal-open", "monotone"))) {
    warning("'interpolate' does not have a valid value, defaulting to 'cardinal'")
    interpolate <- "cardinal"
  }

  data <- data.frame(data)
  data <- data[,c(key, value, date)]
  colnames(data) <- c("key", "value", "date")

  data %>%
    mutate(date=format(as.Date(date), "%Y-%m-%d")) %>%
    arrange(date) -> data

  params = list(
    data=data,
    offset=offset,
    interactive=interactive,
    interpolate=interpolate,
    palette="Blues",
    text="black",
    tooltip="black",
    x_tick_interval=1,
    x_tick_units="month",
    x_tick_format="%b",
    y_tick_count=5,
    y_tick_format=",g"
  )

  htmlwidgets::createWidget(
    name = 'streamgraph',
    x = params,
    width = width,
    height = height,
    package = 'streamgraph'
  )

}

#' Modify streamgraph x axis formatting
#'
#' Change the tick interval, units and label text display format for the
#' streamgraph x axis.
#'
#' @param sg streamgraph object
#' @param tick_interval interval between ticks, not tick count (defaults to \code{1})
#' @param tick_units unit the ticks are in; d3 time scale unit specifier (defaults to \code{month})
#' @param tick_format how to show the labels (subset of \code{strftime} formatters) (defaults to \code{\%b})
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
                      tick_interval=1,
                      tick_units="month",
                      tick_format="%b") {

  sg$x$x_tick_interval <- tick_interval
  sg$x$x_tick_units <- tick_units
  sg$x$x_tick_format <- tick_format

  sg

}

#' Modify streamgraph y axis formatting
#'
#' Change the tick count
#'
#' @param sg streamgraph object
#' @param tick_count number of y axis ticks, not tick interval (defaults to \code{5});
#'        make this \code{0} if you want to hide the y axis
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

#' Modify streamgraph colors
#'
#' Change the ColorBrewer palette being used
#'
#' @param sg streamgraph object
#' @param palette ColorBrewer pallete atomic character value (defaults to \code{Blues})
#' @param text text color CURRENTLY NOT IMPLEMENTED
#' @param tooltip color CURRENTLY NOT IMPLEMENTED
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
#'   sg_colors("PuOr")
#' }
sg_colors <- function(sg, palette="Blues", text="black", tooltip="black") {

  sg$x$palette <- palette
  sg$x$text <- text
  sg$tooltip <- tooltip

  sg

}