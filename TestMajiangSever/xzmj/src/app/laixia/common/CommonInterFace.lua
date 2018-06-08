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
        local userDefault = cc.UserDefault:getInstance()
        local isEffectOn = userDefault:getIntegerForKey("isEffectOn", 1)==1
        if isEffectOn then
            audio.playSound("sound/effect/dianjinjinru.mp3" , false)
        end
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

    local centerY = 0
    local bottomH = 0

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
        centerY = y - offset_y / 2
--        Panel_middle:setBackGroundColor(cc.c3b(0,255,0))
--        Panel_middle:setBackGroundColorType(1)
	end

    local Panel_down = _G.seekNodeByName(layout, "Panel_down")
    if Panel_down then
		local x, y = Panel_down:getPosition()
--        Panel_down:setBackGroundColor(cc.c3b(255,0,0))
        bottomH = Panel_down:getContentSize().height
--        Panel_down:setBackGroundColorType(1)
        S_XY(Panel_down, x, offset_y / 2)
	end

    local Panel_up = _G.seekNodeByName(layout, "Panel_up")
	if Panel_up then
		local x, y = Panel_up:getPosition()
		y = y - offset_y / 2
        S_XY(Panel_up, x, y)
--        Panel_up:setBackGroundColor(cc.c3b(255,0,0))
--        Panel_up:setBackGroundColorType(1)
	end

    local dif_cb = centerY - bottomH
    local Panel_dialog = _G.seekNodeByName(layout, "Panel_dialog")
    if dif_cb > 0 and Panel_dialog then
        local panel = ccui.Layout:create()
        panel:setTouchEnabled(true)
        panel:setPositionY(offset_y / 2 + bottomH)
        panel:setContentSize(cc.size(display.width, dif_cb))
--        panel:setBackGroundColor(cc.c3b(255,0,0))
--        panel:setBackGroundColorType(1)
        Panel_dialog:addChild(panel)
    end
end

function _G.adapPanel_root(layout, percent)
    local panel_root = _G.seekNodeByName(layout, "Panel_root")
    if panel_root then
        local layout_size = SIZE(panel_root)
        panel_root:setPositionY(-(display.height - layout_size.height) / 2)
        panel_root:setContentSize(cc.size(display.width, display.height))
        local Panel_dialog = _G.seekNodeByName(layout, "Panel_dialog")
        if Panel_dialog then
            if type(percent) ~= "number" then
                return
            end
            S_Y(Panel_dialog, display.height * percent)
        end
    end
end

--转屏幕 
--android true转换横屏
function _G.setPlatformAdap(isLandscape)
    if device.platform == "android" then
        luaj.callStaticMethod("com/laixia/game/ddz/AppActivity", "rotate", {isLandscape}, "(Z)V")
    elseif device.platform == "ios" then
        local methodStr = isLandscape and "landscape" or "portrait"
        luaoc.callStaticMethod("IKCRLXBridgeManager", methodStr)
    elseif device.platform == "windows" then
        lx.LXUIManager:setLandscape(isLandscape)
    end
end

function _G.setCommonDisplay(isLandscape)
    if isLandscape then
        _G.resetDisplay({designWidth = 1280, 
		    designHeight = 720, 
		    resolutionPolicy = cc.ResolutionPolicy.FIXED_HEIGHT, 
		    isLandscape = true,
		    version = "1.0"})
    else
        _G.resetDisplay({designWidth = 720, 
		    designHeight = 1280, 
		    resolutionPolicy = cc.ResolutionPolicy.FIXED_WIDTH, 
		    isLandscape = false,
		    version = "1.0"})
    end
end

