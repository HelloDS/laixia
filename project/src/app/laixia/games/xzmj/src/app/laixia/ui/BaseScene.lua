

--[[
    场景基础类 何强  
]]--

local BaseScene = class("BaseScene", function()
    return cc.Scene:create()
end)

function BaseScene:ctor()


    --一级弹窗
    self.controllerStack = xzmj.ui.ViewStack.new()
    self.controllerStack:setLocalZOrder(5)
    self.controllerStack:addTo(self)

    --二级弹窗
    self.dialogStack = xzmj.ui.ViewStack.new()
    self.dialogStack:isRetain(true)
    self.dialogStack:setLocalZOrder(10)
    self.dialogStack:addTo(self)

    --错误信息一级层
    self.debuger = xzmj.layer.DebuggerLayer.new() 
    self.debuger:setLocalZOrder(60)
    self.debuger:addTo(self)



    if self.onEnter or self.enterFinish or self.onExit or self.onExitStart or self.onCleanup then
        self:registerScriptHandler(function(event)
            if event == "enter" then
                if type(self.onEnter) == "function" then
                    self:onEnter()
                end
            elseif event == "enterTransitionFinish" then
                if type(self.onEnterFinish) == "function" then
                    self:onEnterFinish()
                end
            elseif event == "exit" then
                if type(self.onExit) == "function" then
                    self:onExit()
                end
            elseif event == "exitTransitionStart" then
                if type(self.onExitStart) == "function" then
                    self:onExitStart()
                end
            elseif event == "cleanup" then
                if type(self.onCleanup) == "function" then
                    self:onCleanup()
                end
            end
        end)
    end
end

function BaseScene:push(controller)
    local currentController = self.controllerStack:currentView()
    if currentController and currentController.__cname == "GameLayer" then
        self.controllerStack:push(controller, false)
    else
        self.controllerStack:push(controller)
    end
end

function BaseScene:pop()
    self.controllerStack:pop()
end

function BaseScene:replace(controller)
    self.controllerStack:replace(controller)
end

function BaseScene:showDialog(dialog)
    self.dialogStack:push(dialog)
end

function BaseScene:dismissDialog()
    self.dialogStack:pop()
end

function BaseScene:disissAllDialog()
    -- self.dialogStack:popAll()
    self.dialogStack:clean()
end

function BaseScene:disissAllView()
    self.controllerStack:popToRoot()
end

function BaseScene:registHintAndAlert()

    xzmj.debuger = self.debuger
end

function BaseScene:onEnter()
    -- self.listener_a = qy.Event.add(qy.Event.SERVICE_LOADING_SHOW,function(event)
    --     self.loading:setVisible(true)
    -- end)

    -- self.listener_b = qy.Event.add(qy.Event.SERVICE_LOADING_HIDE,function(event)
    --     self.loading:setVisible(false)
    -- end)

    -- self.listener_c = qy.Event.add("SDKEvent",function(event)
    --     print("====================>> SDKEvent")
    -- end)

    self:registHintAndAlert()

    xzmj.runningScene = self

end

function BaseScene:onExit()


end

function BaseScene:onCleanup()
end

return BaseScene
