
local TurnWindow = class("TurnWindow", import("...CBaseDialog"):new())-- 
local soundConfig = laixiaddz.soundcfg;     
local Packet = import("....net.Packet") 

local db2 = laixiaddz.JsonTxtData
local itemdbm = db2:queryTable("items");

function TurnWindow:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_SINGLE_DIALOG
    self.mIsShow = false
    self.mIsPlaying = false
end

function TurnWindow:getName()
    return "TurnWindow"
end 

function TurnWindow:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_BIGTURNTABLE_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SENDLOTTRYTMSG_TOTURNTABLE, handler(self, self.DuringPlayingGame))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_REFRESH_TOTURNTABLE_PRICEINFO, handler(self, self.refreshPriceInfo))
    
end
  -- {
  --   {"ID",CDataTypeObj.Int},
  --   {"ItemID",CDataTypeObj.Int},
  --   {"Num",CDataTypeObj.Int}, 
  --   {"Name",CDataTypeObj.UTF8},
  -- }

function TurnWindow:refreshPriceInfo(data)
    if self.mIsShow== true then
        local userdefault = cc.UserDefault:getInstance()
        for i=1,3 do 
            local name = userdefault:getStringForKey("FirstName_" .. i)
            local price = userdefault:getStringForKey("FirstPrice_" .. i)
            if name == nil or price == nil then
                userdefault:setStringForKey(("FirstName_" .. i),"")
                userdefault:setStringForKey(("FirstPrice_" .. i),"")
            end
        end 

        local name2 = userdefault:getStringForKey("FirstName_2")
        local price2 = userdefault:getStringForKey("FirstPrice_2")
        local name3 = userdefault:getStringForKey("FirstName_3")
        local price3 = userdefault:getStringForKey("FirstPrice_3")
        if name3 ~= "" then
            userdefault:setStringForKey("FirstName_1",name2)
            userdefault:setStringForKey("FirstName_2",name3)
            userdefault:setStringForKey("FirstName_3",data.data.text)

            userdefault:setStringForKey("FirstPrice_1",price2)
            userdefault:setStringForKey("FirstPrice_2",price3)
            userdefault:setStringForKey("FirstPrice_3",data.data.award)

            self:GetWidgetByName("Text_NickName1"):setString(name2)
            self:GetWidgetByName("Text_NickName2"):setString(name3)
            self:GetWidgetByName("Text_NickName3"):setString(data.data.text)
            self:GetWidgetByName("Text_Award1"):setString(price2)
            self:GetWidgetByName("Text_Award2"):setString(price3)
            self:GetWidgetByName("Text_Award3"):setString(data.data.award)
        else
            userdefault:setStringForKey("FirstName_3",data.data.text)
            userdefault:setStringForKey("FirstPrice_3",data.data.award)
            self:GetWidgetByName("Text_NickName3"):setString(data.data.text)
            self:GetWidgetByName("Text_Award3"):setString(data.data.award)
        end

        laixiaddz.LocalPlayercfg.TurnWindow_NickName = data.data.text
        laixiaddz.LocalPlayercfg.TurnWindow_Award = data.data.award
    end
