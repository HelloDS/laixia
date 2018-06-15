--开赛了是否进入比赛

local GameListJoin = class("GameListJoin", import("...CBaseDialog"):new())-- 
local soundConfig =  laixia.soundcfg    
local Packet = import("....net.Packet") 
local scheduler = require "framework.scheduler"

function GameListJoin:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function GameListJoin:getName()
    return "GameListJoin"
end

function GameListJoin:onInit()
    self.super:onInit(self)

    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_MATCHJOIN_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_NOSHOW_MATCHJOIN_WINDOW, handler(self, self.notShowJoinLayer))

    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_HIDE_MATCHJOIN_WINDOW, handler(self, self.destroy))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_MAST_MATCHJOIN_WINDOW,handler(self,self.goMatch))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_MATCHDETAIL_WINDOW,handler(self,self.goMatcDetails))

end
function GameListJoin:notShowJoinLayer(msg)
    -- local str = msg.data.data
    -- if str == "ShopWindow" or str == "LaixiaIsInMatch" or str == "LaixiaisConnectCardTable" then
    --    local Details = Packet.new("CGDetails", _LAIXIA_PACKET_CS_MatchDetailsID)
    --    Details:setValue("GameID", laixia.config.GameAppID)
    --    Details:setValue("PageType", laixia.LocalPlayercfg.LaixiaGamePageType)
    --    local roomID = 0
    --     if laixia.LocalPlayercfg.LaixiaMatchLastRoom == nil then
    --        roomID = cc.UserDefault:getInstance():getDoubleForKey("matdchRoomID")
    --    else
    --         roomID = laixia.LocalPlayercfg.LaixiaMatchLastRoom
    --    end
    -- --    Details:setValue("RoomID", roomID)
    -- --    laixia.net.sendPacketAndWaiting(Details)
    -- -- end
    -- -- if eventType == ccui.TouchEventType.ended then
    --     local CSExitMatchGame = Packet.new("CSExitMatchGame", _LAIXIA_PACKET_CS_ExitMatchGameID)
    --     CSExitMatchGame:setValue("GameID", laixia.config.GameAppID)
    --     CSExitMatchGame:setValue("PageType", laixia.LocalPlayercfg.LaixiaGamePageType)
    --     CSExitMatchGame:setValue("RoomID", roomID)
    --     laixia.net.sendPacketAndWaiting(CSExitMatchGame)
--         if laixia.LocalPlayercfg.LaixiaCurrentWindow ~= "GameListWindow"  then -- 如果当前界面不是比赛列表则请求比赛列表
--             ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MATCHLIST_WINDOW)
--             ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_GAMELIST_GOGAMELIST)
--         end
--         if laixia.LocalPlayercfg.LaixiaCurrentWindow == "LobbyWindow" then
--             ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW)      -- 请求个人详情
--         end
    -- end

end
function GameListJoin:onShow(mesg)


    local  str = string.split(mesg.data.TEXT, "》")
    str = string.split(str[1], "《")
    self.tempMatchGameName= str[2]:gsub("金币",laixia.utilscfg.CoinType())
    print(laixia.LocalPlayercfg.LaixiaRoomID)
    self.time =20
    self.nowtime =0
    self:AddWidgetEventListenerFunction("SP_Button_Close", handler(self, self.onShutDown))--关闭按钮
    self:AddWidgetEventListenerFunction("SP_Button_Quit", handler(self, self.onShutDown))--退赛
    self:AddWidgetEventListenerFunction("SP_Button_OK", handler(self, self.onJoinMatch)) --报名比赛
    self:GetWidgetByName("SP_Label_MatchTitle"):setString(mesg.data.TEXT)
    self:GetWidgetByName("SP_Label_Time"):setString("(20)")

    -- local itemData = laixia.JsonTxtData:queryTable("items"):query("ItemID",mesg.data.RDS[1].ItemId);
    -- local rds =mesg.data.RDS[1]
    -- self:GetWidgetByName("SP_Image_PrizeNumberBG"):setVisible(false)
    --     if rds.ItemCT > 1 then
    --         self:GetWidgetByName("SP_Image_PrizeNumberBG"):setVisible(true)
    --         self:GetWidgetByName("SP_BitmapLabel_PrizeNumber"):setString(rds.ItemCT)
    --     end
    --  self:GetWidgetByName("SP_Image_PrizeIcon"):loadTexture(itemData.ImagePath, 1)
   

end



function GameListJoin:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MATCHJOIN_WINDOW)
        laixia.LocalPlayercfg.LaixiaJoinMatch = false

    end
