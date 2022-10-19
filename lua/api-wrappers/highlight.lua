local api = vim.api
local format = string.format
local M = {}

---@class nvim.api.Highlight
---@field fg? integer
---@field bg? integer
---@field sp? integer The color of various underlines.
---@field blend? integer Between 0 and 100.  Override the blend level for a highlight group within the popupmenu or floating windows. 'pumblend' or 'winblend' must be set to take effect
---@field bold? boolean
---@field italic? boolean
---@field standout? boolean
---@field underline? boolean
---@field undercurl? boolean
---@field underdouble? boolean
---@field underdotted? boolean
---@field underdashed? boolean
---@field strikethrough? boolean
---@field reverse? boolean
---@field nocombine? boolean

---@param color integer 24-bit RGB Neovim internal value.
---@return string #Color in "#rrggbb" hexadecimal format.
function M.color_to_hex(color)
   vim.validate({
      val = { color, 'number' }
   })
   return format('#%06x', color)
end

---Returns the 24-bit RGB value of a `nvim_get_color_map()` color name or
---"#rrggbb" hexadecimal string.
---@param color string One of `nvim_get_color_map()` names or "#rrggbb" hexadecimal value.
---@return integer
function M.color_to_rgb(color)
   return api.nvim_get_color_by_name(color)
end

---@param name string
---@return nvim.api.Highlight
function M.get_highlight(name)
   ---@type boolean
   local rgb = api.nvim_get_option('termguicolors')
   local hl = api.nvim_get_hl_by_name(name, rgb)
   hl.fg = hl.foreground
   hl.bg = hl.background
   hl.sp = hl.special
   hl.foreground = nil
   hl.background = nil
   hl.special = nil
   return hl
end

---Set highlighting group in the global (0) namespace.
---@param name string
---@param hl nvim.api.Highlight
function M.set_highlight(name, hl)
   api.nvim_set_hl(0, name, hl)
end

---Set highlighting group in the particular namespace.
---@param ns_id integer
---@param name string
---@param hl nvim.api.Highlight
function M.set_namespace_highlight(ns_id, name, hl)
   api.nvim_set_hl(ns_id, name, hl)
end

-- Set active namespace for highlights.
---@param ns_id integer
function M.activate_namespace(ns_id)
   api.nvim_set_hl_ns(ns_id)
end

return M

