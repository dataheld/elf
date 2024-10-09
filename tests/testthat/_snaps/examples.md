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
      [<text>:  6] @.formals '<generated>' {unparsed}
      
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

# roclet: can retrieve code and metadata

    Code
      results
    Output
      # A tibble: 3 x 5
        topic   alias   file   name  code                                             
        <chr>   <chr>   <chr>  <chr> <chr>                                            
      1 zap_fun zap_fun <text> foo   "zap_fun(1, 2)"                                  
      2 zap_fun zap_fun <text> bar   "zap_fun(2, 3)"                                  
      3 qux_fun qux_fun <text> baz   "qux_fun(3, 4)\nonly the result of this should b~

# roclet: can inform about found resuable calls

    Code
      roxygen2::roclet_output(reusableExamples_roclet(), results)
    Message
      Found these (reusable) examples:
    Output
      # A tibble: 3 x 5
        topic   alias   file   name  code                                             
        <chr>   <chr>   <chr>  <chr> <chr>                                            
      1 zap_fun zap_fun <text> foo   "zap_fun(1, 2)"                                  
      2 zap_fun zap_fun <text> bar   "zap_fun(2, 3)"                                  
      3 qux_fun qux_fun <text> baz   "qux_fun(3, 4)\nonly the result of this should b~

