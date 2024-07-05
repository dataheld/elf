#' @inherit base::system.file
#' @inheritDotParams base::system.file
#' @keywords paths
system_file2 <- function(..., package = pkgload::pkg_name()) {
  system.file(..., package = package)
}
