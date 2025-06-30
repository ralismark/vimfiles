local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event

local function quickkey(index)
	local keys = "asdfweruio"
	if index > #keys then
		return nil
	end
	return keys:sub(index, index)
end

local function get_prompt_text(prompt, default_prompt)
	local prompt_text = prompt or default_prompt
	if prompt_text:sub(-1) == ":" then
		prompt_text = "[" .. prompt_text:sub(1, -2) .. "]"
	end
	return prompt_text
end

local UISelect = Menu:extend("UISelect")

function UISelect:init(items, opts, on_done)
	local border_top_text = get_prompt_text(opts.prompt, "[Select Item]")
	local kind = opts.kind or "unknown"

	local popup_options = {
		relative = "cursor",
		position = {
			row = 1,
			col = -3,
		},

		win_options = {
			cursorline = true,
			winhighlight = "NormalFloat:Pmenu,CursorLine:PmenuSel",
		},
		zindex = 999,
	}

	local max_width = popup_options.relative == "editor" and vim.o.columns - 4 or vim.api.nvim_win_get_width(0) - 4
	local max_height = popup_options.relative == "editor" and math.floor(vim.o.lines * 80 / 100)
		or vim.api.nvim_win_get_height(0)

	local format_item = opts.format_item or tostring

	local menu_items = {}
	for index, item in ipairs(items) do
		local data = {
			quick = quickkey(index),
			label = string.sub(format_item(item), 0, max_width),
			item = item,
			index = index,
		}
		menu_items[index] = Menu.item(
			(data.quick or " ") .. "  " .. data.label,
			data
		)
	end

	local menu_options = {
		min_width = vim.api.nvim_strwidth(border_top_text),
		max_width = max_width,
		max_height = max_height,
		lines = menu_items,
		on_close = function()
			on_done(nil, nil)
		end,
		on_submit = function(item)
			on_done(item.item, item.index)
		end,
	}

	UISelect.super.init(self, popup_options, menu_options)

	-- cancel operation if cursor leaves select
	self:on(event.BufLeave, function()
		on_done(nil, nil)
	end, { once = true })

	for index, item in ipairs(items) do
		local qk = quickkey(index)
		if qk then
			self:map("n", qk, function()
				on_done(item, index)
			end)
		end
	end
end

local select_ui = nil

vim.ui.select = function(items, opts, on_choice)
	assert(type(on_choice) == "function", "missing on_choice function")

	if select_ui then
		-- ensure single ui.select operation
		error("another instance of vim.ui.select is pending")
	end

	select_ui = UISelect(items, opts, function(item, index)
		if select_ui then
			-- if it's still mounted, unmount it
			select_ui:unmount()
		end
		-- pass the select value
		on_choice(item, index)
		-- indicate the operation is done
		select_ui = nil
	end)

	select_ui:mount()
end
