
local TPSelfBuilding = class("TPSelfBuilding", import("...CBaseDialog"):new())-- 
local soundConfig =  laixiaddz.soundcfg
local Packet = import("....net.Packet")


function TPSelfBuilding:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_SINGLE_DIALOG
end

function TPSelfBuilding:getZorder()
   return  10 
end

function TPSelfBuilding:getName()
    return "TPSelfBuilding"
end

function TPSelfBuilding:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_SELFBUILDING_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_SELFBUILDING_WINDOW, handler(self, self.destroy))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_PACKET_CREATESELFBUILF, handler(self, self.onSendCreateList))
end

function TPSelfBuilding:onSendCreateList()
     local packetCreateList = Packet.new("onSendCreateList", _LAIXIA_PACKET_CS_CreateListID)
     laixia.net.sendPacket(packetCreateList)
end

function TPSelfBuilding:onShow(msg)
    self.ButtonArray ={}
    self.Panel_right = self:GetWidgetByName("Panel_right")
    self:AddWidgetEventListenerFunction("Button_close", handler(self,self.onShutDown)) --关闭
    self:AddWidgetEventListenerFunction("Button_JoinRoom", handler(self,self.onJoinGame)) --加入游戏
    self:AddWidgetEventListenerFunction("Button_CreateRoom", handler(self,self.onCreateRoom)) --确认创建
    self:AddWidgetEventListenerFunction("Button_DelNum", handler(self,self.onDelNum)) --删除数字
    self:AddWidgetEventListenerFunction("Button_ResetNum", handler(self,self.onResetNum)) --删除数字

    self:GetWidgetByName("Text_RoomName"):setString(laixiaddz.LocalPlayercfg.LaixiaPlayerNickname.."房间")

--    local btn_now = self:GetWidgetByName("Button_MenPiaoNow",mode)
--    table.insert(self.ButtonArray,btn_now)
--    local btn_des = self:GetWidgetByName("Button_MenPiao",mode)
--    table.insert(self.ButtonArray,btn_des)
--    btn_des:addTouchEventListener(handler(self, self.onShouMenPiaoUI))


--    btn_now = self:GetWidgetByName("Button_JinBiNow",mode)
--    table.insert(self.ButtonArray,btn_now)
--    btn_des = self:GetWidgetByName("Button_JinBi",mode)
--    table.insert(self.ButtonArray,btn_des)
--    btn_des:addTouchEventListener(handler(self, self.onShouJinBiUI))

--    btn_now = self:GetWidgetByName("Button_JoinGameNow",mode)
--    table.insert(self.ButtonArray,btn_now)
--    btn_des = self:GetWidgetByName("Button_JoinGame",mode)
--    table.insert(self.ButtonArray,btn_des)    
--    btn_des:addTouchEventListener(handler(self, self.onJoinGameUI))
    
    self.Text_CoinNum = self:GetWidgetByName("Text_CoinNum")
    self.mJoinRoomID = self:GetWidgetByName("Label_RoomID")    --加入房间的ID输入框
    self.mGameType = 2
    self.isMenPiao = false
    self.mJushu = 6      --默认情况下
    self.mDifen = 1
    self.mBaomingType = 1
    self.opID = 1
    self.data = msg.data
    self.itemData = laixiaddz.JsonTxtData:queryTable("items")
    
    self.mBaomingArray = {}
    self.mJuShuArray = {}
    self.mDifenArray = {}

    local gameType = self:GetWidgetByName("Image_GameType")  --斗地主类型
    for i=1,1 do
       local path = "Image_Choose0".. i
       local node = self:GetWidgetByName(path,gameType)
       node:addTouchEventListener( handler(self,self.onGameType)) --游戏类型
       --将所有按钮置为 unselect的状态
       self:GetWidgetByName("Image_isChoose",node):setVisible(false)
    end
    
    local mJushu =  self:GetWidgetByName("Image_Jushu")
    for i=1,2 do
       local path = "Image_Choose0".. i
       local node = self:GetWidgetByName(path,mJushu)
       table.insert(self.mJuShuArray,node)
       self:AddWidgetEventListenerFunction( path , handler(self,self.onJushu),mJushu) --局数

       self:GetWidgetByName("Image_isChoose",node):setVisible(false)
    end
    --底分
    local mDifen = self:GetWidgetByName("Image_Difen")
    for i=1,3 do
       local path = "Image_Choose0".. i
       local node = self:GetWidgetByName(path,mDifen)
       table.insert(self.mDifenArray,node)
       self:AddWidgetEventListenerFunction( path , handler(self,self.onDifen),mDifen) --局数

       self:GetWidgetByName("Image_isChoose",node):setVisible(false)
    end

