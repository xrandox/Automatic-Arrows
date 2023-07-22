AA = {}
AAVersion = "v1.0.0"

Debug:Print("Currently loading Automatic Arrows version " .. AAVersion)

Pack:Require("Data/Automatic-Arrows/categoryloader.lua")
Pack:Require("Data/Automatic-Arrows/utils.lua")
Pack:Require("Data/Automatic-Arrows/automaticarrow.lua")
Pack:Require("Data/Automatic-Arrows/tutorial.lua")
Pack:Require("Data/Automatic-Arrows/aamenu.lua")

Event:OnTick(AA_TickHandler)