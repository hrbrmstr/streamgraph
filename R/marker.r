
#' Add a vertical marker (with optional label) to streamgraph
#'
#' This is useful for marking/labeling notable events along the streams.
#'
#' @param x horizontal position
#' @param label text for the annotation
#' @param stroke_width line width
#' @param stroke line color
#' @param space space (in points) from the marker to place the label
#' @param y vertical position
#' @param color color of the label
#' @param size font size#' @export
#' @param anchor how to justify the label (one of \code{start} [left],
#'     \code{middle} [center] or \code{end} [right])
sg_add_marker <- function(sg, x, label="", stroke_width=0.5, stroke="#7f7f7f", space=5,
                          y=0, color="#7f7f7f", size=12, anchor="start") {

  if (inherits(x, "Date")) { x <- format(x, "%Y-%m-%d") }

  mark <- data.frame(x=x, y=y, label=label, color=color, stroke_width=stroke_width, stroke=stroke,
                     space=space, size=size, anchor=anchor, stringsAsFactors=FALSE)

  if (is.null(sg$x$markers)) {
    sg$x$markers <- mark
  } else {
    sg$x$markers <- bind_rows(mark, sg$x$markers)
  }

  sg

}