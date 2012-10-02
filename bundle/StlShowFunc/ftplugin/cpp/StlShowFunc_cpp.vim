" StlShowFunc_cpp.vim :	a ftplugin for C++
" Author:	Charles E. Campbell, Jr.
" Date:		Sep 09, 2010
" Version:  2k	ASTRO-ONLY
" ---------------------------------------------------------------------
"  Load Once: {{{1
if exists("b:loaded_StlShowFunc_cpp") || !exists("g:loaded_StlShowFunc")
 finish
endif
let b:loaded_StlShowFunc_cpp= "v2k"

" ---------------------------------------------------------------------
" StlShowFunc_cpp: show function name associated with the line under the cursor {{{1
"DechoTabOn
fun! StlShowFunc_cpp()
"  call Dfunc("StlShowFunc_cpp() line#".line(".")." mode=".mode())
  if mode() != 'n'
"   call Dret("StlShowFunc_cpp")
   return
  endif
  if !exists("b:cshowfunc_bgn")
   let b:cshowfunc_bgn= -2
   let b:cshowfunc_end= -2
  endif
"  call Decho("b:cshowfunc_bgn=".b:cshowfunc_bgn." b:cshowfunc_end=".b:cshowfunc_end)

  keepj let swp= SaveWinPosn(0)
  while 1
   keepj let spline= searchpair(')\_s*\%(const\_s*\|volatile\_s*\|/\*.*\*/\_s*\|//.*\_s*\)\{,2}{','','}','bW')
"   call Decho("spline=".spline)
   if spline <= 0
	call StlSetFunc("")
   	break
   endif
   if synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") == "Comment"
	if line(".") == 1
"	 call Decho("case comment in line#1:")
     call StlSetFunc("")
   	 break
	endif
	keepj norm! 0k
	continue
   endif
"   call Decho("after searchpair: line#".line(".").".".col(".")." spline=".spline)
   silent! keepj norm! %b
"   call Decho("after %b        : line#".line(".").".".col(".")." potential-funcname<".expand("<cword>").">")
   if expand("<cword>") !~ '\<\%(if\|for\|try\|catch\|while\|switch\|else\|do\)\>'
	let funcname= expand("<cword>")
"	call Decho("funcname<".funcname.">")
	call StlSetFunc(funcname."()")
	break
   endif
  endwhile
"  call Decho("swp<".swp.">")
  keepjumps call RestoreWinPosn(swp)

  " set the status line and return
"  call Dret("StlShowFunc_cpp : line#".line(".")." col#".col('.'))
endfun

" ---------------------------------------------------------------------
"  Enable FtPlugin: {{{1
if has("fname_case")
 StlShowFunc cpp *.cpp,*.cc,*.c++,*.dxx,*.tcc,*.inl,*.C,*.H,*.hh
else
 StlShowFunc cpp *.cpp,*.cc,*.c++,*.dxx,*.tcc,*.inl,*.hh
endif

" ---------------------------------------------------------------------
"  Modelines: {{{1
" vim: fdm=marker
