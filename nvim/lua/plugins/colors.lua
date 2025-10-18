function theme(repo, opts)
  opts = opts or {}

  local theme = {
    repo,
    lazy = false,
  }

  return theme
end

return {
	theme("nyoom-engineering/oxocarbon.nvim"),
	theme("tiagovla/tokyodark.nvim"),
	theme("kdheepak/monochrome.nvim"),
}
