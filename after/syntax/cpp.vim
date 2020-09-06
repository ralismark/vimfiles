" Vim syntax file
" Language: C++ Additions
" Maintainer: Jon Haggblad <jon@haeggblad.com>
" URL: http://www.haeggblad.com
" Last Change: 21 Sep 2014
" Version: 0.5
" Changelog:
"   0.1 - initial version.
"   0.2 - C++14
"   0.3 - Incorporate lastest changes from Mizuchi/STL-Syntax
"   0.4 - Add template function highlight
"   0.5 - Redo template function highlight to be more robust. Add options.
"
" Additional Vim syntax highlighting for C++ (including C++11/14)
"
" This file contains additional syntax highlighting that I use for C++11/14
" development in Vim. Compared to the standard syntax highlighting for C++ it
" adds highlighting of (user defined) functions and the containers and types
" in the standard library / boost.
"
" Based on:
"   http://stackoverflow.com/questions/736701/class-function-names-highlighting-in-vim
"   http://www.vim.org/scripts/script.php?script_id=4293
"   http://www.vim.org/scripts/script.php?script_id=2224
"   http://www.vim.org/scripts/script.php?script_id=1640
"   http://www.vim.org/scripts/script.php?script_id=3064

" -----------------------------------------------------------------------------
"  Highlight Class and Function names.
"
" Based on the discussion in:
"   http://stackoverflow.com/questions/736701/class-function-names-highlighting-in-vim
" -----------------------------------------------------------------------------

" Functions
syn match   cCustomParen    "(" contains=cParen contains=cCppParen
syn match   cCustomFunc     "\w\+\s*(\@="
hi def link cCustomFunc  Function

" Class and namespace scope
syn match    cCustomScope    "::"
syn match    cCustomClass    "\w\+\s*::" 
        \contains=cCustomScope 
hi def link cCustomClass Function
syn match   cCustomClass    "\<\u\w*\s*\>" 

" Template functions
if exists('g:cpp_experimental_template_highlight') && g:cpp_experimental_template_highlight

    syn match   cCustomAngleBracketStart "<\_[^;()]\{-}>" contained 
                \contains=cCustomAngleBracketStart, cCustomAngleBracketEnd
    hi def link cCustomAngleBracketStart  cCustomAngleBracketContent

    syn match   cCustomAngleBracketEnd ">\_[^<>;()]\{-}>" contained 
                \contains=cCustomAngleBracketEnd
    hi def link cCustomAngleBracketEnd  cCustomAngleBracketContent

    syn match cCustomTemplateFunc "\<\l\w*\s*<\_[^;()]\{-}>(\@="hs=s,he=e-1 
                \contains=cCustomAngleBracketStart
    hi def link cCustomTemplateFunc  cCustomFunc

    syn match    cCustomTemplateClass    "\<\w\+\s*<\_[^;()]\{-}>" 
                \contains=cCustomAngleBracketStart,cCustomTemplateFunc 
    hi def link cCustomTemplateClass cCustomClass


    " Remove 'template' from cppStructure and use a custom match
    syn clear cppStructure 
    syn keyword cppStructure class typename namespace

    syn match   cCustomTemplate "\<template\>" 
    hi def link cCustomTemplate  cppStructure
    syn match   cTemplateDeclare "\<template\_s*<\_[^;()]\{-}>" 
                \contains=cppStructure,cCustomTemplate,cCustomAngleBracketStart 

    " Remove 'operator' from cppStructure and use a custom match
    syn clear cppOperator 
    syn keyword cppOperator typeid
    syn keyword cppOperator and bitor or xor compl bitand and_eq or_eq xor_eq not not_eq

    syn match   cCustomOperator "\<operator\>" 
    hi def link cCustomOperator  cppStructure
    syn match   cTemplateOperatorDeclare "\<operator\_s*<\_[^;()]\{-}>[<>]=\?" 
                \contains=cppOperator,cCustomOperator,cCustomAngleBracketStart 
endif

" Alternative syntax that is used in:
"  http://www.vim.org/scripts/script.php?script_id=3064
"syn match cUserFunction "\<\h\w*\>\(\s\|\n\)*("me=e-1 contains=cType,cDelimiter,cDefine
"hi def link cCustomFunc  Function

" Cluster for all the stdlib functions defined below
syn cluster cppSTLgroup     contains=cppSTLfunction,cppSTLfunctional,cppSTLconstant,cppSTLnamespace,cppSTLtype,cppSTLexception,cppSTLiterator,cppSTLiterator_tagcppSTLenumcppSTLioscppSTLcast

syntax keyword cppSTLnamespace std
syntax keyword cppSTLconstant nullptr

"raw string literals
syntax region cppRawString matchgroup=cppRawDelimiter start=@\%(u8\|[uLU]\)\=R"\z([[:alnum:]_{}[\]#<>%:;.?*\+\-/\^&|~!=,"']\{,16}\)(@ end=/)\z1"/ contains=@Spell

" syn match cppDecLiteral '[^\D0][\d'']*[uU]\?[lL]\{0,2\}'
" syn match cppOctLiteral '0[\o'']*[uU]\?[lL]\{0,2\}'
" syn match cppHexLiteral '0[xX][\x'']\+[uU]\?[lL]\{0,2\}'
" syn match cppBinLiteral '0[bB][01'']\+[uU]\?[lL]\{0,2\}'
" syn cluster cppIntLiteral contains=cppDecLiteral,cppOctLiteral,cppHexLiteral,cppBinLiteral
" 
" syn match cppFPNoDec '[^\D0][\d'']*[eE][+-]\?[&\D0][\d'']*[fFlL]\?'
" syn match cppFPDot '[^\D0][\d'']*\.([eE][+-]\?[&\D0][\d'']*)\?[fFlL]\?'
" syn match cppFPFract '([^\D0][\d'']*)\?\.[\d'']*([eE][+-]\?[&\D0][\d'']*)\?[fFlL]\?'
" syn match cppHexFP '0[xX][\x'']\+\.\?[\x'']*[pP][+-]\?[&\D0][\d'']*[fFlL]\?'
" syn cluster cppFPLiteral contains=cppFPNoDec,cppFPDot,cppFPFract,cppHexFP
" syn cluster cppNumLiteral contains=cppIntLiteral,cppFPLiteral

syn match cppReservedIdent "\<_[_\u]\w*\>"

" Default highlighting
if version >= 508 || !exists("did_cpp_syntax_inits")
  if version < 508
    let did_cpp_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink cppSTLfunction     Function
  HiLink cppSTLfunctional   Typedef
  HiLink cppSTLconstant     Constant
  HiLink cppSTLnamespace    Constant
  HiLink cppSTLtype         Typedef
  HiLink cppSTLexception    Exception
  HiLink cppSTLiterator     Typedef
  HiLink cppSTLiterator_tag Typedef
  HiLink cppSTLenum         Typedef
  HiLink cppSTLios          Function
  HiLink cppSTLcast         Statement " be consistent with official syntax
  HiLink cppRawString       String 
  HiLink cppRawDelimiter    Delimiter

  HiLink cppNumLiteral      Number
  delcommand HiLink
endif
