" Exit quickly when:
" - this plugin was already loaded
if !exists("g:ropevim_loaded")
python << EOF
import sys, vim
sys.path.append(vim.eval("expand('<sfile>:p:h')")  + '/libs/')
try:
  import ropevim
except:
  pass
EOF
let g:ropevim_loaded = 1
endif

