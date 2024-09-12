# installed ====

#' Check if a package is installed
#'
#' Wrapper around [rlang::is_installed()].
#' @keywords dependencies helper
#' @name pkg_installed
NULL

#' @describeIn pkg_installed returns `TRUE` or the error message as a string.
#' @param x Name of the package.
#' @export
check_pkg_installed <- function(x = character(1L)) {
  res <- checkmate::check_string(x)
  if (!isTRUE(res)) {
    return(res)
  }
  if (rlang::is_installed(x)) {
    return(TRUE)
  } else {
    paste("Package", x, "is not installed.")
  }
}

#' @describeIn pkg_installed returns `x` invisibly or errors out.
#' @export
assert_pkg_installed <- checkmate::makeAssertionFunction(check_pkg_installed)

#' @describeIn pkg_installed returns `TRUE` or `FALSE`
#' @export
test_pkg_installed <- checkmate::makeTestFunction(check_pkg_installed)

#' @describeIn pkg_installed returns an [testthat::expectation()]
#' @export
expect_pkg_installed <- checkmate::makeExpectationFunction(check_pkg_installed)
