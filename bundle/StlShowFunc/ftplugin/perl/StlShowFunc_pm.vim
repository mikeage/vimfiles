" StlShowFunc_pm.vim :	a ftplugin for Perl
" Author:	Charles E. Campbell, Jr.
" Date:		Apr 03, 2010
" Version:  2e	ASTRO-ONLY
" ---------------------------------------------------------------------
"  Load Once: {{{1
if exists("b:loaded_StlShowFunc_pm") || !exists("g:loaded_StlShowFunc")
 finish
endif
let b:loaded_StlShowFunc_pm= "v2e"

" ---------------------------------------------------------------------
" StlShowFunc_pm: show function name associated with the line under the cursor {{{1
"DechoTabOn
fun! StlShowFunc_pm()
"  call Dfunc("StlShowFunc_pm() line#".line(".")." mode=".mode())
  if mode() != 'n'
"   call Dret("StlShowFunc_pm")
   return
  endif
  if !exists("b:perlshowfunc_bgn")
   let b:perlshowfunc_bgn= -2
   let b:perlshowfunc_end= -2
  endif

  if getline(".") =~ '^\s*sub\s'
   let bgnfuncline= line(".")
   if bgnfuncline != 0 && getline(bgnfuncline) =~ '^\s*sub\s\+\h\w*\s*{}\s*$'
    let endfuncline= line(".")
   else
	sil! keepj let endfuncline = search('^\s*}\s*$','Wn')
   endif
  elseif getline(".") =~ '^\s*}\s*$'
   sil! keepj let bgnfuncline = search('^\s*sub\s\+\h\w*\s*[({]','Wbn')
   let            endfuncline = line(".")
  else
   sil! keepj let bgnfuncline = search('^\s*sub\s\+\h\w*\s*[({]','Wbn')
   sil! keepj let endfuncline = search('^\s*}\s*$','Wn')
   if bgnfuncline != 0 && getline(bgnfuncline) =~ '^\s*sub\s\+\h\w*\s*{}\s*$'
   	let endfuncline= bgnfuncline
   endif
  endif
"  call Decho("previous bgn,end[".b:perlshowfunc_bgn.",".b:perlshowfunc_end."]")
"  call Decho("current  bgn,end[".bgnfuncline.",".endfuncline."]")

  if bgnfuncline == b:perlshowfunc_bgn && endfuncline == b:perlshowfunc_end
   " looks like we're in the same region -- no change
"   call Dret("StlShowFunc_pm : no change")
   return
  endif

  let        b:perlshowfunc_bgn = bgnfuncline
  let        b:perlshowfunc_end = endfuncline
  sil! keepj let endprvfuncline = search('^}$','Wbn')
"  call Decho("endprvfuncline=".endprvfuncline)

  if bgnfuncline < endprvfuncline || (endprvfuncline == 0 && bgnfuncline == 0)
   call StlSetFunc("")
  else
   let funcline= getline(bgnfuncline)
   if funcline =~ '^\s*sub\s*\h\w*'
   	let funcname= substitute(funcline,'^\s*sub\s*\(\h\w*\).\{-}$','\1','')
"    call Decho("funcname<".funcname.">")
    call StlSetFunc(funcname."()")
   endif
  endif

  " set the status line and return
"  call Dret("StlShowFunc_pm")
endfun

" ---------------------------------------------------------------------
"  Enable FtPlugin: {{{1
StlShowFunc pm

" ---------------------------------------------------------------------
"  Modelines: {{{1
" vim: fdm=marker
