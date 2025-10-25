local M = {}

local float_term = require("util.float").float_terminal

function M.find_cmake()
  if vim.g.cmake_path and vim.fn.filereadable(vim.g.cmake_path) == 1 then
    return vim.g.cmake_path
  end

  local path = vim.fn.exepath("cmake")
  if path ~= "" and vim.fn.filereadable(path) == 1 then
    vim.g.cmake_path = path
    return path
  end

  local fallback_paths = {
    "/opt/homebrew/bin/cmake",
    "/usr/local/bin/cmake",
    "/usr/bin/cmake",
  }
  for _, p in ipairs(fallback_paths) do
    if vim.fn.filereadable(p) == 1 then
      vim.g.cmake_path = p
      return p
    end
  end

  local handle = io.popen("which cmake 2>/dev/null")
  if handle then
    local result = handle:read("*a"):gsub("%s+", "")
    handle:close()
    if result ~= "" and vim.fn.filereadable(result) == 1 then
      vim.g.cmake_path = result
      return result
    end
  end

  vim.notify("cmake not found in PATH or common locations", vim.log.levels.ERROR)
  return "cmake" -- fallback, so termopen still runs even if broken
end

function M.configure_cmake(build_type)
  vim.fn.mkdir("build", "p")
  float_term(
    { M.find_cmake(), "-DCMAKE_BUILD_TYPE=" .. build_type, "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON", ".." },
    { cwd = "build" }
  )
end

vim.keymap.set("n", "<leader>cd", function() M.configure_cmake("Debug") end,          { desc = "CMake Debug" })
vim.keymap.set("n", "<leader>cr", function() M.configure_cmake("Release") end,        { desc = "CMake Release" })
vim.keymap.set("n", "<leader>cp", function() M.configure_cmake("RelWithDebInfo") end, { desc = "CMake RelWithDebInfo" })


vim.api.nvim_create_user_command("Build", function(opts)
  local t = opts.args
  if t == "" then print("Usage: :Build <target>"); return end
  float_term(
    { M.find_cmake(), "--build", "build", "--parallel", "20", "--target", t },
    { height_ratio = 0.8, width_ratio = 0.8, border = "single" }
  )
end, { nargs = 1 })

return M

