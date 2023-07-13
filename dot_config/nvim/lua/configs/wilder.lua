local status_ok, wilder = pcall(require, "wilder")
if not status_ok then
	return
end

wilder.setup { modes = { ":", "/", "?" } }
wilder.set_option("use_python_remote_plugin", 0)
wilder.set_option("pipeline", {
	wilder.branch(
		wilder.cmdline_pipeline {
			fuzzy = 1,
			set_pcre2_pattern = 1,
		},
		wilder.search_pipeline()
	),
})
wilder.set_option(
	"renderer",
	wilder.wildmenu_renderer {
		highlighter = wilder.basic_highlighter(),
	}
)
