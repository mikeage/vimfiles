" StlShowFunc_sh.vim :	a ftplugin for Borne shell, Korn/Posix shell, and Bash
" Author:	Charles E. Campbell, Jr.
" Date:		Apr 03, 2010
" Version:  2f	ASTRO-ONLY
" ---------------------------------------------------------------------
"  Enable Plugin For All Sh FileTypes: {{{1
if &diff
 finish
endif
augroup STLSHOWFUNC_SH
 au!
 exe "au CursorMoved ".expand("%")." call StlShowFunc_sh()"
augroup END
" ---------------------------------------------------------------------
"  Load Once: {{{1
if exists("b:loaded_StlShowFunc_sh") || !exists("g:loaded_StlShowFunc")
 finish
endif
let b:loaded_StlShowFunc_sh= "v2f"

" ---------------------------------------------------------------------
" StlShowFunc_sh: show function name associated with the line under the cursor {{{1
"DechoTabOn
fun! StlShowFunc_sh()
"  call Dfunc("StlShowFunc_sh() line#".line(".")." mode=".mode())
  if mode() != 'n'
"   call Dret("StlShowFunc_sh")
   return
  endif

  if !exists("b:shshowfunc_bgn")
   let b:shshowfunc_bgn= -2
   let b:shshowfunc_end= -2
  endif

  let curlinenum = line(".")
  let swp        = SaveWinPosn(0)
  if getline(".") =~ '^\s*function\>'
   let bgnfuncline = line(".")
  else
   sil! keepj let bgnfuncline= search('^\s*function\>','bW')
  endif
"  call Decho("preliminary bgnfuncline=".bgnfuncline)
  if bgnfuncline > 0
   sil! keepj let shfuncstart= search('^\s*{','W')
   if shfuncstart != 0
	sil! keepj let endfuncline= searchpair('{','','}',"Wn")
	if endfuncline <= 0
	 let bgnfuncline= 0
	endif
   else
    let bgnfuncline = 0
    let endfuncline = 0
   endif
  else
   let bgnfuncline= 0
   let endfuncline= 0
  endif
  if curlinenum < bgnfuncline || endfuncline < curlinenum
   let bgnfuncline= 0
   let endfuncline= 0
  endif
  call RestoreWinPosn(swp)
"  call Decho("previous bgn,end[".b:shshowfunc_bgn.",".b:shshowfunc_end."]")
"  call Decho("current  bgn,end[".bgnfuncline.",".endfuncline."]")

  if bgnfuncline == b:shshowfunc_bgn && endfuncline == b:shshowfunc_end
   " looks like we're in the same region -- no change
"   call Dret("StlShowFunc_sh : no change")
   return
  endif

  let b:shshowfunc_bgn = bgnfuncline
  let b:shshowfunc_end = endfuncline
  let endprvfuncline     = search('^}$','Wbn')
"  call Decho("endprvfuncline=".endprvfuncline)

  if bgnfuncline < endprvfuncline || (endprvfuncline == 0 && bgnfuncline == 0)
   call StlSetFunc("")
  else
   let funcline= getline(bgnfuncline)
   if funcline =~ '^\s*function\s*\h\w*'
   	let funcname= substitute(funcline,'^\s*function\s*\(\h\w*\).\{-}$','\1','')
"    call Decho("funcname<".funcname.">")
    call StlSetFunc(funcname."()")
   endif
  endif

  " set the status line and return
"  call Dret("StlShowFunc_sh")
endfun

" ---------------------------------------------------------------------
"  Enable FtPlugin: {{{1
StlShowFunc sh

" ---------------------------------------------------------------------
"  Modelines: {{{1
" vim: fdm=marker