end
function TurnWindow:refreshTurnData(type)
    --选中
    for k,v in pairs(self.dataInfo.turnTableInfo) do
        if v.Type == type then
            local index = v.Index%12
            if index == 0 then
                index = 12
            end
            local panel = self:GetWidgetByName("Panel_"..(index),self.Image_zhuanpan)
            local image_icon = self:GetWidgetByName("Image_award",panel)
            local item = itemdbm:query("ItemID",v.ItemID);
            --加载奖励图标
            if v.ItemID == 9999 then
                image_icon:loadTexture("new_ui/TurnWindow/zailaiyici.png") 
                local item = {}
                item.ItemName = ""
                image_icon:setScale(0.9)
            else
                local baoming_Array = string.split(item.ImagePath ,'/')
                if #baoming_Array >1 then
                   image_icon:loadTexture(item.ImagePath)
                else
                    image_icon:loadTexture(item.ImagePath, 1)         
                end
                image_icon:setScale(0.5)
            end

            local Text_Award = self:GetWidgetByName("Text_Award",panel)
            --Text_Award:setString(v.ItemName)
            if v.ItemID == 9999 or v.ItemID == 9998 then
                Text_Award:setString("1")
            else
                Text_Award:setString(laixiaddz.helper.numeralRules_2( v.Num)) --这里要缩写
            end
        end 
        --检查前够不够
        local checkData = 0
        if type == 2 then
            checkData = self.dataInfo.CostMid
        elseif type == 3 then
            checkData = self.dataInfo.CostBig
        end
        if laixiaddz.LocalPlayercfg.LaixiaPlayerGold>=checkData or type == 1 then
            if type == 1 and self.FreeTime <= 0 then
                 self.Button_start:setVisible(false)
                 self.Button_start_Enable:setVisible(true)
            else
                self.Button_start:setVisible(true)
                self.Button_start_Enable:setVisible(false)
            end
        else
            self.Button_start:setVisible(false)
            self.Button_start_Enable:setVisible(true)
        end
    end 
end
function TurnWindow:onButtonHigh1(sender,eventType)
     if eventType == ccui.TouchEventType.ended then
        if self.mIsPlaying == true then
            return
        end
        self.Button_high_1:setVisible(false)
        self.Button_high_2:setVisible(true)
        self.Button_Low_1:setVisible(true)
        self.Button_Low_2:setVisible(false)
        --免费次数为0 开始按钮不可点
        self.TurnTableType = 3
          
        self:refreshTurnData(3)
    end
