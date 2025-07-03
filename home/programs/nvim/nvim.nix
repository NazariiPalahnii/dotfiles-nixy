{ config, lib, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      onedark-nvim
      nvim-web-devicons
      lualine-nvim
      bufferline-nvim
      nvim-tree-lua
      indent-blankline-nvim
      nvim-scrollbar
      
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-file-browser-nvim
      nvim-treesitter-context
      
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-vsnip
      vim-vsnip
      lspkind-nvim
      lspsaga-nvim
      trouble-nvim
      
      (nvim-treesitter.withPlugins (plugins: [
        plugins.tree-sitter-python
        plugins.tree-sitter-rust
        plugins.tree-sitter-javascript
        plugins.tree-sitter-typescript
        plugins.tree-sitter-html
        plugins.tree-sitter-css
        plugins.tree-sitter-json
        plugins.tree-sitter-lua
        plugins.tree-sitter-nix
        plugins.tree-sitter-cpp
        plugins.tree-sitter-bash
        plugins.tree-sitter-markdown
      ]))
      nvim-ts-autotag
      rainbow-delimiters-nvim
      gitsigns-nvim
      
      nvim-autopairs
      comment-nvim
      which-key-nvim
      surround-nvim
      nvim-colorizer-lua
    ];

    extraLuaConfig = ''
      -- Базовые настройки
      vim.opt.termguicolors = true
      vim.cmd.colorscheme("onedark")
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.smartindent = true
      vim.opt.signcolumn = "yes"
      vim.opt.updatetime = 300
      vim.opt.backup = false
      vim.opt.writebackup = false

      -- Горячие клавиши
      vim.g.mapleader = ' '
      vim.keymap.set('n', '<leader>tt', ':NvimTreeToggle<CR>', { silent = true })
      vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { silent = true })
      vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { silent = true })
      vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gd', ':lua vim.lsp.buf.definition()<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gr', ':lua vim.lsp.buf.references()<CR>', { silent = true })
      vim.keymap.set('n', '<leader>rn', ':lua vim.lsp.buf.rename()<CR>', { silent = true })
      vim.keymap.set('n', '<leader>aa', ':tabnew +Ex /etc/nixos<CR>', { silent = true })

      -- Фикс конфликтов для comment.nvim
      vim.keymap.set('n', '<leader>cc', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', { silent = true })
      vim.keymap.set('n', '<leader>bc', '<cmd>lua require("Comment.api").toggle.blockwise.current()<CR>', { silent = true })

      -- Конфиг bufferline (верхняя панель вкладок)
      require("bufferline").setup({
        options = {
          mode = "tabs",
          separator_style = "slant",
          always_show_bufferline = true,
          show_close_icon = false,
          offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left"
          }
        }
      }
    })

    -- Конфиг trouble.nvim (просмотр ошибок)
    require("trouble").setup({
      position = "bottom",
      height = 10,
      icons = true,
      mode = "document_diagnostics"
    })


    -- Конфиг which-key (подсказки клавиш)
    require("which-key").setup({
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
    },
    win = {
      border = "rounded",
      margin = { 1, 0, 1, 0 },
      padding = { 2, 1, 2, 1 },
    },
  })

      -- Конфиг nvim-autopairs (автозакрытие скобок)
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt", "vim" },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
        },
      })
      -- Конфиг comment.nvim (комментирование)
      require("Comment").setup({
        toggler = {
          line = "<leader>cc",  -- Было <leader>c
          block = "<leader>bc", -- Было <leader>b
        },
        opleader = {
          line = "<leader>c",
          block = "<leader>b",
        },
        extra = {
          eol = "<leader>ce", -- Новый маппинг для end-of-line
        },
      })
      -- Конфиг nvim-colorizer (показ цветов)
      require("colorizer").setup({
        "*",
        css = { rgb_fn = true },
          scss = { rgb_fn = true },
        }, {
        names = false,
      })

      -- Конфиг surround.nvim (обрамление текста)
      require("surround").setup({})

      -- Конфиг scrollbar
      require("scrollbar").setup({
        show = true,
        handle = {
          color = "#3e4452",
        },
        marks = {
          Search = { color = "#e5c07b" },
          Error = { color = "#e06c75" },
          Warn = { color = "#d19a66" },
          Info = { color = "#61afef" },
          Hint = { color = "#98c379" },
        },
      })

          -- Настройка LSP серверов (добавь в секцию LSP)
      local servers = {
        pyright = {},      -- Python
        rust_analyzer = {},-- Rust
        tsserver = {},     -- TypeScript/JavaScript
        html = {},         -- HTML
        cssls = {},        -- CSS
        jsonls = {},       -- JSON
        lua_ls = {         -- Lua
            settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = { library = vim.api.nvim_get_runtime_file("", true) },
              telemetry = { enable = false },
            },
          },
        },
        nixd = {},         -- Nix
        clangd = {},       -- C/C++
        bashls = {},       -- Bash
        marksman = {},     -- Markdown
      }

      -- Клавиши для trouble.nvim
      vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true })
      vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true })
      vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true })

      -- Клавиши для Lspsaga
      vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
      vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
      vim.keymap.set("n", "gp", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
      -- Статусная строка
      require('lualine').setup({
        options = {
          theme = 'onedark',
          component_separators = { left = '|', right = '|'},
          section_separators = { left = "", right = ""},
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
      })
      
      -- Дерево файлов
      require("nvim-tree").setup({
        view = {
          width = 35,
        },
        renderer = {
          group_empty = true,
          highlight_git = true,
          icons = {
            show = {
              git = true,
            },
          },
        },
      })
      
      -- Поиск (Telescope)
      local telescope = require('telescope')
      telescope.setup({
        defaults = {
          layout_strategy = 'vertical',
          layout_config = { height = 0.95, width = 0.95 },
          sorting_strategy = 'ascending',
          prompt_prefix = "🔍 ",
          file_ignore_patterns = { "node_modules", ".git" },
        },
        pickers = {
          find_files = { theme = "dropdown" },
          live_grep = { theme = "ivy" },
          buffers = { theme = "dropdown" },
        },
      })
      telescope.load_extension('fzf')
      telescope.load_extension('file_browser')
      
      -- LSP и автодополнение
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
        formatting = {
          format = require('lspkind').cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
          })
        }
      })
      
      -- Настройка LSP серверов
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      
      -- Treesitter
      require('nvim-treesitter.configs').setup({
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = true },
        rainbow = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
      })
      
      -- Git интеграция
      require('gitsigns').setup({
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 1000,
        },
      })
      
      -- Горячие клавиши
      vim.g.mapleader = ' '
      vim.keymap.set('n', '<leader>tt', ':NvimTreeToggle<CR>', { silent = true })
      vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { silent = true })
      vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { silent = true })
      vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gd', ':lua vim.lsp.buf.definition()<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gr', ':lua vim.lsp.buf.references()<CR>', { silent = true })
      vim.keymap.set('n', '<leader>rn', ':lua vim.lsp.buf.rename()<CR>', { silent = true })
      vim.keymap.set('n', '<leader>aa', ':tabnew +Ex /etc/nixos<CR>', { silent = true })
      
      -- Автоформатирование
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.py", "*.rs", "*.js", "*.ts", "*.lua", "*.nix", "*.cpp", "*.c" },
        callback = function()
          vim.lsp.buf.format({ async = false })
        end
      })
      
      -- Индикаторы отступов
      require("ibl").setup {
        indent = { char = "▏" },
        scope = { 
          enabled = true,
          show_start = true,
          show_end = true,
        }
      }
      
      -- Neovide специфичные настройки
      if vim.g.neovide then
        vim.o.guifont = "FiraCode Nerd Font:h12"
        vim.g.neovide_transparency = 0.95
        vim.g.neovide_background_color = "#1e1e2e"
      end
    '';
    
    extraConfig = ''
      " Основные настройки
      set scrolloff=8
      set mouse=a
      set clipboard+=unnamedplus
      set undofile
      set undodir=~/.vim/undodir
      set noswapfile
      set timeoutlen=500
      set completeopt=menu,menuone,noselect
      
      " Прозрачность
      highlight Normal guibg=none
      highlight NonText guibg=none
      highlight EndOfBuffer ctermbg=none guibg=none
      highlight SignColumn ctermbg=none guibg=none
      highlight StatusLine guibg=none
      
      inoremap <C-S> <Nop>
      " Автосохранение
      augroup autosave
        autocmd!
        autocmd TextChanged,TextChangedI * if &modifiable && !&readonly | silent! write | endif
      augroup END
    '';
  };
}
