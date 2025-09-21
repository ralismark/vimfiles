-- Luasnip abbreviations
local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l
local rep = require("luasnip.extras").rep

-------------------------------------------------------------------------------

local function dirname()
	return f(function() return vim.fn.expand("%:p:h:t") end)
end

local skels = {

	-- special ones for my blog
	--[[
	s("**/ralismark.github.io/**/links/*.md", {
		t({ "---",
			"layout: link",
			"title: ", }), i(1), t({ "",
			"url: ", }), i(2), t({ "",
			"date: " }), f(function() return vim.fn.strftime("%Y-%m-%d") end), t({ "",
			"tags:",
			"---",
			"",
			"" })
	}),
	s("**/ralismark.github.io/**/*.md", {
		t({ "---",
			"layout: post",
			"title: ", }), i(1), t({ "",
			"excerpt:",
			"date: " }), f(function() return vim.fn.strftime("%Y-%m-%d") end), t({ "",
			"tags:",
			"---",
			"",
			"" })
	}),
	]]

	-- templates
	s("setup.py", {
		t({ "#!/usr/bin/env python3",
			"",
			"from setuptools import setup",
			"",
			"setup(",
			"    name=\"" }), dirname(), t({ "\",",
			"    version=\"0.1.0\",",
			"    install_requires=[",
			"    ],",
			"    entry_points={",
			"        \"console_scripts\": [",
			"            # \"cmd = " }), dirname(), t({ ".main:cli",
			"        ]",
			"    },",
			")", }),
	}),
	s(".editorconfig", t({
		"root = true",
		"",
		"[*.{js,ts}]",
		"indent_style = space",
		"indent_size = 4",
	})),
	s("*.dot", {
		t({ "digraph {",
			"\tgraph [layout=" }), i(1, "neato"), t({ "];",
			"\t" }), i(0), t({ "",
			"}" })
	}),
	s("*.tex", {
		t({ "\\documentclass{article}",
			"",
			"\\usepackage[utf8]{inputenc}",
			"\\usepackage[a4paper,margin=2cm]{geometry}",
			"",
			"\\begin{document}",
			"",
			"" }), i(0), t({ "",
			"",
			"\\end{document}" })
	}),
	s("CMakeLists.txt", {
		t({ "cmake_minimum_required(VERSION 3.5)",
			"",
			"project(" }), dirname(), t({ "",
			"",
			"#######################",
			"# Project Setup",
			"#######################",
			"",
			"# C++17 support",
			"set(CMAKE_CXX_STANDARD 17)",
			"set(CMAKE_CXX_STANDARD_REQUIRED ON)",
			"",
			"# Output special files to named directories",
			"set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)",
			"set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)",
			"set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)",
			"",
			"#######################",
			"# Project Sources",
			"#######################",
			"",
			"" })
	}),
	s("*.html", {
		t({ "<!doctype html>",
			"<html>",
			"<head>",
			"\t<meta charset=\"utf-8\" />",
			"</head>",
			"<body>",
			"" }), i(0), t({ "",
			"</body>",
			"</html>" })
	}),
	s("*.svg", {
		t({ "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
			"<svg",
			"\txmlns:xlink=\"http://www.w3.org/1999/xlink\"",
			"\txmlns=\"http://www.w3.org/2000/svg\"",
			">",
			"" }), i(0), t({ "",
			"</svg>" })
	}),
	s("*.cpp", {
		t({ "#include <bits/stdc++.h>",
			"using namespace std;",
			"",
			"#ifdef L",
			"#define debug(...) fprintf(stderr, __VA_ARGS__)",
			"#else",
			"#define debug(...)",
			"#endif",
			"",
			"",
			"",
			"signed main()",
			"{",
			"#ifndef L",
			"\tfreopen(\"___in.txt\", \"r\", stdin);",
			"\tfreopen(\"___out.txt\", \"w\", stdout);",
			"#endif",
			"",
			"" }), i(0), t({ "",
			"}" })
	}),
	s("flake.nix", {
		t({ "{",
			"  description = \"A very basic flake\";",
			"",
			"  inputs = {",
			"    nixpkgs.url = \"github:nixos/nixpkgs/nixpkgs-unstable\"; # or \"nixpkgs/nixos-22.05\"",
			"    flake-utils.url = \"github:numtide/flake-utils\";",
			"  };",
			"",
			"  outputs = { self, nixpkgs, flake-utils }:",
			"    flake-utils.lib.eachDefaultSystem (system:",
			"      let",
			"        pkgs = import nixpkgs { inherit system; };",
			"      in",
			"      rec {",
			"        # apps.default = {",
			"        #   type = \"app\";",
			"        #   program = \"...\";",
			"        # };",
			"",
			"        # packages.default = ...",
			"",
			"        # devShells.default = pkgs.mkShell {",
			"        #   buildInputs = with pkgs; [ ... ];",
			"        # };",
			"      });",
			"}" })
	}),
	s("*.pre-commit-config.yaml", {
		-- TODO fetch latest revisions from github
		t({ "# See https://pre-commit.com for more information",
			"# See https://pre-commit.com/hooks.html for more hooks",
			"repos:",
			"  - repo: https://github.com/pre-commit/pre-commit-hooks",
			"    rev: v3.2.0",
			"    hooks:",
			"      - id: trailing-whitespace",
			"      - id: end-of-file-fixer",
			"      - id: check-yaml",
			"      - id: check-added-large-files",
			"  - repo: https://github.com/psf/black",
			"    rev: stable",
			"    hooks:",
			"      - id: black" })
	}),

	-- preambles
	--[[s("*.md", {
		t({ "---",
			"geometry: a4paper",
			"header-includes: |",
			"  \\newcommand\\R{\\mathbb{R}}",
			"---",
			"",
			"" })
	}),]]
	s("*.go", {
		t("package "), f(function() return vim.fn.expand("%:p:h:t"):gsub("%W", "_") end), t({ "",
			"",
			"",
		}),
	}),
	s("*.hpp", t({ "#pragma once", "" })),
	s("*.h", t({ "#pragma once", "" })),
	s("*.xml", t({ "<?xml version=\"1.0\" encoding=\"utf-8\"?>", "" })),

	-- shebangs
	s("*.py", t({ "#!/usr/bin/env python3", "" })),
	s("*.sh", t({ "#!/bin/sh", "set -eu", "" })),
	s("*.sed", t({ "#!/usr/bin/env -S sed -Ef", "" })),
	s("CACHEDIR.TAG", t({ "Signature: 8a477f597d28d172789f06886806bc55", "" })),
}

-------------------------------------------------------------------------------

return {
	defs = skels,
	expand = function()
		local fname = vim.fn.expand("<afile>:t")
		local path = vim.fn.expand("<afile>:p")

		for _, snip in ipairs(skels) do
			local pat = snip.trigger
			if vim.fn.match(pat:find("/") and path or fname, vim.fn.glob2regpat(pat)) >= 0 then
				ls.snip_expand(snip, {})
				return
			end
		end
	end,
}
