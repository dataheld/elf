describe("roxy_tag_elfReusableExamples", {
  example <- brio::read_file(
    fs::path_package(
      package = "elf",
      "examples", "elfReusableExamples", "parse", ext = "R"
    )
  )
  it(
    "can be parsed",
    expect_snapshot(roxygen2::parse_text(example)[[1]]$tag)
  )
  it(
    "can separate name and code",
    expect_snapshot(roxygen2::parse_text(example)[[1]]$tag[[2]]$val)
  )
  it(
    "can be formatted",
    {
      topic <- roxygen2::roc_proc_text(roxygen2::rd_roclet(), example)[[1]]
      expect_snapshot(topic$get_section("examples"))
    }
  )
})
