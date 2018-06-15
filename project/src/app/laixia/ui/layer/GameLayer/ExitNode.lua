


local ExitNode = class("ExitNode", import("...BaseView"))

function ExitNode:ctor( delegate )
    ExitNode.super.ctor(self)
    self.delegate = delegate
    self:InjectView("Panel_Node")
    self:InjectView("Closebtn")
    self:InjectView("TitleImage")
    self.TitleImage:setVisible(true)
    --返回主大厅按钮
    self:AddWidgetEventListenerFunction(self.Closebtn,handler(self,self.exitMainLayer))
end

function ExitNode:SetCloseBtn( visible )
    self.Closebtn:setVisible( visible )
end

function ExitNode:GetCsbName()
    return "ExitNode"
end

function ExitNode:exitMainLayer(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:dismiss()
    end
end 

function ExitNode:Closebtnf(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        ObjectEventDispatch:dispatchEvent( { name = xzmj.evt[1], data = "跑马灯说事件派发成功" })
        if self.delegate and self.delegate.closef then

        end
    end
end 


return ExitNode

