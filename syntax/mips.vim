" Vim syntax file
" Language: MIPS
" Original Author: Alex Brick <alex@alexrbrick.com>
" Maintainer: Harenome Ranaivoarivony Razanajato <harno.ranaivo@gmail.com>
" Maintainer: Timmy Yao <timmy.yao@outlook.com.au>
" Last Change: 2020 Jun 23
" Based on Alex Brick's syntax file:
" http://www.vim.org/scripts/script.php?script_id=2045

" Init {{{
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

setlocal iskeyword+=-
setlocal iskeyword+=$
setlocal iskeyword+=.
syntax case match

set comments=:#
set commentstring=#\ %s

" }}}

" Basics {{{

syntax match mipsComment /#.*/
syntax match mipsNumber /\<[-]\?\d\+\>/ " Decimal numbers
syntax match mipsNumber /\<-\?0\(x\|X\)[0-9a-fA-F]\+\>/ " Hex numbers
syntax region mipsString start=/"/ skip=/\\"/ end=/"/
syntax region mipsChar start=/'/ skip=/\\'/ end=/'/
syntax match mipsLabel /\w\+:/he=e-1

" }}}

" Registers {{{

" Raw integer registers
syntax keyword mipsRegisterRawInt $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12 $13
syntax keyword mipsRegisterRawInt $14 $15 $16 $17 $18 $19 $20 $21 $22 $23 $24
syntax keyword mipsRegisterRawInt $25 $26 $27 $28 $29 $30 $31

hi def link mipsRegisterRawInt mipsRegisterRaw

" Raw float registers
syntax match mipsRegisterRawFloat /\$f[12][0-9]/
syntax match mipsRegisterRawFloat /\$f3[01]/
syntax match mipsRegisterRawFloat /\$f[0-9]/

hi def link mipsRegisterRawFloat mipsRegisterRaw

" Named registers
syntax keyword mipsRegisterZero          $0 $r0 $zero
syntax keyword mipsRegisterAsmTemp       $at
syntax keyword mipsRegisterReturn        $v0 $v1
syntax keyword mipsRegisterArg           $a0 $a1 $a2 $a3
syntax keyword mipsRegisterTemp          $t0 $t1 $t2 $t3 $t4 $t5 $t6 $t7 $t8 $t9
syntax keyword mipsRegisterSaved         $s0 $s1 $s2 $s3 $s4 $s5 $s6 $s7 $s8 $s9
syntax keyword mipsRegisterKernel        $k0 $k1
syntax keyword mipsRegisterGlobalPointer $gp
syntax keyword mipsRegisterStackPointer  $sp
syntax keyword mipsRegisterFramePointer  $fp
syntax keyword mipsRegisterReturnAddr    $ra

hi def link mipsRegisterZero          mipsRegisterCommon
hi def link mipsRegisterSaved         mipsRegisterCommon
hi def link mipsRegisterTemp          mipsRegisterCommon
hi def link mipsRegisterReturn        mipsRegisterCalling
hi def link mipsRegisterArg           mipsRegisterCalling
hi def link mipsRegisterGlobalPointer mipsRegisterCalling
hi def link mipsRegisterStackPointer  mipsRegisterCalling
hi def link mipsRegisterFramePointer  mipsRegisterCalling
hi def link mipsRegisterReturnAddr    mipsRegisterCalling
hi def link mipsRegisterAsmTemp       mipsRegisterInternal
hi def link mipsRegisterKernel        mipsRegisterInternal

" }}}

" Directives {{{

syntax keyword mipsDirective .2byte .4byte .8byte .aent .align .ascii .asciiz
syntax keyword mipsDirective .byte .comm .cpadd .cpload .cplocal .cprestore
syntax keyword mipsDirective .cpreturn .cpsetup .data .double .dword .dynsym
syntax keyword mipsDirective .end .endr .ent .extern .file .float .fmask
syntax keyword mipsDirective .frame .globl .gpvalue .gpword .half .kdata
syntax keyword mipsDirective .ktext .lab .lcomm .loc .mask .nada .nop .option
syntax keyword mipsDirective .origin .repeat .rdata .sdata .section .set
syntax keyword mipsDirective .size .space .struct .text .type .verstamp
syntax keyword mipsDirective .weakext .word

" }}}

