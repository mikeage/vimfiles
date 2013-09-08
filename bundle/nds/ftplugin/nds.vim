let b:logTimestampExpr='^NDS: \^\zs\d\+\.\d\+\ze\s'
let g:LogViewer_Filetypes.=(g:LogViewer_Filetypes =~ ",nds") ? '' : ',nds'
