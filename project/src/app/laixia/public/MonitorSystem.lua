

import(".MonitorID")

local _M = class("ObjectEventDispatch")
_M.EventIDs = _EventIDs

function _M:ctor(...)
    cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
end



function _M:pushEvent(eventID,msg)
 
    self:dispatchEvent({name = eventID,data = msg})
end

function _M:removeEvent(eventID)
    self:removeEventListenersByTag(eventID)
end



function _M:onEnter()
    print("ObjectEventDispatch:onEnter")
end



if(G_MonitorSystem == nil )then
    G_MonitorSystem = _M.new(...)
end

return G_MonitorSystem


