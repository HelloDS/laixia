
local _UILayer_M = class("UILayer", function()
    return cc.Layer:create()
end )

function _UILayer_M:ctor()
    self:retain()
end


UILayer = _UILayer_M.new()
return UILayer
