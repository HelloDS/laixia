local Gain = class("Gain", import("...CBaseDialog"):new())-- 
local soundConfig =  laixiaddz.soundcfg

function Gain:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function Gain:getZorder()
   return  20 
end

function Gain:getName()
    return "TPGain"
end

function Gain:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_GAIN_WINDOW, handler(self, self.show))
end


function Gain:onShow(msg)

     self.mIsShow = false
     self.mItemArray = {}
     -- local nodeBottom = laixiaddz.ani.CObjectAnimationManager:playAnimationAt(self.mInterfaceRes,"Gain","Default Timeline",
     -- function()  
     -- end )  
     -- nodeBottom:setPosition(cc.p(0,90))
     -- nodeBottom:setLocalZOrder(15)
     
     
     self:AddWidgetEventListenerFunction("Button_GainShutDown", handler(self,self.onShutDown))  --关闭

     self.itemData = laixiaddz.JsonTxtData:queryTable("items")

     self.mCell = self:GetWidgetByName("Gain_Cell")
     self.mBG = self:GetWidgetByName("Image_GainBG")
     self.mPiont = self:GetWidgetByName("Image_Point")

     if #msg.data == 0  then
        self:destroy()
        return 
     end
     self.overFun = nil
     
     if msg.data.overFun ~= nil  then
        self.overFun = msg.data.overFun
     end

     self.isSelfBuilding = false

     if msg.data.rank~= nil and msg.data.rank > 0 then
        self.mCell = self:GetWidgetByName("Gain_Cell_SelfBuilding")
        local myRanking = self:GetWidgetByName("Image_MyRanking")
        myRanking:setVisible(true)
        local x,y  = myRanking:getPosition() 
        if msg.data.rank == 1 then
           myRanking:loadTexture("reward_first.png",1)
        elseif msg.data.rank == 2 then
           myRanking:loadTexture("reward_second.png",1)
        end
        self.isSelfBuilding = true
     end
     table.insert(self.mItemArray,msg.data)

     if self.mIsShow == false  then
        self:addShowItem()
     end
     self.mIsShow = true
end

function Gain:addItemMsg(cell,data,copyNum)
   cell:setVisible(true)
   local str = ""
   if copyNum == 0 then
        str = ""
   elseif copyNum == 1 then
        str = "_Copy"
   elseif copyNum == 2 then
        str = "_Copy_Copy"
   end
    local icon = self:GetWidgetByName("Gain_Circle_Icon"..str, cell)
   local itemmsg = self.itemData:query("ItemID",data.ItemID);
   icon:loadTexture(itemmsg.ImagePath) 
   
    self:GetWidgetByName("Gain_Title"..str, cell) :setString(itemmsg.ItemName)
   if data.noshowNum then  --如果为空也显示
        self:GetWidgetByName("Gain_Libao_Num"..str, cell) :setVisible(false)
   else
        self:GetWidgetByName("Gain_Libao_Num"..str, cell) :setString(data.ItemCount)
   end
    self:GetWidgetByName("Gain_Libao_Num"..str, cell):setLocalZOrder(1050)
   

end

--添加入一行显示
function Gain:addListView(itemNumber ,data)
      local listView = self:GetWidgetByName("ListView_Gain")
      listView:removeAllItems()
      for  i= 1,itemNumber do  
          local cell = self.mCell:clone()
          listView:pushBackCustomItem(cell)
          self:addItemMsg(cell,data[i])
      end
end

--添加多行显示 --或者显示不够一行
function Gain:addItemSetP(shengyu ,data)
    
    for i=1,3  do
        local num = i -1
        local node_path = "Gain_Cell_".. num
        self:GetWidgetByName(node_path):setVisible(false)
        node_path = "Gain_Cell_SelfBuilding_"..num
        self:GetWidgetByName(node_path):setVisible(false)
    end
    


        --不得已而为之 wangtianye
      local isHasCopy = 0
      if shengyu == 1 then
          
        local cell = nil 
        if self.isSelfBuilding then
            isHasCopy = 2
           cell =  self:GetWidgetByName("Gain_Cell_SelfBuilding_2")
        else
            isHasCopy = 0
           cell =  self:GetWidgetByName("Gain_Cell_2")
        end
----------------------
        self:addItemMsg(cell,data[1],isHasCopy)
      else
          
          local cell0 = nil
          local cell1 = nil

       if self.isSelfBuilding then
           cell0 =  self:GetWidgetByName("Gain_Cell_SelfBuilding_0")
            self:addItemMsg(cell0,data[1],1)
           cell1 =  self:GetWidgetByName("Gain_Cell_SelfBuilding_1")
            self:addItemMsg(cell1,data[2],2)
        else
            cell0 =  self:GetWidgetByName("Gain_Cell_0")
            self:addItemMsg(cell0,data[1],1)
            cell1 =  self:GetWidgetByName("Gain_Cell_1")
            self:addItemMsg(cell1,data[2],1)
            cell0:setPositionX(cell0:getPositionX()+150)
            cell1:setPositionX(cell1:getPositionX()-150)
        end
      end
end

function Gain:addShowItem()
    local index = #self.mItemArray 
    if self.mItemArray == nil or #self.mItemArray == 0 then
       return 
    end
     
    local data = self.mItemArray[1]
    table.remove(self.mItemArray,1)
    local itemNumber = #data
    local hangshu =  math.floor(itemNumber / 3)
    local shengyu  =  itemNumber% 3

    if hangshu > 0  then
       self:addListView(itemNumber,data)
    else
       self:addItemSetP (shengyu,data)
    end

end


function Gain:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        if #self.mItemArray > 0 then
           self:addShowItem()
        else
            if self.overFun ~= nil then
                self.overFun()
            else
                self:destroy()
            end
        end
        
    end
end

function Gain:onCallBackFunction()
    self:destroy()
end



function Gain:onDestroy()
     self.mItemArray = {} 
     self.mIsShow  = false

end

return Gain.new()


