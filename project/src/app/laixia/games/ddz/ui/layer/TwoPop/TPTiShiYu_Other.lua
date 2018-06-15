
local TiShiYuOther = class("TiShiYuOther", import("...CBaseDialog"):new())-- 
local soundConfig =  laixiaddz.soundcfg

function TiShiYuOther:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function TiShiYuOther:getZorder()
   return  20 
end

function TiShiYuOther:getName()
    return "TiShiYuOther"
end

function TiShiYuOther:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_TISHIYUOTHER_WINDOW, handler(self, self.show))

end
function TiShiYuOther:onShow(data)
   
    self:AddWidgetEventListenerFunction("TiShiYu_Button_Lift",handler(self,self.onLiftButton))  
    self:AddWidgetEventListenerFunction("TiShiYu_Button_Right", handler(self,self.onRightButton))

    local content_text=self:GetWidgetByName("TiShiYu_Content_Text")
    content_text:setVisible(true)

    self.mLeftFun  = nil
    self.mRightFun = nil

    self._leftCallParam     = data.data.leftParam     or nil;
    self._rightCallParam    = data.data.rightParam    or nil;

    self.mTime = data.data.time   or nil;   --倒计时时间
    self.mRightText = data.data.rightBtnText   or nil;


    if type(data.data) ~= "table" then
        content_text:setString(data.data)
    else
  
        self:GetWidgetByName("TiShiYu_Button_Lift"):setVisible(true)
        self:GetWidgetByName("TiShiYu_Button_Right"):setVisible(true)

        content_text:setString(data.data.mainText)
        self.mLeftFun = data.data.leftCall
        self.mRightFun = data.data.rightCall
        if data.data.leftBtnText ~= nil then
           self:GetWidgetByName("Label_ButtonName_Lift"):setString(tostring(data.data.leftBtnText))
        end

        if data.data.rightBtnText ~= nil then
            if self.mTime ~= nil  then
               self:GetWidgetByName("Label_ButtonName_Right"):setString(tostring(self.mRightText..self.mTime.."s"))
            else
               self:GetWidgetByName("Label_ButtonName_Right"):setString(tostring(self.mRightText))
            end
           
        end

    end
end

function TiShiYuOther:onRightButton(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        if self.mRightFun  ~= nil then
            self.mRightFun (self._rightCallParam)
        end
        self:destroy()
    end
end

function TiShiYuOther:onLiftButton(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        
        if self.mLeftFun  ~= nil then
            self.mLeftFun (self._leftCallParam)
        end
        self:destroy()
    end
end

function TiShiYuOther:closeFunction()
    if self.mLeftFun  ~= nil then
        self.mLeftFun ()
    end
    self:destroy()
end

function TiShiYuOther:onCallBackFunction()
    self:closeFunction()
end

local tempTime = 0
function TiShiYuOther:onTick(dt)
    tempTime =tempTime + dt

    if tempTime >= 1 then
       tempTime = 0
       if self.mTime ~= nil  then
           self.mTime = self.mTime -1
           
           self:GetWidgetByName("Label_ButtonName_Right"):setString(tostring(self.mRightText..self.mTime.."s"))
           if self.mTime  == 0 then
                if self.mLeftFun  ~= nil then
                    self.mLeftFun ()
                end
                self:destroy()
           end

       end

    end

end


function TiShiYuOther:onDestroy()
    self.mLeftFun  = nil
    self.mRightFun = nil
end

return TiShiYuOther.new()


