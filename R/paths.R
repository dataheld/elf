#' @inherit base::system.file
#' @inheritDotParams base::system.file
#' @keywords paths
#' @export
system_file2 <- function(..., package = pkgload::pkg_name()) {
  system.file(..., package = package)
}

#' Create path to external data
#' @inheritParams system_file2
#' @keywords paths
#' @export
path_extdata <- function(...) {
  args <- c("extdata", list(...))
  rlang::exec(system_file2, !!!args, mustWork = TRUE) # nolint
}
