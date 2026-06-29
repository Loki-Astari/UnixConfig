# Neovim Keybindings Reference

**Leader key: `<Space>`**

---

## General Navigation

| Mode | Key | Action | Source |
|------|-----|--------|--------|
| n | `n` | Next search result (centered) | core/keymaps |
| n | `N` | Previous search result (centered) | core/keymaps |
| n | `Ctrl-d` | Scroll down half page (centered) | core/keymaps |
| n | `Ctrl-u` | Scroll up half page (centered) | core/keymaps |

## Window Management

| Mode | Key | Action | Source |
|------|-----|--------|--------|
| n | `Shift-Up` | Decrease window height | core/keymaps |
| n | `Shift-Down` | Increase window height | core/keymaps |
| n | `Shift-Left` | Increase window width | core/keymaps |
| n | `Shift-Right` | Decrease window width | core/keymaps |

## Buffer Navigation

| Mode | Key | Action | Source |
|------|-----|--------|--------|
| n | `Tab` | Next buffer | core/keymaps |
| n | `Shift-Tab` | Previous buffer | core/keymaps |
| n | `<leader><leader>` | Find existing buffers (Telescope) | telescope |
| n | `<leader>01` - `<leader>09` | Jump to buffer 1-9 | core-keymaps |
| n | `<leader>0$` | Jump to last buffer | core-keymaps |
| n | `<leader>bp` | Pick buffer (interactive) | core-keymaps |
| n | `<leader>bx` | Pick and close buffer | core-keymaps |

## Search (Telescope) `<leader>s`

| Mode | Key | Action |
|------|-----|--------|
| n | `<leader>sh` | Search Help tags |
| n | `<leader>sk` | Search Keymaps |
| n | `<leader>sf` | Search Files |
| n | `<leader>ss` | Search Select Telescope picker |
| n | `<leader>sw` | Search current Word (grep) |
| n | `<leader>sg` | Search by Grep (live) |
| n | `<leader>sd` | Search Diagnostics |
| n | `<leader>sr` | Search Resume (reopen last) |
| n | `<leader>s.` | Search Recent Files |
| n | `<leader>s/` | Search in Open Files |
| n | `<leader>sn` | Search Neovim config files |
| n | `<leader>/` | Fuzzy search in current buffer |
| n | `<leader>sc` | Toggle case sensitive search |

## LSP `gr` prefix (active when LSP attached)

| Mode | Key | Action |
|------|-----|--------|
| n | `grn` | Rename symbol |
| n, x | `gra` | Code action |
| n | `grr` | Go to references |
| n | `gri` | Go to implementation |
| n | `grd` | Go to definition |
| n | `grD` | Go to declaration |
| n | `grt` | Go to type definition |
| n | `gO` | Document symbols |
| n | `gW` | Workspace symbols |

## Toggle `<leader>t`

| Mode | Key | Action | Source |
|------|-----|--------|--------|
| n | `<leader>th` | Toggle inlay hints (LSP) | lsp |
| n | `<leader>tb` | Toggle git blame (inline) | gitsigns |
| n | `<leader>tw` | Toggle word diff | gitsigns |

## Git (Gitsigns) `<leader>h`

| Mode | Key | Action |
|------|-----|--------|
| n | `<leader>hs` | Stage hunk |
| v | `<leader>hs` | Stage hunk (visual selection) |
| n | `<leader>hr` | Reset hunk |
| v | `<leader>hr` | Reset hunk (visual selection) |
| n | `<leader>hS` | Stage entire buffer |
| n | `<leader>hR` | Reset entire buffer |
| n | `<leader>hp` | Preview hunk (popup) |
| n | `<leader>hi` | Preview hunk inline |
| n | `<leader>hb` | Blame line (full) |
| n | `<leader>hd` | Diff this |
| n | `<leader>hD` | Diff this ~ |
| n | `<leader>hq` | Send hunks to quickfix |
| n | `<leader>hQ` | Send all hunks to quickfix |

## AI Agent `<leader>a`

