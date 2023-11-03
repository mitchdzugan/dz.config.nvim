" my filetype file
if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufRead,BufNewFile *.zn       setfiletype clojure
    au! BufRead,BufNewFile *.dz       setfiletype dz
augroup END
