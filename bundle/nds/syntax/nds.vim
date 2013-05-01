"*****************************************************************************
"** Name:      nds.vim -                                                    **
"**                                                                         **
"** Type:      syntax file                                                  **
"**                                                                         **
"** Author:    Mike Miller (mmiller@nds.com)                                **
"**                                                                         **
"** Copyright: (c) 2007-10 by Mike Miller (probably NDS; whatever...)       **
"**                                                                         **
"** License:   GNU General Public License 2 (GPL 2)                         **
"**                                                                         **
"**            This program is free software; you can redistribute it       **
"**            and/or modify it under the terms of the GNU General Public   **
"**            License as published by the Free Software Foundation,        **
"**            version 2 of the License                                     **
"**                                                                         **
"**            This program is distributed in the hope that it will be      **
"**            useful, but WITHOUT ANY WARRANTY; without even the implied   **
"**            warrenty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      **
"**            PURPOSE.                                                     **
"**            See the GNU General Public License for more details.         **
"**                                                                         **
"** Version:   2.0.0                                                        **
"**            tested under Win32, GVIM 7.3, and Linux 7.3                  **
"**                                                                         **
"** History:                                                                **
"**            1.0.0 Initial release: XDebug only                           **
"**            2.0.0 Added Core and DIAG prints. Added conceal to hide some **
"**                  of the lesser used information (esp. for DIAG)         **
"**                                                                         **
"** Known Bugs:                                                             **
"**            The 'location' field goes until the last >, and doesn't only **
"**            check for balanced pairs of <>. This should be fixed, since  **
"**            it can break if the string contains a >                      **
"**                                                                         **
"*****************************************************************************
"** Description:                                                            **
"**   This file provides highlighting for NDS logs (XDebug, Core, and DIAG  **
"*****************************************************************************

" There should be no need to modify this file, except if you want to add
" strings that should be highlighted within the standard prints (see, for
" example, ndsLostMessages

syntax clear
syntax case match
set concealcursor=nc
set conceallevel=3

"*****************************************************************************
"** General columns, and their order                                        **
"*****************************************************************************

" Add any highlights that should be noted even in the main text prints
" This has to be first, b/c vim is annoying.
syntax match ndsText /.*$/ skipwhite contains=ndsLostMessages,ndsEnter,ndsExit

