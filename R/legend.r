
#' Modify streamgraph legend properties
#'
#' If the \code{streamgraph} is interactive, a "legend" can be added
#' that displays a select menu of all the stream categories. Selecting
#' a category will highlight that stream in the graph.
#'
#' TODO: legends for non-interactive streamgraphs
#'
#' @param sg streamgraph object
#' @param show if this is \code{TRUE} and \code{interactive} is \code{TRUE} then a popup menu
#'        will be available that lists ll the keys in the data set. Selecting a key will
#'        perform the same action as hovering over the area with the mouse.
#' @param label label for the legend (optional)
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
#' streamgraph(dat, "genre", "n", "year") %>%
#'   sg_fill_brewer("PuOr") %>%
#'   sg_legend(TRUE, "Genre: ")
#' }
sg_legend <- function(sg, show=FALSE, label="") {

  sg$x$legend <- show
  sg$x$legend_label <- label

  sg

}