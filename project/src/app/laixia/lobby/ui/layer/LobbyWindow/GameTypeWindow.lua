
local laixia = laixia;

local soundConfig =  laixia.soundcfg; 
local EffectDict =  laixia.EffectDict; 
local EffectAni = laixia.EffectAni; 

local GameTypeWindow = class("GameTypeWindow", import("...CBaseDialog"):new())

function GameTypeWindow:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
    self.mIsShow = false
end
 
function GameTypeWindow:getName()
    return "GameTypeWindow"
end

function GameTypeWindow:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_GAMETYPE_WINDOW, handler(self, self.show))
end

--经典场 type = 2  （123分）  --欢乐场 type = 0  --癞子场  type = 1
function GameTypeWindow:onShow(msg)
        self.mButtonArray ={}
        self.mTime= 0
       --经典场
        self:AddWidgetEventListenerFunction("Image_GameType_JDC", handler(self, self.onShowRoomGround))
        local temp = {}
        temp.Name = "JDC"
        temp.Button = self:GetWidgetByName("Image_GameType_JDC")
        temp.Button.Type = 2
        table.insert(self.mButtonArray,temp)  
        --癞子场
        self:AddWidgetEventListenerFunction("Image_GameType_LZC", handler(self, self.onShowRoomGround))
        local temp = {}
        temp.Name = "LZC"
        temp.Button = self:GetWidgetByName("Image_GameType_LZC")
        temp.Button.Type = 1
        table.insert(self.mButtonArray,temp)  
       --欢乐场 
        self:AddWidgetEventListenerFunction("Image_GameType_HLC", handler(self, self.onShowRoomGround))
        local temp = {}
        temp.Name = "HLC"
        temp.Button = self:GetWidgetByName("Image_GameType_HLC")
        temp.Button.Type = 0
        --table.insert(self.mButtonArray,temp) 
       --比赛场
        self:AddWidgetEventListenerFunction("Image_GameType_BSC", handler(self, self.onShowGameList))
        local temp = {}
        temp.Name = "BSC"
        temp.Button = self:GetWidgetByName("Image_GameType_BSC")
        table.insert(self.mButtonArray,temp)  
 
       --关闭
       self:AddWidgetEventListenerFunction("Button_GameType_Quit",handler(self, self.onShutDown));       
       self.mTime =  5
       self.mIsShow = true
end
      

function GameTypeWindow:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy() 
    end
end

function GameTypeWindow:onShowRoomGround(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local game_type = sender.Type
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_ROOM_WINDOW,game_type)
    end
end
function GameTypeWindow:onShowGameList(sender, eventtype)
    -- 比赛场按钮回调函数
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SENDRENMAN_GOGAMELIST)
        self:destroy()
    end
end



function GameTypeWindow:addGameAnimation(animationType)
   local mbttonAnimation
   local mBtton = animationType.Button
   local mAniType= animationType.Name 


   if mAniType == "JDC" then
        mbttonAnimation= EffectAni:createAni(EffectDict._ID_DICT_GAMETYPE_JINGDIANCHANG)
   elseif mAniType == "LZC"  then 
        mbttonAnimation= EffectAni:createAni(EffectDict._ID_DICT_GAMETYPE_LAIZICHANG)
   elseif mAniType == "BSC"  then 
        mbttonAnimation= EffectAni:createAni(EffectDict._ID_DICT_TYPE_LOBBY_MATCH)
   elseif mAniType == "HLC"  then 
        mbttonAnimation= EffectAni:createAni(EffectDict._ID_DICT_GAMETYPE_DANJICHANG)
   end
   mbttonAnimation:addTo(mBtton ,4)
   mbttonAnimation:setPosition(cc.p(-45,-23))     

      local icon = self:GetWidgetByName("Image_TypeIcon",mBtton)
         
       local funAction = cc.CallFunc:create(function()
              icon:setVisible(false)
       end)
       local funAction2 = cc.CallFunc:create(function()
              icon:setVisible(true)
              mbttonAnimation:removeFromParent()
       end)


          icon:runAction(
           cc.Sequence:create(
               funAction ,
               cc.DelayTime:create(5),
               funAction2
           ))

end


function GameTypeWindow:onTick(dt)
    if self.mIsShow then
         self.mTime = self.mTime +dt
         if self.mTime > 5 then
            local index =  math.random(1,#self.mButtonArray)
            self.mTime  = 0
            self:addGameAnimation(self.mButtonArray[index])
         end
    end
end

function GameTypeWindow:onDestroy()
  self.mTime =0
  self.mButtonArray ={}
end
return GameTypeWindow.new()
