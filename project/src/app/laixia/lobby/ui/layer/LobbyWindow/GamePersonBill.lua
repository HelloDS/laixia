--
-- Author: peter
-- Date: 2017-12-21 14:07:47
--
local GamePersonBill = class("GamePersonBill", import("...CBaseDialog"):new())
local soundConfig = laixia.soundcfg;     
local Packet = import("....net.Packet") 

local db2 = laixia.JsonTxtData
local itemdbm = db2:queryTable("items");

local laixia = laixia;
local l_RoomDataMgr


function GamePersonBill:ctor()
	self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
	self.mIsShow = false
end

function GamePersonBill:getName()
    return "GamePersonBill"
end 

function GamePersonBill:onInit()
	self.super:onInit(self)
	ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_PERSONBILL_WINDOW, handler(self, self.show))
	ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_HIDEPERSONBILL_WINDOW, handler(self, self.destroy))
end

function GamePersonBill:onShow(msg)
    --if self.mIsShow == false then
        self.BG = self:GetWidgetByName("Image_1")
        self.BG:setTouchEnabled(true)
        self.BG:setTouchSwallowEnabled(true)
        
    	self.AllRankdata = msg.data.GameBill
    	self.mRankCell = self:GetWidgetByName("Panel_2")
    	self.mRankinglisview = self:GetWidgetByName("ListView_1")
    
    
    	--self.quit = self:GetWidgetByName("Button_1")
    	self:AddWidgetEventListenerFunction("Button_1", handler(self, self.goBack))
    	--if #self.AllRankdata > 0 then--or self.mIndex == #self.AllRankdata then
    	if #self.AllRankdata > 0 then
    		self:addRankCell(1,#self.AllRankdata)
        end
 --        self.mIsShow = true
	-- end

end

function GamePersonBill:goBack(sender, eventType)
	if eventType == ccui.TouchEventType.ended then  
		--隐藏该界面
		ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HIDEPERSONBILL_WINDOW)
	end
end

function GamePersonBill:addRankCell(begin, over)
	 for i = begin, over do
        local rankdate = self.AllRankdata[i]
        local rankCell = self.mRankCell:clone()
        rankCell:setVisible(true)
        

        self.Text_num = self:GetWidgetByName("Text_num",rankCell)
        self.Text_name = self:GetWidgetByName("Text_name", rankCell)
        self.Text_time = self:GetWidgetByName("Text_time", rankCell)
        self.Text_time:enableOutline(cc.c4b(187,63,39,255), 2)
        
        rankCell.player = rankdate
        rankCell:setTouchEnabled(true)

        self.mRankinglisview:pushBackCustomItem(rankCell)

        if tonumber(rankdate["RoomID"]) == 50 then
--        	self.Text_name:setString("自建房")
    	else
    		l_RoomDataMgr =  laixia.JsonTxtData:queryTable("room_list")
    		local roomInfo = l_RoomDataMgr:query("roomid",tonumber(rankdate["RoomID"]))
    		self.Text_name:setString(roomInfo["name"])

        end

        self.Text_num:setString(rankdate["Num"])
		--self.Text_name:setString(roomInfo["name"])
		self.Text_time:setString(rankdate["Time"])
    end
end


return GamePersonBill.new()