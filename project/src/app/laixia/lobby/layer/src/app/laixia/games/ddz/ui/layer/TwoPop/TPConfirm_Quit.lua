local Confirm_Quit = class("Confirm_Quit", import("...CBaseDialog"):new())-- 
local soundConfig =  laixiaddz.soundcfg
local laixia = laixia;


function Confirm_Quit:ctor(...)    
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG; 
end 

function Confirm_Quit:getName()
    return "Confirm_Quit"
end

function Confirm_Quit:onInit()
    self.super:onInit(self)           
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_ANDROIDBACKTK_WINDOW, handler(self, self.show))    
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_EXITGAME_WINDOW, handler(self, self.exitGame))
end

function Confirm_Quit:onShow()
    self:AddWidgetEventListenerFunction("CQ_Button_Close",handler(self,self.onClose));
    self:AddWidgetEventListenerFunction("CQ_Button_Quit",handler(self,self.onExitGame));
    self:AddWidgetEventListenerFunction("CQ_Button_Start",handler(self,self.onGetCoin));
end


--退出游戏
function Confirm_Quit:onExitGame(sender,eventType)
    if(eventType == ccui.TouchEventType.ended) then  
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)      
        self:exitGame()
    end            
end 

function Confirm_Quit:exitGame()
    if device.platform == "android" then            
        os.exit(); 
    elseif device.platform == "windows" then
        os.exit(); 
    end 
end

function Confirm_Quit:onGetCoin(sender,eventType)
    if(eventType == ccui.TouchEventType.ended) then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
        if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow ~= "CardTableDialog"then
            if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "GameRoomGround" and ui.GameRoomGround.mRoomType ~= nil then
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_QUICKGAME_WINDOW,ui.GameRoomGround.mRoomType)
            else
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_QUICKGAME_WINDOW,0)
            end
        end
        
    end 
end

--离开界面
function Confirm_Quit:onClose(sender,eventType)    
    if(eventType == ccui.TouchEventType.ended) then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy() 
    end            
end

return Confirm_Quit.new()
