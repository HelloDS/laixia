local laixia = laixia;
local soundConfig =  laixiaddz.soundcfg; 
local EffectDict =  laixia.EffectDict;
local EffectAni = laixia.EffectAni;   
local JsonTxtData = laixiaddz.JsonTxtData;
local GameRoomGround = class("GameRoomGround", import("...CBaseDialog"):new()) 

function GameRoomGround:ctor(...)
    self.super:onInit(self)
    self.hDialogType = DialogTypeDef.DEFINE_SINGLE_DIALOG
    self.mIsShow = false
    self.mTime = 0
    self.mRoomType = 0
end
 
function GameRoomGround:getName()
    return "GameRoomGround" --csb = GameRoomGround
end

function GameRoomGround:onInit()
    local Image_Bg = _G.seekNodeByName("BG")
    if Image_Bg then
        Image_Bg:setContentSize(cc.size(display.width, display.height))
    end
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_UPDATE_SELECTROOM_WINDOW,handler(self,self.show)) 
end

--[[
 * 通过RoomID获取比赛详情
 * @param  roomId = 详情标识
--]]
function GameRoomGround:getTicketGold(roomId)
    for i,v in ipairs(self.mRoomArrayMsg) do
        if v.RoomID == roomId then
            return v
        end
    end
end 

--[[
 * 快速开赛
 * @param  sender = 按钮
 * @param  eventType = 事件
--]]
function GameRoomGround:onStartGame(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        local info
        for i,v in ipairs(self.mRoomArrayMsg) do
            dump(v,"vvvvvvv")
            dump(laixiaddz.LocalPlayercfg.LaixiaGoldCoin ,"laixiaddz.LocalPlayercfg.LaixiaGoldCoin ")

            if laixiaddz.LocalPlayercfg.LaixiaGoldCoin >= v.MinGold and  laixiaddz.LocalPlayercfg.LaixiaGoldCoin <= v.MaxGold then
                info = v
                break
            end
        end
        dump(info,"info")
        if info then
            sender.roomID = info.RoomID
            sender.MatchId = info.MatchId
            self:onSendPacktEnterRoom(sender, ccui.TouchEventType.ended)
        else
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"没有可加入的游戏场！")
        end
    end
end 

--[[
 * 初始数据存储及按钮信息绑定
 * @param  msg = {1={MaxGold,MinGold,RoomID.....},..}
--]]
function GameRoomGround:InitWindow(msg)
    if self.mIsShow == true then 
        local roomData = msg.data
        self.mRoomArrayMsg = roomData
        laixiaddz.LocalPlayercfg.mRoomData = roomData
        for i=1,#self.roomList do
            if i <= #roomData then
                local roomNode = self.roomList[i]
                roomNode.roomID = roomData[i].RoomID
                roomNode.MatchId = roomData[i].match_enroll_id
                local mRoomMsg = roomData[i]
                self:addMsg2Node(roomNode,mRoomMsg) 
            end  
        end
    end 
end

--[[
 * 请求报名按钮
 * @param  sender = xx场按钮
 * @param  eventType = 事件
--]]
function GameRoomGround:onSendPacktEnterRoom(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local roomID = sender.roomID
        local info = self:getTicketGold(roomID)
        if info and info.MinGold and info.MaxGold then
            if laixiaddz.LocalPlayercfg.LaixiaGoldCoin > info.MaxGold then
                -- 报名超出限制金币数
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"金币超出限额!")
            elseif laixiaddz.LocalPlayercfg.LaixiaGoldCoin < info.MinGold then
                -- 报名低于限制金币数
                -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"金币不足!")
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_RELIEFINFO_WINDOW)
            elseif laixiaddz.LocalPlayercfg.LaixiaGoldCoin >= info.MinGold and  laixiaddz.LocalPlayercfg.LaixiaGoldCoin <= info.MaxGold  then
                -- 申请游戏场报名
                local stream = laixiaddz.Packet.new("baoming", "LXG_GAME_ENTER")
                stream:setReqType("post")
                stream:setValue("match_id",sender.roomID)
                stream:setValue("match_enroll_id",sender.MatchId)
                stream:setValue("is_continuance",0)
                stream:setValue("score",laixiaddz.LocalPlayercfg.LaixiaGoldCoin)
                stream:setPostData("uid", laixiaddz.LocalPlayercfg.LaixiaPlayerID)
                local function cb(data)
                    --TODO 游戏场暂时写死
                    dump("roomID",roomID)
                    local dataParam = {}
                    dataParam.RoomID = roomID
                    dataParam.MatchId = sender.MatchId
                    dataParam.RoomType = 2
                    if data.dm_error == 0 then
                        -- 游戏场报名成功进入牌桌
                        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_LANDLORDTABLE_WINDOW,dataParam)
                    else
                        -- 游戏场报名失败 显示错误信息
                        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,data.error_msg)
                    end
                end
                dump(stream,"stream")
                laixiaddz.net.sendHttpPacketAndWaiting(stream.key,stream,cb)
            end
        end
    end
end

--发送我本地版本号
function GameRoomGround:sendCurVersion()
    local version = cc.UserDefault:getInstance():getStringForKey("version")
    if version ~=nil and version~="" then
    elseif version==nil or version=="" then
        CurVersion = "2.0.14"
    end
    local stream = laixiaddz.Packet.new("CSGetVersion", _LAIXIA_PACKET_CS_GETVERSION)
    stream:setValue("Code", 0)
    stream:setValue("GameID", 1)
    stream:setValue("GameVersion",version)
    laixia.net.sendHttpPacketAndWaiting(stream,nil,2) 
