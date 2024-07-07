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
#' @keywords path helpers, example helpers
#' @noRd
source_pef <- function(...) {
  source(path_ex_file(...), local = TRUE)$value
}

#' Create or edit example files
#'
#' This function creates R files in the `inst/examples/` to be reused in
#' tests, `#' @examples` and more.
#' When reused for tests, only last return of an example file will be tested.
#' You may therefore need a lot of relatively small example files.
#' The suggested convention is to sort them in folders named by `file_name`
#' function name and test name.
#'
#' @inheritParams fs::path
#' @inheritParams usethis::use_template
#' @export
#' @keywords example helpers
use_ex_file <- function(..., open = rlang::is_interactive()) {
  # TODO https://github.com/dataheld/elf/issues/2
  # take currently open file name from usethis
  usethis::use_directory(example_path)
  path <- fs::path(example_path, ..., ext = "R")
  usethis::use_template(
    "example.R",
    save_as = path,
    open = open,
    package = "elf"
  )
}

example_path <- fs::path("inst", "examples")

#' Create path to example files
#' Used in example tag and tests
#' @inheritParams path_package_this
#' @keywords path helpers, example helpers
#' @export
path_ex_file <- function(...) {
  args <- c("examples", list(...))
  rlang::exec(path_package_this, !!!args, mustWork = TRUE) # nolint
}
