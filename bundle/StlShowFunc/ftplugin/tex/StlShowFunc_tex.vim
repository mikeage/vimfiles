" StlShowFunc_tex.vim :	an ftplugin for LaTeX
" Author:	Charles E. Campbell, Jr.
" Date:		Apr 03, 2010
" Version:  1a	ASTRO-ONLY
" ---------------------------------------------------------------------
"  Load Once: {{{1
if exists("b:loaded_StlShowFunc_m") || !exists("g:loaded_StlShowFunc")
 finish
endif
let b:loaded_StlShowFunc_tex= "v1a"

" ---------------------------------------------------------------------
" StlShowFunc_m: show function name associated with the line under the cursor {{{1
"DechoTabOn
fun! StlShowFunc_tex()
"  call Dfunc("StlShowFunc_tex() line#".line(".")." mode=".mode())
  if mode() != 'n'
"   call Dret("StlShowFunc_tex")
   return
  endif
  if !exists("b:mshowfunc_bgn")
   let b:mshowfunc_bgn= -2
   let b:mshowfunc_end= -2
  endif

  sil! keepj let bgnfuncline = search('\\\%(part\|chapter\|section\|subsubsection\|subsection\)\>','Wbn')
  sil! keepj let endfuncline = search('\\\%(part\|chapter\|section\|subsubsection\|subsection\)\>','Wn')
  if getline(".") =~ '^\s*function\>'
   let bgnfuncline= line(".")
   let endfuncline= bgnfuncline
  endif
  if getline(".") =~ '^\s*endfunction\>'
   let endfuncline= line(".")
  endif
"  call Decho("previous bgn,end[".b:mshowfunc_bgn.",".b:mshowfunc_end."]")
"  call Decho("current  bgn,end[".bgnfuncline.",".endfuncline."]")

  if bgnfuncline == b:mshowfunc_bgn && endfuncline == b:mshowfunc_end
   " looks like we're in the same region -- no change
"   call Dret("StlShowFunc_tex : no change")
   return
  endif

  let            b:mshowfunc_bgn = bgnfuncline
  let            b:mshowfunc_end = endfuncline
  sil! keepj let endprvfuncline  = search('\\\%(part\|chapter\|section\|subsubsection\|subsection\)\>','Wbn')
"  call Decho("endprvfuncline=".endprvfuncline)

  if bgnfuncline < endprvfuncline || (endprvfuncline == 0 && bgnfuncline == 0)
   call StlSetFunc("")
  else
   " extract the section/title name from the bgnfuncline
   let title_line= getline(bgnfuncline)
"   call Decho("title_line<".title_line.">")
   if title_line =~ '\\\%(part\|chapter\|section\|subsubsection\|subsection\)\s*{'
	let title= substitute(title_line,'^.*\\\%(part\|chapter\|section\|subsubsection\|subsection\)\s*{\([^}]\+\)}.*$','\1','')
"    call Decho("title<".title.">")
    call StlSetFunc(title)
   else
    call StlSetFunc("")
   endif
  endif

  " set the status line and return
"  call Dret("StlShowFunc_tex")
endfun

" ---------------------------------------------------------------------
"  Plugin Enabling: {{{1
StlShowFunc tex

" ---------------------------------------------------------------------
"  Modelines: {{{1
" vim: fdm=marker
