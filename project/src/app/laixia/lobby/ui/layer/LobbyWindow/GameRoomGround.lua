
local laixia = laixia;
local Packet =  import("....net.Packet")
local soundConfig =  laixia.soundcfg; 
local EffectDict =  laixia.EffectDict;
local EffectAni = laixia.EffectAni;   
local JsonTxtData = laixia.JsonTxtData;
local GameRoomGround = class("GameRoomGround", import("...CBaseDialog"):new()) 

function GameRoomGround:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_SINGLE_DIALOG
    self.mIsShow = false
    self.mTime = 0
    self.mRoomType = 0
end
 
function GameRoomGround:getName()
      return "GameRoomGround"
end

function GameRoomGround:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_UPDATE_SELECTROOM_WINDOW,handler(self,self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SEND_ROOM_WINDOW, handler(self, self.sendRoomListPacket))  
 
end

function GameRoomGround:sendRoomListPacket(msg)
    local data = msg.data
    self.mRoomType = data
    local stream = Packet.new("EnterListRoom", _LAIXIA_PACKET_CS_ListRoomID)
    stream:setValue("RoomType", self.mRoomType)
    laixia.net.sendPacketAndWaiting(stream)
end

function GameRoomGround:getTicketGold(roomId)
    local maxCoin = 0
    local mTicketGold = 0
    for i,v in ipairs(self.mRoomArrayMsg) do
        if v.RoomID == roomId then
            maxCoin = v.MaxGold 
            mTicketGold = v.MinGold
            break
        end
    end
    
    if laixia.LocalPlayercfg.LaixiaPlayerGold >= maxCoin and maxCoin >0 then 
        local callback = function()
        
            if self.mRoomType ~= nil then
                ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_QUICKGAME_WINDOW,self.mRoomType)
            else
                ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_QUICKGAME_WINDOW,0)
            end
             
        end
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, {Text="您太土豪了，还是去更高级的房间玩吧~ " , OnCallFunc=callback})
        return false 
    end
    return mTicketGold
end 


function GameRoomGround:InitWindow(msg)
    if self.mIsShow == true then 
        local roomData = msg.data
        self.mRoomArrayMsg = roomData
        for i=1,#self.roomList do
            if i <= #roomData then
                local roomNode = self.roomList[i]
                roomNode.roomID = roomData[i].RoomID
                local mRoomMsg = roomData[i]
                self:addMsg2Node(roomNode,mRoomMsg) 
            end  
        end
         
    end 
end

function GameRoomGround:onSendPacktEnterRoom(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local roomID = sender.roomID
        local mTicketGold = self:getTicketGold(roomID)
        if mTicketGold == false then 
            return 
        end 
        if device.platform ~= "windows" then
            self:sendCurVersion()
        end

        laixia.LocalPlayercfg.LaixiaInGolds = mTicketGold
        laixia.LocalPlayercfg.LaixiaRoomID = roomID
        local stream = Packet.new("enterRoom", _LAIXIA_PACKET_CS_EnterRoomID)
        stream:setValue("RoomID", roomID)
        if roomID == 50 then
           laixia.net.sendPacket(stream)
        else
           laixia.net.sendPacketAndWaiting(stream)
        end
    end
end
--发送我本地版本号
function GameRoomGround:sendCurVersion()
    local version = cc.UserDefault:getInstance():getStringForKey("version")
    if version ~=nil and version~="" then
    elseif version==nil or version=="" then
        version = LAIXIA_ORIGIN_VERSION or "2.0.1"
    end
   

    local stream = Packet.new("CSGetVersion", _LAIXIA_PACKET_CS_GETVERSION)
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
        local  minmoney = laixia.helper.numeralRules_2(mTicketGold)
        Label_Coins:setString("准入:"..minmoney.."金币")
        local playersNum = self:GetWidgetByName("Label_Players",container)
        playersNum:setString(mRoomMsg.OnlineNumber .. "人")
       
        if mRoomMsg.Cound and mRoomMsg.Cound ~= 0 and mRoomMsg.ItemCount and mRoomMsg.ItemCount ~= 0 then
            local  itemDBM = JsonTxtData:queryTable("items");
            local item = itemDBM:query("ItemID",mRoomMsg.ItemId);
            local itemName = item.ItemName
            local tips = "每" .. mRoomMsg.Cound .. "局送" .. mRoomMsg.ItemCount .. "来豆"
            self:GetWidgetByName("Label_Round",container):setVisible(true)
            self:GetWidgetByName("Label_Round",container):setString(tips)
        else
            self:GetWidgetByName("Label_Round",container):setVisible(false)
        end 
end

function GameRoomGround:onShow(msg)
    if self.mIsShow == false then
        -- self:GetWidgetByName("BG"):loadTexture("mall_bg.png",1)
        ---在这里加上一个标识 
        cc.UserDefault:getInstance():setStringForKey("lastwindow","ddz_GameRoomGround")
        cc.UserDefault:getInstance():setDoubleForKey("lastwindow_time",os.time())
        self.roomList ={}
        --这里暂时先改成 经典场2 --modify by wangtianye
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
        
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_COMMONFLOOR_WINDOW)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_COMMONTOP_WINDOW,
        {
            goBackFun = function()
                ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW)
            end,
        } ) 

        if device.platform ~= "windows" then
            self:sendCurVersion()
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
    self.mIsShow = false
    self.mTime =0
end

return GameRoomGround.new()
