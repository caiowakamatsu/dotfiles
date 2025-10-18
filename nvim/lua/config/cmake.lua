local M = {}

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

return M

