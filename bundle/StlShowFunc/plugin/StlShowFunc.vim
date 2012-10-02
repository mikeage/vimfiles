" StlShowFunc.vim : status line show-function script
"   Author: Charles E. Campbell
"   Date:   Sep 24, 2012
"   Version: 2q	ASTRO-ONLY
"   Copyright: Charles E. Campbell (09/24/12) (see StlShowFunc.txt for license)
" =====================================================================
" Load Once: {{{1
if &cp || exists("g:loaded_StlShowFunc")
 finish
endif
let s:keepcpo= &cpo
set cpo&vim
let g:loaded_StlShowFunc= "v2q"

" =====================================================================
" Commands: {{{1
com! -bang -nargs=* StlShowFunc	call s:ShowFuncSetup(<bang>1,<f-args>)

" =====================================================================
" Settings:
if !exists("b:stlshowfunc_keep")
 let b:stlshowfunc_keep= &l:stl
endif
if !exists("g:stlshowfunc_stlnofunc")
 let s:stlshowfunc_stlnofunc= '%1*%f%2* %{&kmp }%h%m%r%0*%=%-14.(%l,%c%V%)%< %P Win#%{winnr()} %{winwidth(0)}x%{winheight(0)} %<%{strftime("%a %b %d, %Y, %I:%M:%S %p")}'
else
 let s:stlshowfunc_stlnofunc= g:stlshowfunc_stlnofunc
endif
if !exists("g:stlshowfunc_stlfunc")
 let s:stlshowfunc_stlfunc = '%1*%f %3*%{StlShowFunc()}%2* %h%m%r%0* %= %-14.(%l,%c%V%)%< %P Win#%{winnr()} %{winwidth(0)}x%{winheight(0)} %<%{strftime("%a %b %d, %Y, %I:%M:%S %p")}'
else
 let s:stlshowfunc_stlfunc = g:stlshowfunc_stlfunc
endif
let &l:stl=s:stlshowfunc_stlnofunc

"  Set up User[1234] highlighting only if they're not already defined. {{{2
hi def User1 ctermfg=white ctermbg=blue guifg=white guibg=blue
hi def User2 ctermfg=cyan  ctermbg=blue guifg=cyan  guibg=blue
hi def User3 ctermfg=green ctermbg=blue guifg=green guibg=blue
hi def User4 ctermfg=red   ctermbg=blue guifg=red   guibg=blue

" =====================================================================
"  Functions: {{{1

" ---------------------------------------------------------------------
" ShowFuncSetup: toggle the display of containing function in the status line {{{2
"    StlShowFunc  [lang] - turn showfunc on
"    StlShowFunc!        - turn showfunc off
fun! s:ShowFuncSetup(mode,...)
"  call Dfunc("ShowFuncSetup(mode=".a:mode.") a:0=".a:0)

  if a:0 >= 1
   let stlhandler= a:1
"   call Decho("stlhandler<".stlhandler.">")
  endif
  if a:0 >= 2
   let stlhandlerlist= a:2
"   call Decho("stlhandlerlist<".stlhandlerlist.">")
  elseif a:0 >= 1
   let stlhandlerlist= "*.".a:1
  else
   let stlhandlerlist= "*.".&ft
  endif
  if !exists("s:showfunclang")
   let s:showfunclang= []
  endif

  if a:mode
   " turning StlShowFunc mode on
   if a:0 == 0
	echohl Error | echo "(ShowFuncSetup) missing stlhandler" | echohl None
"	call Dret("ShowFuncSetup : missing stlhandler")
	return
   endif
   " check if stlhandler has already been added to the autocmd list
   if count(s:showfunclang,stlhandler) == 0
   	let s:showfunc= 0
	call add(s:showfunclang,stlhandler)
"	call Decho('s:showfunclang'.string(s:showfunclang))
   endif
"   call Decho("s:showfunc ".(exists("s:showfunc")? "exists" : "doesn't exist"))
"   call Decho("StlShowFunc_".stlhandler."() ".(exists("*StlShowFunc_".stlhandler)? "exists" : "doesn't exist"))

   if (!exists("s:showfunc") || s:showfunc == 0) && exists("*StlShowFunc_".stlhandler)
   	" enable StlShowFunc for stlhandler language
"	call Decho("enabling StlShowFunc_".stlhandler)
    let s:showfunc= 1
"    call Decho("exe au CursorMoved *.".stlhandler." call StlShowFunc_".stlhandler."()")
    augroup STLSHOWFUNC
	 exe "au CursorMoved ".stlhandlerlist." call StlShowFunc_".stlhandler."()"
    augroup END
"	call Decho("exe call StlShowFunc_".stlhandler."()")
	exe "call StlShowFunc_".stlhandler."()"
   endif

  else
   " turning StlShowFunc mode off
   " remove *all* StlShowFunc handlers
   if exists("s:showfunc") && s:showfunc == 1
"	call Decho("disabling all StlShowFunc_*")
	let &l:stl=b:stlshowfunc_keep
    augroup STLSHOWFUNC
    	au!
    augroup END
    augroup! STLSHOWFUNC
   endif
   let s:showfunc     = 0
   let s:showfunclang = []
  endif

"  call Dret("ShowFuncSetup")
endfun

" ---------------------------------------------------------------------
" StlShowFunc: {{{2
fun! StlShowFunc()
  if exists("s:stlshowfunc_{winnr()}")
   return s:stlshowfunc_{winnr()}
  endif
  return ""
endfun

" ---------------------------------------------------------------------
" StlSetFunc: assigns a funcname to a window {{{2
"             A funcname of "" clears the window-associated function name
fun! StlSetFunc(funcname)
"  call Dfunc("StlSetFunc(funcname<".a:funcname.">)")
  if a:funcname == ""
   " remove the funcname to window association
   if exists("s:stlshowfunc_{winnr()}")
   	unlet s:stlshowfunc_{winnr()}
   endif
  else
   " set up the window to function name association
   " also set up the status line option to show the function
   let s:stlshowfunc_{winnr()} = a:funcname
   let &l:stl                  = s:stlshowfunc_stlfunc
  endif
"  call Dret("StlSetFunc")
endfun

" =====================================================================
" Modelines: {{{1
" vim: fdm=marker
let &cpo= s:keepcpo
unlet s:keepcpo
