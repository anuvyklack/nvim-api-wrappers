# nvim-api-wrappers

The library with OOP wrappers around Neovim api.
This library itself depend on [middlecalss](https://github.com/anuvyklack/middleclass)
library. You are welcome to open pull-requests to extend the library if
something you need is missing.

> I know arguments about dependency hell, and know that many people are afraid
> of plugins with dependencies. But with moving to Lua, the pool of
> opportunities is increased, and it is harder for plugins to be self-contained
> avoiding libraries. As a consequence, libraries, such
> [plenary](https://github.com/nvim-lua/plenary.nvim),
> [nui](https://github.com/MunifTanjim/nui.nvim)
> and others are become to appear.

Both `Window` and `Buffer` classes have meta-accessors to interact with options
of the particular window or buffer, respectively.

Here is the example for `Buffer` class:

```lua
local Buffer = require('api-wrappers').Buffer
-- or
local Buffer = require('api-wrappers.buffer')

local bufnr = vim.api.nvim_get_current_buf()
local buffer = Buffer(bufnr) ---@type nvim.api.Buffer

-- Access buffer option through meta-accessor.
m = buffer.bo.modifiable
-- the same using method
m = buffer:get_option('modifiable')

-- Set buffer option through meta-accessor
buffer.bo.modifiable = false
-- the same with method
buffer:set_option('modifiable', false)
```
