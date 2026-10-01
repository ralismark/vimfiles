local snacks = require "snacks"

vim.ui.select = require "vimrc.select"

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
	local kind = opts.kind

	if false then
		-- TODO make this the default some day
		opts.snacks = {
		}
		if opts.preview_item then
			opts.snacks.layout = { preset = "telescope" }
			opts.snacks.preview = function(ctx)
				local result = opts.preview_item(ctx.item.item)
				if not result or not result.buf then
					return
				end
				ctx.preview:set_buf(result.buf)
				ctx.preview:highlight({ buf = result.buf })
				if result.pos then
					ctx.item.pos = result.pos
				end
				if result.pos_end then
					ctx.item.end_pos = result.pos_end
				end
				ctx.preview:loc()
			end
		end
		return snacks.picker.select(items, opts, on_choice)
	else
		return require "vimrc.select" (items, opts, on_choice)
	end
end
