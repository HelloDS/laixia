--开赛了是否进入比赛

local GameListJoin = class("GameListJoin", import("...CBaseDialog"):new())-- 
local soundConfig =  laixiaddz.soundcfg    
local Packet = import("....net.Packet") 
local scheduler = require "framework.scheduler"

function GameListJoin:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function GameListJoin:getName()
    return "GameListJoin" -- csb = Start_Prompt.csb
end

function GameListJoin:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_MATCHJOIN_WINDOW, handler(self, self.show))
    -- ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_NOSHOW_MATCHJOIN_WINDOW, handler(self, self.notShowJoinLayer))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_MATCHJOIN_WINDOW, handler(self, self.destroy))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_MAST_MATCHJOIN_WINDOW,handler(self,self.goMatch))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_MATCHDETAIL_WINDOW,handler(self,self.goMatcDetails))

end

--[[
 * 播放特效特效
 * @param  mesg = {data={START_TIME(开赛时间戳),MATCH_ID(比赛标识)}}
--]]
function GameListJoin:onShow(mesg)
    if mesg and mesg.data then
        local date = mesg.data
        -- 设置倒计时
        self.time = math.floor(date.START_TIME - os.time())
        if self.time < 0 then self.time = 0 end
        -- self.nowtime =0
        -- 倒计时节点
        self.timeText = self:GetWidgetByName("SP_Label_Time")    
        self:AddWidgetEventListenerFunction("SP_Button_Close", handler(self, self.onCloseWindow)) -- 关闭按钮
        self:AddWidgetEventListenerFunction("SP_Button_OK", handler(self, self.onJoinMatch))      -- 前往比赛按钮
        self:AddWidgetEventListenerFunction("SP_Button_Quit", handler(self, self.goMatcDetails))  -- 退赛按钮
        self.timeText:setString(self.time)
        -- 设置开赛名称
        laixiaddz.LocalPlayercfg.LaixiaMatchRoom = date.MATCH_ID
        self.match_id = date.MATCH_ID
        local roomName
        local arr = laixiaddz.LocalPlayercfg.LaixiaMatchdata
        if arr and type(arr) == "table" then
            for k1,v1 in pairs(arr) do
                for k,v in pairs(v1.rooms) do
                    if date.MATCH_ID and tonumber(v.RoomID) == tonumber(date.MATCH_ID) then
                        roomName = v.RoomName
                        self.payment_method = v.Baomingfei[1].payment_method
                        laixiaddz.LocalPlayercfg.LaixiaGameListIndex = tonumber(k1)
                        break
                    end
                end
            end
        end
        self:GetWidgetByName("SP_Label_MatchTitle"):setString(roomName)
    else
        local scene = cc.Director:getInstance():getRunningScene()
        scene:popUpTips("GameListJoin:onShow(error)")
    end
    self:startTimer()
end

--[[
 * 定时器
 * @param  dt 时间间隔
--]]
function GameListJoin:schedulerTick(dt)
    self.time = self.time -1
    if self.time <= 0 then
        self.time = 0
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHJOIN_WINDOW)
        self:stopTimer()
    else
        self.timeText:setString("(".. self.time..")")
    end
end

--[[
 * 关闭当前窗口
 * @param  sender 点击按钮
 * @param  eventType  事件类型
--]]
function GameListJoin:onCloseWindow(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHJOIN_WINDOW)
    end
end

--[[
 * 前往比赛
 * @param  sender 点击按钮
 * @param  eventType  事件类型
--]]
function GameListJoin:onJoinMatch(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        laixiaddz.LocalPlayercfg.laixiaddzJoinMatch = true
        --只有在决定参赛了才会赋值
        laixiaddz.LocalPlayercfg.LaixiaMatchName = self.tempMatchGameName
        if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "ShopWindow" then --在商店界面不弹出 去比赛的弹窗
            return
        elseif laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" and laixiaddz.LocalPlayercfg.laixiaddzIsInMatch== true  then  
            -- 此时在比赛牌桌内
            local matchid = 0
            if laixiaddz.LocalPlayercfg.LaixiaMatchID == 0 then
                matchid = cc.UserDefault:getInstance():getDoubleForKey("matdchId")
            else
                matchid = laixiaddz.LocalPlayercfg.LaixiaMatchID
            end
            -- 比赛退出牌桌 TODO
            local goback = Packet.new("CSExitRoom", _LAIXIA_PACKET_CS_MatchQuitDeskID)
            goback:setValue("GameID", laixia.config.GameAppID)            
            goback:setValue("MatchID", matchid)
            laixia.net.sendPacketAndWaiting(goback)
        elseif laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" and laixiaddz.LocalPlayercfg.LaixiaisConnectCardTable == true then  
            -- 此时在常规牌桌内 不能退出
            local scene = cc.Director:getInstance():getRunningScene()
            scene:popUpTips("常规牌桌内不能退出!")
            return
            --参加比赛点击参加时强制把比赛详情页面中的比赛进行退赛处理
        elseif  laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "lhd_main_window" then 
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_DRAGON_QUIT_TABLE)
        elseif   laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "GameListWindow" and   laixiaddz.LocalPlayercfg.LaixiaisMatchDetail == true  then 
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_WITHDRAW_MATCHJOIN_WINDOW)
        end
        self:goMatchReq()   
    end
