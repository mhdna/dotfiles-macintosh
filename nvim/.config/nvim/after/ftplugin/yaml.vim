" Turn off syntax highlighting for large YAML files.
if line('$') > 500
  setlocal syntax=OFF
endif

setlocal tabstop=2       " number of visual spaces per TAB
setlocal softtabstop=2   " number of spaces in tab when editing
setlocal shiftwidth=2    " number of spaces to use for autoindent
setlocal expandtab       " expand tab to spaces so that tabs are spaces
