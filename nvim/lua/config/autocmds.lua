-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Workaround clangd: al abrir el header que define una macro, clangd deja de
-- devolver su #define como referencia desde los .c. Al salir de un header
-- abierto con `gr`, lo descargamos y (según el modo) reiniciamos clangd.
--
--   vim.g.clangd_macro_fix = "eager"  (default) reinicia al salir del header
--   vim.g.clangd_macro_fix = "lazy"   reinicia recién al volver a apretar `gr`
--   vim.g.clangd_macro_fix = false    desactiva el workaround ("off")
do
  local mode = vim.g.clangd_macro_fix
  if mode == false or mode == "off" then
    return
  end
  if mode ~= "lazy" then
    mode = "eager"
  end

  local gr_time = 0
  local gr_header = nil
  local needs_restart = false

  local function is_header(buf)
    local name = vim.api.nvim_buf_get_name(buf)
    return name:match("%.h$") or name:match("%.hpp$") or name:match("%.hh$") or name:match("%.hxx$")
  end

  local function is_shown(buf)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == buf then
        return true
      end
    end
    return false
  end

  local function restart_clangd()
    if #vim.lsp.get_clients({ name = "clangd" }) == 0 then
      return false
    end
    vim.cmd("lsp restart clangd")
    return true
  end

  -- al salir del header: descargarlo y reiniciar (eager) o marcarlo (lazy)
  local function release_header(header)
    if vim.api.nvim_buf_is_valid(header) then
      pcall(vim.cmd, ("bunload! %d"):format(header))
    end
    if mode == "lazy" then
      needs_restart = true
    else
      restart_clangd()
    end
  end

  local ok, picker = pcall(require, "snacks.picker")
  if ok and picker.lsp_references then
    local orig = picker.lsp_references
    picker.lsp_references = function(...)
      gr_time = vim.uv.hrtime()
      if mode == "lazy" and needs_restart then
        needs_restart = false
        local old_id = (vim.lsp.get_clients({ bufnr = 0, name = "clangd" })[1] or {}).id
        if restart_clangd() then
          vim.notify("clangd: reiniciando (fix de referencias a macros)…", vim.log.levels.INFO)
          vim.wait(5000, function()
            local c = vim.lsp.get_clients({ bufnr = 0, name = "clangd" })[1]
            return c and c.id ~= old_id
          end, 20)
        end
      end
      return orig(...)
    end
  end

  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(args)
      local buf = args.buf
      if buf == gr_header then
        return
      end
      if not gr_header and is_header(buf) and (vim.uv.hrtime() - gr_time) < 15e9 then
        gr_header = buf
        return
      end
      if gr_header then
        local header = gr_header
        gr_header = nil
        if not vim.api.nvim_buf_is_valid(header) then
          if mode == "lazy" then
            needs_restart = true
          else
            restart_clangd()
          end
        elseif not is_shown(header) then
          release_header(header)
        end
      end
    end,
  })
end
