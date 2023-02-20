local source = {}

---Return whether this source is available in the current context or not (optional).
---@return boolean
function source:is_available()
  return true
end

---Return the debug name of this source (optional).
---@return string
function source:get_debug_name()
  return 'hr'
end

---Return the keyword pattern for triggering completion (optional).
---If this is ommited, nvim-cmp will use a default keyword pattern. See |cmp-config.completion.keyword_pattern|.
---@return string
function source:get_keyword_pattern()
  return [[\([-=_]\)\1\{4,}]]
end

---Invoke completion (required).
---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(params, callback)
  local startcol = params.context:get_offset(self.get_keyword_pattern())
  if startcol == params.context.cursor.col then
    return
  end

  local len = 80 - startcol
  callback({
      { label = ("-"):rep(len) },
      { label = ("="):rep(len) },
      { label = ("_"):rep(len) },
  })
end

---Register your source to nvim-cmp.
return source
