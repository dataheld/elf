# roxy_tag_elfReusableExamples: can be parsed

    Code
      roxygen2::parse_text(example)[[1]]$tag
    Output
      [[1]]
      [<text>:  1] @title 'An example documentation of a resuable example' {parsed}
      
      [[2]]
      [<text>:  2] @elfReusableExamples 'foo...' {parsed}
      
      [[3]]
      [<text>:  4] @elfReusableExamples 'bar...' {parsed}
      
      [[4]]
      [<text>:  6] @usage '<generated>' {parsed}
      
      [[5]]
      [<text>:  6] @.formals '<generated>' {parsed}
      
      [[6]]
      [<text>:  6] @backref '<generated>' {parsed}
      

# roxy_tag_elfReusableExamples: can separate name and code

    Code
      roxygen2::parse_text(example)[[1]]$tag[[2]]$val
    Output
      $name
      [1] "foo"
      
      $code
      [1] "zap_fun(1, 2)"
      

# roxy_tag_elfReusableExamples: can be formatted

    Code
      topic$get_section("examples")
    Output
      \examples{
      # foo
      zap_fun(1, 2)
      # bar
      zap_fun(2, 3)
      } 

