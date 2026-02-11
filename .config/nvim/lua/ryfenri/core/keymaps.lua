vim.g.mapleader = " "

local keymap = vim.keymap

local opts = {
	noremap = true, -- non-recursive
	silent = true, -- do not show message
}

local function get_visual_selection()
    local mode = vim.fn.mode()
    if not mode:match('[vV\22]') then
        return nil
    end

    local region = vim.fn.getregion(
        vim.fn.getpos('v'),
        vim.fn.getpos('.'),
        { type = mode }
    )

    return table.concat(region, '\n')
end


vim.keymap.set('v', '<leader>iv', function()
    local selected = get_visual_selection()
    if not selected then return end

    local path = selected:match('%((.-)%)') or selected:gsub('^[./]+', '')
    local full_path = vim.fn.expand('%:p:h') .. '/' .. path
    if vim.fn.filereadable(full_path) == 0 then full_path = path end

    local term = vim.env.TERM or ''
    local is_kitty = term:match('kitty') or vim.env.KITTY_WINDOW_ID

    if is_kitty then
        local cmd = string.format(
            "kitty @ launch --location=vsplit --title=image-preview --cwd=current sh -c 'kitty +kitten icat --hold %s'",
            vim.fn.shellescape(full_path)
        )
        vim.fn.jobstart({ 'sh', '-c', cmd }, { detach = true })
		vim.defer_fn(function()
			vim.fn.jobstart({
				'kitty', '@', 'resize-window',
				'--axis=vertical',
				'--increment=9999'
			}, { detach = true })
		end, 50)
    else
        vim.cmd('new | wincmd J | resize 20')
        vim.fn.termopen({ 'sh', '-c', string.format('chafa %s; read -p "Press enter..."', vim.fn.shellescape(full_path)) })
        vim.cmd('startinsert')
    end
end, opts)

keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)

keymap.set("n", "m", "h", opts)

keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)
keymap.set("n", "<ESC>", ":nohlsearch <CR>", opts)

keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)
keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Telescope
keymap.set("n", "<leader>ff", ":Telescope find_files <CR>", opts)
keymap.set("n", "<leader>fg", ":Telescope live_grep <CR>", opts)
keymap.set("n", "<leader>fh", ":Telescope help_tags <CR>", opts)
keymap.set("n", "<leader>fb", ":Telescope buffers <CR>", opts)
keymap.set("n", "<leader>fc", ":Telescope colorscheme <CR>", opts)
keymap.set("n", "<leader>gb", ":Telescope git_branches <CR>", opts)

-- NvimTree
keymap.set("n", "<leader>e", ":NvimTreeToggle <CR>", opts)

-- Navagation
keymap.set("n", "<C-h>", "<C-w><C-h>")
keymap.set("n", "<C-l>", "<C-w><C-l>")
keymap.set("n", "<C-k>", "<C-w><C-k>")
keymap.set("n", "<C-j>", "<C-w><C-l>")

-- Colorizer
keymap.set("n", "<leader>ct", ":ColorizerToggle <CR>", opts)

-- Lsp
keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
keymap.set("n", "gd", vim.lsp.buf.definition, opts)
keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)
keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, opts)
keymap.set("n", "<leader>k", vim.lsp.buf.hover, opts)
keymap.set("n", "<leader>li", vim.lsp.buf.implementation, opts)
keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
keymap.set("n", "<leader>lD", vim.lsp.buf.type_definition, opts)
keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
keymap.set("n", "gr", vim.lsp.buf.references, opts)
keymap.set("n", "<leader>f", ":Format <CR>", opts)

-- Markdown
keymap.set("n", "<leader>mr", ":RenderMarkdown toggle <CR>", opts)

-- Debugger
keymap.set("n", "<leader>db", ":DapToggleBreakpoint <CR>")
keymap.set("n", "<leader>dpr", function ()
	require("dap-python").test_method()
end)


-- 99
keymap.set("v", "<leader>99", function ()
	require("99").visual_prompt()
	local cwd = vim.uv.cwd()
	vim.fn.mkdir(cwd .. "/tmp", "p")
end, opts)
