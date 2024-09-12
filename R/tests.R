#' Transform snapshot output
#'
#' To be used as an argument for [testthat::expect_snapshot()].
#' @param x A character vector.
#' @family test helpers
#' @name transform_snap
NULL

#' @describeIn transform_snap
#' Mark snapshots as generated files,
#' so they can be skipped by superlinter.
#' @export
transform_with_generated <- function(x = character()) {
  c(
    "<!--@generated-->",
    x
  )
}
