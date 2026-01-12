local M = {}

--- Append a file extension (default: "cmd") to the given base name, when
--- running on Windows. Otherwise this returns the given base name.
--- @param baseName string the base name to extend
--- @param ext? string the extension to append, when on Windows
--- @return string
M.append_win_ext = function(baseName, ext)
  if vim.fn.has "win32" == 0 then
    return baseName
  end

  return baseName .. "." .. (ext or "cmd")
end

--- Try and get the appropriate browser command for the environment neovim is
--- running in.
--- @return string?
M.get_browser_command = function()
  if vim.fn.executable "xdg-open" == 1 then
    return "xdg-open"
  end

  if vim.fn.executable "wslview" == 1 then
    return "wslview"
  elseif vim.fn.has "wsl" == 1 then
    vim.notify(
      'Could not find "wslview", despite running in WSL.'
        .. ' Did you forget to install "wslu"?',
      vim.log.levels.WARN
    )
  end

  return nil
end

--- Try to determine the system background (or dark mode). If it can't be
--- determined, fall back to "dark".
--- @return "light" | "dark"
M.get_system_background = function()
  if vim.fn.has "win32" == 1 or vim.fn.has "wsl" == 1 then
    local result = vim
      .system({
        "reg.exe",
        "query",
        "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
        "/v",
        "AppsUseLightTheme",
      }, { text = true })
      :wait()

    if result.code ~= 0 then
      vim.notify('Calling "reg.exe" failed.', vim.log.levels.ERROR)
      return "dark"
    end

    return result.stdout:match "0x1" and "light" or "dark"
  end

  if vim.fn.executable "darkman" == 1 then
    local result = vim.system({ "darkman", "get" }, { text = true }):wait()

    if result.code > 0 then
      return "dark"
    end

    return (result.stdout:gsub("%s+", "") == "dark") and "dark" or "light"
  end

  return "dark"
end

--- Set the options common for a dos formatted file for the current buffer.
M.set_dos_file_options = function()
  vim.opt_local.endofline = false
  vim.opt_local.fixendofline = false
  if vim.opt_local.modifiable:get() then
    vim.opt_local.fileformat = "dos"
  end
end

--- Set up the shell, depending on the platform.
--- @param use_default? boolean force using the default settings
M.set_up_shell = function(use_default)
  if use_default then
    local function reset(option_name)
      vim.opt_global[option_name] =
        vim.api.nvim_get_option_info2(option_name, { scope = "global" }).default
    end

    reset "shell"
    reset "shellcmdflag"
    reset "shellredir"
    reset "shellpipe"
    reset "shellquote"
    reset "shellxquote"

    return
  end

  if vim.fn.has "win32" ~= 1 then
    return
  end

  local has_pwsh = vim.fn.executable "pwsh"
  local has_powershell = vim.fn.executable "powershell"
  if has_pwsh or has_powershell then
    vim.o.shell = has_pwsh and "pwsh" or "powershell"
    vim.o.shellcmdflag = "-NoLogo"
      .. " -NonInteractive"
      .. " -ExecutionPolicy RemoteSigned"
      .. " -Command [Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()"
      .. "; $PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'"
      .. "; $PSStyle.OutputRendering = 'plaintext'"
      .. "; Remove-Alias -Force -ErrorAction SilentlyContinue tee"
      .. ";"
    vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
    vim.o.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
  end
end

return M
