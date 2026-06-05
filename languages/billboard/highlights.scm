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

; Argument list items (in synth headers, effects, track metadata, DEFAULT)
(arg_list (arg (arg_name) @property))
(arg_list (arg (ref) @property))
(arg_list (arg (number) @number))
(arg_list (arg (operator) @operator))

; Trailing sampler config in synth headers
(additional_config) @string

; Punctuation
["<" ">"] @punctuation.bracket
[":" ";" ","] @punctuation.delimiter
