local class = require('middleclass')
local api = vim.api
local fn = vim.fn

---@class nvim.api.Buffer
---@field id integer
---@field bo table buffer options meta-accessor
local Buffer = class('nvim.api.Buffer')

---@param bufnr? integer If not passed the current buffer number will be used.
function Buffer:initialize(bufnr)
   self.id = bufnr or api.nvim_get_current_buf()

   self.bo = setmetatable({}, {
      __index = function(_, opt)
         return api.nvim_buf_get_option(self.id, opt)
      end,
      __newindex = function(_, opt, value)
         api.nvim_buf_set_option(self.id, opt, value)
      end
   })
end

---@param l win.Buffer
---@param r win.Buffer
function Buffer.__eq(l, r)
   return l.id == r.id
end

function Buffer:get_name()
   return api.nvim_buf_get_name(self.id)
end

---@param opts? table
function Buffer:delete(opts)
   opts = opts or {}
   api.nvim_buf_delete(self.id, opts)
end

---@return boolean
function Buffer:is_loaded()
   return api.nvim_buf_is_loaded(self.id)
end

---@param name string
function Buffer:get_option(name)
   return api.nvim_buf_get_option(self.id, name)
end

---@param name string
function Buffer:set_option(name, value)
   return api.nvim_buf_set_option(self.id, name, value)
end

---Returns the number of lines in the given buffer.
---@return integer
function Buffer:line_count()
   return api.nvim_buf_line_count(self.id)
end

---@param start integer First line index
---@param end_ integer Last line index, exclusive.
---@param lines string[] Array of lines to set.
---@param strict_indexing? boolean Whether out-of-bounds should be an error.
function Buffer:set_lines(start, end_, lines, strict_indexing)
   api.nvim_buf_set_lines(self.id, start, end_, strict_indexing or false, lines)
end

---@param ns_id integer Namespace to use or -1 for ungrouped highlight.
---@param hl_group string Name of the highlight group to use.
---@param line integer Line to highlight (zero-indexed).
---@param col_start integer Start of (byte-indexed) column range to highlight.
---@param col_end integer End of (byte-indexed) column range to highlight, or -1 to highlight to end of line.
function Buffer:add_highlight(ns_id, hl_group, line, col_start, col_end)
   api.nvim_buf_add_highlight(self.id, ns_id, hl_group, line, col_start, col_end)
end

return Buffer
