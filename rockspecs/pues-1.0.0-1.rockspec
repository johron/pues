package = "pues"
version = "1.0.0-1"
source = {
   url = "git+https://github.com/johron/pues",
   tag = "1.0.0"
}
description = {
   summary = "Project initializer and runner",
   homepage = "https://github.com/johron/pues",
   license = "GPL-3.0"
}
dependencies = {
   "lua>=5.4",
   "luafilesystem>=1.8.0-1",
   "lunajson>=1.2.3-1",
   "luazip>=1.2.5-1"
}
build = {
   type = "builtin",
   modules = {},
   install = {
      bin = {
         ["pues"] = "src/main.lua"
      }
   },
   copy_directories = {
      "archives"
   }
}