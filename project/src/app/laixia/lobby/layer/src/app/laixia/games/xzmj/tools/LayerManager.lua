--[[
********************************************************
    @date:       2018-3-9
    @author:     zl
    @version:    1.0
    @describe:   斗地主游戏层堆栈管理器
********************************************************
]]

local LayerManager = class("LayerManager", import("common.base.BaseLayerManager"))

-----------------------------------------------------------------------
function LayerManager:ctor(root)
    LayerManager.super:ctor(self)
    app.m_layerManager = self
end

return LayerManager