" foldcol: Fold Column function
" Author:	Charles E. Campbell
" Date:		Nov 17, 2013
" Version:	3g	ASTRO-ONLY
" Usage:
" 	Using visual-block mode, select a block (use ctrl-v).  Press \vfc
" 	This operation will fold the selected block away.
" 	Using normal mode, press \vfc.  This operation will remove all
" 	FoldCol-generated inline-folds.
"
"   Note: this plugin requires Vince Negri's conceal-ownsyntax patch
"         See http://groups.google.com/group/vim_dev/web/vim-patches, Patch#14
"
" 	"But if any of you lacks wisdom, let him ask of God, who gives to
" 	all liberally and without reproach; and it will be given to him."
" 	(James 1:5)
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" GetLatestVimScripts: 1161 1 :AutoInstall: foldcol.vim

" ---------------------------------------------------------------------
" Load Once: {{{1
if &cp || exists("g:loaded_foldcol") || !has("conceal")
 finish
endif
let g:loaded_foldcol= "v3g"

" ---------------------------------------------------------------------
" Public Interface: {{{1
if !hasmapto("<Plug>VFoldCol","v")
 vmap <unique> <Leader>vfc <Plug>VFoldCol
endif
vmap <silent> <Plug>VFoldCol	:<c-u>call <SID>FoldCol(1)<cr>

if !hasmapto("<Plug>NFoldCol","n")
 nmap <unique> <Leader>vfc <Plug>NFoldCol
endif
nmap <silent> <Plug>NFoldCol	:call <SID>FoldCol(0)<cr>

com!		-range -nargs=0 -bang FoldCol	call s:FoldCol(<bang>1)
silent! com	-range -nargs=0 -bang FC		call s:FoldCol(<bang>1)

" ---------------------------------------------------------------------
"  FoldCol: use visual block mode (ctrl-v) to select a block to fold {{{1
fun! s:FoldCol(dofold)
"  call Dfunc("FoldCol(dofold=".a:dofold.")")
"  call Decho("firstline#".a:firstline." lastline#".a:lastline." <".line("'<")." >".line("'>"))

  if a:dofold
   " make a new fold
   if &cole == 0
	let &cole= 1
   endif

   " upper left corner
   let line_ul = line("'<") - 1
   let col_ul  = virtcol("'<")  - 1

   " lower right corner
   let line_lr = line("'>")
   let col_lr  = virtcol("'>")
   if &selection ==# 'exclusive'
	" need to subtract the display width of the character at the end of the selection
	if exists('*strdisplaywidth')
		let col_lr -= strdisplaywidth(matchstr(getline(line_lr), '\%' . col("'>") . 'c.'), strdisplaywidth(strpart(getline(line_lr), 0, col("'>") - 1)))
	else
		let col_lr -= 1
	endif
   endif
  
"   call Decho('syn region FoldCol start="\%>'.line_ul.'l\%>'.col_ul.'v" end="\%>'.line_lr.'l\|\%>'.col_lr.'v" conceal')
   exe 'syn region FoldCol start="\%>'.line_ul.'l\%>'.col_ul.'v" end="\%>'.line_lr.'l\|\%>'.col_lr.'v" conceal containedin=ALL'
  else
   " remove all folded columns
   syn clear FoldCol
  endif
"  call Dret("FoldCol")
endfun

" ---------------------------------------------------------------------
" vim: ts=4 fdm=marker
