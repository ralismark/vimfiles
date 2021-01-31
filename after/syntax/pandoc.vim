syntax keyword Todo TODO NOTE XXX

" For liquid

syntax region liquidTag matchgroup=Operator start="{%" end="%}"
hi def link liquidTag PreProc

syntax region liquidObject matchgroup=Operator start="{{" end="}}"
hi def link liquidObject PreProc

syntax match pandocReferenceLine /^\s*\[.*/ contains=pandocReferenceLabel,liquidTag,liquidObject
