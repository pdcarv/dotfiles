" ir_black color scheme
" More at: http://blog.infinitered.com/entries/show/8


" ********************************************************************************
" Standard colors used in all ir_black themes:
" Note, x:x:x are RGB values
"
"  normal: #f6f3e8
" 
"  string: #A8FF60  168:255:96                   
"    string inner (punc, code, etc): #00A0A0  0:160:160
"  number: #FF73FD  255:115:253                 
"  comments: #7C7C7C  124:124:124
"  keywords: #96CBFE  150:203:254             
"  operators: white
"  class: #FFFFB6  255:255:182
"  method declaration name: #FFD2A7  255:210:167
"  regular expression: #E9C062  233:192:98
"    regexp alternate: #FF8000  255:128:0
"    regexp alternate 2: #B18A3D  177:138:61
"  variable: #C6C5FE  198:197:254
"  
" Misc colors:
"  red color (used for whatever): #FF6C60   255:108:96 
"     light red: #FFB6B0   255:182:176
"
"  brown: #E18964  good for special
"
"  lightpurpleish: #FFCCFF
" 
" Interface colors:
"  background color: black
"  cursor (where underscore is used): #FFA560  255:165:96
"  cursor (where block is used): white
"  visual selection: #1D1E2C  
"  current line: #151515  21:21:21
"  search selection: #07281C  7:40:28
"  line number: #3D3D3D  61:61:61


" ********************************************************************************
" The following are the preferred 16 colors for your terminal
"           Colors      Bright Colors
" Black     #4E4E4E     #7C7C7C
" Red       #FF6C60     #FFB6B0
" Green     #A8FF60     #CEFFAB
" Yellow    #FFFFB6     #FFFFCB
" Blue      #96CBFE     #FFFFCB
" Magenta   #FF73FD     #FF9CFE
" Cyan      #C6C5FE     #DFDFFE
" White     #EEEEEE     #FFFFFF


" ********************************************************************************
set background=light
hi clear

if exists("g:syntax_on")
    syntax reset
endif



" General colors
hi Normal           guifg=#424242     guibg=#f5f5f6     gui=none      ctermfg=black       ctermbg=white       cterm=none

hi LineNr           guifg=#f8f8f8     guibg=black       gui=none      ctermfg=darkgray    ctermbg=none        cterm=none

hi Visual           guifg=none        guibg=#262D51     gui=none      ctermfg=none        ctermbg=darkgray    cterm=none

hi Error            guifg=none        guibg=none        gui=undercurl ctermfg=white       ctermbg=red         cterm=none     guisp=#FF6C60 " undercurl color
hi ErrorMsg         guifg=white       guibg=#FF6C60     gui=bold      ctermfg=white       ctermbg=red         cterm=none
hi WarningMsg       guifg=white       guibg=#FF6C60     gui=bold      ctermfg=white       ctermbg=red         cterm=none

hi CursorLine     guifg=#e1e1e1     guibg=#f5f5f6     gui=none      ctermfg=black       ctermbg=white       cterm=bold
hi Search         guifg=none        guibg=none        gui=underline ctermfg=none        ctermbg=none        cterm=underline

" Syntax highlighting
hi Comment          guifg=#7C7C7C     guibg=none        gui=italic    ctermfg=gray        ctermbg=white       cterm=italic
hi String           guifg=#424242     guibg=none        gui=none      ctermfg=none        ctermbg=none        cterm=none
hi Number           guifg=none        guibg=none        gui=none      ctermfg=none        ctermbg=none        cterm=none

hi Keyword          guifg=none        guibg=none        gui=none      ctermfg=none        ctermbg=none        cterm=none
hi PreProc          guifg=#424242     guibg=#f5f5f6     gui=none      ctermfg=black       ctermbg=white        cterm=none
hi Conditional      guifg=none        guibg=none        gui=none      ctermfg=none        ctermbg=none        cterm=none " if else end

hi Todo             guifg=none        guibg=none        gui=bold      ctermfg=none        ctermbg=none        cterm=bold
hi Constant         guifg=none        guibg=none        gui=none      ctermfg=none        ctermbg=none        cterm=none

hi Identifier       guifg=none        guibg=none        gui=none      ctermfg=none        ctermbg=none        cterm=none
hi Function         guifg=none        guibg=none        gui=none      ctermfg=none        ctermbg=none        cterm=none
hi Type             guifg=none        guibg=none        gui=none      ctermfg=none        ctermbg=none        cterm=none
hi Statement        guifg=none        guibg=none        gui=none      ctermfg=none        ctermbg=none        cterm=none

hi Special          guifg=#424242     guibg=none        gui=none      ctermfg=black       ctermbg=none        cterm=none
hi Delimiter        guifg=none        guibg=none        gui=none      ctermfg=none        ctermbg=none        cterm=none
hi Operator         guifg=#424242     guibg=none        gui=none      ctermfg=black       ctermbg=none        cterm=none

