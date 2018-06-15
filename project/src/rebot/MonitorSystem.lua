

local MonitorSystem = class("ObjectEventDispatch")

function MonitorSystem:ctor(...)
    cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
end

function MonitorSystem:pushEvent(eventID,msg)
    self:dispatchEvent({name = eventID,data = msg})
end

function MonitorSystem:onEnter()

end

return MonitorSystem.new(...)


