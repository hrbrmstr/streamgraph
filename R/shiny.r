
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
