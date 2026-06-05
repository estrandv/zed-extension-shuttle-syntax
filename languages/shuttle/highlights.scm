(prefix) @variable
(suffix) @variable
(index) @number
(number) @number

(arg_name) @property
(ref) @property

(operator) @operator
(repeat "*" @operator)

(info ":" @punctuation.delimiter)
(args "," @punctuation.delimiter)

(section ["(" ")"] @punctuation.bracket)
(alternation "/" @operator)
