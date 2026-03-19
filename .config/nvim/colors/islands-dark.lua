vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then vim.cmd('syntax reset') end
vim.g.colors_name = 'islands-dark'
vim.o.background = 'dark'

local hi = function(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

-- Palette (from JetBrains Islands Dark)
local c = {
	bg         = '#191a1c',
	bg1        = '#1f2024', -- cursorline
	bg2        = '#27282b', -- popup/float
	bg3        = '#2b2d30', -- visual/folded
	bg4        = '#323438', -- indent guide
	bg5        = '#393b40', -- inlay/border
	bg6        = '#43454a', -- matched brace/separator
	fg         = '#bcbec4',
	fg_dim     = '#9da0a8',
	fg_bright  = '#ced0d6',
	fg_dark    = '#868a91',
	comment    = '#7a7e85',
	line_nr    = '#4b5059',
	line_nr_cur = '#a1a3ab',
	keyword    = '#cf8e6d',
	string     = '#6aab73',
	number     = '#2aacb8',
	func       = '#56a8f5',
	method     = '#57aaf7',
	constant   = '#c77dbb',
	type_param = '#16baac',
	metadata   = '#b3ae60',
	doc        = '#5f826b',
	doc_tag    = '#67a37c',
	tag        = '#d5b778',
	template   = '#b189f5',
	link       = '#548af7',
	error      = '#f75464',
	warning    = '#f2c55c',
	info       = '#857042',
	hint       = '#7ec482',
	todo       = '#8bb33d',
	added      = '#549159',
	modified   = '#375fad',
	deleted    = '#868a91',
	search_bg  = '#2d543f',
	search_fg  = '#42bd77',
	text_search = '#114957',
	diff_add   = '#1a3b2d',
	diff_change = '#25324d',
	diff_delete = '#40252b',
	regex      = '#42c3d4',
	whitespace = '#6f737a',
	sel_bg     = '#2a5091',
}

-- Editor
hi('Normal',       { fg = c.fg, bg = c.bg })
hi('NormalFloat',  { fg = c.fg, bg = c.bg2 })
hi('FloatBorder',  { fg = c.bg5, bg = c.bg2 })
hi('Cursor',       { fg = c.bg, bg = c.fg_bright })
hi('CursorLine',   { bg = c.bg1 })
hi('CursorLineNr', { fg = c.line_nr_cur })
hi('LineNr',       { fg = c.line_nr })
hi('SignColumn',   { bg = c.bg })
hi('ColorColumn',  { bg = c.bg1 })
hi('VertSplit',    { fg = c.bg5 })
hi('WinSeparator', { fg = c.bg5 })
hi('StatusLine',   { fg = c.fg, bg = c.bg3 })
hi('StatusLineNC', { fg = c.comment, bg = c.bg3 })
hi('TabLine',      { fg = c.fg_dim, bg = c.bg3 })
hi('TabLineFill',  { bg = c.bg3 })
hi('TabLineSel',   { fg = c.fg_bright, bg = c.bg })
hi('Folded',       { fg = c.fg_dark, bg = c.bg5 })
hi('FoldColumn',   { fg = c.line_nr, bg = c.bg })
hi('NonText',      { fg = c.whitespace })
hi('SpecialKey',   { fg = c.whitespace })
hi('Whitespace',   { fg = c.whitespace })
hi('EndOfBuffer',  { fg = c.bg })
hi('Visual',       { bg = c.sel_bg })
hi('VisualNOS',    { bg = c.sel_bg })
hi('Search',       { bg = c.text_search })
hi('IncSearch',    { bg = c.search_bg, fg = c.search_fg })
hi('CurSearch',    { bg = c.search_bg, fg = c.search_fg })
hi('Substitute',   { bg = c.search_bg })
hi('MatchParen',   { bg = c.bg6, bold = true })
hi('Pmenu',        { fg = c.fg, bg = c.bg2 })
hi('PmenuSel',     { bg = c.bg5 })
hi('PmenuSbar',    { bg = c.bg3 })
hi('PmenuThumb',   { bg = c.bg6 })
hi('WildMenu',     { fg = c.fg_bright, bg = c.bg5 })
hi('Directory',    { fg = c.func })
hi('Title',        { fg = c.tag, bold = true })
hi('ErrorMsg',     { fg = c.error })
hi('WarningMsg',   { fg = c.warning })
hi('ModeMsg',      { fg = c.fg, bold = true })
hi('MoreMsg',      { fg = c.string })
hi('Question',     { fg = c.string })
hi('Conceal',      { fg = c.comment })
hi('SpellBad',     { undercurl = true, sp = c.error })
hi('SpellCap',     { undercurl = true, sp = c.warning })
hi('SpellLocal',   { undercurl = true, sp = c.hint })
hi('SpellRare',    { undercurl = true, sp = c.template })

-- Diff
hi('DiffAdd',    { bg = c.diff_add })
hi('DiffChange', { bg = c.diff_change })
hi('DiffDelete', { fg = c.deleted, bg = c.diff_delete })
hi('DiffText',   { bg = '#2f4a7a' })
hi('Added',      { fg = c.added })
hi('Changed',    { fg = c.modified })
hi('Removed',    { fg = c.error })

-- Syntax
hi('Comment',     { fg = c.comment })
hi('Constant',    { fg = c.constant, italic = true })
hi('String',      { fg = c.string })
hi('Character',   { fg = c.string })
hi('Number',      { fg = c.number })
hi('Float',       { fg = c.number })
hi('Boolean',     { fg = c.keyword })
hi('Identifier',  { fg = c.fg })
hi('Function',    { fg = c.func })
hi('Statement',   { fg = c.keyword })
hi('Conditional', { fg = c.keyword })
hi('Repeat',      { fg = c.keyword })
hi('Label',       { fg = c.keyword })
hi('Operator',    { fg = c.fg })
hi('Keyword',     { fg = c.keyword })
hi('Exception',   { fg = c.keyword })
hi('PreProc',     { fg = c.keyword })
hi('Include',     { fg = c.keyword })
hi('Define',      { fg = c.keyword })
hi('Macro',       { fg = c.keyword })
hi('PreCondit',   { fg = c.keyword })
hi('Type',        { fg = c.fg })
hi('StorageClass', { fg = c.keyword })
hi('Structure',   { fg = c.keyword })
hi('Typedef',     { fg = c.keyword })
hi('Special',     { fg = c.keyword })
hi('SpecialChar', { fg = c.keyword })
hi('Tag',         { fg = c.tag })
hi('Delimiter',   { fg = c.fg })
hi('Debug',       { fg = c.warning })
hi('Underlined',  { fg = c.link, underline = true })
hi('Error',       { fg = c.error })
hi('Todo',        { fg = c.todo, italic = true })

-- Treesitter
hi('@variable',              { fg = c.fg })
hi('@variable.builtin',      { fg = c.keyword })
hi('@variable.parameter',    { fg = c.fg })
hi('@variable.member',       { fg = c.constant })
hi('@constant',              { fg = c.constant, italic = true })
hi('@constant.builtin',      { fg = c.keyword })
hi('@constant.macro',        { fg = c.constant })
hi('@module',                { fg = c.fg })
hi('@label',                 { fg = c.metadata })
hi('@string',                { fg = c.string })
hi('@string.escape',         { fg = c.keyword })
hi('@string.regexp',         { fg = c.regex })
hi('@string.special',        { fg = c.keyword })
hi('@character',             { fg = c.string })
hi('@number',                { fg = c.number })
hi('@number.float',          { fg = c.number })
hi('@boolean',               { fg = c.keyword })
hi('@type',                  { fg = c.fg })
hi('@type.builtin',          { fg = c.keyword })
hi('@type.qualifier',        { fg = c.keyword })
hi('@attribute',             { fg = c.metadata })
hi('@property',              { fg = c.constant })
hi('@function',              { fg = c.func })
hi('@function.builtin',      { fg = c.func })
hi('@function.call',         { fg = c.fg })
hi('@function.method',       { fg = c.method })
hi('@function.method.call',  { fg = c.fg })
hi('@constructor',           { fg = c.func })
hi('@operator',              { fg = c.fg })
hi('@keyword',               { fg = c.keyword })
hi('@keyword.function',      { fg = c.keyword })
hi('@keyword.return',        { fg = c.keyword })
hi('@keyword.operator',      { fg = c.keyword })
hi('@keyword.import',        { fg = c.keyword })
hi('@keyword.repeat',        { fg = c.keyword })
hi('@keyword.conditional',   { fg = c.keyword })
hi('@keyword.exception',     { fg = c.keyword })
hi('@punctuation.bracket',   { fg = c.fg })
hi('@punctuation.delimiter', { fg = c.fg })
hi('@punctuation.special',   { fg = c.fg })
hi('@comment',               { fg = c.comment })
hi('@comment.todo',          { fg = c.todo, italic = true })
hi('@comment.note',          { fg = c.info })
hi('@comment.warning',       { fg = c.warning })
hi('@comment.error',         { fg = c.error })
hi('@markup.heading',        { fg = c.tag, bold = true })
hi('@markup.strong',         { bold = true })
hi('@markup.italic',         { italic = true })
hi('@markup.link',           { fg = c.link, underline = true })
hi('@markup.link.url',       { fg = c.func, underline = true })
hi('@markup.raw',            { fg = c.fg_bright, bg = c.bg4 })
hi('@tag',                   { fg = c.tag })
hi('@tag.attribute',         { fg = c.fg })
hi('@tag.delimiter',         { fg = c.fg })

-- Go-specific treesitter
hi('@type.go',               { fg = c.fg })
hi('@function.call.go',      { fg = c.fg })
hi('@function.method.call.go', { fg = c.fg })

-- LSP semantic tokens
hi('@lsp.type.namespace',    { fg = c.fg })
hi('@lsp.type.type',         { fg = c.fg })
hi('@lsp.type.class',        { fg = c.fg })
hi('@lsp.type.struct',       { fg = c.fg })
hi('@lsp.type.interface',    { fg = c.fg })
hi('@lsp.type.enum',         { fg = c.fg })
hi('@lsp.type.enumMember',   { fg = c.constant, italic = true })
hi('@lsp.type.function',     { fg = c.func })
hi('@lsp.type.method',       { fg = c.method })
hi('@lsp.type.property',     { fg = c.constant })
hi('@lsp.type.variable',     { fg = c.fg })
hi('@lsp.type.parameter',    { fg = c.fg })
hi('@lsp.type.typeParameter', { fg = c.type_param })
hi('@lsp.type.macro',        { fg = c.constant })
hi('@lsp.type.keyword',      { fg = c.keyword })
hi('@lsp.type.comment',      { fg = c.comment })
hi('@lsp.type.string',       { fg = c.string })
hi('@lsp.type.number',       { fg = c.number })
hi('@lsp.mod.deprecated',    { strikethrough = true })
hi('@lsp.mod.readonly',      { italic = true })

-- Diagnostics
hi('DiagnosticError',          { fg = c.error })
hi('DiagnosticWarn',           { fg = c.warning })
hi('DiagnosticInfo',           { fg = c.func })
hi('DiagnosticHint',           { fg = c.hint })
hi('DiagnosticUnderlineError', { undercurl = true, sp = c.error })
hi('DiagnosticUnderlineWarn',  { undercurl = true, sp = c.warning })
hi('DiagnosticUnderlineInfo',  { undercurl = true, sp = c.info })
hi('DiagnosticUnderlineHint',  { undercurl = true, sp = c.hint })

-- Git signs
hi('GitSignsAdd',    { fg = c.added })
hi('GitSignsChange', { fg = c.modified })
hi('GitSignsDelete', { fg = c.deleted })

-- Indent guides (if using indent-blankline or similar)
hi('IblIndent', { fg = c.bg4 })
hi('IblScope',  { fg = '#4e5157' })
