#' Create a new streamgraph
#'
#' \code{streamgraph()} initializes the streamgraph html widget
#' and takes a data frame in "long" format with columns for the
#' category (by default, it looks for \code{key}) and its associated
#' \code{date}  and \code{value}. You can supply the names for those
#' columns if they aren't named as such in your data.\cr
#' \cr
#' By default, interactivity is on, but you can disable that by setting
#' the \code{interactive} parameter to \code{FALSE}.
#'
#' @param data data frame
#' @param key bare or quoted name of the category column (defaults to \code{key})
#' @param value bare or quoted name of the value column (defaults to \code{value})
#' @param date bare or quoted name of the date column (defaults to \code{date})
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
#' @param scale axis scale (\code{date} [default] or \code{continuous})
#' @param top top margin (default should be fine, this allows for fine-tuning plot space)
#' @param right right margin (default should be fine, this allows for fine-tuning plot space)
#' @param bottom bottom margin (default should be fine, this allows for fine-tuning plot space)
#' @param left left margin (default should be fine, this allows for fine-tuning plot space)
#' @param sort experimental
#' @param complete experimental
#' @param order streamgraph ribbon order. "`compat`" to match the orignial package behavior,
#'              "`asis`" to use the input order, "`inside-out`" to sort by index of maximum value,
#'              then use balanced weighting, or "`reverse`" to reverse the input layer order.
#' @import htmlwidgets htmltools
#' @importFrom tidyr expand
#' @return streamgraph object
#' @export
#' @examples \dontrun{
#' library(dplyr)
#' library(streamgraph)
#' ggplot2movies::movies %>%
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
                        key,
                        value,
                        date,
                        width=NULL, height=NULL,
                        offset="silhouette",
                        interpolate="cardinal",
                        interactive=TRUE,
                        scale="date",
                        top=20,
                        right=40,
                        bottom=30,
                        left=50,
                        sort=TRUE,
                        complete=TRUE,
                        order = c("compat", "asis", "inside-out", "reverse")) {

  order <- match.arg(order, choices = c("compat", "asis", "inside-out", "reverse"))
  if (order == "compat") order <- "none"
  if (order == "asis") order <- "default"

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

  if (!missing(key)) {
    key <- substitute(key)
    if (inherits(key, "name")) { key <- as.character(key) }
  } else {
    key <- "key"
  }

  if (!missing(value)) {
    value <- substitute(value)
    if (inherits(value, "name")) { value <- as.character(value) }
  } else {
    value <- "value"
  }

  if (!missing(date)) {
    date <- substitute(date)
    if (inherits(date, "name")) { date <- as.character(date) }
  } else {
    date <- "date"
  }

  data <- data.frame(data)
  data <- data[,c(key, value, date)]
  colnames(data) <- c("key", "value", "date")

  xtu <- "month"
  xtf <- "%b"
  xti <- 1

  if (scale=="date") {

    # date format

    if (all(class(data$date) %in% c("numeric", "character", "integer"))) {
      if (all(nchar(as.character(data$date)) == 4)) {
        data %>%
          mutate(date=sprintf("%04d-01-01", as.numeric(date))) -> data
        xtu <- "year"
        xtf <- "%Y"
        xti <- 10
      }
    }

  } else {

    xtu <- NULL
    xtf <- ",.0f"
    xti <- 10

  }

  # needs all combos, so we do the equiv of expand.grid, but w/dplyr & tidyr

  if (complete) {
    data %>%
      left_join(tidyr::expand(., key, date), ., by=c("key", "date")) %>%
      mutate(value=ifelse(is.na(value), 0, value)) %>%
      select(key, value, date) -> data
  }

  if (scale=="date") {

    # date format

    data %>%
      mutate(date=format(as.Date(date), "%Y-%m-%d")) %>%
      arrange(date) -> data

  }

  params = list(
    data=data,
    markers=NULL,
    annotations=NULL,
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
    fill="brewer",
    label_col="black",
    x_scale=scale,
    sort=sort,
    order=order
  )

  htmlwidgets::createWidget(
    name = 'streamgraph',
    x = params,
    width = width,
    height = height,
    package = 'streamgraph'
  )

}

#' Add a title to the streamgraph
#'
#' @param sg streamgraph object
#' @param title title
#' @return THIS DOES NOT RETURN AN \code{htmlwidget}!! It returns a \code{shiny.tag}
#'         class HTML (the widget is wrapped in a \code{<div>}). It should be the LAST
#'         call in a magrittr pipe chain or called to wrap a streamgraph object for
#'         output
#' @export
sg_title <- function(sg, title="") {

  div(style="margin:auto;text-align:center", strong(title), br(), sg)

}

streamgraph_html <- function(id, style, class, width, height, ...) {
  list(tags$div(id = id, class = class, style = style),
       tags$div(id = sprintf("%s-legend", id), style=sprintf("width:%s", width), class = sprintf("%s-legend", class),
                HTML(sprintf("<center><label style='padding-right:5px' for='%s-select'></label><select id='%s-select' style='visibility:hidden;'></select></center>", id, id))))
}





