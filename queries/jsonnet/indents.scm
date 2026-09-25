; Containers and block structures
[
  (object)
  (array)
  (forloop)
  (parenthesis)
  (params)
  (args)
  (bind)
  (conditional)
  (anonymous_function)
] @indent.begin

; Closing delimiters dedent to match their opener
[
  "}"
  "]"
  ")"
] @indent.branch

; else dedents to match the if line
"else" @indent.branch

; Comments use autoindent
(comment) @indent.auto

; Don't modify indent inside strings
(string) @indent.ignore