end

function GameListJoin:onJoinMatch(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        laixia.LocalPlayercfg.LaixiaJoinMatch = true
        --只有在决定参赛了才会赋值
        laixia.LocalPlayercfg.LaixiaMatchName = self.tempMatchGameName
        if laixia.LocalPlayercfg.LaixiaCurrentWindow == "ShopWindow" then --在商店界面不弹出 去比赛的弹窗
            return
        elseif laixia.LocalPlayercfg.LaixiaCurrentWindow == "CardTableDialog" and laixia.LocalPlayercfg.LaixiaIsInMatch== true  then  --此时在比赛牌桌内
        
            local matchid = 0
            if laixia.LocalPlayercfg.LaixiaMatchID == 0 then
                matchid = cc.UserDefault:getInstance():getDoubleForKey("matdchId")
            else
                matchid = laixia.LocalPlayercfg.LaixiaMatchID
            end
            local goback = Packet.new("CSExitRoom", _LAIXIA_PACKET_CS_MatchQuitDeskID)
            goback:setValue("GameID", laixia.config.GameAppID)            
            goback:setValue("MatchID", matchid)
            laixia.net.sendPacketAndWaiting(goback)
            --return 

        elseif laixia.LocalPlayercfg.LaixiaCurrentWindow == "CardTableDialog" and laixia.LocalPlayercfg.LaixiaisConnectCardTable == true then  --此时在常规牌桌内
            local packet = Packet.new("CSExitRoom", _LAIXIA_PACKET_CS_ExitRoomID)
            packet:setValue("RoomID", ui.CardTableDialog.mRoomID)

            local tableid = -1
            if ui.CardTableDialog.mRoomID == 50 and ui.CardTableDialog.hDeskID ~= nil then
                tableid = ui.CardTableDialog.hDeskID
            end
   
            packet:setValue("TableID", tableid)            
            laixia.net.sendPacketAndWaiting(packet) 
            --return 
            --参加比赛点击参加时强制把比赛详情页面中的比赛进行退赛处理
        elseif  laixia.LocalPlayercfg.LaixiaCurrentWindow == "lhd_main_window" then 
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DRAGON_QUIT_TABLE)
        elseif   laixia.LocalPlayercfg.LaixiaCurrentWindow == "GameListWindow" and   laixia.LocalPlayercfg.LaixiaisMatchDetail == true  then 
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_WITHDRAW_MATCHJOIN_WINDOW)
           -- return  
        end
        self:goMatch()   

    end
end

function GameListJoin:goMatch()
    if self.mIsLoad == false then
        return
    end
    local joninMatch = Packet.new("CGjoinMatch", _LAIXIA_PACKET_CS_MatchJoinInID)
    joninMatch:setValue("GameID", laixia.config.GameAppID)
    joninMatch:setValue("PageType", laixia.LocalPlayercfg.LaixiaGamePageType)
    joninMatch:setValue("RoomID", laixia.LocalPlayercfg.LaixiaMatchLastRoom)
    laixia.net.sendPacketAndWaiting(joninMatch)
    self.roomid = laixia.LocalPlayercfg.LaixiaMatchLastRoom

end

function GameListJoin:goMatcDetails()
        local Details = Packet.new("CGDetails", _LAIXIA_PACKET_CS_MatchDetailsID)
        Details:setValue("GameID", laixia.config.GameAppID)
        Details:setValue("PageType", laixia.LocalPlayercfg.LaixiaGamePageType)
        local roomID = 0
        if laixia.LocalPlayercfg.LaixiaMatchRoom == nil then
            roomID = cc.UserDefault:getInstance():getDoubleForKey("matdchRoomID")
        else
            roomID = laixia.LocalPlayercfg.LaixiaMatchRoom
        end
        Details:setValue("RoomID", roomID)
        laixia.net.sendPacketAndWaiting(Details)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MATCHJOIN_WINDOW) --隐藏当前界面
end


function GameListJoin:onTick(dt)
    self.nowtime = self.nowtime + dt

    if self.nowtime < 1 then
        return
    end
    self.nowtime=0
    self.time= self.time -1
    if self.time <= 0 then
        self.time = 0
       
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MATCHJOIN_WINDOW)
    else
        local per ="(".. self.time..")"
        self:GetWidgetByName("SP_Label_Time"):setString(per )
    end
end


function GameListJoin:onDestroy()
     laixia.LocalPlayercfg.LaixiaJoinMatch = false
       
     self.time =0
end

function GameListJoin:onCallBackFunction()
end


return GameListJoin.new()

