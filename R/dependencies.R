# TODO replace this with upstream https://github.com/dataheld/elf/issues/1
#' Checks if a package is installed and *informs* the user if not
#'
#' This is wrapper around [rlang::check_installed];
#' instead of erroring out if the check fails it returns `FALSE`.
#' However, unlike [rlang::is_installed], it emits a message to the user.
#'
#' @inheritParams rlang::check_installed
#' @inheritDotParams rlang::check_installed
#' @example inst/examples/dependencies/is_installed2/missing.R
#' @example inst/examples/dependencies/is_installed2/present.R
#' @family dependencies helper
#' @export
is_installed2 <- function(...) {
  if (rlang::is_installed(...)) {
    return(TRUE)
  }
  rlang::try_fetch(
    # TODO this should only interact with the user as per .frequency
    # might get annoying otherwise
    # but that is blocked by deep integration in rlang
    rlang::check_installed(...),
    error = function(cnd) {
      inform_missing_pkgs(...)
    }
  )
  rlang::is_installed(...)
}

inform_missing_pkgs <- function(pkg, ...) {
  rlang::inform(
    message = cnd_header.elf_message_package_not_found(
      cnd = new_message_package_not_found(pkg = pkg, ...)
    ),
    .frequency = "once",
    .frequency_id = paste0("elf_message_package_not_found", pkg, collapse = "_")
  )
}

# copied, slightly adapted from rlang
# nolint start

new_message_package_not_found <- function(pkg,
                                          version = NULL,
                                          compare = NULL,
                                          reason = NULL) {
  rlang::message_cnd(
    class = "elf_message_package_not_found",
    pkg = pkg,
    version = version,
    compare = compare,
    reason = reason
  )
}

cnd_header.elf_message_package_not_found <- function(cnd) {
  pkg <- cnd$pkg
  version <- cnd$version
  compare <- cnd$compare
  reason <- cnd$reason
  n <- length(pkg)

  # Quote with `"` to make it easier to copy/paste (#1447)
  pkg_enum <- chr_quoted(cnd$pkg, type = "\"")

  if (!rlang::is_null(version)) {
    pkg_enum <- purrr::list_c(purrr::pmap(list(pkg_enum, compare, version), function(p, o, v) {
      if (rlang::is_na(v)) {
        p
      } else {
        sprintf("%s (%s %s)", p, o, v)
      }
    }))
  }

  pkg_enum <- oxford_comma(pkg_enum, final = "and")

  info <- cli::pluralize("The optional package{?s} {pkg_enum} {?is/are} missing.")

  if (rlang::is_null(reason)) {
    paste0(info, ".")
  } else {
    paste(info, reason)
  }
}

chr_quoted <- function(chr, type = "`") {
  paste0(type, chr, type)
}

oxford_comma <- function(chr, sep = ", ", final = "or") {
  n <- length(chr)

  if (n < 2) {
    return(chr)
  }

  head <- chr[seq_len(n - 1)]
  last <- chr[n]

  head <- paste(head, collapse = sep)

  # Write a or b. But a, b, or c.
  if (n > 2) {
    paste0(head, sep, final, " ", last)
  } else {
    paste0(head, " ", final, " ", last)
  }
}

# nolint end
