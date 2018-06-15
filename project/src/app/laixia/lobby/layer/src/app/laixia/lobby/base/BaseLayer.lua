--[[
    大厅层基类
]]
local BaseLayer = class("BaseLayer", function()
    return display.newLayer()
end)

function BaseLayer:ctor(app, name)
    self.app_           = app
    self.name_          = name
    self.resourceNode_  = nil

    if self.init then self:init() end
end

function BaseLayer:getApp()
    return self.app_
end

function BaseLayer:getName()
    return self.name_
end

function BaseLayer:getResourceNode()
    return self.resourceNode_
end

return BaseLayer