end

function GameRoomGround:addRoomLight(index)
   local roomLight = EffectAni:createAni(EffectDict._ID_DICT_TYPE_GAMEROOM_ROOMLIGHT)
   if (#self.roomList > 0) and (self.roomList[index]~= nil) then
      roomLight:addTo(self.roomList[index] ,4)
   end
end

function GameRoomGround:addMsg2Node(roomNode,mRoomMsg)
        --local container = self:GetWidgetByName("Image_Container",roomNode)
        --container:setVisible(true)
        roomNode:setVisible(true)
        local container = roomNode
        local points = self:GetWidgetByName("Label_Points",container)
        points:setString("底分:" .. mRoomMsg["BaseScore"])
        
        local Label_Coins = self:GetWidgetByName("Label_Coins",container)
        local mTicketGold = mRoomMsg["MinGold"]
        local  minmoney = laixiaddz.helper.numeralRules_2(mTicketGold)
        local  maxGold = laixiaddz.helper.numeralRules_2(mRoomMsg["MaxGold"])
        local str = "准入:"..minmoney.."-"..maxGold.."\n         (金币)"
        Label_Coins:setString(str)
        local playersNum = self:GetWidgetByName("Label_Players",container)
        playersNum:setString(mRoomMsg.OnlineNumber .. "人")
       
        -- 奖励信息
        local awardDescNode = self:GetWidgetByName("Label_Round",container)
        if mRoomMsg.AwardDesc then
            awardDescNode:setVisible(true)
            awardDescNode:setString(mRoomMsg.AwardDesc)
        else
            awardDescNode:setVisible(false)
        end

        -- if mRoomMsg.Cound and mRoomMsg.Cound ~= 0 and mRoomMsg.ItemCount and mRoomMsg.ItemCount ~= 0 then
        --     local  itemDBM = JsonTxtData:queryTable("items");
        --     local item = itemDBM:query("ItemID",mRoomMsg.ItemId);
        --     local itemName = item.ItemName
        --     local tips = "每" .. mRoomMsg.Cound .. "局送" .. mRoomMsg.ItemCount .. "来豆"
        --     self:GetWidgetByName("Label_Round",container):setVisible(true)
        --     self:GetWidgetByName("Label_Round",container):setString(tips)
        -- else
        --     self:GetWidgetByName("Label_Round",container):setVisible(false)
        -- end 
end

--进行适配
function GameRoomGround:setAdaptation()
    --view:setScale(display.contentScaleFactor)
    -- view:setScaleY(display.widthInPixels/display.width)
    --if(self.hDialogType ~= DialogTypeDef.DEFINE_SINGLE_DIALOG) then
        --view:setScale(display.contentScaleFactor)
            -- :scaleX(XScale)
            -- :scaleY(YScale)
    --end
    if device.platform == "ios" then
        --暂时先 适配 iphoneX
        print("aaaa"..display.widthInPixels.."-----"..display.heightInPixels)
        if display.widthInPixels  == 2436 and display.heightInPixels == 1125 then
            self:GetWidgetByName("BG"):setScaleX(2436/3*2/1280)
        end
    end

end

--[[
 * 显示窗口
 * @param  msg = {1={MaxGold,MinGold,RoomID.....},..}
--]]
function GameRoomGround:onShow(msg)
    if self.mIsShow == false then
        self:setAdaptation()

        local btn = self:GetWidgetByName("Button_Start_Game")
        if btn then
            btn:addTouchEventListener(handler(self,self.onStartGame)) 
        end
        -- local Image_Bg = self:GetWidgetByName("BG")
        -- Image_Bg:setContentSize(cc.size(display.width, display.height))
        -- Image_Bg:setPosition(cc.p(display.cx, display.cy))
        -- 在这里加上一个标识 
        cc.UserDefault:getInstance():setStringForKey("lastwindow","ddz_GameRoomGround")
        cc.UserDefault:getInstance():setDoubleForKey("lastwindow_time",os.time())
        self.roomList ={}
        -- TODO 这里暂时先改成 经典场2 --modify by wangtianye
        self.mRoomType = 2
        for i = 1, 3 do
           local path  = "Room_Ground_"..i
           local node  = self:GetWidgetByName(path)
           table.insert(self.roomList,node)
           node:addTouchEventListener(handler(self,self.onSendPacktEnterRoom)) 
        end

        if not self.mRoomType then 
            self.mRoomType = 0
        end 

        self.mTime = 10
        
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_COMMONFLOOR_WINDOW)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_COMMONTOP_WINDOW,
        {
            goBackFun = function()
                self:destroy()
            end,
        } ) 

        if device.platform ~= "windows" then
            -- self:sendCurVersion()
        end
        
        self.mIsShow = true
    end
    self:InitWindow(msg)
end

function GameRoomGround:onTick(dt)
    if self.mIsShow then
        self.mTime = self.mTime+dt
        if self.mTime > 10 then
           local index =math.random(1,4) 
           --self:addRoomLight(index)
           self.mTime =0
        end
    end
end

function GameRoomGround:onDestroy()
    self.mRoomArrayMsg = {}
    self.mIsShow = false
    self.mTime =0
end

return GameRoomGround.new()
