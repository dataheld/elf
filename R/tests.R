#' Transform snapshot output
#'
#' To be used as an argument for [testthat::expect_snapshot()].
#' @param x A character vector.
#' @family testing helpers
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

#' Make a [testthat::skip_if_not()] function
#'
#' Function operator to turn
#' [checkmate](https://mllg.github.io/checkmate/index.html)'s
#' `check_*()`-type functions into [testthat](https://testthat.r-lib.org)'s
#' `skip_if_not_*()` functions.
#' @inheritParams checkmate::makeAssertionFunction
#' @details
#' Notice that `check_*()` are always formulated *positively*;
#' the message from `check_*()` is emitted,
#' when its condition is *not* met.
#' The [testthat](https://testthat.r-lib.org) equivalent is the opposite:
#' a `skip_if_not_*()` function would skip with the emitted message.
#'
#' You cannot generate `skip_if_*()` functions from `check_*()` functions,
#' because the negation of the emitted message may be wrong or confusing.
#' But you can create one manually:
#'
#' ```r
#' skip_if_cond <- function(x) {
#'   testthat::skip_if(
#'     my_pkg::check_cond(x),
#'     # needs a custom message here
#'     "Skipping because condition is true."
#'   )
#' }
#' ```
#' @export
#' @family testing helpers
make_skip_if_not_function <- function(check.fun) {
  force(check.fun)
  function(...) {
    res <- check.fun(...)
    if (isTRUE(res)) {
      return(invisible())
    } else {
      testthat::skip(res)
    }
  }
}