" Instruction Sets {{{
" MIPS1 {{{
" Instructions {{{
syntax keyword mipsInstruction add addi addiu addu
syntax keyword mipsInstruction and andi
syntax keyword mipsInstruction bc0f bc0t bc1f bc1t bc2f bc2t bc3f bc3t
syntax keyword mipsInstruction beq beqz
syntax keyword mipsInstruction bgez bgezal bgtz
syntax keyword mipsInstruction blez bltz bltzal
syntax keyword mipsInstruction bne bnez
syntax keyword mipsInstruction break
syntax keyword mipsInstruction c0 c1 c2 c3
syntax keyword mipsInstruction cfc0 cfc1 cfc2 cfc3
syntax keyword mipsInstruction ctc0 ctc1 ctc2 ctc3
syntax keyword mipsInstruction div divu
syntax keyword mipsInstruction j jal jalr jalx jr
syntax keyword mipsInstruction lb lbu lh lhu lui
syntax keyword mipsInstruction lw lwc0 lwc1 lwc2 lwc3 lwl lwr
syntax keyword mipsInstruction mfc0 mfc1 mfc2 mfc3 mfhi mflo
syntax keyword mipsInstruction mtc0 mtc1 mtc2 mtc3 mthi mtlo
syntax keyword mipsInstruction mult multu
syntax keyword mipsInstruction neg negu
syntax keyword mipsInstruction nor not or ori
syntax keyword mipsInstruction rem remu rfe
syntax keyword mipsInstruction sb sh
syntax keyword mipsInstruction sll sllv slt slti sltiu sltu
syntax keyword mipsInstruction sra srav srl srlv
syntax keyword mipsInstruction sub subu
syntax keyword mipsInstruction sw swc0 swc1 swc2 swc3 swl swr
syntax keyword mipsInstruction syscall
syntax keyword mipsInstruction tlbp tlbr tlbwi tlbwr
syntax keyword mipsInstruction xor xori

syntax keyword mipsInstruction abs.d abs.s
syntax keyword mipsInstruction add.d add.s
syntax keyword mipsInstruction c.eq.d c.eq.s
syntax keyword mipsInstruction c.f.d c.f.s
syntax keyword mipsInstruction c.le.d c.le.s
syntax keyword mipsInstruction c.lt.d c.lt.s
syntax keyword mipsInstruction c.nge.d c.nge.s
syntax keyword mipsInstruction c.ngl.d c.ngl.s
syntax keyword mipsInstruction c.ngle.d c.ngle.s
syntax keyword mipsInstruction c.ngt.d c.ngt.s
syntax keyword mipsInstruction c.ole.d c.ole.s
syntax keyword mipsInstruction c.olt.d c.olt.s
syntax keyword mipsInstruction c.seq.d c.seq.s
syntax keyword mipsInstruction c.sf.d c.sf.s
syntax keyword mipsInstruction c.ueq.d c.ueq.s
syntax keyword mipsInstruction c.ule.d c.ule.s
syntax keyword mipsInstruction c.ult.d c.ult.s
syntax keyword mipsInstruction c.un.d c.un.s
syntax keyword mipsInstruction cvt.d.s cvt.d.w cvt.s.d cvt.s.w cvt.w.d cvt.w.s
syntax keyword mipsInstruction div.d div.s
syntax keyword mipsInstruction l.s
syntax keyword mipsInstruction mov.d mov.s
syntax keyword mipsInstruction mul.d mul.s
syntax keyword mipsInstruction neg.d neg.s
syntax keyword mipsInstruction s.s
syntax keyword mipsInstruction sub.d sub.s
"}}}

" Alias {{{
syntax keyword mipsAlias b bal
syntax keyword mipsAlias ehb
syntax keyword mipsAlias nop ssnop
"}}}

" Macros {{{
syntax keyword mipsMacro abs
syntax keyword mipsMacro bge bgeu bgt bgtu ble bleu blt Highlights bltu
syntax keyword mipsMacro cop0 cop1 cop2 cop3
syntax keyword mipsMacro la lca ld li
syntax keyword mipsMacro move
syntax keyword mipsMacro mul mulo mulou
syntax keyword mipsMacro rol ror
syntax keyword mipsMacro sd seq sge sgeu sgt sgtu
syntax keyword mipsMacro sle sleu sne
syntax keyword mipsMacro ulh ulhu ulw ush usw

syntax keyword mipsMacro l.d
syntax keyword mipsMacro s.d
syntax keyword mipsMacro li.d li.s
syntax keyword mipsMacro trunc.w.d trunc.w.s
"}}}
"}}}

" MIPS2 {{{
" Instructions {{{
syntax keyword mipsInstruction bc0fl bc0tl bc1fl bc1tl bc2fl bc2tl bc3fl bc3tl
syntax keyword mipsInstruction beql beqzl
syntax keyword mipsInstruction bgezall bgezl bgtzl
syntax keyword mipsInstruction blezl bltzall bltzl
syntax keyword mipsInstruction bnel bnezl
syntax keyword mipsInstruction flush
syntax keyword mipsInstruction invalidate
syntax keyword mipsInstruction lcache
syntax keyword mipsInstruction ldc1 ldc2 ldc3 ll
syntax keyword mipsInstruction sc scache sdc1 sdc2 sdc3
syntax keyword mipsInstruction sync
syntax keyword mipsInstruction teq teqi
syntax keyword mipsInstruction tge tgei tgeiu tgeu
syntax keyword mipsInstruction tlt tlti tltiu tltu
syntax keyword mipsInstruction tne tnei

