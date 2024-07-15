#' Helper to locally set options
#'
#' Combines options from [options] with [withr].
#' Same as [options::opt_set_local], except based on [withr::defer] and friends.
#'
#' @param x An option name.
#' @inheritParams options::opt_set
#' @inheritParams withr::defer
#' @keywords options helper
#' @export
opt_set_local2 <- function(x,
                           value,
                           envir = parent.frame(),
                           priority = c("first", "last")) {
  old <- options::opt_set(x = x, value = value, env = envir)
  # cannot just extend withr::local_ here,
  # because it has slightly different semantics
  withr::defer(
    options::opt_set(x, old, env = envir),
    envir = envir,
    priority = rlang::arg_match(priority)
  )
}
