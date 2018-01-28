let s:base03 = [ '#000000', 0 ]
let s:base02 = [ '#000000', 0 ]
let s:base01 = [ '#00ff00', 10 ]
let s:base00 = [ '#ffff00', 11 ]
let s:base0 = [ '#0000ff', 12 ]
let s:base1 = [ '#00ffff', 14 ]
let s:base2 = [ '#c0c0c0', 7 ]
let s:base3 = [ '#ffffff', 15 ]

let s:yellow = [ '#808000', 14 ]
let s:orange = [ '#ffff00', 6 ]
let s:red = [ '#800000', 4 ]
let s:magenta = [ '#800080', 5 ]
let s:violet = [ '#ff00ff', 13 ]
let s:blue = [ '#000080', 1 ]
let s:cyan = [ '#008080', 3 ]
let s:green = [ '#008000', 2 ]

let s:white = [ '#ffffff', 15 ]
let s:black = [ '#000000', 0 ]

let s:fg = [ '#ffffff', 15 ]
let s:bg = [ '#000000', 0 ]

" {{{

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]
let s:p.normal.middle = [ [ s:fg, s:bg ] ]
let s:p.normal.right = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]

let s:p.inactive.right = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]
let s:p.inactive.middle = [ [ s:fg, s:bg ] ]
let s:p.inactive.left =  [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]

let s:p.insert.left = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]

let s:p.replace.left = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]

let s:p.visual.left = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]

let s:p.tabline.left = [ [ s:fg, s:bg ] ]
let s:p.tabline.tabsel = [ [ s:fg, s:bg ] ]
let s:p.tabline.middle = [ [ s:fg, s:bg ] ]
let s:p.tabline.right = copy(s:p.normal.right)

let s:p.normal.error = [ [ s:fg, s:bg ] ]
let s:p.normal.warning = [ [ s:fg, s:bg ] ]

" }}}

let s:p.normal.left     = [ [ s:black,  s:green   ] , [ s:white, s:black  ]  ]
let s:p.normal.middle   = [ [ s:black,  s:green   ]                          ]
let s:p.normal.right    = [ [ s:black,  s:white   ] , [ s:white, s:black  ]  ]

let s:p.normal.error    = [ [ s:base2,  s:red     ]                          ]
let s:p.normal.warning  = [ [ s:base02, s:yellow  ]                          ]

let s:p.insert.left     = [ [ s:black,  s:white   ] , [ s:white, s:base02 ]  ]
let s:p.insert.middle   = [ [ s:black,  s:blue    ]                          ]
let s:p.insert.right    = [ [ s:black,  s:white   ] , [ s:white, s:base02 ]  ]

let s:p.inactive.left   = [ [ s:white,  s:base02  ] , [ s:white, s:cyan   ]  ]
let s:p.inactive.middle = [ [ s:white,  s:cyan    ]                          ]
let s:p.inactive.right  = [ [ s:white,  s:base02  ] , [ s:white, s:cyan   ]  ]

let s:p.replace.left    = [ [ s:black,  s:red     ] , [ s:white, s:base03 ]  ]
let s:p.replace.middle  = [ [ s:black,  s:red     ]                          ]
let s:p.replace.right   = [ [ s:black,  s:white   ] , [ s:white, s:base03 ]  ]

let s:p.visual.left     = [ [ s:white,  s:magenta ] , [ s:white, s:black  ]  ]
let s:p.visual.middle   = [ [ s:white,  s:magenta ]                          ]
let s:p.visual.right    = [ [ s:black,  s:white   ] , [ s:white, s:black  ]  ]

let s:p.tabline.left    = [ [ s:white,  s:cyan    ]                          ]
let s:p.tabline.tabsel  = [ [ s:black,  s:orange  ]                          ]
let s:p.tabline.middle  = [ [ s:white,  s:black   ]                          ]
let s:p.tabline.right   = [ [ s:white,  s:blue    ]                          ]

let g:lightline#colorscheme#ll_theme#palette = lightline#colorscheme#flatten(s:p)
