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
"syntax match ndsText /.*$/ skipwhite contains=ndsLostMessages,ndsEnter,ndsExit

syntax match ndsHeaders /^\(PASSED\|FAILED\)\?NDS:.* > /me=e-3 contains=ndsPythonTimestamp,ndsProcess,ndsThread,ndsLogger,ndsModule,ndsFunction,ndsFCID,ndsLine,ndsError,ndsWarning,ndsInfo,ndsDebug
syntax match ndsPass /^PASSED/ 
syntax match ndsFail /^FAILED/ 
syntax match ndsPythonTimestamp /\^\d\{2\}\/\d\{2\}\/\d\{2\} \d\{2\}:\d\{2\}:\d\{2\} / contained
syntax match ndsProcess /<p:\d\+ / contained
syntax match ndsThread /T:[[:alnum:]._]\+ / contained
syntax match ndsLogger /t:[[:alnum:]._]\+ / contained
syntax match ndsModule /M:[[:alnum:]._]\+ / contained
syntax match ndsFunction /F:[[:alnum:]._]\+ / contained
syntax match ndsFCID /FCID:[[:alnum:]._]\+ / contained
syntax match ndsLine /L:[0-9]\+/ contained
syntax match ndsError /!ERROR */he=e-1 contained
syntax match ndsWarning /!WARNING */he=e-1 contained
syntax match ndsInfo /!INFO */he=e-1 contained
syntax match ndsDebug /!DEBUG */he=e-1 contained
syntax match ndsText / > .*$/ms=s+3 contains=r_ok_fail,step

highlight ndsPass guibg=Green ctermbg=Green ctermfg=White
highlight ndsFail guibg=Red guifg=White ctermbg=Red ctermfg=White

highlight link ndsPythonTimestamp Type
highlight link ndsProcess Comment
highlight link ndsThread Comment
highlight link ndsLogger Type
highlight link ndsModule Type
highlight link ndsFunction Type
highlight link ndsFCID Comment
highlight link ndsLine Type
highlight link ndsText String
highlight ndsError guibg=Red guifg=White ctermbg=Red ctermfg=White
highlight ndsWarning guibg=LightRed ctermbg=LightRed ctermfg=Black
highlight ndsInfo ctermfg=White
highlight ndsDebug ctermfg=Gray

syntax match r_ok_fail /r\.ok = False/ contained
highlight r_ok_fail ctermfg=Red
syntax match step /=========== STEP:.* ===============/ contained
highlight step ctermbg=White


set nowrap
"set linebreak

map <silent> <leader>ch :call ToggleGroupConceal('ndsHeaders') <CR>
map <silent> <leader>cd :call ToggleGroupConceal('ndsProcess')<CR>:call ToggleGroupConceal('ndsThread')<CR>:call ToggleGroupConceal('ndsFCID')<CR>
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