---这里默认第一个都选中 以后也许会改 --TODO
    local node = self:GetWidgetByName("Image_Choose01",gameType)
    self:GetWidgetByName("Image_isChoose",node):setVisible(true)
    local node = self:GetWidgetByName("Image_Choose01",mJushu)
    self:GetWidgetByName("Image_isChoose",node):setVisible(true)
    local node = self:GetWidgetByName("Image_Choose01",mDifen)
    self:GetWidgetByName("Image_isChoose",node):setVisible(true)
    -- self.mJinBi = self:GetWidgetByName("Image_JinBi")
    -- self.mJinBi:setVisible(false)
    -- self.mMenPiao = self:GetWidgetByName("Image_Menpiao")   
    -- self.mMenPiao:setVisible(false )

--    self.CreateUI = self:GetWidgetByName("Image_Create")
--    self.CreateUI:setVisible(true)  
    -- self.Joi  mUI:setVisible(false)
    -- self.mJoinRoomID:setString("请输入桌号")


    
    for i = 1,10 do
       local num = i -1
       local path = "Button_Num_".. num
       local node = self:GetWidgetByName(path,self.JoinRoomUI)
       node.Num = num
       node:addTouchEventListener( handler(self,self.onAddNum)) --游戏类型
    end
    
    -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_COMMONFLOOR_WINDOW)
    -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_COMMONTOP_WINDOW,
    -- {
    --     goBackFun = function()
    --             ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW)
    --     end,
    -- } )
        
    self:updateUIdate(2) 
--    self:showOnlyButton(1)
    self:onUpdateUI()
end



--更新最小携带数据
--参数为，房间类型0表示欢乐场，1表示癞子场 5表示经典场
function TPSelfBuilding:updateUIdate(mRoomType)
     local data = self.data 
     self.mBaomingArray = {}

     for i,v  in ipairs(data) do
        if v.RoomType == mRoomType then
           self.mBaomingArray  = v
        end
     end
end

function TPSelfBuilding:onShowOnlyButton(mButton,mName)
    local isChoose = 0
    local sender = mButton:getParent()
    
    for i=1,3 do
       local path = "Image_Choose0".. i
       local bg = self:GetWidgetByName( path , sender)
       if bg == nil then
            break
       end
       if mName == path then
            self:GetWidgetByName( "Image_isChoose" , bg):setVisible(true)
            isChoose =  i 
       else
            self:GetWidgetByName( "Image_isChoose" , bg):setVisible(false)
       end
    end
    return isChoose
end

