--[[
    此处存放来下游戏公用接口函数
            此处存放函数必须用_G开头，输入输出添加注释
]]

---获取大小宽高，或者宽高的一半
--常用代码段，用于返回不需要处理的node , #if not node then return nil end#
--获取大小的方法对于gui也适用。
SIZE = function(node) 
if not node then return nil end 
local size = node:getContentSize()
if size.width == 0 and size.height == 0 and type(node.getLayoutSize) == "function" then
    local w,h = node:getLayoutSize()
    return cc.size(w,h)
else 
    return size
end
end
W = function(node) if not node then return nil end  return SIZE(node).width; end
W2 = function(node) if not node then return nil end  return W(node)/2;end
H = function(node) if not node then return nil end  return SIZE(node).height; end
H2 = function(node) if not node then return nil end  return H(node)/2;end
S_SIZE = function(node,w,h) if not node then return nil end  return node:setContentSize(cc.size(w,h)); end
S_W = function(node,w) if not node then return nil end  return node:setContentSize(cc.size(w,H(node))); end
S_H = function(node,h) if not node then return nil end  return node:setContentSize(cc.size(W(node),h)); end

---获取坐标及设置坐标
X = function(node) if not node then return nil end  return node:getPositionX(); end
Y = function(node) if not node then return nil end  return node:getPositionY(); end
XY = function(node) if not node then return nil end  return node:getPosition(); end
S_X = function(node,x) if not node then return nil end  node:setPosition(cc.p(x,Y(node))); end
S_Y = function(node,y) if not node then return nil end  node:setPosition(cc.p(X(node),y)); end
S_XY = function(node,x,y) if not node then return nil end  node:setPosition(x,y); end

--居中A显示。A的描点为0,0     set point center
S_XY_C = function(a)
    S_XY(a,W2(a:getParent())-W2(a),H2(a:getParent())-H2(a))
end
--见SET_POINT_CENTER。    set point center
S_XY_C0 = S_P_CENTER
--居中A显示。A的描点为0.5,0.5    set point center
S_XY_C5 = function(a)
    S_XY(a,W2(a:getParent()),H2(a:getParent()))
end

---描点相关方法。
AX = function(node) if not node then return nil end  return node:getAnchorPoint().x; end
AY = function(node) if not node then return nil end  return node:getAnchorPoint().y; end
AXY = function(node) if not node then return nil end  return node:getAnchorPoint(); end
S_AX = function(node,x) if not node then return nil end  node:setAnchorPoint(cc.p(x,AY(node))); end
S_AY = function(node,y) if not node then return nil end  node:setAnchorPoint(cc.p(AX(node),y)); end
S_AXY = function(node,x,y) if not node then return nil end  node:setAnchorPoint(x,y); end

--[[
    通用按钮点击事件(放大缩小效果)
]]
function _G.onTouchButton(eventObj, eventType)
    local function setButtonEffect(node, start)
        local small = cc.ScaleTo:create(0.005 , 0.95 , 0.95)
        local big = cc.ScaleTo:create(0.003 , 1.05 , 1.05)
        local normal = cc.ScaleTo:create(0.02 , 1, 1)

        if start then
            node:runAction(small)
        else
            node:runAction(cc.Sequence:create(big , normal))
        end
    end
    if eventType == ccui.TouchEventType.began then
        setButtonEffect(eventObj,true)
        audio.playSound("sound/effect/dianjinjinru.mp3" , false)
    elseif eventType == ccui.TouchEventType.ended then
        setButtonEffect(eventObj,false) 
    elseif eventType == ccui.TouchEventType.canceled then
        setButtonEffect(eventObj,false)
    end
end
function _G.seekNodeByName(rootNode, name)
	if not rootNode or not name then
		return nil
	end

	if rootNode:getName() == name then
		return rootNode
	end

	local children = rootNode:getChildren()
	if not children or #children == 0 then
		return nil
	end
	for i, parentNode in ipairs(children) do
		local childNode = seekNodeByName(parentNode, name)
		if childNode then
			return childNode
		end
	end

	return nil
end

--[[
    说明：适配函数
    使用条件: 工程必须采用 FIXED_WIDTH 或 FIXED_HEIGHT 策略
    @param layout: cocostudio ui 场景根元素
]]
function _G.adap(layout)
    if layout == nil then return end
	local layout_size = SIZE(layout)
    local panel_root = _G.seekNodeByName(layout, "Panel_root")
    if panel_root then
        layout_size = SIZE(panel_root)
    end
    local offset_x = layout_size.width - display.width
    local offset_y = layout_size.height - display.height

    local Panel_middle = _G.seekNodeByName(layout, "Panel_middle")
    if Panel_middle then
        local tmp_x = offset_x / 2
        local tmp_y = offset_y / 2
		local x, y = Panel_middle:getPosition()
        if layout_size.width > layout_size.height then
    		x = x - tmp_x
        else
            y = y - tmp_y
        end
		Panel_middle:setPosition(x, y)
	end

    local Panel_down = _G.seekNodeByName(layout, "Panel_down")
    if Panel_down then
		local x, y = Panel_down:getPosition()
		Panel_down:setPosition(x, offset_y / 2)
	end

    local Panel_up = _G.seekNodeByName(layout, "Panel_up")
	if Panel_up then
		local x, y = Panel_up:getPosition()
		y = y - offset_y / 2
		Panel_up:setPosition(x, y)
	end
end