A lua library for [Neovim](https://github.com/neovim/neovim) to provide
one-shot stubs for vim commands, vim keymaps and `require()` calls. Its primary
intend is to provide mechanism for lazy loading packages using the neovim
package manager [Mini.Deps](https://github.com/echasnovski/mini.deps) of the
[mini.nvim](https://github.com/echasnovski/mini.nvim) library.


## Installation

Since the main use case is lazy loading packages with `MiniDeps`, here is the
installation code using `MiniDeps`.

```lua
local add = MiniDeps.add
add({ source = 'shuber2/oneshotstubs.nvim' })
```

## Usage

The lua module `oneshotsutbs` provides three module functions:

- `keymap(mode, lhs, callback, opts)`
- `command(cmd, callback)`
- `require(module, callback)`

In all cases, `callback` is associated with a vim keymap as in
`vim.keymap.set()`, a vim user command as in
`vim.api.nvim_create_user_command()` and a lua `package.preload()` function,
respectively. Upon the first invokation the following happens:

1. the keymap, function or preload function is deinstalled again (hence "oneshot"),
2. the `callback` is called, and
3. the original functionality (keymap, function) is invoked.

The typical use case is **lazy loading packages with Mini.Deps** by setting
`callback` to a `MiniDeps.add()` command. For instance, if a package has
significant load times and would compromise neovim's startuptime. Or if we
would not like to call a package only on demand, maybe for performance or
privacy reasons.

```lua
oneshotstubs = require('oneshotstubs')

-- Like vim.keymap.set()
oneshotstubs.keymap({'n', 'v'}, '<leader>KB', function() add({ source = 'dbeniamine/cheat.sh-vim' }) end)
-- Like vim.api.nvim_create_user_command()
oneshotstubs.command('Copilot', function() add({ source = 'github/copilot.vim' }) end)
-- Like require()
oneshotstubs.require('gp', function() add({ source = 'robitx/gp.nvim' }) end)
```


## Credits

The original code was posted by [cathalogue](https://github.com/leath-dub) as a
[suggestion](https://github.com/echasnovski/mini.nvim/issues/1353#issue-2677280618)
to be added to [mini.nvim](https://github.com/echasnovski/mini.nvim) to provide
lazy loading of packages. However, the author of mini.nvim felt it would
compromise simplicity for a rare need.
