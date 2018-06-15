
local GameListWindow_Resurrection= class("GameListWindow_Resurrection",import("...CBaseDialog"):new())--
local soundConfig = laixiaddz.soundcfg; 
local Packet =import("....net.Packet")

local laixia = laixia;
local db2 = laixiaddz.JsonTxtData;
local itemDBM 

function GameListWindow_Resurrection:ctor(...) 
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG      
end

function GameListWindow_Resurrection:getName()
	return "GameListWindow_Resurrection"
end

function GameListWindow_Resurrection:onInit()
    self.super:onInit(self)    
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_MATCHEASTER_WINDOW,handler(self,self.show))--会首先调用父类的show方法生成界面
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_MATCHEASTER_WINDOW,handler(self,self.destroy))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_MATCHEASTERRESULT_WINDOW,handler(self,self.goMatchresult))-- 复活失败显示结算界面


end



function GameListWindow_Resurrection:onShow(mesg)
	itemDBM = db2:queryTable("items");

    self:AddWidgetEventListenerFunction("Button_fuhuozaizhan", handler(self, self.Resurrection))
    self:AddWidgetEventListenerFunction("Button_quxiao", handler(self, self.ShutDown))
    self:AddWidgetEventListenerFunction("Revive_Button_Closee", handler(self, self.ShutDown))
    self.data = mesg.data
    self.time = self.data.Time --倒计时时间

    local Items =self.data.Items
    for i, v in pairs(Items) do
           local Item = itemDBM:query("ItemID",v.ItemID);
           if v.ItemID == 1001 then
              laixiaddz.LocalPlayercfg.LaixiaInGolds=v.ItemCount  --复活需要金数量
              self:GetWidgetByName("Revive_Label_Fuhuo"):setString("真遗憾，老板您已经被淘汰啦，花费"..v.ItemCount..laixia.utilscfg.CoinType().."即可复活。")
    
           elseif  v.ItemID == 1002 then 
               self:GetWidgetByName("Revive_Label_Fuhuo"):setString("真遗憾，老板您已经被淘汰啦，花费"..v.ItemCount.."奖券即可复活。")
  
            else
              self:GetWidgetByName("AtlasLabel_fuhuo"):setvisible(false)

           end
    end

    
    self.nowTime =0 --现在的时间
    self.nexTime=self.nowTime+1
    if self.data.ResurCt > 0 then
        local str = "（" .. self.data.Time .. "）"
        --self:GetWidgetByName("Label_daojishi"):setString(str)
    end
        self:GetWidgetByName("Button_quxiao"):setVisible(true)
        self:GetWidgetByName("Button_fuhuozaizhan"):setVisible(true)
      
end


function GameListWindow_Resurrection:ShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
       self:goMatchresult()
       ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHEASTER_WINDOW);
    end
end

function GameListWindow_Resurrection:goMatchresult()
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHEASTER_WINDOW);
        local data = { }
        data.mesg = self.data.Msg
        data.rank = self.data.Rank
        data.roomID = self.data.RoomID
        data.ISWin = false   
 
       ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHRESULT_WINDOW,data); 

       
end

function GameListWindow_Resurrection:Resurrection(sender, eventType)
    if eventType == ccui.TouchEventType.ended then

    local resurection = Packet.new("resurection", _LAIXIA_PACKET_CS_MatchResurrectionID)
    resurection:setValue("GameID", laixia.config.GameAppID)
    resurection:setValue("MatchID", self.data.MatchID)
    laixia.net.sendPacket(resurection)
       
    end

end

function GameListWindow_Resurrection:onTick(dt)
    self.nowTime = self.nowTime + dt
    if self.nowTime >= self.nexTime then
        self.nexTime = self.nexTime + 1
        local per =(self.time - self.nexTime) 
        local  str ="（".. per.."）"
    end
    if self.nowTime >=self.time then
    end
end


function GameListWindow_Resurrection:onDestroy()
	
end



return GameListWindow_Resurrection.new()

