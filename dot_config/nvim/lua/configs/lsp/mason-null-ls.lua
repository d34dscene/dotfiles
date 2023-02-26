local status_ok, mason_null_ls = pcall(require, "mason-null-ls")
if not status_ok then
	return
end

mason_null_ls.setup {
	ensure_installed = nil,
	automatic_installation = true,
	automatic_setup = false,
}
