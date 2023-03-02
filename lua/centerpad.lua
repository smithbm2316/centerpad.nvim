local v = vim.api

local center_buf = {}

-- function to toggle zen mode on
local turn_on = function(config)
  -- Get reference to current_buffer
  local main_win = v.nvim_get_current_win()

  -- create scratch window to the left
  vim.cmd(string.format('%svnew', config.leftpad))
  vim.cmd('wincmd H')
  
  local leftpad = v.nvim_get_current_buf()
  v.nvim_buf_set_name(leftpad, 'leftpad')

  -- Switch to leftpad and fix its width
  local leftpad_win = v.nvim_get_current_win()
  v.nvim_set_current_win(leftpad_win)
  v.nvim_win_set_width(leftpad_win, config.leftpad)
  v.nvim_win_set_option(leftpad_win, "winfixwidth", true)

  v.nvim_set_current_win(main_win)

  -- create scratch window to the right
  vim.cmd(string.format('%svnew', config.rightpad))
  vim.cmd('wincmd L')
  local rightpad = v.nvim_get_current_buf()
  v.nvim_buf_set_name(rightpad, 'rightpad')

  print(vim.inspect(config.rightpad))
  -- Switch to rightpad and fix its width
  local rightpad_win = v.nvim_get_current_win()
  v.nvim_set_current_win(rightpad_win)
  v.nvim_win_set_width(rightpad_win, config.rightpad)
  v.nvim_win_set_option(rightpad_win, "winfixwidth", true)

  v.nvim_set_current_win(main_win)

  -- keep track of the current state of the plugin
  vim.g.center_buf_enabled = true
end

-- function to toggle zen mode off
local turn_off = function(config)
  -- Get reference to current_buffer
  local curr_buf = v.nvim_get_current_buf()
  local curr_bufname = v.nvim_buf_get_name(curr_buf)

  -- Make sure the currently focused buffer is not a scratch buffer
  if curr_bufname == 'leftpad' or curr_bufname == 'rightpad' then
    print('If you want to toggle off zen mode, switch focus out of a scratch buffer')
    return
  end

  -- Delete the scratch buffers
  local windows = v.nvim_tabpage_list_wins(0)
  for _, win in ipairs(windows) do
    local bufnr = v.nvim_win_get_buf(win)
    local cur_name = v.nvim_buf_get_name(bufnr)
    if cur_name:match('leftpad') or cur_name:match('rightpad') then
      v.nvim_buf_delete(bufnr, { force = true })
    end
  end

  -- keep track of the current state of the plugin
  vim.g.center_buf_enabled = false
end

-- function for user to run, toggling on/off
center_buf.toggle = function(config)
  -- set default options
  config = config or { leftpad = 36, rightpad = 36 }

  -- if state is true, then toggle center_buf off
  if vim.g.center_buf_enabled == true then
    turn_off(config)
  else
    turn_on(config)
  end
end

center_buf.run_command = function(...)
  local args = {...}
  if #args == 1 then
    center_buf.toggle { leftpad = args[1], rightpad = args[1] }
  elseif #args == 2 then
    center_buf.toggle { leftpad = args[1], rightpad = args[2] }
  else
    center_buf.toggle()
  end
end

return center_buf
