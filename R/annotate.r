. <- NULL

#' Add text annotation to streamgraph
#'
#' Use this function to place text at any point on a streamgraph. This
#' is especially useful for non-interactive streamgraphs (i.e. to label
#' a particular stream).
#'
#' @param sg streamgraph object
#' @param label text for the annotation
#' @param x horizontal position
#' @param y vertical position
#' @param color color of the label
#' @param size font size
#' @export
sg_annotate <- function(sg, label, x, y, color="black", size=12) {

  if (inherits(x, "Date")) { x <- format(x, "%Y-%m-%d") }

  ann <- data.frame(label=label, x=x, y=y, color=color, size=size, stringsAsFactors=FALSE)

  if (is.null(sg$x$annotations)) {
    sg$x$annotations <- ann
  } else {
    sg$x$annotations <- bind_rows(ann, sg$x$annotations)
  }

  sg

}
