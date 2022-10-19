local class = require('middleclass')
local api = vim.api
local fn = vim.fn
local Buffer = require('api-wrappers.buffer')

---@class nvim.api.Window
---@field id integer
---@field wo table window options meta-accessor
local Window = class('nvim.api.Window')

---@param winid? integer If absent or 0 - the current window ID will be used.
function Window:initialize(winid)
   self.id = (not winid or winid == 0) and api.nvim_get_current_win() or winid

   self.wo = setmetatable({}, {
      __index = function(_, opt)
         return api.nvim_win_get_option(self.id, opt)
      end,
      __newindex = function(_, opt, value)
         api.nvim_win_set_option(self.id, opt, value)
      end
   })
end

---@param l nvim.api.Window
---@param r nvim.api.Window
function Window.__eq(l, r)
   return l.id == r.id
end

---@param force? boolean
function Window:close(force)
   api.nvim_win_close(self.id, force or false)
end

---@return nvim.api.Buffer
function Window:get_buffer()
   return Buffer(api.nvim_win_get_buf(self.id))
end

---@return boolean
function Window:is_valid()
   return api.nvim_win_is_valid(self.id)
end

---@return 'autocmd' | 'command' | 'loclist' | 'popup' | 'preview' | 'quickfix' | 'unknown'
function Window:get_type()
   return fn.win_gettype(self.id)
end

---Is window floating?
function Window:is_floating()
   return self:get_type() == 'popup'
end

---@param buffer nvim.api.Buffer
function Window:set_buffer(buffer)
   api.nvim_win_set_buf(self.id, buffer.id)
end

---@param name string
function Window:get_option(name)
   return api.nvim_win_get_option(self.id, name)
end

---@param name string
function Window:set_option(name, value)
   return api.nvim_win_set_option(self.id, name, value)
end

---The width of offset of the window, occupied by line number column,
---fold column and sign column.
---@return integer
function Window:get_text_offset()
  return fn.getwininfo(self.id)[1].textoff
end

---@return integer
function Window:get_width()
   return api.nvim_win_get_width(self.id)
end

---@return integer
function Window:get_height()
   return api.nvim_win_get_height(self.id)
end

---@param width integer
function Window:set_width(width)
   api.nvim_win_set_width(self.id, width)
end

---@param height integer
function Window:set_height(height)
   api.nvim_win_set_height(self.id, height)
end

---@return { [1]: integer, [2]: integer } pos
function Window:get_cursor()
   return api.nvim_win_get_cursor(self.id)
end

---@param pos { [1]: integer, [2]: integer }
function Window:set_cursor(pos)
   api.nvim_win_set_cursor(self.id, pos)
end

---Set float window config table
---@param config table
function Window:set_config(config)
   api.nvim_win_set_config(self.id, config)
end

return Window
