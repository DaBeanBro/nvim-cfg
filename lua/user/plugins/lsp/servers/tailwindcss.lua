return function(on_attach)
	return {
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
		end,
		settings = {
			tailwindCSS = {
				classAttributes = { "class", "className", "ngClass" },
				experimental = {
					classRegex = {
						"tw`([^`]*)", -- tw`...`
						"tw='([^']*)", -- <div tw="..." />
						"tw={`([^`}]*)", -- <div tw={"..."} />
						"tw\\.\\w+`([^`]*)", -- tw.xxx`...`
						"tw\\(.*?\\)`([^`]*)", -- tw(component)`...`
						"styled\\(.*?, '([^']*)'\\)",
						{ "cn\\(([^)]*)\\)", "(?:'|\"|`)([^\"'`]*)(?:'|\"|`)" },
						{ "clsx\\(([^]*)\\)", "(?:'|\"|`)([^\"'`]*)(?:'|\"|`)" },
						{ "(?:twMerge|twJoin)\\(([^\\);]*)[\\);]", "[`'\"`]([^'\"`,;]*)[`'\"`]" },
						{ "{([\\s\\S]*)}", ":\\s*['\"`]([^'\"`]*)['\"`]" },
					},
				},
			},
		},
	}
end
