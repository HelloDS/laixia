--[[
********************************************************
    @date:       2018-3-15
    @author:     zl
    @version:    1.0
    @describe:   图标列表管理
********************************************************
]]
local IconListUtils = {}

IconListUtils.ITEM_TAG = { ICON = 1, NAME = 2}
IconListUtils.FOLDER_TAG = 10
IconListUtils.LoginLayer_TAG = 1000
IconListUtils.m_itemSize = {width = 209, height = 188}
IconListUtils.m_iconSize = {width = 209, height = 188}

function IconListUtils.createIcon(info)
    if not info or not info.icon then 
        return
    end

    if type(info) == "table" then
        local suffix = string.sub(info.icon, -3, string.len(info.icon))
        if suffix == "png" then
            return IconListUtils.createGameIcon(info)
        elseif suffix == "csb" then
            return IconListUtils.createCSBIcon(info)
        end
    end

    return IconListUtils.createDefaultIcon()
end

function IconListUtils.createGameIcon(gameInfo)
    local ok = cc.FileUtils:getInstance():isFileExist(gameInfo.icon)
    if ok then 
        local icon = cc.ui.UIImage.new(gameInfo.icon)
        icon:align(display.CENTER, IconListUtils.m_itemSize.width / 2, IconListUtils.m_itemSize.height / 2)
        return icon
    end
    return IconListUtils.createDefaultIcon()
end

function IconListUtils.createCSBIcon(gameInfo)
    local ok = cc.FileUtils:getInstance():isFileExist(gameInfo.icon)
    if ok then 
        local node = cc.CSLoader:createNode(gameInfo.icon)
        local action = cc.CSLoader:createTimeline(gameInfo.icon)
        node:runAction(action)
        action:gotoFrameAndPlay(0, 80, true)
        node:setPosition(cc.p(100,80))
        return node
    end
    return IconListUtils.createDefaultIcon()
end

function IconListUtils.createDefaultIcon()
    local icon = cc.ui.UIImage.new("images/ic_morenhead4.png")
    icon:align(display.CENTER, IconListUtils.m_itemSize.width / 2, IconListUtils.m_itemSize.height / 2)
    return icon
end

function IconListUtils.clickGameIcon(clickItem)
    print("点击了" .. clickItem.m_gameInfo.displayName .. "图标")
    if clickItem and clickItem.m_gameInfo then
        local gameId = clickItem.m_gameInfo.gameId
        if gameId == "1" then
            _G.setPlatformAdap(true)
            _G.setCommonDisplay(true)
            local DDZLobbyScene = require("games.ddz.layer.DDZLobbyScene").new()
            display.replaceScene(DDZLobbyScene)
        else
            local scene = cc.Director:getInstance():getRunningScene()
            scene:popUpTips("敬请期待")
        end
    end
end

function IconListUtils.runGame(gameInfo, startEvent)
    if gameInfo == nil then
        return
    end

    local filePath = "games." .. gameInfo.folderName .. ".src.GameEntity"
    package.preload[filePath] = nil
    package.loaded[filePath] = nil
    local g = require(filePath).new(gameInfo, app.m_gameManager, startEvent)
    app.m_gameManager:runGame(g)
end

return IconListUtils