syntax keyword mipsInstruction ceil.w.d ceil.w.s
syntax keyword mipsInstruction floor.w.d floor.w.s
syntax keyword mipsInstruction round.w.d round.w.s
syntax keyword mipsInstruction sqrt.d sqrt.s
syntax keyword mipsInstruction sync.l sync.p
"}}}

" Macros {{{
syntax keyword mipsMacro bgel bgeul bgtl bgtul
syntax keyword mipsMacro blel bleul bltl bltul
"}}}
"}}}

" MIPS3 {{{
syntax keyword mipsInstruction cache
syntax keyword mipsInstruction clo clz
syntax keyword mipsInstruction dabs dadd daddi daddiu daddu
syntax keyword mipsInstruction dctr dctw
syntax keyword mipsInstruction ddiv ddivu
syntax keyword mipsInstruction deret
syntax keyword mipsInstruction di
syntax keyword mipsInstruction dla dlca dli
syntax keyword mipsInstruction dmfc0 dmfc1 dmfc2 dmfc3
syntax keyword mipsInstruction dmtc0 dmtc1 dmtc2 dmtc3
syntax keyword mipsInstruction dmul dmulo dmulou dmult dmultu
syntax keyword mipsInstruction dneg dnegu
syntax keyword mipsInstruction drem dremu
syntax keyword mipsInstruction drol dror
syntax keyword mipsInstruction dsll dsll32 dsllv
syntax keyword mipsInstruction dsra dsra32 dsrav dsrl dsrl32 dsrlv
syntax keyword mipsInstruction dsub dsubu
syntax keyword mipsInstruction ei
syntax keyword mipsInstruction eret
syntax keyword mipsInstruction ext
syntax keyword mipsInstruction ins
syntax keyword mipsInstruction ldl ldr lld lwu
syntax keyword mipsInstruction madd maddu
syntax keyword mipsInstruction mfhc1 mfhc2
syntax keyword mipsInstruction msub msubu
syntax keyword mipsInstruction mthc1 mthc2
syntax keyword mipsInstruction pause
syntax keyword mipsInstruction rdhwr rdpgpr
syntax keyword mipsInstruction rorv rotl rotr rotrv
syntax keyword mipsInstruction scd
syntax keyword mipsInstruction sdbbp sdl sdr
syntax keyword mipsInstruction seb
syntax keyword mipsInstruction seh
syntax keyword mipsInstruction sync_acquire synci sync_release
syntax keyword mipsInstruction sync_mb sync_rmb sync_wmb
syntax keyword mipsInstruction udi0 udi1 udi2 udi3 udi4 udi5 udi6 udi7 udi8 udi9
syntax keyword mipsInstruction udi10 udi11 udi12 udi13 udi14 udi15
syntax keyword mipsInstruction uld usd
syntax keyword mipsInstruction wait
syntax keyword mipsInstruction wrpgpr
syntax keyword mipsInstruction wsbh

syntax keyword mipsInstruction ceil.l.d ceil.l.s
syntax keyword mipsInstruction cvt.d.l cvt.l.d
syntax keyword mipsInstruction cvt.l.s cvt.s.l
syntax keyword mipsInstruction floor.l.d floor.l.s
syntax keyword mipsInstruction jalr.hb
syntax keyword mipsInstruction jr.hb
syntax keyword mipsInstruction round.l.d round.l.s
syntax keyword mipsInstruction trunc.l.d trunc.l.s
"}}}

" MIPS4 32 {{{
syntax keyword mipsInstruction movf movn movt movz
syntax keyword mipsInstruction pref

syntax keyword mipsInstruction movf.d movf.s
syntax keyword mipsInstruction movn.d movn.s
syntax keyword mipsInstruction movt.d movt.s
syntax keyword mipsInstruction movz.d movz.s
"}}}

" MIPS4 32R2 {{{
syntax keyword mipsInstruction ldxc1
syntax keyword mipsInstruction lwxc1
syntax keyword mipsInstruction prefx
syntax keyword mipsInstruction sdxc1
syntax keyword mipsInstruction swxc1

