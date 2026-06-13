# titan.nvim

An elegant, blazing-fast, IDE-like Neovim configuration built on lazy.nvim, LSP, Treesitter, and rich development utilities.

Develop, navigate, and edit codebases with a highly responsive, custom-tailored workspace designed for maximum efficiency.

- **Modern Plugin Management:** Powered by `lazy.nvim` with aggressive lazy-loading for fast startup times.
- **Rich IDE Capabilities:** Full LSP integration via `mason.nvim` and `mason-tool-installer.nvim` for automated installation of servers, formatters, and linters.
- **Enhanced UI Components:** Clean, modern floats and interactive buffers via `lspsaga.nvim`, `dressing.nvim`, and `alpha.nvim`.
- **Fuzzy Finder:** High-speed fuzzy search across files, buffers, live greps, and open TODOs using `telescope.nvim`.
- **Advanced Syntax Highlighting:** AST-based code highlighting, smart folding, and deep language understanding powered by `nvim-treesitter`.
- **Formatting & Linting on Demand:** Automated linting via `nvim-lint` and formatting on-save or via keybind using `conform.nvim`.
- **Git Integration:** Real-time git diff signs directly in the gutter via `gitsigns.nvim`.
- **Beautiful Aesthetics:** Semi-transparent `tokyonight.nvim` colorscheme with custom buffer tabs via `bufferline.nvim` and statusline via `lualine.nvim`.

---

## Contents