" The EZLog header may or may not be present.
syntax match ndsEZLogHeader /^<\d\d\/\d\d\/\d\d\d\d \d\d:\d\d:\d\d:\d\d\d> / nextgroup=ndsNDS,ndsSeq conceal
" This header was seen on logs from China. Not sure what tool it was from.
syntax match ndsChinaLogHeader /^\[\a\{3} \a\{3} \d\{2} \d\{2}:\d\{2}:\d\{2}\.\d\{3} \d\{4}\] / nextgroup=ndsNDS,ndsSeq conceal 
syntax match ndsChinaLogHeader2 /^<\d\{2}-\d\{2}-\d\{4} \d\{2}:\d\{2}:\d\{2}\:\d\{3}> / nextgroup=ndsNDS,ndsSeq conceal 
" Core and DIAG logs contain NDS: at the beginning, as per LQQ-350
syntax match ndsNDS /NDS: \?/ nextgroup=ndsTimestamp skipwhite conceal
" XDebug uses a sequence counter; more useful, but not technically correct
syntax match ndsSeq /[0-9]\+ /he=e-1 nextgroup=ndsTimestamp skipwhite
" Timestamp; milliseconds (inc. fractional ms in DIAG) from boot
syntax match ndsTimestamp /\^[0-9.]\+ \?/ nextgroup=ndsFatal,ndsError,ndsWarning,ndsCaution,ndsMilestone,ndsLevel  skipwhite conceal
" Component
syntax match ndsComp /-[a-zA-Z_0-9]\+/ nextgroup=ndsLocation skipwhite
" Level. Can be a string (XDebug, DIAG) or a number (Core)
syntax match ndsLevel /![a-zA-Z0-9]\+/ nextgroup=ndsComp skipwhite
" All of the location fields. Starting with a <, they are of the format X:xxxxxx.
syntax match ndsLocation /[^^]<.\{-}>/ms=s+1,me=e-1 contains=ndsLocationFile,ndsLocationThread1,ndsLocationThread2,ndsLocationFunction,ndsLocationLine,ndsLocationProcess nextgroup=ndsText conceal 
" For Core, F: refers to the function; Core uses M: for the file. It shouldn't matter very much, since all get the same highlighting by default
syntax match ndsLocationFile /[FM]: \?[a-zA-Z_0-9.()]\+/ skipwhite contained
syntax match ndsLocationLine /L:[0-9]\+/ skipwhite contained
syntax match ndsLocationFunction /P: \?[a-zA-Z_0-9. <>()]\+/ skipwhite contained contains=ndsLocationFile,ndsLocationLine,ndsLocationFunction,ndsLocationThread1,ndsLocationThread2,ndsLocationProcess
syntax match ndsLocationThread1 /t: \?\(0x\)\?[a-zA-Z_0-9. ]\+/ skipwhite contained contains=ndsLocationFile,ndsLocationLine,ndsLocationFunction,ndsLocationThread1,ndsLocationThread2,ndsLocationProcess
syntax match ndsLocationThread2 /T: \?\(0x\)\?[a-zA-Z_0-9. ]\+/ skipwhite contained contains=ndsLocationFile,ndsLocationLine,ndsLocationFunction,ndsLocationThread1,ndsLocationThread2,ndsLocationProcess
syntax match ndsLocationProcess /p: \?\(0x\)\?[0-9a-fA-F ]\+/ skipwhite contained contains=ndsLocationFile,ndsLocationLine,ndsLocationFunction,ndsLocationThread1,ndsLocationThread2,ndsLocationProcess


"*****************************************************************************
"** Add strings which should be highlighted within the regular prints here  **
"*****************************************************************************
syntax match ndsLostMessages /last_block_lost=[^0][0-9]*,/hs=s+0,he=e-1 contained
syntax match ndsEnter / |-> /ms=s+1,me=e-1 contained
syntax match ndsExit / <-| /ms=s+1,me=e-1 contained

"*****************************************************************************
"**  We'll highlight the entire header for important messages               **
"*****************************************************************************
syntax match ndsFatal /!FA\?TA\?L */ nextgroup=ndsComp
syntax match ndsError /!ERRO\?R\? */ nextgroup=ndsComp
syntax match ndsWarning /!WA\?RN */ nextgroup=ndsComp contained
syntax match ndsCaution /!CTN */ nextgroup=ndsComp
syntax match ndsMilestone /!MIL */ nextgroup=ndsComp

" XRay logs. Mostly deprecated...
"syntax match ndsXRay /@|5A[A-F0-9]\+/ contains=ndsXRayHeader,ndsXRayLen,ndsXRaySeq,ndsXRayTimestamp,ndsXRayParams,ndsXRayComp,ndsXRaySub,ndsXRayMil,ndsXRayStat,ndsXRayStatPass transparent
"syntax match ndsXRayHeader /@|5A/ contained
"syntax match ndsXRayLen /\%5v../ contained  
"syntax match ndsXRaySeq /\%7v../ contained 
"syntax match ndsXRayControl /@|5A......01.\+/
"syntax match ndsXRayParams /\%43v.\+/ contained
"syntax match ndsXRayTimestamp /\%13v......../ contained 
"syntax match ndsXRayComp /\%37v../ contained 
"syntax match ndsXRaySub /\%39v../ contained 
"syntax match ndsXRayMil /\%41v../ contained 
"syntax match ndsXRayStat /\%29v......../ contained
"syntax match ndsXRayStatPass /\%29v00000000/ contained

