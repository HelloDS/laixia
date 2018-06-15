--
-- Author: Feng
-- Date: 2018-05-03 14:58:30
--
local ActivityNode = class("ActivityNode" ,function()
    return ccui.Layout:create() 
end)

function ActivityNode:ctor()
    self:init()
end

function ActivityNode:init()
    local pen = ccui.Layout:create() 
    self:addChild(pen)
    local csbNode = cc.CSLoader:createNode("new_ui/ActivityNode.csb")
    csbNode:setAnchorPoint(0, 0)
    pen:addChild(csbNode)
    self.rootNode = csbNode
    self.Button_activity = _G.seekNodeByName(self.rootNode,"Button_activity")
    self.Text_activity = _G.seekNodeByName(self.rootNode,"Text_activity")
    self.Text_activity:setFontSize(26)

    self.Button_activity:setSwallowTouches(false)
    self.Button_activity:addTouchEventListener( function ( sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            self.mlayer:changePage( self.tag )
            self:setBtnOpacity( true )
        end 
    end)
end

function ActivityNode:changeTitle(data)
    local str = data
    self.Text_activity:setString(data)
end

function ActivityNode:Update( layer )
    self.mlayer = layer
end

--[[
    设置按钮点击和没有点击得状态
]]--
function ActivityNode:setBtnOpacity( _ty )
    if _ty then
        self.Button_activity:setOpacity(255)
    else
        self.Button_activity:setOpacity(125)
    end
end


return ActivityNode