end

--[[
 * 进入比赛请求
 * @param  nil
--]]
function GameListJoin:goMatchReq()
    if self.mIsLoad == false then return end
    -- TODO
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_LANDLORDTABLE_WINDOW,{})
    self:destroy()
end

--[[
 * 退出比赛
 * @param  sender 点击按钮
 * @param  eventType  事件类型
--]]
function GameListJoin:goMatcDetails(sender,eventType)
    -- flag = true 退赛
    local flag  
    if eventType and eventType == ccui.TouchEventType.ended then
        -- 按钮点击 
        flag = true
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
    elseif not sender and not eventType then
        -- 事件推送
        flag = true
    end
    if flag then
        -- 退赛
        local stream = Packet.new("match_out", "LXG_MATCH_CANCEL_ENROLL")
        stream:setReqType("post")
        stream:setValue("match_id", self.match_id)
        stream:setValue("payment_method", self..payment_method)
        stream:setPostData("uid", laixiaddz.LocalPlayercfg.LaixiaPlayerID)
        local function cb(data)
            if data.dm_error == 0 then
                print("比赛退出成功！")
                local match = laixiaddz.LocalPlayercfg.LaixiaMatchdata
                if #match == 0 then return end
                local red_temp = match[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms
                for i = 1, #red_temp do
                    if (laixiaddz.LocalPlayercfg.LaixiaMatchRoom == red_temp[i].RoomID) then
                        laixiaddz.LocalPlayercfg.LaixiaMatchdata[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms[i].CurJoinNum = laixiaddz.LocalPlayercfg.LaixiaMatchdata[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms[i].CurJoinNum - 1
                        laixiaddz.LocalPlayercfg.LaixiaMatchdata[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms[i].Sate = 1
                        laixiaddz.LocalPlayercfg.LaixiaMatchdata[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms[i].SelfJoin = 0
                    end
                end
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_MATCHSTATE_WINDOW)
            else
                print("比赛退出失败！")
            end
        end
        laixiaddz.net.sendHttpPacketAndWaiting(stream.key,stream,cb)
        self.destroy()
    end
end

--[[
 * 启动定时器
 * @param  nil
--]]
function GameListJoin:startTimer()
    if not self.__Timer then
        self.__Timer = scheduler.scheduleGlobal(function(dt)
            self:schedulerTick(dt)
        end, 0.2) -- 时间限制
    end
end

--[[
 * 消耗定时器
 * @param  nil
--]]
function GameListJoin:stopTimer()
    if self.__Timer then
        scheduler.unscheduleGlobal(self.__Timer)
        self.__Timer = nil
    end 
end

--[[
 * 注销
 * @param  nil
--]]
function GameListJoin:onDestroy()
    self:stopTimer()
    laixiaddz.LocalPlayercfg.LaixiaJoinMatch = false
    self.time =0
end

return GameListJoin.new()

----------------------TODO REMOVE↓ 
-- function GameListJoin:notShowJoinLayer(msg)
--     -- local str = msg.data.data
--     -- if str == "ShopWindow" or str == "LaixiaIsInMatch" or str == "LaixiaisConnectCardTable" then
--     --    local Details = Packet.new("CGDetails", _LAIXIA_PACKET_CS_MatchDetailsID)
--     --    Details:setValue("GameID", laixia.config.GameAppID)
--     --    Details:setValue("PageType", laixiaddz.LocalPlayercfg.LaixiaGamePageType)
--     --    local roomID = 0
--     --     if laixiaddz.LocalPlayercfg.LaixiaMatchLastRoom == nil then
--     --        roomID = cc.UserDefault:getInstance():getDoubleForKey("matdchRoomID")
--     --    else
--     --         roomID = laixiaddz.LocalPlayercfg.LaixiaMatchLastRoom
--     --    end
--     -- --    Details:setValue("RoomID", roomID)
--     -- --    laixia.net.sendPacketAndWaiting(Details)
--     -- -- end
--     -- -- if eventType == ccui.TouchEventType.ended then
--     --     local CSExitMatchGame = Packet.new("CSExitMatchGame", _LAIXIA_PACKET_CS_ExitMatchGameID)
--     --     CSExitMatchGame:setValue("GameID", laixia.config.GameAppID)
--     --     CSExitMatchGame:setValue("PageType", laixiaddz.LocalPlayercfg.LaixiaGamePageType)
--     --     CSExitMatchGame:setValue("RoomID", roomID)
--     --     laixia.net.sendPacketAndWaiting(CSExitMatchGame)
-- --         if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow ~= "GameListWindow"  then -- 如果当前界面不是比赛列表则请求比赛列表
-- --             ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW)
-- --             ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_GAMELIST_GOGAMELIST)
-- --         end
-- --         if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "LobbyWindow" then
-- --             ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW)      -- 请求个人详情
-- --         end
--     -- end
-- end

-- function GameListJoin:onCallBackFunction()
-- end