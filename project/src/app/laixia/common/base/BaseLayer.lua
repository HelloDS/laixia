--[[
********************************************************
    @date:       2018-3-14
    @author:     zl
    @version:    1.0
    @describe:   层基类
********************************************************
]]

local CSBHelper = require("common.CSBHelper")
local BaseLayer = class("BaseLayer", function()
    return display.newLayer()
end)

function BaseLayer:ctor(app, name)
    self.app_           = app
    self.name_          = name
    self.resourceNode_  = nil

    CSBHelper.load(self)

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

function BaseLayer:tick(dt)
    if(self.mIsLoad) then
        self:onTick(dt)
    end
end
return BaseLayer