--[[
********************************************************
    @date:       2018-3-14
    @author:     zl
    @version:    1.0
    @describe:   大厅-层基类
********************************************************
]]

local BaseLayer = class("BaseLayer", import("common.base.BaseLayer"))

function BaseLayer:ctor(app, name)
    BaseLayer.super.ctor(self, app, name)
end

return BaseLayer