#' Path to *this* package
#' @inherit fs::path_package
#' @keywords path helpers
#' @export
path_package_this <- function(package = pkgload::pkg_name(), ...) {
  system.file(..., package = package)
}

#' Create path to external data
#' @inherit path_package_this
#' @keywords path helpers
#' @export
path_extdata <- function(...) {
  args <- c("extdata", list(...))
  rlang::exec(path_package_this, !!!args, mustWork = TRUE) # nolint
}
