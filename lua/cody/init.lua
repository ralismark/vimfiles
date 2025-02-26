local M = {}

M.api = require "cody.api"
M.autocomplete = require "cody.autocomplete"
M.config = require "cody.config"
M.models = require "cody.models"

function M.modelconfig()
	return M.api.request("GET", "/.api/modelconfig/supported-models.json"):wait()
end

return M