"highlight ndsXRayHeader gui=bold guibg=LightGray
"highlight ndsXRayLen guifg=Red
"highlight link ndsXRaySeq Type
"highlight ndsXRayControl guibg=LightGray gui=italic guifg=DarkBlue
"highlight link ndsXRayParams String
"highlight link ndsXRayTimestamp Type
"highlight ndsXRayComp gui=italic,bold  
"highlight ndsXRaySub gui=italic guifg=Red
"highlight ndsXRayMil guifg=Red
"highlight ndsXRayStat gui=bold guibg=Red guifg=White

"*****************************************************************************
"** All the colors                                                          **
"*****************************************************************************

highlight ndsLostMessages gui=bold guibg=Red guifg=White cterm=bold ctermbg=Red ctermfg=White
highlight ndsEnter guibg=DarkGreen guifg=White ctermbg=DarkGreen ctermfg=White
highlight ndsExit guibg=DarkGreen guifg=White ctermbg=DarkGreen ctermfg=White

highlight ndsEZLogHeader guifg=Gray ctermfg=Gray 
highlight ndsChinaLogHeader guifg=Gray ctermfg=Gray 
highlight ndsChinaLogHeader2 guifg=Gray ctermfg=Gray 
highlight link ndsNDS Type
highlight link ndsSeq Type
highlight link ndsTimestamp Type
highlight ndsComp guifg=Red gui=italic
highlight ndsLevel guifg=Purple ctermfg=DarkMagenta

highlight link ndsLocationFile Comment
highlight link ndsLocationLine Comment
highlight link ndsLocationFunction Comment
highlight link ndsLocationThread1 Comment
highlight link ndsLocationThread2 Comment
highlight link ndsLocationProcess Comment

highlight link ndsText String

highlight ndsFatal guibg=Red ctermbg=Red
highlight ndsError guibg=Red guifg=White ctermbg=Red ctermfg=White
highlight ndsWarning guibg=LightRed ctermbg=LightRed ctermfg=Black
highlight ndsCaution guibg=LightRed ctermbg=LightRed ctermfg=Black  
highlight ndsMilestone guibg=Gray ctermbg=Gray

"set wrap
"set linebreak

map <silent> <leader>ch :call ToggleGroupConceal('ndsEZLogHeader') <CR>:call ToggleGroupConceal('ndsChinaLogHeader')<CR>:call ToggleGroupConceal('ndsChinaLogHeader2')<CR>
map <silent> <leader>chh :call ToggleGroupConceal('ndsNDS') <CR>:call ToggleGroupConceal('ndsTimestamp')<CR>
map <silent> <leader>cd :call ToggleGroupConceal('ndsLocation') <CR>

" Thanks to 'Al' at stackoverflow for this function:
" http://stackoverflow.com/questions/3853631/toggling-the-concealed-attribute-for-a-syntax-highlight-in-vim
function! ToggleGroupConceal(group)
	" Get the existing syntax definition
	redir => syntax_def
	exe 'silent syn list' a:group
	redir END
	" Split into multiple lines
	let lines = split(syntax_def, "\n")
	" Clear the existing syntax definitions
	exe 'syn clear' a:group
	for line in lines
		" Only parse the lines that mention the desired group
		" (so don't try to parse the "--- Syntax items ---" line)
		if line =~ a:group
			" Get the required bits (the syntax type and the full definition)
			let matcher = a:group . '\s\+xxx\s\+\(\k\+\)\s\+\(.*\)'
			let type = substitute(line, matcher, '\1', '')
			let definition = substitute(line, matcher, '\2', '')
			" Either add or remove 'conceal' from the definition
			if definition =~ 'conceal'
				let definition = substitute(definition, ' conceal\>', '', '')
				exe 'syn' type a:group definition
			else
				exe 'syn' type a:group definition 'conceal'
			endif
		endif
	endfor
	" Redefine the syntaxes which also match at the beginning, to prevent priority conflicts
"	exe 'syntax match ndsFatal /^.*!FA\?TA\?L.*$/' 
	"exe 'syntax match ndsError /^.*!ERRO\?R\?.*$/'
"	exe 'syntax match ndsWarning /^.*!WA\?RN.*$/'
"	exe 'syntax match ndsCaution /^.* !CTN .*$/'
endfunction

