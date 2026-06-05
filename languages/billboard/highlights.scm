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

; Group filter names
(group_filter (group_name) @type)

; Track metadata content (inside <...>)
(track_metadata (group_override) @type)
(track_metadata (arg_list (arg_name) @property))
(track_metadata (arg_list (number) @number))
(track_metadata (arg_list (operator) @operator))

; DEFAULT statement args
(default_statement (arg_list (arg_name) @property))
(default_statement (arg_list (number) @number))
(default_statement (arg_list (operator) @operator))

; Argument lists (native Shuttle-style args)
(arg_name) @property
(ref) @property
(number) @number
(operator) @operator
(additional_config) @string

; Punctuation
["<" ">"] @punctuation.bracket
[":" ";" ","] @punctuation.delimiter
