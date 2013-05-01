" Log files are of type nds
augroup filetypedetect
	au BufNewFile,BufRead *.cap,*.log setfiletype nds
	" We explicitely set this, since otherwise, .txt files are already set to "text"
	au BufNewFile,BufRead levels.txt,output*.txt set filetype=nds
augroup END

