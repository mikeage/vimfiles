function! TimestampGetTimestamp(line)
	return str2float(strpart(matchstr(getline(a:line), '\^\d\+\.\d\+'),1))
endfunction

function! TimestampGetDelta()
	if (!exists('b:ref_timestamp'))
		return ""
	endif

	let l:timestamp=TimestampGetTimestamp(line('.'))
	if l:timestamp != 0
		return printf("%.6f", l:timestamp-b:ref_timestamp)
	else
		return ""
	endif
endfunction

function! TimestampSetReference()
	let b:ref_timestamp=TimestampGetTimestamp(line('.'))
endfunction

function! TimestampJumpDelta(delta)
	let l:ref_timestamp=TimestampGetTimestamp(line('.'))
	let origLine= line('.')
	let endLine = line('$')
	if a:delta > 0
		let l:dir=1
	else
		let l:dir=-1
	endif
	let i = origLine
	while i <= endLine && i >= 1
		try
		let i = i + l:dir
		exec i
			let l:timestamp=TimestampGetTimestamp(line('.'))
			if abs(l:timestamp - l:ref_timestamp) >= abs(a:delta)
				let matches=1
				break
			endif 
		endtry
	endwhile
	if matches
		return i - l:dir
	else
		exec origLine
		return 0
	endif
endfunction

let g:loaded_Timestamp= "1"

"NDS: ^1367826991.914039 !INFO   -VRMS         		< I:GW p:0x00000000 P:MW t:0x74412c30 T:VRM_SRV M:pvp_gen.c F:PANEL_HandleInternalMcmMsoChangedMsg L:1510 > mso type 0x26 (SAI) 
"NDS: ^1367826991.914469 !INFO   -VRMS         		< I:GW p:0x00000000 P:MW t:0x74412c30 T:VRM_SRV M:pvp_gen.c F:PANEL_HandleInternalMcmMsoChangedMsg L:1510 > mso type 0x0 (SCI) 
"NDS: ^1367826992.111302 !INFO   -VRMS         		< I:GW p:0x00000000 P:MW t:0x74412c30 T:VRM_SRV M:pvp_gen.c F:PANEL_HandleInternalMcmMsoChangedMsg L:1510 > mso type 0x32 (PSI) 
"NDS: ^1367826992.112060 !MIL    -MCM          		< I:GW p:0x00000000 P:MW t:0x097f9670 T:MCM_ITCMAIN_THREAD M:mcm_mediaconn_event.c F:MCM_Mediaconn_ActionPreparing L:2974 > @@PMON@@,trace,mediacon,mc-prepared,6,fsnfmt=,hMC=0x6 