- [Requirements](#requirements)
- [Getting Started](#getting-started)
- [File Structure](#file-structure)
- [Keymaps Cheat Sheet](#keymaps-cheat-sheet)
  - [General Settings](#general-settings)
  - [Window & Tab Management](#window--tab-management)
  - [File Explorer (NvimTree)](#file-explorer-nvimtree)
  - [Fuzzy Finder (Telescope)](#fuzzy-finder-telescope)
  - [LSP Navigation & Actions](#lsp-navigation--actions)
  - [Formatting & Linting](#formatting--linting)
- [License](#license)

---

## Requirements

Ensure your system meets the following prerequisites before installing:

- **Neovim 0.9.0+** (with LuaJIT)
- **Git** (for cloning the configuration and downloading plugins)
- **A Nerd Font** (e.g., [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts) or [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts)) for rich icon support
- **ripgrep** (required for Telescope's live grep functionality)
- **Node.js & npm** (required for Mason to install and run JavaScript/TypeScript and other language servers)
- **Python 3 & pip** (required for Python linting and formatting utilities)

---

## Getting Started

Follow these steps to clean your existing environment and install `titan.nvim`:

### 1. Back up your existing configuration

Run the following commands to safely back up your current Neovim config and state:

```bash
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.local/state/nvim ~/.local/state/nvim.backup
mv ~/.cache/nvim ~/.cache/nvim.backup
```

### 2. Clone the repository

Clone this configuration directly into your Neovim configuration directory:

```bash
git clone https://github.com/titanaprilian/dotfiles.git ~/.config/nvim
```

### 3. Open Neovim and install plugins

Start Neovim:

```bash
nvim
```

On your first launch, `lazy.nvim` automatically opens and downloads all configured plugins, LSP servers, formatters, and linters. Once the installation completes, restart Neovim (`:qa` and then restart) to activate all features.

---

## File Structure

The project layout divides core configuration, keymaps, and plugins cleanly:

```text
nvim/
├── init.lua                # Entry point, loads core settings and plugins
├── lazy-lock.json          # Pin lockfile for installed plugins
├── skills-lock.json        # Pin lockfile for active agent skills
└── lua/
    └── titan/
        ├── core/           # Core configuration files
        │   ├── init.lua    # Loads options and keymaps
        │   ├── keymaps.lua # Global custom keybindings
        │   └── options.lua # Global Neovim settings and options
        └── plugins/        # Plugin setups (loaded dynamically by lazy.nvim)
            ├── lsp/        # Language Server Protocol setups
            │   ├── lsp.lua       # Main LSP servers configuration & attachment keymaps
            │   ├── lspsaga.lua   # UI wrappers for diagnostics/definitions/rename
            │   └── mason.lua     # Automated installation of LSPs, formatters, & linters
            ├── colorscheme.lua   # Tokyonight theme configuration
            ├── treesitter.lua    # AST syntax highlighting configuration
            ├── telescope.lua     # Fuzzy finder configuration & search keymaps
            └── ... (other utility plugins)
```

---

## Keymaps Cheat Sheet

The leader key is mapped to `<Space>`. Use these highly optimized keybindings to speed up your editing workflow.

### General Settings

| Mode | Shortcut | Action |
|------|----------|--------|
| Insert | `jk` | Exit insert mode |
| Normal | `<leader>nh` | Clear search highlights |
| Normal | `<leader>+` | Increment number under cursor |
| Normal | `<leader>-` | Decrement number under cursor |

### Window & Tab Management

| Mode | Shortcut | Action |
|------|----------|--------|
| Normal | `<leader>sv` | Split window vertically |
| Normal | `<leader>sh` | Split window horizontally |
| Normal | `<leader>se` | Make split windows equal size |
| Normal | `<leader>sx` | Close current split window |
| Normal | `<leader>to` | Open a new tab |
| Normal | `<leader>tx` | Close the current tab |
| Normal | `<leader>tn` | Go to the next tab |
| Normal | `<leader>tp` | Go to the previous tab |
| Normal | `<leader>tf` | Open the current buffer in a new tab |

### File Explorer (NvimTree)

| Mode | Shortcut | Action |
|------|----------|--------|
| Normal | `<leader>ee` | Toggle file explorer sidebar |
| Normal | `<leader>ef` | Toggle file explorer focus on the current file |
| Normal | `<leader>ec` | Collapse all open directories in file explorer |
| Normal | `<leader>er` | Refresh file explorer contents |

### Fuzzy Finder (Telescope)

| Mode | Shortcut | Action |
|------|----------|--------|
| Normal | `<leader>ff` | Fuzzy find files in current working directory |
| Normal | `<leader>fr` | Fuzzy find recently opened files |
| Normal | `<leader>fs` | Search for a text string across files (live grep) |
| Normal | `<leader>fc` | Search for the word currently under cursor |
| Normal | `<leader>ft` | Find all TODO comments across project files |

#### Telescope Interactive Shortcuts

While browsing search results in the Telescope prompt, use these controls:

- `<C-k>` — Move to previous search result
- `<C-j>` — Move to next search result
- `<C-q>` — Send all selected search items to the quickfix list

### LSP Navigation & Actions

These keymaps activate automatically when an LSP client attaches to an open buffer:

| Mode | Shortcut | Action |
|------|----------|--------|
| Normal | `gd` | Jump to symbol definition |
| Normal | `gt` | Jump to type definition |
| Normal | `gD` | Jump to symbol declaration |
| Normal | `gi` | List all implementations |
| Normal | `gr` | List all references |
| Normal | `gp` | Peek symbol definition in a floating window (Lspsaga) |
| Normal | `<leader>rn` | Rename symbol across project |
| Normal/Visual | `<leader>ca` | Trigger code actions |
| Normal | `<leader>sh` | Show signature help |
| Normal | `[d` | Go to previous diagnostic error/warning |
| Normal | `]d` | Go to next diagnostic error/warning |

### Formatting & Linting

Format and lint files on demand or automatically on save:

| Mode | Shortcut | Action |
|------|----------|--------|
| Normal/Visual | `<leader>mp` | Manually format buffer or visual range |
| Normal | `<leader>l` | Trigger linting manually for the current file |

---

## License

This Neovim configuration is open-source software licensed under the [MIT License](LICENSE).