end
function TurnWindow:onButtonHigh2(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.mIsPlaying == true then
            return
        end
        self.Button_high_1:setVisible(true)
        self.Button_high_2:setVisible(false)
        self.TurnTableType = 1
        if self.FreeTime <= 0 then
            self.Button_start:setVisible(false)
            self.Button_start_Enable:setVisible(true)
        else
            self:refreshTurnData(1)
        end
    end
end
function TurnWindow:onButtonLow1(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.mIsPlaying == true then
            return
        end
        self.Button_Low_1:setVisible(false)
        self.Button_Low_2:setVisible(true)
        self.Button_high_1:setVisible(true)
        self.Button_high_2:setVisible(false)

        self.TurnTableType = 2
        
        self:refreshTurnData(2)
    end
end

function TurnWindow:onButtonLow2(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.mIsPlaying == true then
            return
        end
        self.Button_Low_1:setVisible(true)
        self.Button_Low_2:setVisible(false)
        self.TurnTableType = 1
        if self.FreeTime <= 0 then
            self.Button_start:setVisible(false)
            self.Button_start_Enable:setVisible(true)
        else
            self:refreshTurnData(1)
        end
    end
end

function TurnWindow:onShow(data)
    if self.mIsShow == false then
        self:setAdaptation()
        self.Panel_Award = self:GetWidgetByName("Panel_Award")
        self.Panel_Award:addTouchEventListener(handler(self, self.onClosePrize))
        self.Node_Anim = self:GetWidgetByName("Node_1",self.Panel_Award )
        self.Image_Award = self:GetWidgetByName("Image_Award",self.Panel_Award )
        self.Text_Award = self:GetWidgetByName("Text_Award",self.Panel_Award)
--        self.Text_Award:setVisible(false)
        self.Panel_Award:setVisible(false)
        

        self.Player_Gold = self:GetWidgetByName("Text_PlayerGold")
        self.Player_Gold:setString(laixiaddz.LocalPlayercfg.LaixiaPlayerGold)
        self.dataInfo = data.data
    
        self.TurnTableType = 1--默认免费
        self.Button_high_1 = self:GetWidgetByName("Button_High_1")
        self.Button_high_2 = self:GetWidgetByName("Button_High_2")
        self.Button_Low_1 = self:GetWidgetByName("Button_Low_1")
        self.Button_Low_2 = self:GetWidgetByName("Button_Low_2")
    
        self.Button_start = self:GetWidgetByName("Button_start")
        self.Button_start:addTouchEventListener(handler(self, self.PlayTurn))
        self.Button_start_Enable = self:GetWidgetByName("Button_start_Enable")
        self.Button_start_Enable:addTouchEventListener(handler(self,self.onTips))
    
        self.Button_Close = self:GetWidgetByName("Button_Close")
        self.Button_Close:addTouchEventListener(handler(self,self.onClose))
        
        -- self.AgainTime = self.dataInfo.AgainTime or 0  --新增免费抽奖次数字段
        self.FreeTime = self.dataInfo.FreeTime or 0
        self.Text_Free_Time = self:GetWidgetByName("Text_FreeTime")
        self.Text_Free_Time:setString("剩余免费次数"..(self.FreeTime or 0))
    
        if self.FreeTime<= 0 then
            self.Button_start:setVisible(false)
            self.Button_start_Enable:setVisible(true)
        else
            self.Button_start:setVisible(true)
            self.Button_start_Enable:setVisible(false)
        end
    
        self.Button_high_1:setVisible(true)
        self.Button_high_2:setVisible(false)
        self.Button_high_1:addTouchEventListener(handler(self, self.onButtonHigh1))
        self.Button_high_2:addTouchEventListener(handler(self, self.onButtonHigh2))
    
        self.Button_Low_1:setVisible(true)
        self.Button_Low_2:setVisible(false)
        self.Button_Low_1:addTouchEventListener(handler(self, self.onButtonLow1))
        self.Button_Low_2:addTouchEventListener(handler(self, self.onButtonLow2))
        
        self.Image_zhuanpan = self:GetWidgetByName("Image_zhuanpan")
        
        self:refreshTurnData(1)
    
        self.Text_Hight_Cost_1 = self:GetWidgetByName("Text_Cost",self.Button_high_1 )
        self.Text_Hight_Cost_2 = self:GetWidgetByName("Text_Cost",self.Button_high_2 )
        self.Text_Hight_Cost_1:setString(self.dataInfo.CostBig)
        self.Text_Hight_Cost_2:setString(self.dataInfo.CostBig)
        self.Text_Low_Cost_1 = self:GetWidgetByName("Text_Cost",self.Button_Low_1 )
        self.Text_Low_Cost_2 = self:GetWidgetByName("Text_Cost",self.Button_Low_2 )
        self.Text_Low_Cost_1:setString(self.dataInfo.CostMid)
        self.Text_Low_Cost_2:setString(self.dataInfo.CostMid)
    
        self.anim_node = self:GetWidgetByName("Sprite_Anim")

        ---------------add by feng 修改后台数据之后的
        local userdefault = cc.UserDefault:getInstance()
        for key,value in pairs(self.dataInfo.TurnTableRewards) do
            if value ~= nil then
                self:GetWidgetByName("Text_NickName" .. key):setString(value.Name)
                userdefault:setStringForKey(("FirstName_" .. key),value.Name)
                local awardName = ""
                local item = itemdbm:query("ItemID",value.ItemID);

                if value.ItemID == 9999 then
                     self:GetWidgetByName("Text_Award"..key):setString("")
                     userdefault:setStringForKey(("FirstPrice_" .. key),"")
                elseif (item~=nil and item.ItemType == 3 ) then
                     self:GetWidgetByName("Text_Award"..key):setString(item.ItemName)
                     userdefault:setStringForKey(("FirstPrice_" .. key),item.ItemName)
                else
                     self:GetWidgetByName("Text_Award"..key):setString(laixiaddz.helper.numeralRules_2( value.Num)..item.ItemName) --这里要缩写
                     userdefault:setStringForKey(("FirstPrice_" .. key),laixiaddz.helper.numeralRules_2( value.Num)..item.ItemName)
                end
            else
                local name = userdefault:getStringForKey("FirstName_" .. key)
                local price = userdefault:getStringForKey("FirstPrice_" .. key)
                if name == nil or name == "" then
                    self:GetWidgetByName("Text_NickName" .. key):setString("")
                    self:GetWidgetByName("Text_Award"..key):setString("")
                else
                    self:GetWidgetByName("Text_NickName" .. key):setString(name)
                    self:GetWidgetByName("Text_Award"..key):setString(award)
                end
            end
        end
        ---------------

        ---------------add by feng 接着之前的写的
        -- local userdefault = cc.UserDefault:getInstance()
        --  for key,value in pairs(self.dataInfo.TurnTableRewards) do
        --      local name = userdefault:getStringForKey("FirstName_" .. key)
        --      local price = userdefault:getStringForKey("FirstPrice_" .. key)
        --      if  name == nil or name == "" then
        --          self:GetWidgetByName("Text_NickName"..key):setString(value.Name)
        --          userdefault:setStringForKey(("FirstName_" .. key),value.Name)
        --          local awardName = ""
        --          local item = itemdbm:query("ItemID",value.ItemID);
        --          if value.ItemID == 9999 then
        --             self:GetWidgetByName("Text_Award"..key):setString("")
        --             userdefault:setStringForKey(("FirstPrice_" .. key),"")
        --          elseif (item~=nil and item.ItemType == 3 ) then
        --              self:GetWidgetByName("Text_Award"..key):setString(item.ItemName)
        --              userdefault:setStringForKey(("FirstPrice_" .. key),item.ItemName)
        --          else
        --              self:GetWidgetByName("Text_Award"..key):setString(laixiaddz.helper.numeralRules_2( value.Num)..item.ItemName) --这里要缩写
        --              userdefault:setStringForKey(("FirstPrice_" .. key),laixiaddz.helper.numeralRules_2( value.Num)..item.ItemName)
        --          end
        --      else
        --         self:GetWidgetByName("Text_Award" .. key):setString(price)
        --         self:GetWidgetByName("Text_NickName" .. key):setString(name)
        --      end
        --  end

        --  local name_3 = userdefault:getStringForKey("FirstName_3")
        --  local price_3 = userdefault:getStringForKey("FirstPrice_3")
        --  if  name_3 == nil or price_3 == "" then
        --      laixiaddz.LocalPlayercfg.TurnWindow_NickName = cc.UserDefault:getInstance():getStringForKey("turn_name")
        --      laixiaddz.LocalPlayercfg.TurnWindow_Award = cc.UserDefault:getInstance():getStringForKey("turn_award")
        --      if laixiaddz.LocalPlayercfg.TurnWindow_NickName~=nil then
        --         self:GetWidgetByName("Text_NickName3"):setString(laixiaddz.LocalPlayercfg.TurnWindow_NickName )
        --         userdefault:setStringForKey(("FirstName_3"),laixiaddz.LocalPlayercfg.TurnWindow_NickName)
        --     end
        --     if laixiaddz.LocalPlayercfg.TurnWindow_Award~=nil then
        --          self:GetWidgetByName("Text_Award3"):setString(laixiaddz.LocalPlayercfg.TurnWindow_Award )
        --          userdefault:setStringForKey(("FirstPrice_3"),laixiaddz.LocalPlayercfg.TurnWindow_Award)
        --      end 
        --  else
        --     self:GetWidgetByName("Text_Award3"):setString(price_3)
        --     self:GetWidgetByName("Text_NickName3"):setString(name_3)
        --  end
        ---------------


        --之前的代码
        -- for key,value in pairs(self.dataInfo.TurnTableRewards) do
        --     self:GetWidgetByName("Text_NickName"..key):setString(value.Name)
        --     local awardName = ""
        --     local item = itemdbm:query("ItemID",value.ItemID);

        --      if value.ItemID == 9999 then
        --         self:GetWidgetByName("Text_Award"..key):setString("")
        --     elseif (item~=nil and item.ItemType == 3 ) then
        --         self:GetWidgetByName("Text_Award"..key):setString(item.ItemName)
        --     else
        --         self:GetWidgetByName("Text_Award"..key):setString(laixiaddz.helper.numeralRules_2( value.Num)..item.ItemName) --这里要缩写
        --     end
        -- end

        -- laixiaddz.LocalPlayercfg.TurnWindow_NickName = cc.UserDefault:getInstance():getStringForKey("turn_name")
        -- laixiaddz.LocalPlayercfg.TurnWindow_Award = cc.UserDefault:getInstance():getStringForKey("turn_award")
        -- if laixiaddz.LocalPlayercfg.TurnWindow_NickName~=nil then
        --     self:GetWidgetByName("Text_NickName3"):setString(laixiaddz.LocalPlayercfg.TurnWindow_NickName )
        -- end
        -- if laixiaddz.LocalPlayercfg.TurnWindow_Award~=nil then
        --     self:GetWidgetByName("Text_Award3"):setString(laixiaddz.LocalPlayercfg.TurnWindow_Award )
        -- end    
        
--        self.anim_click = display.newSprite("res/new_ui/TurnWindow/zhuanpandi.png")
--        self.anim_click:setAnchorPoint(cc.p(0.5,0.5))
--        self.anim_click:addTo(self.anim_node)

       local system = laixiaddz.ani.CocosAnimManager
        self.anim_idle = system:playAnimationAt(self.anim_node,"doudizhu_turntable_idle")
        
--        local system = laixiaddz.ani.CocosAnimManager
--        self.anim_idle_playing = system:playAnimationAt(self.anim_node,"doudizhu_turntable_click")
--        self.anim_idle_playing:setVisible(false)
       
        self.mIsShow = true
   end
end
function TurnWindow:PlayTurn(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        --Image_zhuanpa
        local cost = 0
        if self.TurnTableType == 1 then 
            self.FreeTime = self.FreeTime - 1
            self.Text_Free_Time:setString("剩余免费次数"..(self.FreeTime or 0))    
        elseif self.TurnTableType == 2 then 
            cost = self.dataInfo.CostMid
        elseif self.TurnTableType == 3 then
            cost = self.dataInfo.CostBig
        end
        laixiaddz.LocalPlayercfg.LaixiaPlayerGold = laixiaddz.LocalPlayercfg.LaixiaPlayerGold - cost
        self.Player_Gold:setString(laixiaddz.LocalPlayercfg.LaixiaPlayerGold)
        
        self.mIsPlaying = true
        self.Button_start:setVisible(false)
        self.Button_start_Enable:setVisible(true)
        local stream = Packet.new("CSTurntableLotter", _LAIXIA_PACKET_CS_TurnTableLotteryID)
        stream:setValue("HttpCode", laixiaddz.LocalPlayercfg.LaixiaHttpCode) 
        stream:setValue("TurnTableType", self.TurnTableType)
        laixia.net.sendHttpPacketAndWaiting(stream)
    end
end
function TurnWindow:onClose(sender,eventType)
    if eventType ==  ccui.TouchEventType.ended then
    laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        if self.mIsPlaying == true then
        else
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW)
        end 
    end
end

function TurnWindow:onTips(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.mIsPlaying == false then  
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"你的抽奖次数为零或者金币不足")
        end
    end
end

function TurnWindow:onClosePrize(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.Award_node then
            self.Award_node:removeFromParent()
            self.Award_node = nil 
        end
        self.Panel_Award:setVisible(false)
        self.Player_Gold:setString(laixiaddz.LocalPlayercfg.LaixiaPlayerGold)
    end
end
--zhuanb
function TurnWindow:DuringPlayingGame(data)
    --这里要开始播动画 并且开始转盘
    laixiaddz.soundTools.playSound(soundConfig.EVENT_SOUND.ui_event_lobby_wheel)
    self.anim_idle:setVisible(false)
    if not self.anim_idle_playing then
        local system = laixiaddz.ani.CocosAnimManager
        self.anim_idle_playing = system:playAnimationAt(self.anim_node,"doudizhu_turntable_click")
     end
    self.anim_idle_playing:setVisible(true)
    
    local index = data.data.hitIndex%12
    if index == 0 then
        index = 12
    end
    local start = self.Image_zhuanpan:getRotation()%360
    --local start = self.anim_click:getRotation()%360
    local Angle = -(360-( index -1)*30-start)  /12 --平均分配到12组里
    
    local action = cc.RotateBy:create(1,-(360+Angle))
    local action1 = cc.RotateBy:create(50/60,-(360+Angle))
    local action2 = cc.RotateBy:create(35/60,-(360+Angle))
    local action3 = cc.RotateBy:create(30/60,-(360+Angle))
    local action4 = cc.RotateBy:create(25/60,-(360+Angle))
    local action5 = cc.RotateBy:create(43/60,-(360+Angle))
    local action6 = cc.RotateBy:create(45/60,-(360+Angle))
    local action7 = cc.RotateBy:create(50/60,-(360+Angle))
    local action8 = cc.RotateBy:create(45/60,-(360+Angle))
    local action9 = cc.RotateBy:create(25/60,-(180+Angle))
    local action10 = cc.RotateBy:create(29/60,-(90+Angle))
    local action11 = cc.RotateBy:create(80/60,-(90+Angle))
--    local action10 = cc.RotateBy:create(23/60,-(90+Angle))
--    local action11 = cc.RotateBy:create(66/60,-(270+Angle))
    --最后要转到
    --self.anim_click
    --,action10,action11
    self.Image_zhuanpan:runAction(cc.Sequence:create(action,action1,action2,action3,action4,action5,action6,action7,action8,action9,action10,action11,cc.CallFunc:create(function()
        --弹出获得奖励界面 TODO
        --物品数量 data.data.ItemNum 
        --物品ID data.data.ItemID
        ------------------------------------------
        -- self.Node_1
        -- self.image_jl
        -- self.text_name
        -- self.text_num
        -- self.button_close
        if self.anim_idle_playing then
--                self.anim_idle_playing:removeFromParent()
            self.anim_idle_playing = nil
        end
        self.anim_idle:setVisible(true)
        self.Image_zhuanpan:performWithDelay(handler(self,function()
           
            local isShowAward = false
            if data.data.ItemID == 9999 then
                local system = laixiaddz.ani.CocosAnimManager
                self.Award_node = system:playAnimationAt(self.Node_Anim,"doudizhu_turntable_ordinary")
                self.Award_node:setLocalZOrder(1005)
                isShowAward = true
            elseif data.data.ItemID==9998 then -- 如果字段==大奖
                -- self.BG = display.newColorLayer(cc.c4b(128,128,128,120))
                -- self.BG:setPosition(cc.p(0,0))
                -- self.BG:setLocalZOrder(10)
                -- self.BG:addTo(display.getRunningScene())
                local system = laixiaddz.ani.CocosAnimManager
                self.Award_node = system:playAnimationAt(self.Node_Anim,"doudizhu_turntable_bigprize")
                self.Award_node:setLocalZOrder(1005)
                isShowAward = true
                -- self.BG:runAction(cc.Sequence:create(
                --     cc.DelayTime:create(2),
                --     cc.CallFunc:create(
                --         function()
                --             self.BG:removeFromParent()
                --         end)))
            else
                -- self.BG = display.newColorLayer(cc.c4b(128,128,128,120))
                -- self.BG:setPosition(cc.p(0,0))
                -- self.BG:setLocalZOrder(3)
                -- self.BG:addTo(display.getRunningScene())
                local system = laixiaddz.ani.CocosAnimManager
                self.Award_node = system:playAnimationAt(self.Node_Anim,"doudizhu_turntable_ordinary")
                self.Award_node:setLocalZOrder(1005)
                isShowAward = true
                -- self.BG:runAction(cc.Sequence:create(
                --     cc.DelayTime:create(2),
                --     cc.CallFunc:create(
                --         function()
                --             self.BG:removeFromParent()
                --         end)))
            end
            if isShowAward then
                self.Panel_Award:setVisible(true)
                local Itemsdata = itemdbm:query("ItemID",data.data.ItemID)
                
                local baoming_Array = string.split(Itemsdata.ImagePath ,'/')
                if #baoming_Array >1 then
                    if data.data.ItemID == 1001 then
                        self.Image_Award:loadTexture("new_ui/TurnWindow/jinbi_1.png")
                        self.Image_Award:setScale(1.0)
                    else
                        self.Image_Award:loadTexture(Itemsdata.ImagePath)
                    end
                    -- local sprite = display.newSprite(Itemsdata.ImagePath)
                    -- sprite:setAnchorPoint(cc.p(0.5,0.5))
                    -- sprite:setScale(1.5)
                    -- sprite:addTo(self.Image_Award)
                    -- if data.data.ItemID ~= 1001 then
                    --     self.Image_Award:loadTexture(Itemsdata.ImagePath)
                    -- end
                else
                    self.Image_Award:removeAllChildren()
                    self.Image_Award:loadTexture(Itemsdata.ImagePath, 1) 
                    self.Image_Award:setScale(1.5)        
                    if data.data.ItemID == 1001 then
                        self.Image_Award:loadTexture("new_ui/TurnWindow/jinbi_1.png")
                        self.Image_Award:setScale(1.0)
                    elseif data.data.ItemID == 9999 then
                        self.Image_Award:loadTexture("new_ui/TurnWindow/zhuanpan_song.png") 
                        self.Image_Award:setScale(1.3) 
                    end
                end
                
                
                self.Text_Award:setString(data.data.ItemNum)
                
                if data.data.ItemID == 9999 then
                    self.Text_Award:setString("再来一次")
                end

                self.Panel_Award:performWithDelay(handler(self,function()
                    if  self.Award_node then
                        self.Award_node:removeFromParent()
                        self.Award_node = nil 
                    end
                    self.Panel_Award:setVisible(false)
                    self.Player_Gold:setString(laixiaddz.LocalPlayercfg.LaixiaPlayerGold)
                end),2)
            end
--            self.anim_idle_playing:setVisible(false)
            
            laixiaddz.LocalPlayercfg.LaixiaPlayerGold = data.data.GoldNum
            
            local HoldNum = 0
            local isNeedCheckCoin = false
            
            -- self.AgainTime = data.data.AgainTime or 0
            self.FreeTime = data.data.FreeTime
            self.Text_Free_Time:setString("剩余免费次数"..(self.FreeTime or 0))
            if self.TurnTableType==1 then
                if self.FreeTime <= 0 then
                    self.Button_start:setVisible(false)
                    self.Button_start_Enable:setVisible(true)
                else
                    self.Button_start:setVisible(true)
                    self.Button_start_Enable:setVisible(false)
                end
                isNeedCheckCoin = false
                HoldNum = 0
            elseif self.TurnTableType==2 then
                HoldNum = self.dataInfo.CostMid
                isNeedCheckCoin = true
            elseif self.TurnTableType == 3 then
                HoldNum = self.dataInfo.CostBig
                isNeedCheckCoin = true
            end
            if isNeedCheckCoin == true then
                if laixiaddz.LocalPlayercfg.LaixiaPlayerGold>=HoldNum then
                    self.Button_start:setVisible(true)
                    self.Button_start_Enable:setVisible(false)
                else
                    self.Button_start:setVisible(false)
                    self.Button_start_Enable:setVisible(true)
                end
            end
            self.mIsPlaying = false
        end),1)
        -----------------------------------------------------
        --下面这句 在关闭奖励界面后调用
        --转完了 刷新下界面状态
        
    end)))

end

function TurnWindow:setAdaptation()
    if device.platform == "ios" then
        --暂时先 适配 iphoneX
        if display.widthInPixels  == 2436 and display.heightInPixels == 1125 then
            self:GetWidgetByName("Image_1"):setScaleX(2436/3*2/1280)
        end
    end
end
  -- {"StatID",Type.Short} ,
  --       -- 中奖命中
  --       { "hitIndex", Type.Int },
  --       -- 摇奖时间
  --       { "rollTime", Type.Int },
  --       { "JiangquanNum", Type.Int },
  --       { "GoldNum", Type.Double },
function TurnWindow:onDestroy()
    self.mIsShow = false
    self.anim_idle_playing = nil
    self.anim_idle = nil
end

return TurnWindow.new()
