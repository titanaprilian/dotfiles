# titan.nvim

Neovim configuration dotfiles built on lazy.nvim, Mason, Telescope, and Treesitter.

## Commands
- `nvim --headless "+Lazy! sync" +qa` - Sync and update all lazy.nvim plugins
- `nvim --headless "+TSUpdateSync" +qa` - Update all Treesitter parsers
- `nvim --headless "+MasonUpdate" +qa` - Update Mason registry
- `nvim +checkhealth` - Run Neovim health checks

## Gotchas
- **Adding Plugins**: Do not clutter `init.lua`. Create a new `<plugin-name>.lua` file in `lua/titan/plugins/`. `lazy.nvim` automatically discovers and merges all files in this directory.
- **Configuring Plugins**: Use `opts = {}` or `config = function()` inside the lazy.nvim plugin spec. Do not manually call `require("plugin").setup()` outside of lazy.nvim definitions.
- **Adding LSPs**: Add the LSP name to the `ensure_installed` list in `lua/titan/plugins/lsp/mason.lua` under `mason-lspconfig.nvim`.
- **Adding Formatters/Linters**: Add the tool name to the `ensure_installed` list in `lua/titan/plugins/lsp/mason.lua` under `mason-tool-installer.nvim`.
- **Global Options & Keymaps**: Place global vim options in `lua/titan/core/options.lua` and global keybindings in `lua/titan/core/keymaps.lua`.

## Conventions
- **Formatting**: Use `conform.nvim` (configured in `formatting.lua`).
- **Linting**: Use `nvim-lint` (configured in `linting.lua`).
- **LSP Keymaps**: LSP-specific keymaps are attached dynamically in `lua/titan/plugins/lsp/lsp.lua` upon the `LspAttach` event. Do not place them in global keymaps.
