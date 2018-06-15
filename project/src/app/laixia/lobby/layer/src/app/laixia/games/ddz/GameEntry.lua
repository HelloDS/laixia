--[[
    斗地主的GameEntity
]]

require("games.ddz.init")
local GameEntity = class("GameEntity", import("common.GameBase"))

function GameEntity:ctor(...)
    GameEntity.super.ctor(self)
end

function GameEntity:onEnter(rootLayer)
    local mainLayer = require("games.ddz.MainLayer").new()
    rootLayer:addChild(mainLayer)
end

function GameEntity:onExit()

end

return GameEntity