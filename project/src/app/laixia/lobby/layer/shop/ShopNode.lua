--
-- Author: Feng
-- Date: 2018-05-03 14:58:54
--

local ShopNode = class("ShopNode" ,function()
    return ccui.Layout:create()--cc.Node:create() 
end)
--[[
    构造函数
]]
function ShopNode:ctor(data)
    self:init(data)
end

--[[
    初始化
]]
function ShopNode:init(data)
--初始化界面
    local csbNode = cc.CSLoader:createNode("new_ui/MallNode.csb")
	csbNode:setAnchorPoint(0, 0)
	csbNode:setPosition(0,0)--display.cx,display.cy)
	self:addChild(csbNode)
	self.rootNode = csbNode
    self.Image_mall = _G.seekNodeByName(self.rootNode,"Image_mall")
    self.Button_buy = _G.seekNodeByName(self.rootNode,"Button_buy")
    self.Text_price = _G.seekNodeByName(self.rootNode,"Text_price")
--    self.Text_time = _G.seekNodeByName(self.rootNode,"Text_time")
    self.Text_price:enableOutline(cc.c4b(153, 108, 67, 255), 2)
end
function ShopNode:initPhoto(data)
	-- self.Image_mall:loadTexture("new_ui/email/tubiao.png")
end
function ShopNode:initTime(str)
	self.Text_time:setString(str)
end
function ShopNode:initContent(str)
	self.Text_content:setString(str)
end
return ShopNode