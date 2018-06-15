--[[
function()
    return ccs.GUIReader:getInstance():widgetFromBinaryFile("new_ui/Animation.csb")
end )
]]

local xzmj = xzmj;

local BaseView = class("BaseView",function ( ... )
    return cc.Node:create()
end)

function BaseView:ctor()
    -- 监听事件
    if self.onEnter or self.enterFinish or self.onExit or self.onExitStart or self.onCleanup then
        self:registerScriptHandler(function(event)
            if event == "enter" then
                if type(self.onEnter) == "function" then
                    self:onEnter()
                end
            elseif event == "enterTransitionFinish" then
                if type(self.onEnterFinish) == "function" then
                    self:onEnterFinish()
                end
            elseif event == "exit" then
                if type(self.onExit) == "function" then
                    self:onExit()
                end
            elseif event == "exitTransitionStart" then
                if type(self.onExitStart) == "function" then
                    self:onExitStart()
                end
            elseif event == "cleanup" then
                if type(self.onCleanup) == "function" then
                    self:onCleanup()
                end
            end
        end)
    end

    self:LoadCsbName()

end

function BaseView:UpdateDate(...)
    print("操作数据")
end

function BaseView:onShow(...)
    print("操作UI")
end


function BaseView:SetCsbName( csbName )
    self.mCsbName = csbName
end
function BaseView:GetCsbName(  )
    return self.mCsbName
end
function BaseView:LoadCsbName( csbName )
    local csbFile = self:GetCsbName()
    local node = nil

    if csbFile == nil or csbFile == "" then
        node = cc.Node:create()
    elseif type(csbFile) == "string" then
        local path = "games/xzmj/"..csbFile..".csb"
        node = cc.CSLoader:createNode(path)
        if node == nil then
            print("--------------游戏内csb文件装载error-------------- ")
            node = cc.Node:create()
        end
    end
    node:setContentSize(display.size)
    ccui.Helper:doLayout(node)
    if node.setBackGroundColorOpacity then
        node:setBackGroundColorOpacity(0)
    end
    --
    local originSize = node:getContentSize()
    if (originSize.width == 0 and originSize.height == 720) or (originSize.width == 0 and originSize.height == 0) then
        node:setContentSize(cc.Director:getInstance():getVisibleSize())
        ccui.Helper:doLayout(node)
    end
    node:setCascadeColorEnabled(true)
    node:setCascadeOpacityEnabled(true)
    self:addChild(node)
    self.mCsbNode = node
end


-- 继承
function BaseView.Inherit(name, csbFile)
    local InheritView = class(name, BaseView)
    if csbFile then
        -- 重写__create函数, 引入皮肤
        InheritView.__create = function()
            return InheritView.super.__create(csbFile)
        end
    end
    return InheritView
end

-- 查找子节点 支持递归搜索
-- namd:        子节点名称
-- recursive:   是否使用递归查找, 默认是
function BaseView:findViewByName(name, recursive)
    local child = nil

    if recursive or recursive == nil then
        --
        self:enumerateChildren("//" .. name, function(ret)
            child = ret
        end)
    else
        child = self:getChildByName(name)
    end

    return child
end

function BaseView:findViewByTag(tag)
    return self:getChildByTag(tag)
end

function BaseView:addView(view)
    self:addChild(view)
end

function BaseView:removeView(view)
    self:removeChild(view)
end

function BaseView:addTo(parent, localZOrder)
    if localZOrder then
        self:setLocalZOrder(localZOrder)
    end
    parent:addChild(self)
end

function BaseView:removeFrom(parent)
    parent:removeChild(self)
end

-- 注入一个视图, bindName如果不为空则
-- 创建 self.View.bindName = view
-- 否则 self.View.name = view
-- namd:        需要绑定的节点名称
-- bindName:    绑定给表的元素名称
-- 引入self.View是防止与其它变量冲突
function BaseView:InjectView(name, bindName)
    -- self.View = self.View or {}

    -- if not self.View[bindName or name] then
    --     self.View[bindName or name] = self:findViewByName(name, true)
    -- end

    if not self[bindName or name] then
        self[bindName or name] = self:findViewByName(name, true)
    end
end

--[[
    注入一个自定义视图, 只支持一级继承

    name
    CustomView
    ... 调用ctor构造函数的参数列表

    usage:
        self:InjectCustomView("Icon", qy.Widget.Icon, {
            ["onClick"] = function(icon)
                print("____" .. icon:getTag())
            end
        })
]]
function BaseView:InjectCustomView(name, CustomView, ...)
    local node = self:findViewByName(name, true)
    if node then
        -- 拷贝基类的方法
        for k,v in pairs(BaseView) do node[k] = v end
        -- 调用构造函数
        node:ctor(...)
        -- 拷贝子类的方法
        for k,v in pairs(CustomView) do node[k] = v end
        -- 调用构造函数
        node:ctor(...)
        -- 绑定
        self[name] = node
    end
