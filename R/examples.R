#' Source path_ex_files
#'
#' To use this in your package, re-declare `source_pef()` in your package
#' with *your* package name.
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
#' @inheritParams fs::path_package
#' @keywords path helpers, example helpers
#' @noRd
source_pef <- function(package, ...) {
  path <- fs::path_package(package = package, "examples", ..., ext = "R")
  source(path, local = TRUE)$value
}

source_pef_elf <- purrr::partial(source_pef, package = "elf")

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
  path <- fs::path(example_path, ..., ext = "R")
  usethis::use_directory(fs::path_dir(path))
  usethis::use_template(
    "example.R",
    save_as = path,
    open = open,
    package = "elf"
  )
}

example_path <- fs::path("inst", "examples")
