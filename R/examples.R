# example path helper ====

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
#' @family path helpers
#' @family example helpers
#' @export
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
#' @family example helpers
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

# elfReusableExamples tag ====

#' Tag for reusable example code
#'
#' Provides new roxygen2 tag to make the `@examples` code reusable.
#'
#' @details
#' Using this tag, you can reuse the expression in `@examples`.
#' For example,
#' your `@examples` may be an invocation of the documented function.
#' You may often use the same invocation to write unit tests for the function.
#' This tag lets you reuse the example code.
#'
#' Alternatively, you can store this code in a separate file,
#' include it in the documentation via `@example`,
#' and call it in tests and elsewhere via [source_pef()].
#'
#' @family example helpers
#' @family testing helpers
#'
#' @name elfReusableExamples
NULL

#' @rdname elfReusableExamples
#' @details
#' `@elfReusableExamples ${1:name} {2:# example code}`
#' Example code to be reused.
#'
#' Wraps @examples.
#' @usage
#' #' @elfResuableExamples ${1:name} {2:# example code}
#' @name tag_reusable_examples
NULL

#' @exportS3Method roxygen2::roxy_tag_parse
roxy_tag_parse.roxy_tag_elfReusableExamples <- function(x) {
  check_pkg_installed("roxygen2")
  check_pkg_installed("stringr")
  parsed <- stringr::str_split(
    x$raw,
    pattern = stringr::boundary("word"),
    n = 2,
    simplify = TRUE
  )
  x$val <- list(
    name = parsed[1, 1],
    code = parsed[1, 2]
  )
  x
}

#' @exportS3Method roxygen2::roxy_tag_rd
roxy_tag_rd.roxy_tag_elfReusableExamples <- function(x, base_path, env) {
  res <- paste(
    paste("#", x[["val"]][["name"]]),
    x[["val"]][["code"]],
    sep = "\n"
  )
  roxygen2::rd_section("examples", res)
}

#' Roclet to retrieve code from `@elfReusableExamples`
#' @family example helpers
#' @family testing helpers
#' @keywords internal
#' @export
reusableExamples_roclet <- function() {
  roxygen2::roclet("elfReusableExamples")
}

#' @exportS3Method roxygen2::roclet_process
roclet_process.roclet_elfReusableExamples <- function(x, blocks, env, base_path) {
  empty_res <- tibble::tibble(
    topic = character(),
    alias = character(),
    file = character(),
    name = character(),
    code = character()
  )
  purrr::map(
    blocks,
    .f = function(block) {
      tags <- roxygen2::block_get_tags(block, "elfReusableExamples")
      full_res <- empty_res
      for (tag in tags) {
        res <- tibble::tibble(
          topic = purrr::pluck(block, "object", "topic"),
          alias = purrr::pluck(block, "object", "alias"),
          file = tag$file,
          name = tag$val$name,
          code = tag$val$code
        )
        full_res <- tibble::add_row(full_res, res)
      }
      full_res
    }
  )  |>
    purrr::list_rbind()
}

#' @exportS3Method roxygen2::roclet_output
roclet_output.roclet_elfReusableExamples <- function(x, results, base_path, ...) {
  message("Found these (reusable) examples:")
  print(results)
  invisible(NULL)
}

#' An example documentation of a resuable example
#' @inheritDotParams paste
#' @elfReusableExamples lorem
#' paste2("ipsum", "dolor")
#' @noRd
paste2 <- function(...) paste(...)
