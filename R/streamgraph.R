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
#' @param top top margin (default should be fine, this allows for fine-tuning plot space)
#' @param right right margin (default should be fine, this allows for fine-tuning plot space)
#' @param bottom bottom margin (default should be fine, this allows for fine-tuning plot space)
#' @param left left margin (default should be fine, this allows for fine-tuning plot space)
#' @import htmlwidgets htmltools
#' @importFrom tidyr expand
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
                        interactive=TRUE,
                        top=20,
                        right=40,
                        bottom=30,
                        left=50) {

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

  xtu <- "month"
  xtf <- "%b"
  xti <- 1

  if (all(class(data$date) %in% c("numeric", "character", "integer"))) {
    if (all(nchar(as.character(data$date)) == 4)) {
      data %>%
        mutate(date=sprintf("%04d-01-01", as.numeric(date))) -> data
      xtu <- "year"
      xtf <- "%Y"
      xti <- 10
    }
  }

  # needs all combos, so we do the equiv of expand.grid, but w/dplyr & tidyr

  data %>%
    left_join(tidyr::expand(., key, date), ., by=c("key", "date")) %>%
    mutate(value=ifelse(is.na(value), 0, value)) %>%
    select(key, value, date) -> data

  # date format

  data %>%
    mutate(date=format(as.Date(date), "%Y-%m-%d")) %>%
    arrange(date) -> data

  params = list(
    data=data,
    offset=offset,
    interactive=interactive,
    interpolate=interpolate,
    palette="Spectral",
    text="black",
    tooltip="black",
    x_tick_interval=xti,
    x_tick_units=xtu,
    x_tick_format=xtf,
    y_tick_count=5,
    y_tick_format=",g",
    top=top,
    right=right,
    bottom=bottom,
    left=left,
    legend=FALSE,
    legend_label="",
    fill="brewer"
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
#' @param tick_interval interval between ticks, not tick count (defaults to \code{10} if source data is in years, otherwise \code{1})
#' @param tick_units unit the ticks are in; d3 time scale unit specifier (defaults to \code{month})
#' @param tick_format how to show the labels (subset of \code{strftime} formatters) (defaults to \code{\%b})
#' @param show show vertical gridlines? (defaults to \code{FALSE})
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

#' Modify streamgraph colors
#'
#' Change the ColorBrewer palette being used
#'
#' @param sg streamgraph object
#' @param palette ColorBrewer pallete atomic character value (defaults to \code{Spectral})
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
sg_colors <- function(sg, palette="Spectral") {

  sg$x$fill <- "brewer"
  sg$x$palette <- palette
  sg$x$text <- "black"
  sg$tooltip <- "black"

  sg

}

#' Use ColorBrewer palettes for streamgraph fill colors
#'
#' ColorBrewer provides sequential, diverging and qualitative colour schemes
#' which are particularly suited and tested to display categorical values.
#'
#' @param sg streamgraph object
#' @param palette ColorBrewer pallete atomic character value (defaults to \code{Spectral})
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
#'   sg_fill_brewer("PuOr")
#' }
sg_fill_brewer <- function(sg, palette="Spectral") {

  sg$x$fill <- "brewer"
  sg$x$palette <- palette

  sg

}

#' Use Tableau discrete palettes for streamgraph fill colors
#'
#' Tableau discrete palettes provide colour schemes
#' which are particularly suited and tested to display categorical values.
#'
#' @param sg streamgraph object
#' @param palette Tableau discrete pallete atomic character value (defaults to \code{tableau20}). Must be one of
#'        \code{c("tableau20", "tableau10medium", "gray5", "colorblind10", "trafficlight", "purplegray12", "bluered12", "greenorange12", "cyclic")}
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
#'   sg_fill_tableau("purplegray12")
#' }
sg_fill_tableau<- function(sg, palette="tableau20") {

  if (palette %in%  c("tableau20", "tableau10medium", "gray5",
                      "colorblind10", "trafficlight", "purplegray12",
                      "bluered12", "greenorange12", "cyclic")) {

    sg$x$fill <- "manual"
    sg$x$palette <- tableau_colors(palette)

  } else {
    warning("'palette' value is not a valid Tableau discrete color scale, using streamgraph defaults")
  }

  sg

}

#' Use manual colors for streamgraph fill colors
#'
#' Specify a vector of colors (e.g. \code{c("red", "#00ff00", rgb(0,0,1))}) to
#' use for the color scale. Note that \code{streamgraph} sorts the categorical values
#' before assigning the mappings, which means you can use that as a determinstic way of
#' assigning specific colors to categories. If the number of categories
#' exceeds the number of colors in the palette, the colors will be reused in order.
#'
#' @param sg streamgraph object
#' @param values character vector of
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
#'   sg_fill_manual(c("black", "#ffa500", "blue", "white", "#00ff00', "red"))
#' }
sg_fill_manual <- function(sg, values=NULL) {

  if (is.null(values)) {

    warning("color values not specified, using streamgraph defauls")

  } else {

    sg$x$fill <- "manual"
    sg$x$palette <- col2hex(values)

  }

  sg

}


#' Modify streamgraph legend properties
#'
#' If the \code{streamgraph} is interactive, a "legend" can be added
#' that displays a select menu of all the stream categories. Selecting
#' a category will highlight that stream in the graph.
#'
#' TODO: legends for non-interactive streamgraphs
#'
#' @param show if this is \code{TRUE} and \code{interactive} is \code{TRUE} then a popup menu
#'        will be available that lists ll the keys in the data set. Selecting a key will
#'        perform the same action as hovering over the area with the mouse.
#' @param label label for the legend (optional)
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
#'   sg_colors("PuOr") %>%
#'   sg_legend(TRUE, "Genre: ")
#' }
sg_legend <- function(sg, show=FALSE, label="") {

  sg$x$legend <- show
  sg$x$legend_label <- label

  sg

}

#' Widget output function for use in Shiny
#'
#' @export
streamgraphOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'streamgraph', width, height, package = 'streamgraph')
}


#' Widget render function for use in Shiny
#'
#' @export
renderStreamgraph <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, streamgraphOutput, env, quoted = TRUE)
}

streamgraph_html <- function(id, style, class, width, height, ...) {
  list(tags$div(id = id, class = class, style = style),
       tags$div(id = sprintf("%s-legend", id), style=sprintf("width:%s", width), class = sprintf("%s-legend", class),
                HTML(sprintf("<center><label for='%s-select'></label><select id='%s-select' style='visibility:hidden;'></select></center>", id, id))))
}
