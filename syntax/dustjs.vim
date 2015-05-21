" Vim syntax file
" Language:     Dustjs
" Maintainer:   Vladimir Chizhov <me@vchizhov.com>
" Remarks:
"   - Original DustJS by LinkedIn repo and site:
"     https://github.com/linkedin/dustjs
"     http://dustjs.com
"   - Another vim syntax file, that inspired this work:
"     https://github.com/jimmyhchan/dustjs.vim
"
" Licensed under the same terms as Vim itself.
"
" ================================================================================


" Read the HTML syntax to start with
if version < 600
  so <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim
  unlet b:current_syntax
endif

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Standard HiLink will not work with included syntax files
if version < 508
  command! -nargs=+ HiLink hi link <args>
else
  command! -nargs=+ HiLink hi def link <args>
endif


syn region  dustjsUnmatched       matchgroup=dustjsUnmatchedBars start='{' end='}'

syn region  dustjsRef             start='\v[{][^ \t]'he=e-1 end='}' contains=@dustjsIdentifier oneline containedin=@htmlDustjsContainer

syn region  dustjsComment         start='{!' end='!}'

syn match   dustjsPath            /\v\.|[a-zA-Z_$][0-9a-zA-Z_$]*/ contained
syn match   dustjsFilter          /\v\|[a-zA-Z_$][0-9a-zA-Z_$]*/ contained
syn match   dustjsNoFilter        /|/ contained
syn cluster dustjsIdentifier      contains=dustjsPath,dustjsFilter

syn region  dustjsSection         start='\v[{][#?^<+@%:]' end='\v[/]?[}]' contains=dustjsPath,@dustjsParams,dustjsSectionUnclosed,dustjsNoFilter containedin=@htmlDustjsContainer
syn region  dustjsSectionClose    start='{/' end='}' contains=dustjsPath,dustjsNoFilter containedin=@htmlDustjsContainer
syn match   dustjsSectionUnclosed /\/[ \t]\+}/ contained

syn region  dustjsPartial         start='{>' end='}' contains=dustjsPartialName,dustjsPartialPath,@dustjsParams,dustjsPartialUnclosed,dustjsSectionUnclosed,dustjsNoFilter
syn match   dustjsPartialName     />\@<=\v[a-zA-Z_$][0-9a-zA-Z_$]*/ contained
syn match   dustjsPartialPath     />\@<=\v\"(([a-zA-Z_$][0-9a-zA-Z_$]*)|\/|\.)*\"/ contained
syn match   dustjsPartialUnclosed /\/\@<!}/ contained

syn region  dustjsParamName       start=/[\t ]/ end=/=/me=e-1,he=e-1 contained nextgroup=dustjsParamValueAtom,dustjsParamValueExpr oneline
syn region  dustjsParamValueAtom  start=/=/hs=s+1 end=/\v[0-9a-zA-Z_$]*/ contained oneline
syn region  dustjsParamValueExpr  start=/=\"/hs=s+1 skip='\\"' end=/\"/ contained oneline contains=dustjsRef,dustjsSpecial
syn cluster dustjsParams          contains=dustjsParamName,dustjsParamValueAtom,dustjsParamValueExpr

syn region  dustjsSpecial         start='{\~' end='}' containedin=@htmlDustjsContainer

syn cluster htmlDustjsContainer   add=htmlHead,htmlTitle,htmlString,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,htmlLink,htmlBold,htmlUnderline,htmlItalic,htmlValue

HiLink dustjsSection              Statement
HiLink dustjsSectionClose         Statement
HiLink dustjsComment              Comment
HiLink dustjsRef                  Statement
HiLink dustjsPath                 Identifier
HiLink dustjsFilter               Special
HiLink dustjsSpecial              Special
HiLink dustjsBuiltin              Special
HiLink dustjsPartialName          Include
HiLink dustjsPartialPath          Include
HiLink dustjsPartial              Statement
HiLink dustjsPathSep              Include
HiLink dustjsParamName            Type
HiLink dustjsParamValueAtom       Identifier
HiLink dustjsParamValueExpr       String

" Errors
HiLink  dustjsPartialUnclosed     Error
HiLink  dustjsSectionUnclosed     Error
HiLink  dustjsNoFilter            Error
HiLink  dustjsUnmatchedBars       Error
HiLink  dustjsUnmatched           NONE

let b:current_syntax = "dustjs"
delcommand HiLink

