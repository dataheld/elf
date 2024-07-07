#' Path to *this* package
#' @inheritParams fs::path_package
#' @inheritDotParams fs::path_package
#' @keywords path helpers
#' @example inst/examples/paths/path_package_this/example.R
#' @export
path_package_this <- function(..., package = "elf") {
  fs::path_package(package = package, ...)
}

#' Create path to external data
#' @inherit path_package_this
#' @keywords path helpers
#' @export
path_extdata <- function(...) path_package_this("extdata", ...)
