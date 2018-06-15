--[[
********************************************************
    @date:      2018-3-1
    @author:    zl
    @version:   1.0
    @explain:   游戏管理器
********************************************************
]]

local GameManager = class("GameManager")

function GameManager:ctor()
    self.m_games = {}
end

--[[
    大厅进入游戏接口
]]
function GameManager:runGame(game)
    if game == nil then
        return
    end
    table.insert(self.m_games, 1, game)

    game.m_rootLayer = display.newLayer()
    app.m_mainScene:addChild(game.m_rootLayer, 9999)

    game:onEnter(game.m_rootLayer)
    --fix me 设置大厅休眠
end

--[[
    当游戏结束时由游戏调用
]]
function GameManager:exitGame()
    if #self.m_games < 2 then
        return
    end

    local game = self.m_games[1]
    if game ~= nil then
        game:onExit()
        if game.m_rootLayer ~= nil then 
            game.m_rootLayer:removeFromParent()
        end
        --fix me 激活大厅
        cc.Director:getInstance():getTextureCache():removeAllTextures()
    end

    table.remove(self.m_games, 1)    
end

--[[
    游戏是否存在
    @param string gameFolderName    游戏目录名 
    @ret   bool   true 存在, false 不存在
]]
function GameManager:gameExist(gameFolderName)
    local path = "games/" .. gameFolderName .. "/"
    local bExist = cc.FileUtils:getInstance():isFileExist(path .. "GameEntity.lua")
    return bExist
end

--[[
    大厅加入到gamemanager
]]
function GameManager:setLobby(lobbyEntity)
    if #self.m_games > 0 then
        return false
    end

    self.m_games[1] = lobbyEntity
end

return GameManager