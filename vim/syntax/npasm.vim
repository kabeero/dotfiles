" Vim syntax file
" Language: NP Assembly
" Maintainer: Joseph Schmitz
" Latest Revision: 07 July 2012
if exists ("b:current_syntax")
    finish
endif

" Ignore case.
syn case ignore

" Labels inside comments.
syn keyword npasmTodo contained TODO FIXME XXX NOTE

" Comments themselves, indicated by a ';'.
syn match npasmComment ";.*$" contains=npasmTodo

" Labels.
syn match npasmLabel "\w*:"

" Preprocessor keywords.
syn match npasmDefine '#DEFINE'

" Expressions.
syn region npasmExpression start='{' end='}'

" Integer constants, binary and hex.
syn match npasmInt "\<\d\+\>" display
syn match npasmInt "\<[01]\+[b]\>" display
syn match npasmInt "\<\x\+[h]\>" display
 
" Instruction keywords.
syn keyword npasmInstruction ADD ADC SUB SBB
syn keyword npasmInstruction AND ORR EOR
syn keyword npasmInstruction CMP LDR STR OUT
syn keyword npasmInstruction BEQ BNE BCS BHS BCC BLO BMI BPL BVS BVC BHI BLS BZ BNZ
syn keyword npasmInstruction BGE BLT BGT BLE BAL B
syn keyword npasmInstruction ZEQ ZNE ZCS ZHS ZCC ZLO ZMI ZPL ZVS ZVC ZHI ZLS
syn keyword npasmInstruction ZGE ZLT ZGT ZLE ZAL Z
syn keyword npasmInstruction ASR LSL LSR
syn keyword npasmInstruction BL BX RST NOP WAK IMG GTB
syn keyword npasmInstruction TINTL TINTH TRSTL TRSTH

" Data source keywords.
syn keyword npasmDataSource X Y Z
syn keyword npasmDataSource V0 V1 V2 V3 V4 V5 V6 V7
syn keyword npasmDataSource R0 R1 R2 R3
syn keyword npasmDataSource N S W E
syn keyword npasmDataSource SR RCR

let b:current_syntax = "npasm"

hi def link npasmTodo           Todo
hi def link npasmComment        Comment
hi def link npasmInstruction    Statement
hi def link npasmDefine         Define
hi def link npasmExpression     PreProc
hi def link npasmDataSource     Type
hi def link npasmLabel          Function
hi def link npasmInt            Number
