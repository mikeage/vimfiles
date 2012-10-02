" StlShowFunc_mv.vim :	a ftplugin for Maple V files
" Author:	Charles E. Campbell, Jr.
" Date:		Apr 03, 2010
" Version:  2e	ASTRO-ONLY
" ---------------------------------------------------------------------
"  Load Once: {{{1
if exists("b:loaded_StlShowFunc_mv") || !exists("g:loaded_StlShowFunc")
 finish
endif
let b:loaded_StlShowFunc_mv= "v2e"

" ---------------------------------------------------------------------
" StlShowFunc_mv: show function name associated with the line under the cursor {{{1
"DechoTabOn
fun! StlShowFunc_mv()
"  call Dfunc("StlShowFunc_mv() line#".line(".")." mode=".mode())
  if mode() != 'n'
"   call Dret("StlShowFunc_mv")
   return
  endif
  if !exists("b:mvshowfunc_bgn")
   let b:mvshowfunc_bgn= -2
   let b:mvshowfunc_end= -2
  endif

  if getline(".") =~ ':=\s*proc\s*('
   let bgnfuncline= line(".")
  else
   sil! keepj let bgnfuncline = search(':=\s*proc\s*(','Wbn')
   if bgnfuncline == 0
   	let endfuncline= 0
   endif
  endif
  if bgnfuncline != 0
   if getline(".") =~ '^\s*end:\=\s*$'
    let endfuncline= line(".")
   else
	sil! keepj let endfuncline = search('^\s*end:\=\s*$','Wbn')
	if endfuncline < line(".") && endfuncline > bgnfuncline
	 let bgnfuncline= 0
	 let endfuncline= 0
	else
	 sil! keepj let endfuncline = search('^\s*end:\=\s*$','Wn')
	endif
   endif
  endif
"  call Decho("previous bgn,end[".b:mvshowfunc_bgn.",".b:mvshowfunc_end."]")
"  call Decho("current  bgn,end[".bgnfuncline.",".endfuncline."]")

  if bgnfuncline == b:mvshowfunc_bgn && endfuncline == b:mvshowfunc_end
   " looks like we're in the same region -- no change
"   call Dret("StlShowFunc_mv : no change")
   return
  endif

  let b:mvshowfunc_bgn     = bgnfuncline
  let b:mvshowfunc_end     = endfuncline
  keepj let endprvfuncline = search('^\s*endf\%[unction]\>','Wbn')
"  call Decho("endprvfuncline=".endprvfuncline)

  if bgnfuncline < endprvfuncline || (endprvfuncline == 0 && bgnfuncline == 0)
   call StlSetFunc("")
  else
   " extract the function name from the bgnfuncline
   let funcline= getline(bgnfuncline)
   if funcline =~ '^.\{-}:=\s*proc\s*('
   	let funcname= substitute(funcline,'^\s*\(\h\w*\)\s*:=\s*proc\s*(.*$','\1','')
"   call Decho("funcname<".funcname.">")
    call StlSetFunc(funcname."()")
   else
    call StlSetFunc("")
   endif
  endif

  " set the status line and return
"  call Dret("StlShowFunc_mv")
endfun

" ---------------------------------------------------------------------
"  Plugin Enabling: {{{1
StlShowFunc mv

" ---------------------------------------------------------------------
"  Modelines: {{{1
" vim: fdm=marker