| Mode | Key | Action |
|------|-----|--------|
| n, v | `<leader>ao` | Open agent (default) |
| n, v | `<leader>ac` | Open Cursor agent |
| n, v | `<leader>ax` | Close current agent |
| n, v | `<leader>at` | Toggle current agent |
| n, v | `<leader>as` | Send selection to agent |
| n, v | `<leader>ad` | Send diagnostics to agent |
| n, v | `<leader>a<Space>` | Open Agent Session Selector |
| n, v | `<leader>ar` | Replay Agent Session Selector |
| n, v | `<leader>ah` | Open Agent Diff Viewer |

## File Explorer (Neo-tree)

| Mode | Key | Action |
|------|-----|--------|
| n | `\` | Toggle Neo-tree sidebar |
| n | `<leader>e` | Toggle Neo-tree sidebar |

### Neo-tree Window Keys

| Key | Action |
|-----|--------|
| `Enter` / double-click | Open file |
| `Space` | Toggle node expand/collapse |
| `Esc` | Cancel / close preview |
| `P` | Toggle preview (float) |
| `l` | Focus preview |
| `S` | Open in horizontal split |
| `s` | Open in vertical split |
| `t` | Open in new tab |
| `w` | Open with window picker |
| `a` | Add file |
| `A` | Add directory |
| `d` | Delete |
| `r` | Rename |
| `b` | Rename basename only |
| `y` | Copy to clipboard |
| `x` | Cut to clipboard |
| `p` | Paste from clipboard |
| `c` | Copy (to destination) |
| `m` | Move (to destination) |
| `C` | Close node |
| `z` | Close all nodes |
| `R` | Refresh |
| `q` | Close Neo-tree window |
| `?` | Show help |
| `<` / `>` | Previous / next source |
| `i` | Show file details |

### Neo-tree Filesystem Keys

| Key | Action |
|-----|--------|
| `Backspace` | Navigate up |
| `.` | Set root |
| `H` | Toggle hidden files |
| `/` | Fuzzy finder |
| `D` | Fuzzy finder (directories) |
| `#` | Fuzzy sorter |
| `f` | Filter on submit |
| `Ctrl-x` | Clear filter |
| `[g` / `]g` | Previous / next git modified |
| `o` | Order by... submenu |
| `oc/od/og/om/on/os/ot` | Order by created/diagnostics/git/modified/name/size/type |

### Neo-tree Git Status Keys

| Key | Action |
|-----|--------|
| `A` | Git add all |
| `ga` | Git add file |
| `gu` | Git unstage file |
| `gU` | Git undo last commit |
| `gr` | Git revert file |
| `gc` | Git commit |
| `gp` | Git push |
| `gg` | Git commit and push |

## Clojure (Conjure)

| Mode | Key | Action |
|------|-----|--------|
| n | `<leader>cr` | Open Conjure REPL below AIAgent |

## Diff Mode

| Mode | Key | Action | Source |
|------|-----|--------|--------|
| n | `Z` | Push diff right + jump to next | core/keymaps |
| n | `C` | Toggle comment on parameter (C++) | core/keymaps |

## Copy Mode `<leader>q`

| Mode | Key | Action |
|------|-----|--------|
| n | `<leader>qq` | Toggle Copy Mode (hides line numbers, signs, and agent panel) |

## Config

| Mode | Key | Action |
|------|-----|--------|
| n | `<leader>rr` | Reload core config (options + keymaps) |
| n | `<leader>E` | Open quickfix list |
| n | `<leader>?` | Show buffer-local keymaps (which-key) |

## Autocomplete (Blink.cmp) - Insert Mode

Preset: **super-tab**

| Key | Action |
|-----|--------|
| `Tab` / `Shift-Tab` | Accept completion / move through snippet |
| `Ctrl-Space` | Open completion menu (or docs if open) |
| `Ctrl-n` / `Ctrl-p` | Select next / previous item |
| `Up` / `Down` | Select next / previous item |
| `Ctrl-e` | Hide menu |
| `Ctrl-k` | Toggle signature help |

## Markdown

| Mode | Key | Action | Source |
|------|-----|--------|--------|
| i | `--` | Expands to em dash (`---`) | init.lua |
