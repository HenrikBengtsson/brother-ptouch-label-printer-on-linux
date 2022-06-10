help([[
ptouch-print: Print Labels on Brother P-touch Printers on Linux 
]])

local name = myModuleName()
local version = myModuleVersion()
whatis("Version: " .. version)
whatis("Keywords: tools, printing")
whatis("URL: https://github.com/HenrikBengtsson/brother-ptouch-label-printer-on-linux (docs), https://git.familie-radermacher.ch/linux/ptouch-print.git (source code)")
whatis("Description: Print labels on Brother P-touch printers on Linux. Examples: `print-touch --help` and `man print-touch`.")

local root = os.getenv("SOFTWARE_ROOT_MANUAL")
local home = pathJoin(root, name .. "-" .. version)

prepend_path("PATH", pathJoin(home, "bin"))
prepend_path("MANPATH", pathJoin(home, "share", "man"))
