 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#292114',
    base01 = '#453621',
    base02 = '#3e311e',
    base03 = '#716b61',
    base04 = '#b6b3af',
    base05 = '#f3f2f2',
    base06 = '#f3f2f2',
    base07 = '#f3f2f2',
    base08 = '#875c38',
    base09 = '#66a6cc',
    base0A = '#cad65c',
    base0B = '#e4b267',
    base0C = '#96cae9',
    base0D = '#ecc893',
    base0E = '#e1e996',
    base0F = '#eef4be',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- telescope.nvim
  hi('TelescopeNormal',         { fg = '#f3f2f2',          bg = '#292114' })
  hi('TelescopeBorder',         { fg = '#716b61',             bg = '#292114' })
  hi('TelescopePromptNormal',   { fg = '#f3f2f2',          bg = '#292114' })
  hi('TelescopePromptBorder',   { fg = '#716b61',             bg = '#292114' })
  hi('TelescopePromptPrefix',   { fg = '#e4b267',             bg = '#292114' })
  hi('TelescopePromptCounter',  { fg = '#b6b3af',  bg = '#292114' })
  hi('TelescopePromptTitle',    { fg = '#292114',             bg = '#e4b267' })
  hi('TelescopePreviewTitle',   { fg = '#292114',             bg = '#cad65c' })
  hi('TelescopeResultsTitle',   { fg = '#292114',             bg = '#66a6cc' })
  hi('TelescopeSelection',      { fg = '#f3f2f2',          bg = '#3e311e' })
  hi('TelescopeSelectionCaret', { fg = '#e4b267',             bg = '#3e311e' })
  hi('TelescopeMatching',       { fg = '#e4b267',             bold = true })

  -- mini.pick
  hi('MiniPickNormal',         { fg = '#f3f2f2',          bg = '#292114' })
  hi('MiniPickBorder',         { fg = '#716b61',             bg = '#292114' })
  hi('MiniPickPrompt',   { fg = '#f3f2f2',          bg = '#292114' })
  hi('MiniPickPromptPrefix',   { fg = '#e4b267',             bg = '#292114' })
  hi('MiniPickBorderText',    { fg = '#292114',             bg = '#e4b267' })
  hi('MiniPickMatchCurrent',      { fg = '#f3f2f2',          bg = '#3e311e' })
  hi('MiniPickPromptCaret', { fg = '#e4b267',             bg = '#3e311e' })
  hi('MiniPickMatchRanges',       { fg = '#e4b267',             bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates).
-- The handler re-requires this module, which re-runs the code below, so the
-- previous handle is stopped first; otherwise handlers double on every signal.
if _G.__matugen_signal then
  _G.__matugen_signal:stop()
  _G.__matugen_signal:close()
end

local signal = vim.uv.new_signal()
_G.__matugen_signal = signal
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    require('matugen').setup()
  end)
)

return M
