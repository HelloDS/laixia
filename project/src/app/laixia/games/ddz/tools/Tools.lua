--[[
********************************************************
    @date:       2018-3-9
    @author:     zl
    @version:    1.0
    @describe:   斗地主游戏公共方法
********************************************************
]]


--[[
    返回监听(键盘和手机)
]]
function _G.addKeyboardListener(m_uiRoot ,m_self, callback)
    local function onKeyReleased(keyCode, event)
        print("addKeyboardListener keyCode = " .. keyCode)
        if keyCode == cc.KeyCode.KEY_BACK then  -- cc.KeyCode.KEY_BACK == 6
            if not callback or type(callback) ~= "function" then 
                app.m_layerManager:pop();
            else
                callback();
            end
        end
        event:stopPropagation() -- 子界面返回不影响父界面
    end
    --监听手机返回键
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED )
    local eventDispatcher = m_uiRoot:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,m_uiRoot)
end

--[[
    坐标系转换 将对话框设置在基础node的中心
]]
function _G.setCenterDialog(baseNode, dialogLayer)
    if not baseNode then return end
    if not dialogLayer then return end
    if not baseNode.getContentSize then return end
    --1. get baseNode width, heigh
    local width = baseNode:getContentSize().width
    local height = baseNode:getContentSize().height
    --2. x,y baseNode conver to full screen x,y
    local pos = baseNode:convertToWorldSpace(cc.p(width / 2, height / 2))
    local panel_dialog = cc.uiloader:seekNodeByName(dialogLayer , "panel_dialog" , true)
    --3. set dialog x, y
    panel_dialog:setPosition(pos)
end

--[[
    开启定时器
    @parme funcName 传入定时器要调用的函数名
    @parme time 定时器变化时间
]]
function _G.setStartSchedule(funcName , time)
    if not funcName then return end
    if not time then time = 0.2 end
    return cc.Director:getInstance():getScheduler():scheduleScriptFunc(funcName, time, false)
end

--[[
    关闭定时器
    @parme 定时器名字
]]
function _G.setCloseSchedule(name)
    if name ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(name)
        name = nil
    end
end

-- 计算字符串宽度
function _G.getStringLength(string , fontSize)
    if not string or not fontSize then return end

    local str = string
    local fontSize = fontSize
    local lenInByte = #str
    local width = 0

    for i=1,lenInByte do
        local curByte = string.byte(str, i)
        local byteCount = 0;
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
        local char = string.sub(str, i, i+byteCount-1)
        i = i + byteCount
     
        if byteCount == 1 then
            width = width + math.ceil(fontSize/2)
        elseif byteCount > 1 then
            width = width + fontSize
        else
            --乱码
        end
    end
    return width
end

--[[
    --设置滚动容器内文本自动换行
    @parme scrollview 滚动容器
    @parme text 文本控件
    @parme string 文本字符串内容
]]
function _G.setAutoText(scrollview , text , string)
    local srvWidth = scrollview:getContentSize().width;
    --方法第二个参数为0会自动计算高度
    text:setTextAreaSize(cc.size(srvWidth , 0))
    --设置true是为了当只有文本宽度时候自动换行得到文本高度
    text:ignoreContentAdaptWithSize(true);
    text:setString(string)
    --设置容器内部大小
    dump(text:getContentSize().height , "规则高度");
    scrollview:setInnerContainerSize(cc.size(srvWidth , text:getContentSize().height))
    --恢复，必须执行这一句，要不会乱行
    text:ignoreContentAdaptWithSize(false);
end

--[[
    --设置对话框文本自动换行
    @parme width 换行宽度
    @parme text 文本控件
    @parme string 文本字符串内容
]]
function _G.setAutoTextDialog(width , text , string)
    local height = text:getContentSize().height;
    text:setTextAreaSize(cc.size(width , 0))
    text:ignoreContentAdaptWithSize(true);
    text:setString(string)
    if text:getContentSize().height == height then print("不换行") return end;
    text:ignoreContentAdaptWithSize(false);
end