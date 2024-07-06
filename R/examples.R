#' Source path_ex_files
#'
#' @section Warning:
#' Can only be called if all objects used in sourced files are already loaded.
#' This is not a collation issue, but similar.
#' `source()` parses at load time, so objects must be available at call time.
#' Usually this will mean that it's best to place `source_pef()`
#' at the end of a source file to which it pertains (say, the examples).
#' If it uses objects from other files,
#' manual collation instructions via `#' @include foo.R` may be neeeded,
#' but that will quickly make the package unwieldy.
#' @noRd
source_pef <- function(...) {
  source(path_ex_file(...), local = TRUE)$value
}

#' Create path to example files
#' Used in example tag and tests
#' @inheritParams system_file2
#' @keywords paths examples
#' @export
path_ex_file <- function(...) {
  args <- c("examples", list(...))
  rlang::exec(system_file2, !!!args, mustWork = TRUE) # nolint
}