syntax match mipsInstruction "madd\.d"
syntax match mipsInstruction "madd\.s"
syntax match mipsInstruction "msub\.d"
syntax match mipsInstruction "msub\.s"
syntax match mipsInstruction "nmadd\.d"
syntax match mipsInstruction "nmadd\.s"
syntax match mipsInstruction "nmsub\.d"
syntax match mipsInstruction "nmsub\.s"
syntax match mipsInstruction "recip\.d"
syntax match mipsInstruction "recip\.s"
syntax match mipsInstruction "rsqrt\.d"
syntax match mipsInstruction "rsqrt\.s"
"}}}

" MIPS5 32R2 {{{
syntax keyword mipsInstruction luxc1
syntax keyword mipsInstruction suxc1

syntax match mipsInstruction "abs\.ps"
syntax match mipsInstruction "add\.ps"
syntax match mipsInstruction "alnv\.ps"
syntax match mipsInstruction "c\.eq\.ps"
syntax match mipsInstruction "c\.f\.ps"
syntax match mipsInstruction "c\.le\.ps"
syntax match mipsInstruction "c\.lt\.ps"
syntax match mipsInstruction "c\.nge\.ps"
syntax match mipsInstruction "c\.ngl\.ps"
syntax match mipsInstruction "c\.ngle\.ps"
syntax match mipsInstruction "c\.ngt\.ps"
syntax match mipsInstruction "c\.ole\.ps"
syntax match mipsInstruction "c\.olt\.ps"
syntax match mipsInstruction "c\.seq\.ps"
syntax match mipsInstruction "c\.sf\.ps"
syntax match mipsInstruction "c\.ueq\.ps"
syntax match mipsInstruction "c\.ule\.ps"
syntax match mipsInstruction "c\.ult\.ps"
syntax match mipsInstruction "c\.un\.ps"
syntax match mipsInstruction "cvt\.ps\.s"
syntax match mipsInstruction "cvt\.s\.pl"
syntax match mipsInstruction "cvt\.s\.pu"
syntax match mipsInstruction "madd\.ps"
syntax match mipsInstruction "mov\.ps"
syntax match mipsInstruction "movf\.ps"
syntax match mipsInstruction "movn\.ps"
syntax match mipsInstruction "movt\.ps"
syntax match mipsInstruction "movz\.ps"
syntax match mipsInstruction "msub\.ps"
syntax match mipsInstruction "mul\.ps"
syntax match mipsInstruction "neg\.ps"
syntax match mipsInstruction "nmadd\.ps"
syntax match mipsInstruction "nmsub\.ps"
syntax match mipsInstruction "pll\.ps"
syntax match mipsInstruction "plu\.ps"
syntax match mipsInstruction "pul\.ps"
syntax match mipsInstruction "puu\.ps"
syntax match mipsInstruction "sub\.ps"
"}}}

" MIPS64 {{{
syntax keyword mipsInstruction dclo dclz
"}}}

" MIPS64R2 {{{
" Instructions {{{
syntax keyword mipsInstruction dext dextm dextu
syntax keyword mipsInstruction dins dinsm dinsu
syntax keyword mipsInstruction dror32 drorv drotr32 drotrv
syntax keyword mipsInstruction dsbh dshd
"}}}

" Macros {{{
syntax keyword mipsMacro drotl drotr
"}}}
"}}}
"}}}

" Pseudo things {{{
" Some compilers and emulators support some
" of the following instructions, directives, etc.

syntax keyword mipsPseudoInstruction subi subiu
syntax keyword mipsPseudoInstruction blti
syntax keyword mipsPseudoInstruction clear
syntax keyword mipsPseudoDirective .macro .end_macro .include .eqv

"}}}

" MPP Extensions {{{

syntax keyword mipsDirective .let
syntax match mipsVariable /@\S\+/
hi def link mipsVariable Identifier

" }}}

" Highlights Linking {{{

hi def link mipsComment Comment
hi def link mipsNumber Number
hi def link mipsString String
hi def link mipsChar Character
hi def link mipsLabel Label

if !exists("g:mips_internal") || !g:mips_internal
	" just for the different colour
	hi def link mipsRegisterCalling  Structure
	hi def link mipsRegisterRaw      Error
	hi def link mipsRegisterInternal Error
	hi def link mipsRegisterCommon   Identifier
else
	hi def link mipsRegisterCalling  Identifier
	hi def link mipsRegisterRaw      Identifier
	hi def link mipsRegisterInternal Identifier
	hi def link mipsRegisterCommon   Identifier
endif

hi def link mipsDirective           Type
hi def link mipsAlias               mipsInstruction
hi def link mipsMacro               mipsInstruction
hi def link mipsInstruction         Statement
hi def link mipsPseudoInstruction   PreProc
hi def link mipsPseudoDirective     PreProc

" }}}

let b:current_syntax = "mips"
" vim:ft=vim:fdm=marker:
