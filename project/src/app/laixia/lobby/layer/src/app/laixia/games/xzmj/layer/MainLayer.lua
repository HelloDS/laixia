--[[
斗地主游戏大厅
]]

--fix me 需要用CSBBase可以单独调用，因为CSBBase是一个类 不是一个节点
--local CSBBase = require("app.laixia.lobby.ui.CSBBase")

local Packet =  require("games.ddz.net.Packet")  
local DDZLobbyWindow = class("DDZLobbyWindow", function()
    return display.newLayer()
end) 
local CSBHelper = require("app.laixia.common.CSBHelper")
DDZLobbyWindow.CSB_NAME = "games/ddz/MainLayer.csb"
DDZLobbyWindow.CSB_CHILD = 
    {
        panel_root                                                  = {varname = "panel_root"},
        ["panel_root.panel_left.panel_left_top.panel_exit"]         = {varname = "panel_exit", events = {{["event"] = "touch", ["method"] = "onTabButtonClicked"}}},
        ["panel_root.panel_center.panel_center_middle.btn_game"]    = {varname = "btn_game", events = {{["event"] = "touch", ["method"] = "onTabButtonClicked"}}},
        ["panel_root.panel_center.panel_center_middle.btn_match"]   = {varname = "btn_match", events = {{["event"] = "touch", ["method"] = "onTabButtonClicked"}}},
    }
---------------------------------------------------------------------------------------
function DDZLobbyWindow:ctor(...)
    CSBHelper.load(self)
end
function DDZLobbyWindow:init()

end
function DDZLobbyWindow:onTabButtonClicked(sender , event)
    if sender == nil or not sender:isVisible() then
        return
    end
    local senderName = sender:getName()
    if event ~= ccui.TouchEventType.ended then 
        return 
    end
    -- 游戏场
    if senderName == "btn_game" then
        self.mRoomType = 2 --经典场
        laixia.LocalPlayercfg.OnReturnFunction = _LAIXIA_EVENT_UPDATE_SELECTROOM_WINDOW       
        local stream = Packet.new("EnterListRoom", _LAIXIA_PACKET_CS_ListRoomID)
        stream:setValue("RoomType", self.mRoomType)
        laixia.net.sendPacketAndWaiting(stream)
        -- 比赛场
    elseif senderName == "btn_match" then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MATCHLIST_WINDOW)
        laixia.LocalPlayercfg.OnReturnFunction = _LAIXIA_EVENT_SHOW_MATCHLIST_WINDOW

        local CSMatchListPacket = Packet.new("CSMatchGame", _LAIXIA_PACKET_CS_MatchGameID)
        CSMatchListPacket:setValue("GameID", laixia.config.GameAppID)
        CSMatchListPacket:setValue("PageType", 1 )
        laixia.net.sendPacketAndWaiting(CSMatchListPacket)
    elseif senderName == "btn_friendroom" then
    
    elseif senderName == "panel_exit" then
--        app.m_gameManager:exitGame()
        self:removeSelf()
    end
end


return DDZLobbyWindow


