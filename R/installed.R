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
#' @inheritParams checkmate::makeAssertion
#' @inheritParams checkmate::assert
#' @export
assert_pkg_installed <- checkmate::makeAssertionFunction(check_pkg_installed)

#' @describeIn pkg_installed returns `TRUE` or `FALSE`
#' @inheritParams checkmate::makeTest
#' @export
test_pkg_installed <- checkmate::makeTestFunction(check_pkg_installed)

#' @describeIn pkg_installed returns an [testthat::expectation()]
#' @inheritParams checkmate::makeExpectation
#' @export
expect_pkg_installed <- checkmate::makeExpectationFunction(check_pkg_installed)

#' @describeIn pkg_installed
#' skips test if package is *not* installed.
#' Same as [testthat::skip_if_not_installed()],
#' except using [rlang::is_installed()] under the hood.
#' @include tests.R
#' @export
skip_if_pkg_not_installed2 <- make_skip_if_not_function(check_pkg_installed)

# installed but not via load_all ====

#' Check if a package is installed, but not via [pkgload::load_all()]
#'
#' To speed up development,
#' [pkgload::load_all()] simulates installing a package.
#' This simulation is usually sufficient,
#' but there are edge cases which it cannot cover.
#' Use this family of predicates to guard against these edge cases.
#'
#' @details
#' A frequent example of an edge case for [pkgload::load_all()]
#' occurs when child processes are launched during development,
#' such as in [shinytest2](https://rstudio.github.io/shinytest2/).
#' These child processes may not "know" that their parent
#' used the `load_all()`d version of an in-development package,
#' but may instead use whichever version was last installed.
#' This can lead to inconsistent results and painful confusion.
#' @noRd