end

function BaseView:UpdateDate( data )
    
end

function BaseView:AddWidgetEventListenerFunction(ctrlName,event)
    if(ctrlName  ~= nil ) then
        ctrlName:setTouchEnabled(true)
        ctrlName:setSwallowTouches(true)
        ctrlName:addTouchEventListener(event)
    end
end

--按钮放大缩小动画特效
function BaseView:addButAnimationEventListener(but,callFun)
    but.callFun = callFun
    but:addTouchEventListener(function(sender,eventtype)
        if eventtype == ccui.TouchEventType.began then
            xzmj.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
            local sc = cc.ScaleTo:create(0.1, 1.1)
            sender:runAction(sc)
        elseif eventtype == ccui.TouchEventType.moved then
        elseif eventtype == ccui.TouchEventType.canceled then
            local sc_back = cc.ScaleTo:create(0.1, 1)
            sender:runAction(sc_back)
        elseif eventtype == ccui.TouchEventType.ended then 
            local sc_back = cc.ScaleTo:create(0.1, 1)
            sender:runAction(sc_back)   
            --监听的函数
            if sender.callFun ~= nil then
                sender.callFun()
            end
        end
    end)
end


--将层添加到场景上 并放到堆栈管理器中retain 增加引用
function BaseView:Show()
    xzmj.runningScene:push( self )
end

function BaseView:dismiss()
    xzmj.runningScene.controllerStack:pop( self )
end

--销毁所有二级弹窗
function BaseView:dismissAll()
    xzmj.runningScene:disissAllDialog()
end


-- 给一个view注入一个点击的事件
-- endedFunc(self, sender)
--扩展参数: extendObj
--extendObj.eventFunc :点击时事件函数
--extendObj.beganFunc :点击开始
--extendObj.canceledFunc :取消事件
--extendObj.isScale :点击时是否进行缩放，默认true
--extendObj.hasAudio :点击时是否有音效，默认true
--extendObj.audioType :点击时音效的常量，默认是通用音效(在qy.tank,view.type.SoundType中定义)
--extendObj.dribble :是否屏蔽快速点击
function BaseView:OnClick(name, endedFunc, extendObj)
    --xzmj.soundManager.playEffect(xzmj.soundEnum.BUTTON_COMMON)
    assert(endedFunc, "endedFunc 不能为空")
    assert(name, "name 不能为空")
    if extendObj == nil then
        extendObj = {}
    end
    if extendObj.isScale == nil then
        extendObj.isScale = true
    end
     if extendObj.hasAudio == nil then
        extendObj.hasAudio = true
    end
    if extendObj.audioType == nil then
      --  extendObj.audioType = qy.SoundType.COMMON_CLICK
    end

    local view = type(name) ~= "string" and name or self[name] or self:findViewByName(name,true)
    if tolua.cast(view,"cc.Node") then
        view:setTouchEnabled(true)
        view:setSwallowTouches(true)
        local scaleX = view:getScaleX()
        local scaleY = view:getScaleY()

        view:addTouchEventListener(function(sender, eventType)
            
            if extendObj.eventFunc then
                extendObj.eventFunc(self, eventType)
            end

            if eventType == ccui.TouchEventType.ended then
                -- print("++++++++++++++++++++++++ touch end",view:getPosition(),view:getContentSize().width,view:getContentSize().height)
                -- if not extendObj.dribble then
                    -- view:setTouchEnabled(false)
                    -- view:setSwallowTouches(false)
                -- end
                --点击音效
                if extendObj.hasAudio then
                    --qy.QYPlaySound.playEffect(extendObj.audioType)
                end
                --点击结束回调
                endedFunc(self, sender)

                --点击缩放
                if extendObj.isScale then
                    view:setScaleX(scaleX * 1)
                    view:setScaleY(scaleY * 1)
                end

                -- view:setTouchEnabled(true)
            end

            if eventType == ccui.TouchEventType.began then
                -- print("++++++++++++++++++++++++ touch began",view:getPosition(),view:getContentSize().width,view:getContentSize().height)
                if extendObj.isScale then
                    view:setScaleX(scaleX * 0.95)
                    view:setScaleY(scaleY * 0.95)
                end
                if extendObj.beganFunc then
                    extendObj.beganFunc(self, sender)
                end
            end

            if eventType == ccui.TouchEventType.canceled then
                -- print("++++++++++++++++++++++++ touch cancel",view:getPosition(),view:getContentSize().width,view:getContentSize().height)
                if extendObj.isScale then
                    view:setScaleX(scaleX * 1)
                    view:setScaleY(scaleY * 1)
                end
                if extendObj.canceledFunc then
                    extendObj.canceledFunc(self, sender)
                end
            end
        end)
    end
end