function TPSelfBuilding:onGameType(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        
        local name = sender:getName()
        local gametype = self:onShowOnlyButton(sender,name)
        
        --0:常规斗地主  1：癞子斗地主 2：经典斗地主(123)
        if gametype == 1 then    --经典场
           self.mGameType = 2 
        elseif gametype == 2 then   --欢乐场
           self.mGameType = 0
        else                     --癞子场
           self.mGameType = 1
        end
        self:updateUIdate(self.mGameType) 
        self:onUpdateUI()
    end
end

function TPSelfBuilding:onBaoMingFei(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        
        local name = sender:getName()
        local baomingType = self:onShowOnlyButton(sender,name)
        self.mBaomingType  = baomingType
        self:onUpdateUI()
    end
end

function TPSelfBuilding:onJushu(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        
        local name = sender:getName()
        
        local jushu = self:onShowOnlyButton(sender,name)
        if jushu == 1 then
           self.mJushu  = 6
        elseif jushu == 2 then
           self.mJushu  = 15
        elseif jushu == 3 then
           self.mJushu  = 24
        end
        self:onUpdateUI() 
    end
end
--底分
function TPSelfBuilding:onDifen(sender,eventType)
  if eventType == ccui.TouchEventType.ended then
      laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
      local name = sender:getName()
      local difen = self:onShowOnlyButton(sender,name)
      if difen == 1 then
          self.mDifen = 1
      elseif difen == 2 then
          self.mDifen = 5
      elseif difen == 3 then
          self.mDifen = 10
      elseif difen == 4 then
          self.mDifen = 20
      end 
      self:onUpdateUI()
  end
end

--显示唯一的前景按钮
function TPSelfBuilding:showOnlyButton(index)
   laixia.UItools.onShowOnly(index,self.ButtonArray)   
end

function TPSelfBuilding:onUpdateUI()
        local data = self.mBaomingArray.Options  
        
        if data == nil then
           return
        end
        
        local jushuType = 1
        if self.mJushu == 6  then
            jushuType = 1
        elseif self.mJushu == 15 then
            jushuType = 2
        end

        local cost= {}
        if self.isMenPiao then
--           self.mJinBi:setVisible(false)
--           self.mMenPiao:setVisible(true )

           for i,v  in ipairs(data) do       
              local temp = {}
              temp.ItemID = v.ItemID
              temp.OpID = v.OpID
              temp.ItemCost = v.ItemCost
              temp.Rewards = v.Rewards
              temp.difen = v.difen
              table.insert(cost,temp)
           end
        else
--           self.mJinBi:setVisible(true)
--           self.mMenPiao:setVisible(false )
           
           for i,v  in ipairs(data) do
              local temp = {}       
              temp.ItemID = 1001
              temp.OpID = v.OpID
              temp.ItemCost = v.Cost
              temp.Rewards = v.Rewards
              temp.difen = v.difen
              table.insert(cost,temp)
           end
        end
      self:onShowUI(cost,self.isMenPiao,jushuType,self.mBaomingType)   
end
function TPSelfBuilding:onShowUI(cost,isMenPiao,jushuType,BaomingType)
     
     for i,v in ipairs(cost) do
        if i<=#self.mJuShuArray then
           if v.ItemCost >= 0 then
              self.mJuShuArray[i]:setVisible(true)
           else
              self.mJuShuArray[i]:setVisible(false)  
              self.mJushu = 6
           end
        end
     end
                                        
    if isMenPiao then
        local data = nil 

        if jushuType > 0 and  jushuType <= #cost then
           data = cost[jushuType]
        end                                  

        local menpiaoNum = data.ItemCost
        local menpiaoID = data.ItemID
        local haveNum = 0
        for i,v in ipairs(laixiaddz.LocalPlayercfg.LaixiaPropsData) do  
            if v.ItemID == menpiaoID then
              haveNum = v.ItemCount
            end
        end
        
        local needNum = self:GetWidgetByName("Label_NeedNum",self.mMenPiao)
        local needIcon = self:GetWidgetByName("Image_NeedIcon",self.mMenPiao)

        
        if haveNum >= menpiaoNum then
           needNum:setString(menpiaoNum)
           needNum:setColor(cc.c3b(4,162,0))
           needIcon:loadTexture("zjz_enough.png" ,1)
        else
           needNum:setString(menpiaoNum)
           needNum:setColor(cc.c3b(234,17,0))
           needIcon:loadTexture("zjz_notenough.png" ,1)
        end
       self.opID = data.OpID 
    else

          if jushuType == 1 then
            self:GetWidgetByName("Text_CoinNum"):setString(cost[jushuType].ItemCost)
            BaomingType = 1
          elseif jushuType == 2 then
            self:GetWidgetByName("Text_CoinNum"):setString(cost[jushuType].ItemCost)
            BaomingType = 2
          end
--        local baomingfei =  self:GetWidgetByName("Image_BaoMing",self.mJinBi)
--        for i=1,#cost do 
--           if i> 3 then
--               break
--           end  
--           local path = "Image_Choose0".. i
--           self:GetWidgetByName(path,baomingfei) :setVisible(true)
--           self:AddWidgetEventListenerFunction( path , handler(self,self.onBaoMingFei),baomingfei) 
--           local minCarryNode = self:GetWidgetByName("Label_smallTitle0"..i,baomingfei) 
--           minCarryNode:setString(cost[i].ItemCost)
--        end

--        local reward = cost[BaomingType].Rewards

--        local jiangli =  self:GetWidgetByName("Image_JiangLi",self.mJinBi)
--        
--        for j,v in ipairs(reward) do
--            if j > 2 then
--               break
--            end
--            local path = "Image_Prize0".. j
--            local jiangliIcon =self:GetWidgetByName(path,jiangli)
--            local lb_path = "Label_Prize0".. j
--            local iangliLible = self:GetWidgetByName(lb_path,jiangli) 
--
--
--            local itemID = v.Rewards[1].ID
--            iangliLible:setString("x"..reward[j].Rewards[1].Num)
--            local itemmsg = self.itemData:query("ItemID",itemID);
--            jiangliIcon:removeAllChildren()
--            jiangliIcon:loadTexture(itemmsg.ImagePath ,1)
--
--            if itemmsg.PresentItemID1 == 1003 then
--                 local sicon =  "red_packet_"..itemmsg.BaseCount..".png"
--                 local count = ccui.ImageView:create(sicon,1)
--                 count:setPosition(78,60)
--                 count:setLocalZOrder(100)
--                 count:addTo(jiangliIcon)
--            end
--        end
        self.opID = cost[BaomingType].OpID 
    end
end


function TPSelfBuilding:onShouMenPiaoUI(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:showOnlyButton(1)
--        self.CreateUI:setVisible(true)  
        self.JoinRoomUI:setVisible(false)
         -- self.mJoinRoomID:setString("请输入桌号")
        self.isMenPiao = true
        self:onUpdateUI()
    end
end



function TPSelfBuilding:onShouJinBiUI(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:showOnlyButton(3)
        self.CreateUI:setVisible(true)  
        self.JoinRoomUI:setVisible(false)
        -- self.mJoinRoomID:setString("请输入桌号")
        self.isMenPiao = false
        self:onUpdateUI()
    end
end


function TPSelfBuilding:onJoinGameUI(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:showOnlyButton(5)
        
        self.CreateUI:setVisible(false)  
        self.JoinRoomUI:setVisible(true)
    end
end

function TPSelfBuilding:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW)
        self:destroy()
    end
end
--重输数字
function TPSelfBuilding:onResetNum(sender,eventType)
  if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        for i=1,6 do
            self:GetWidgetByName("Text_JoinRoom_id"..i,self.Panel_right):setString("")
        end
  end
end
--删除数字
function TPSelfBuilding:onDelNum(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        -- local str=self.mJoinRoomID:getString()
        -- local tableID = tonumber(str)
        
        -- if tableID == nil then
        -- else
        --     local len = #str
        --     local r_str = string.sub(str,1,len-1)
        --     if r_str == "" then
        --        r_str = "请输入桌号"
        --     end
        --     self.mJoinRoomID:setString(r_str)
        -- end
        for i=6,1,-1 do
            if self:GetWidgetByName("Text_JoinRoom_id"..i , self.Panel_right):getString() ~= "" then
                self:GetWidgetByName("Text_JoinRoom_id"..(i),self.Panel_right):setString("")
                break
           end
        end
    end
end

function TPSelfBuilding:onAddNum(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        -- local str=self.mJoinRoomID:getString()
        -- local tableID = tonumber(str)
        -- local num  = sender.Num
        -- if tableID == nil then
        --     self.mJoinRoomID:setString(num)
        -- else
        --     str = str .. num
        --     self.mJoinRoomID:setString(str)
        -- end
        local flag = true
        for i=1,6 do
            if self:GetWidgetByName("Text_JoinRoom_id"..i):getString() == "" then
                self:GetWidgetByName("Text_JoinRoom_id"..i):setString(sender.Num)
                flag = false
                if i == 6 then
                  flag = true
                end
                break
            end
        end
        if flag == true then
            self:onJoinGame()
        end
    end
end

--加入游戏
function TPSelfBuilding:onJoinGame(sender, eventType)
    --if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)

        local str=""
        for i=1,6 do
            str = str..self:GetWidgetByName("Text_JoinRoom_id"..i):getString()
        end

        local tableID = tonumber(str)
        if str == "" then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "需要输入房号！")
            self:onResetNum()
            return
        end
        if tableID ~= 0 then
            local onSendJoinTable = Packet.new("onSendJoinTable", _LAIXIA_PACKET_CS_JoinTableID)
            onSendJoinTable:setValue("TableID",   tableID);
            laixia.net.sendPacket(onSendJoinTable)
            self:onResetNum()
        else
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "房间不存在")
            self:onResetNum()
            return
        end


    --end
end



--创建房间
function TPSelfBuilding:onCreateRoom(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local roomType = 0
        local createID = 1
        if self.isMenPiao then
           roomType = 1
        else
           roomType = 0 
        end

        if self.mGameType == 2 then
            createID = 1
        elseif self.mGameType == 0 then
            createID = 2 
        else
            createID = 3
        end


         local onSendCreateTable = Packet.new("onSendCreateTable", _LAIXIA_PACKET_CS_CreateTableID)
         onSendCreateTable:setValue("RoomType", roomType);
         onSendCreateTable:setValue("Count", self.mJushu );
         onSendCreateTable:setValue("CreateID", createID);
         onSendCreateTable:setValue("OptionID",self.opID  );
         onSendCreateTable:setValue("difen",self.mDifen);
         laixia.net.sendPacket(onSendCreateTable)
    end
end



function TPSelfBuilding:onDestroy()
    self.callFunc = nil
end

return TPSelfBuilding.new()


