require('which-key').register {
    ['<leader>c'] = {
        name = '[C]ode',
        _ = 'which_key_ignore'
    },
    ['<leader>d'] = {
        name = '[D]ocument',
        _ = 'which_key_ignore'
    },
    ['<leader>r'] = {
        name = '[R]ename',
        _ = 'which_key_ignore'
    },
    ['<leader>s'] = {
        name = '[S]earch',
        _ = 'which_key_ignore'
    },
    ['<leader>w'] = {
        name = '[W]orkspace',
        _ = 'which_key_ignore'
    }
}

require('telescope').setup {
    extensions = {
        ['ui-select'] = {require('telescope.themes').get_dropdown()}
    }
}

vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false
    })
end, {
    desc = '[/] Fuzzily search in current buffer'
})

vim.keymap.set('n', '<leader>s/', function()
    require('telescope.builtin').live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files'
    }
end, {
    desc = '[S]earch [/] in Open Files'
})

-- Shortcut for searching your neovim configuration files
vim.keymap.set('n', '<leader>sn', function()
    require('telescope.builtin').find_files {
        cwd = vim.fn.stdpath 'config'
    }
end, {
    desc = '[S]earch [N]eovim files'
})