function BaseView:OnClickForBuilding(name, endedFunc, extendObj)
    assert(endedFunc, "endedFunc 不能为空")
    assert(name, "name 不能为空")
    if extendObj == nil then
        extendObj = {}
    end
     if extendObj.hasAudio == nil then
        extendObj.hasAudio = true
    end
    if extendObj.audioType == nil then
       -- extendObj.audioType = qy.SoundType.COMMON_CLICK
    end

    local view = type(name) ~= "string" and name or self[name] or self:findViewByName(name, true)
    if tolua.cast(view,"cc.Node") then
        view:setTouchEnabled(true)
        view:setSwallowTouches(false)
        view:addTouchEventListener(function(sender, eventType)

            if extendObj.eventFunc then
                extendObj.eventFunc(self, eventType)
            end

            if eventType == ccui.TouchEventType.ended then
                view:setTouchEnabled(false)
                --点击音效
                if extendObj.hasAudio then
                   -- qy.QYPlaySound.playEffect(extendObj.audioType)
                end
                --点击结束回调
                endedFunc(self, sender)
                view:setTouchEnabled(true)
                view:setSwallowTouches(false)
            end

            if eventType == ccui.TouchEventType.began then
                if extendObj.beganFunc then
                    extendObj.beganFunc(self, sender)
                end
            end

            if eventType == ccui.TouchEventType.canceled then
                if extendObj.canceledFunc then
                    extendObj.canceledFunc(self, sender)
                end
            end

            if eventType == ccui.TouchEventType.moved then
                if extendObj.movedFunc then
                    extendObj.movedFunc(self, sender)
                end
            end
        end)
    end
end

function BaseView:OnClickForBuilding1(name, endedFunc, extendObj)
    assert(endedFunc, "endedFunc 不能为空")
    assert(name, "name 不能为空")
     
    if extendObj == nil then
        extendObj = {}
    end
     if extendObj.hasAudio == nil then
        extendObj.hasAudio = true
    end
    if extendObj.audioType == nil then
        -- extendObj.audioType = qy.SoundType.COMMON_CLICK
    end

    local view = type(name) ~= "string" and name or self[name] or self:findViewByName(name, true)
    if tolua.cast(view,"cc.Node") then
        local scaleX = view:getScaleX()
        local scaleY = view:getScaleY()
        view:setTouchEnabled(true)
        view:setSwallowTouches(false)
        view:addTouchEventListener(function(sender, eventType)

            if extendObj.eventFunc then
                extendObj.eventFunc(self, eventType)
            end

            if eventType == ccui.TouchEventType.ended then
                view:setTouchEnabled(false)
                --点击音效
                if extendObj.hasAudio then
                    --qy.QYPlaySound.playEffect(extendObj.audioType)
                end
                --点击结束回调
                endedFunc(self, sender)
                view:setTouchEnabled(true)
                view:setSwallowTouches(false)
                if extendObj.isScale then
                    view:setScaleX(scaleX * 1)
                    view:setScaleY(scaleY * 1)
                end
            end

            if eventType == ccui.TouchEventType.began then
                if extendObj.isScale then
                    view:setScaleX(scaleX * 0.95)
                    view:setScaleY(scaleY * 0.95)
                end
                if extendObj.beganFunc then
                    extendObj.beganFunc(self, sender)
                end

            end

            if eventType == ccui.TouchEventType.canceled then
                if extendObj.canceledFunc then
                    extendObj.canceledFunc(self, sender)
                end
                if extendObj.isScale then
                    view:setScaleX(scaleX * 1)
                    view:setScaleY(scaleY * 1)
                end
            end

            if eventType == ccui.TouchEventType.moved then
                if extendObj.isScale then
                    view:setScaleX(scaleX * 1)
                    view:setScaleY(scaleY * 1)
                end
                if extendObj.movedFunc then
                    extendObj.movedFunc(self, sender)
                end
            end
        end)
    end
end



--[[
    parent,name,timeline,callback)
]]--
function BaseView:playAnimationAt( node,name,timeline,callback)
    if node == nil or name == nil then
        print("-------BaseView:playAnimationAt----error----")
        return
    end

    local system = xzmj.Animg
    local _node  = system:playAnimationAt(node,name,timeline,callback)
    return _node
end

--[[
    将一个指定的panel 设置为透明
]]--
function BaseView:SetLayoutOpacity( _Layout )
    if _Layout == nil then
        print("=====error====BaseView:SetLayoutOpacity======")
        return
    end
    _Layout:setBackGroundColor(cc.c4b(0,0,0,255))    -- 填充颜色
    _Layout:setBackGroundColorType(ccui.LayoutBackGroundColorType.none)              -- 填充方式
    _Layout:setBackGroundColorOpacity(100)         -- 颜色透明度
end


function BaseView:PlayMusic( ... )
    audio.playMusic( ...,true )
end

function BaseView:PlaySound( _FileName )
    if _FileName then
        audio.playSound(_FileName..".mp3")
    end
end

return BaseView
