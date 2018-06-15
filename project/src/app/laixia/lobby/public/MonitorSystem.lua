

import(".MonitorID")

local _M = class("ObjectEventDispatch")
_M.EventIDs = _EventIDs

function _M:ctor(...)
    cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
end

function _M:pushEvent(eventID,msg)
    --msg = msg or "";
    if eventID ~= "_LAIXIA_EVENT_SEND_HEARTTICK_WINDOW" then
        laixia.logGame("ObjectEventDispatch:pushEvent "..(eventID or"").." " ..(tostring(msg or "")));
    end
    self:dispatchEvent({name = eventID,data = msg})
end

function _M:onEnter()
    print("ObjectEventDispatch:onEnter")
end

if(G_MonitorSystem == nil )then
    G_MonitorSystem = _M.new(...)
end

return G_MonitorSystem


