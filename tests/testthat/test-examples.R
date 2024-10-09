example <- brio::read_file(
  fs::path_package(
    package = "elf",
    "examples", "elfReusableExamples", "parse", ext = "R"
  )
)
describe("roxy_tag_elfReusableExamples", {
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
describe("roclet", {
  results <- roxygen2::roc_proc_text(reusableExamples_roclet(), example)
  it(
    "can retrieve code and metadata",
    expect_snapshot(results)
  )
  it(
    "can inform about found resuable calls",
    expect_snapshot(
      roxygen2::roclet_output(reusableExamples_roclet(), results)
    )
  )
  skip_if(
    is_checking(),
    "Can only run test on source, not installed package."
  )
  it(
    "can extract examples from full package",
    expect_snapshot(
      # drop file path, because it keeps changing
      extract_all_examples(blocks = roxygen2::parse_package("../.."))[-3]
    )
  )
})
