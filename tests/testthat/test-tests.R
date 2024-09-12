describe("make_skip_if_not_function", {
  it("returns invisibly if success", {
    expect_equal(
      make_skip_if_not_function(checkmate::check_scalar)(1),
      invisible()
    )
  })
  # can't easily test for failure, because then it would, well, skip.
})
