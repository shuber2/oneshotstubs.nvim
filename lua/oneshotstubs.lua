local M = {}

function M.keymap(mode, lhs, callback, opts)
  vim.keymap.set(mode, lhs, function()
    vim.keymap.del(mode, lhs)
    callback()
    vim.api.nvim_input(lhs) -- replay keybind
  end, opts)
end

function M.command(cmd, callback)
  vim.api.nvim_create_user_command(cmd, function(cr)
    local args = not vim.tbl_isempty(cr.fargs) and table.concat(cr.fargs, " ") or nil
    vim.api.nvim_del_user_command(cmd) -- remove stub command
    callback()
    vim.cmd(cmd .. (args and (" " .. args) or ""))
  end, { nargs = "*" })
end

function M.require(module, callback)
  package.preload[module] = function()
    package.loaded[module] = nil
    package.preload[module] = nil
    return callback()
  end
end

return M