function _G.resetDisplay(uiInfo)
    local sharedDirector         = cc.Director:getInstance()
    local sharedTextureCache     = cc.Director:getInstance():getTextureCache()
    local sharedSpriteFrameCache = cc.SpriteFrameCache:getInstance()
    local sharedAnimationCache   = cc.AnimationCache:getInstance()

    local CONFIG_SCREEN_WIDTH = uiInfo.designWidth
    local CONFIG_SCREEN_HEIGHT = uiInfo.designHeight

    -- check device screen size
    local glview = sharedDirector:getOpenGLView()

    local size = glview:getFrameSize()
    if ((uiInfo.isLandscape == true) and (size.width < size.height)) or
       ((uiInfo.isLandscape == false) and (size.width > size.height)) then
        glview:setFrameSize(size.height, size.width)
        size = glview:getFrameSize()
    end
    display.sizeInPixels = {width = size.width, height = size.height}

    local w = display.sizeInPixels.width
    local h = display.sizeInPixels.height

    if CONFIG_SCREEN_WIDTH == nil or CONFIG_SCREEN_HEIGHT == nil then
        CONFIG_SCREEN_WIDTH = w
        CONFIG_SCREEN_HEIGHT = h
    end

    local CONFIG_SCREEN_AUTOSCALE = nil
    if uiInfo.resolutionPolicy == cc.ResolutionPolicy.FILL_ALL then
        CONFIG_SCREEN_AUTOSCALE = "FILL_ALL"
    elseif uiInfo.resolutionPolicy == cc.ResolutionPolicy.FIXED_WIDTH then
        CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"
    elseif uiInfo.resolutionPolicy == cc.ResolutionPolicy.FIXED_HEIGHT then
        CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"
    else
        CONFIG_SCREEN_AUTOSCALE = uiInfo.resolutionPolicy
    end

    if not CONFIG_SCREEN_AUTOSCALE then
        if w > h then
            CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"
        else
            CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"
        end
    end

    local scale, scaleX, scaleY

    if CONFIG_SCREEN_AUTOSCALE and CONFIG_SCREEN_AUTOSCALE ~="NONE" then
        if type(CONFIG_SCREEN_AUTOSCALE_CALLBACK) == "function" then
            scaleX, scaleY = CONFIG_SCREEN_AUTOSCALE_CALLBACK(w, h, device.model)
        end

        if CONFIG_SCREEN_AUTOSCALE == "FILL_ALL" then
            CONFIG_SCREEN_WIDTH = w
            CONFIG_SCREEN_HEIGHT = h
            scale = 1.0
            if cc.bPlugin_ then
                glview:setDesignResolutionSize(CONFIG_SCREEN_WIDTH, CONFIG_SCREEN_HEIGHT, cc.ResolutionPolicy.NO_BORDER)
            else
                glview:setDesignResolutionSize(CONFIG_SCREEN_WIDTH, CONFIG_SCREEN_HEIGHT, cc.ResolutionPolicy.FILL_ALL)
            end
        else
            if not scaleX or not scaleY then
                scaleX, scaleY = w / CONFIG_SCREEN_WIDTH, h / CONFIG_SCREEN_HEIGHT
            end

            if CONFIG_SCREEN_AUTOSCALE == "FIXED_WIDTH" then
                scale = scaleX
                CONFIG_SCREEN_HEIGHT = h / scale
            elseif CONFIG_SCREEN_AUTOSCALE == "FIXED_HEIGHT" then
                scale = scaleY
                CONFIG_SCREEN_WIDTH = w / scale
            else
                scale = 1.0
                printError(string.format("display - invalid CONFIG_SCREEN_AUTOSCALE \"%s\"", CONFIG_SCREEN_AUTOSCALE))
            end
            glview:setDesignResolutionSize(CONFIG_SCREEN_WIDTH, CONFIG_SCREEN_HEIGHT, cc.ResolutionPolicy.NO_BORDER)
        end
    else
        CONFIG_SCREEN_WIDTH = w
        CONFIG_SCREEN_HEIGHT = h
        scale = 1.0
    end

    local winSize = sharedDirector:getWinSize()
    display.screenScale        = 2.0
    display.contentScaleFactor = scale
    display.size               = {width = winSize.width, height = winSize.height}
    display.width              = display.size.width
    display.height             = display.size.height
    display.cx                 = display.width / 2
    display.cy                 = display.height / 2
    display.c_left             = -display.width / 2
    display.c_right            = display.width / 2
    display.c_top              = display.height / 2
    display.c_bottom           = -display.height / 2
    display.left               = 0
    display.right              = display.width
    display.top                = display.height
    display.bottom             = 0
    display.widthInPixels      = display.sizeInPixels.width
    display.heightInPixels     = display.sizeInPixels.height

    print(string.format("# CONFIG_SCREEN_AUTOSCALE      = %s", CONFIG_SCREEN_AUTOSCALE))
    print(string.format("# CONFIG_SCREEN_WIDTH          = %0.2f", CONFIG_SCREEN_WIDTH))
    print(string.format("# CONFIG_SCREEN_HEIGHT         = %0.2f", CONFIG_SCREEN_HEIGHT))
    print(string.format("# display.widthInPixels        = %0.2f", display.widthInPixels))
    print(string.format("# display.heightInPixels       = %0.2f", display.heightInPixels))
    print(string.format("# display.contentScaleFactor   = %0.2f", display.contentScaleFactor))
    print(string.format("# display.width                = %0.2f", display.width))
    print(string.format("# display.height               = %0.2f", display.height))
    print(string.format("# display.cx                   = %0.2f", display.cx))
    print(string.format("# display.cy                   = %0.2f", display.cy))
    print(string.format("# display.left                 = %0.2f", display.left))
    print(string.format("# display.right                = %0.2f", display.right))
    print(string.format("# display.top                  = %0.2f", display.top))
    print(string.format("# display.bottom               = %0.2f", display.bottom))
    print(string.format("# display.c_left               = %0.2f", display.c_left))
    print(string.format("# display.c_right              = %0.2f", display.c_right))
    print(string.format("# display.c_top                = %0.2f", display.c_top))
    print(string.format("# display.c_bottom             = %0.2f", display.c_bottom))
    print("#")
end