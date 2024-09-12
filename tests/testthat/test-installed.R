describe("check_pkg_installed", {
  it(
    "accepts installed packages",
    expect_true(check_pkg_installed("base"))
  )
  it(
    "returns message for non-installed packages",
    expect_equal(
      check_pkg_installed("doNOTexist"),
      "Package doNOTexist is not installed"
    )

  )
})
