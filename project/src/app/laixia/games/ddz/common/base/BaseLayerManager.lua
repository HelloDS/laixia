--[[
********************************************************
    @date:       2018-3-14
    @author:     zl
    @version:    1.0
    @describe:   基类-层堆栈管理器
********************************************************
]]

local BaseLayerManager = class("BaseLayerManager")

-----------------------------------------------------------------------
function BaseLayerManager:ctor(root)
    self.moving = false
    self.root   = root
    self.layers = {}
end

function BaseLayerManager:pushLayer(layer)
    if (not layer) then
        dump(layer,"argment layer error for: ")
        return
    end

    if self.moving then 
        return
    end
    self.moving = true

    self:check(layer)
    local scene = cc.Director:getInstance():getRunningScene()
    layer.parentLayer = (#self.layers == 0) and self.root or self.layers[#self.layers]

    table.insert(self.layers,layer)    

    layer:addTo(scene)
--    layer:startMove(handler(self,self.setMoving))--fix me 此处处理界面打开问题 因为界面打开需要一定时间
end

function BaseLayerManager:check(layer)
    if (not layer.key or "function" ~= type(layer.key) or not layer.canRepeat or "function" ~= type(layer.canRepeat)) then
        return
    end

    if (layer:canRepeat()) then
        return
    end

    local index     = nil
    local curKey    = layer:key()
    for i, value in ipairs(self.layers) do
        if (value.key and "function" == type(value.key) and curKey == value.key()) then
            index = i
            break
        end 
    end  
    
    if (nil~=index) then
        self:popTo(index)
    end
end

function BaseLayerManager:popTo(index)
    for i = #self.layers, 1, -1 do
        local layer = table.remove(self.layers,i)
        if(layer and layer.onExit and type(layer.onExit)=="function")then
            layer:onExit()
        end
        layer:endMoveNow()
        if (i == index) then
            break
        end 
    end    
end

function BaseLayerManager:pop()
    if self.moving then return end
    self.moving = true;

    local lastLayer = table.remove(self.layers,#self.layers); 
    if(lastLayer and lastLayer.onExit and type(lastLayer.onExit)=="function")then
        lastLayer:onExit()
    end
    
    lastLayer:endMove(handler(self,self.setMoving))
end

function BaseLayerManager:clear()
    while(#self.layers > 0)
    do
        local lastLayer = self.layers[#self.layers]
        if(lastLayer.onExit and type(lastLayer.onExit)=="function")then
            lastLayer:onExit()
        end
        lastLayer:removeFromParent()  
        table.remove(self.layers)
    end
end

function BaseLayerManager:setMoving()
    self.moving = false
end

function BaseLayerManager:setAllVisable(bool)
    for _,v in ipairs(self.layers) do
        local lastLayer = self.layers[#self.layers]
        v:setVisible(bool)
    end
end

return BaseLayerManager