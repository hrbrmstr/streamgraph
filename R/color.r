#' Modify streamgraph colors
#'
#' Change the ColorBrewer palette being used
#'
#' @param sg streamgraph object
#' @param palette UNUSED; being removed in next release; use \code{sg_fill_*} instead
#' @param axis_color color of the axis text (defaults to "\code{black}")
#' @param tooltip_color color of the tooltip text (defaults to "\code{black}")
#' @param label_color color of the label text for the legend select menu (defaults to "\code{black}")
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
sg_colors <- function(sg, palette=NULL, axis_color="black", tooltip_color="black", label_color="black") {

  if (!is.null(palette)) {
    message("Use 'sg_fill_*' for setting stream colors. This parameter will be removed in an upcoming release.")
  }

  sg$x$text <- axis_color
  sg$x$tooltip <- tooltip_color
  sg$x$label_col <- label_color

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
