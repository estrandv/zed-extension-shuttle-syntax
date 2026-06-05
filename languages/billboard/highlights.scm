; JDW Billboarding syntax highlighting

(comment) @comment

; Line-type markers
">>>" @keyword
"@" @keyword
(selected) @keyword
"€" @keyword
(command_type) @keyword
"DEFAULT" @keyword

; Identifiers
(synth_header (instrument_name) @function)
(group_name) @type
(group_override) @type
(effect_type) @function
(effect_id) @constant
(address) @function
(command_arg) @variable

; Argument lists (native Shuttle-style args)
(arg_name) @property
(ref) @property
(number) @number
(operator) @operator
(additional_config) @string

; Punctuation
["<" ">"] @punctuation.bracket
[":" ";" ","] @punctuation.delimiter
