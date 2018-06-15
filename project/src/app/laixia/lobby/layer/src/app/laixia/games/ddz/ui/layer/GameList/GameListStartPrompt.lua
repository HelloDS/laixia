
--用于比赛开始闪字

local GameListStartPrompt= class("GameListStartPrompt",import("...CBaseDialog"):new())--

function GameListStartPrompt:ctor(...) --
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG      
    self.mesg=""
  
end

function GameListStartPrompt:getName()
	return "GameListStartPrompt"
end

function GameListStartPrompt:onInit()
    self.super:onInit(self) 
    self:SetShowColorLayerFunc(false);
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_MATCHFLICKERWORDS_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_ADD_MATCHFLICKERWORDS_WINDOW,handler(self,self.addMesg))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_MATCHFLICKERWORDS_WINDOW, handler(self, self.destroy))
end

function GameListStartPrompt:addMesg(msg)
    self.mesg= msg.data
end

function GameListStartPrompt:onShow(msg)
    if  msg.data == nil then
        if self.mesg == "" or self.mesg == nil then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHFLICKERWORDS_WINDOW)
        end
    else
        self:addMesg(msg.data)
    end
    if self.mesg==nil or self.mesg == "" then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHFLICKERWORDS_WINDOW)
    else
        self:GetWidgetByName("Label_GameStart_Rule"):setString(self.mesg)
        self.time =0
    end
end

function GameListStartPrompt:onTick(dt)
 if self.mIsLoad == true then
    self.time = self.time + dt
    if self.time > 3 then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHFLICKERWORDS_WINDOW)
    end
  end
end


function GameListStartPrompt:onDestroy()
	self.time = 0
    self.mesg=""
end

return GameListStartPrompt.new()



