
local CURRENT_MODULE_NAME = ...

ui = ui or { }

local WindowManager = class("WindowManager")

function WindowManager:ctor(...)
    self.mWindowList = { }
    self.mNormalWindowList = {}; --
    self.mTopWindow = nil
    self.mWindowListByInner = { }
    self.mWindowListByNormal = { }
    self.mActiveWindow = nil;
    self.mZorder = 0;
    self._item = {}; --
end

function WindowManager:addItem(itemName,itemAlias,otherMiniGameModule)
    if(self._item[itemName] == nil) then
        local _, pos= string.find(string.reverse(itemName),"%.")
        local winName = itemName;
        if(itemAlias ~= nil) then
            winName = itemAlias;
        else
            if(pos ~= nil) then
                winName= string.sub(itemName,1-pos)
            end
        end
        self._item[winName] = otherMiniGameModule or import("."..itemName,CURRENT_MODULE_NAME)
        ui[winName] = self._item[winName]
    end

    return self
end


function WindowManager:doLoad(callback)
    for k,v in pairs(self._item) do
        self:registerWindow(v);
        if(callback ~= nil) then
            callback(v.__cname);
        end
    end
end

function WindowManager:init()
    --
    self:doPreLoad();
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_RETURN_BACK, handler(self, self.onCallBackFunction));

end
function WindowManager:onRegisterAll()
     --------↓↓↓↓↓一级界面↓↓↓↓↓--------
    self:addItem("layer.LobbyWindow.GameRoomGround") --游戏列表
        :addItem("layer.GameList.GameListWindow")--比赛列表窗口
        :addItem("layer.GameList.GameListDetailWindow")--比赛详情
        :addItem("layer.GameList.GameListJoin")--参赛提醒
        :addItem("layer.GameList.GameListStTageWait") --比赛阶段等待界面
        :addItem("layer.GameList.GameListRanking") --比赛看排行
        :addItem("layer.GameList.GameListResult") --比赛结算
        :addItem("layer.GameList.GameListQuitSelected")  --比赛退出弹窗
        :addItem("layer.GameList.GameListWindow_Resurrection")--复活提示
        :addItem("layer.GameList.GameListWaitting") --比赛阶段等待
        :addItem("layer.GameList.GameListStartPrompt") --确认参加比赛
        :addItem("PokerDesk.PokerDeskWindowCardCount","PokerDeskWindowCardCount")
        :addItem("PokerDesk.CardTableDialog","CardTableDialog")
        :addItem("PokerDesk.PokerDeskTalk","PokerDeskTalk")
        :addItem("PokerDesk.PokerAccountWindow","PokerAccountWindow")
        :addItem("PokerDesk.PokerResultWindow_SelfBuilding","PokerResultWindow_SelfBuilding")
        :addItem("PokerDesk.AppleDismissLayer")
        :addItem("layer.TwoPop.TPReconnect") --断线重连
        :addItem("layer.TwoPop.TPBankruptcyPackage") --破产礼包
        :addItem("layer.TwoPop.TPRelief") --救济金界面
        :addItem("layer.TwoPop.TPPersonalWindow")  --牌桌内个人详情页
        :addItem("layer.LobbyWindow.MainDhuan")  --tips
        :addItem("layer.BroadcastWindow")--跑马灯
        :addItem("layer.BroadcastWindows")--跑马灯
        :addItem("layer.LobbyWindow.TsgoShop")--提示跳转商城
    --
    ---------------------------------------
    self:doLoad();
end

function WindowManager:Destory()
    -- 析构函数
    for _, v in pairs(self.mWindowList) do
        v:dtor()
    end
    self.mWindowList = nil
end

function WindowManager:getCount()
    return table.nums(self._item);
end

function WindowManager:doPreLoad()
    self:addItem("LoadingWindow")
        :registerWindow(ui.LoadingWindow);

end

function WindowManager:registerWindowByImportName(name)
    local window = self._item[name];
    if(window ~= nil) then
        self:registerWindow(window);
    end
end


-- 感觉还是需要修改呢
function WindowManager:registerWindow(window,force)
    -- 注册事件

    force = force or false;
    local function _registerWindowAndInit()

        self.mWindowList[window:getName()] = window
        window:onInit()

    end
    if(force) then
        _registerWindowAndInit()
    else
        if(self.mWindowList[window:getName()] == nil) then
            _registerWindowAndInit()
        end
    end
end


function WindowManager:getWindow(windowName)
    -- 获取
    -- laixia.log("WindowManager:getWindow",windowName)
    return self.mWindowList[windowName]
end


function WindowManager:remove(window)
    -- 移除
    self.mWindowList[window:getName()] = nil


end

function WindowManager:tick(dt)
    -- laixia.log("WindowManager:tick")
    for _, v in pairs(self.mWindowList) do
        v:tick(dt)
    end
end

function WindowManager:getRootNode(window)
    return window.root
end


function WindowManager:dump()
    print("WindowManager:dump")

end


function WindowManager:onTop(window)
    if (self.mTopWindow == window)  then
        return
    end

    if (self.mTopWindow ~= nil) then

        self.mTopWindow:destroy()
    end
    self.mTopWindow = window

end

function WindowManager:intoInnerList(window)
    if #self.mWindowListByNormal>0 then
        local normalName=self.mWindowListByNormal[#self.mWindowListByNormal]:getName()
        if self.mWindowListByInner[normalName] then
            table.insert(self.mWindowListByInner[normalName],window)
        else
            self.mWindowListByInner[normalName] = {}
            table.insert(self.mWindowListByInner[normalName],window)
        end
        return
    end
    if self.mTopWindow then
        if self.mWindowListByInner[self.mTopWindow:getName()] then
            table.insert(self.mWindowListByInner[self.mTopWindow:getName()],window)
        else
            self.mWindowListByInner[self.mTopWindow:getName()] = {}
            table.insert(self.mWindowListByInner[self.mTopWindow:getName()],window)
        end
        return
    end
end

function WindowManager:intoNormalList(window)
    if self.mTopWindow then
        table.insert(self.mWindowListByNormal,window)
    end
end

function WindowManager:destoryInnerWindowsByKey(name)
    if self.mWindowListByInner[name] then
        for _,v in ipairs(self.mWindowListByInner[name]) do
            v:destroy()
        end
        self.mWindowListByInner[name] = nil
        self:updateZOrder()
    end
end

function WindowManager:destoryAllNormalWindows()
    for index=#self.mWindowListByNormal,1,-1 do
        self.mWindowListByNormal[index]:destroy()
    end
end

function WindowManager:destoryNormalWindowsByList(window)
    for index=#self.mWindowListByNormal,1,-1 do
        if self.mWindowListByNormal[index] == window then
            table.removebyvalue(self.mWindowListByNormal,self.mWindowListByNormal[index])
            self:updateZOrder()
            return
        end
    end
end

function WindowManager:updateZOrder()
    local mZorder=100
    if (self.mTopWindow ~= nil) then
        self.mTopWindow.root:setLocalZOrder(mZorder)
        mZorder=mZorder+1
        if self.mWindowListByInner[self.mTopWindow:getName()] then
            for _,v in ipairs(self.mWindowListByInner[self.mTopWindow:getName()]) do
                v.root:setLocalZOrder(mZorder)
                mZorder=mZorder+1
            end
        end
    end
    for k,v in ipairs(self.mWindowListByNormal) do
        local zorder =   v:getZorder()
        v.root:setLocalZOrder(mZorder + zorder)
        mZorder=mZorder+1
        local name = v:getName()


        if self.mWindowListByInner[v:getName()] then
            for _,v in ipairs(self.mWindowListByInner[v:getName()]) do
                v.root:setLocalZOrder(mZorder)
                mZorder=mZorder+1
            end
        end
    end
end



function WindowManager:isWindowVisible(windowName)

end

-- 返回当前的主要窗口
function WindowManager:getTopWindow()
    return self.mTopWindow;
end

function WindowManager:setActiveWindow(window)

    self.mActiveWindow = window;
end

function WindowManager:getActiveWindow()
    return self.mActiveWindow;
end

function WindowManager:addWindowToNormalTail(window)

    local pos = table.indexof(self.mNormalWindowList,window)
    if(pos) then
        table.remove(self.mNormalWindowList,pos);
    end
    self.mNormalWindowList[#self.mNormalWindowList +1] = window;
end

function WindowManager:getNormalWindowTail()
    if(isTableEmpty(self.mNormalWindowList)) then
        return nil;
    else
        return self.mNormalWindowList[#self.mNormalWindowList];
    end
end

function WindowManager:removeNormalWindowTail()
    table.remove(self.mNormalWindowList);
end

function WindowManager:removeNormalWindow(window)
    local pos = table.indexof(self.mNormalWindowList,window)
    if(pos) then
        table.remove(self.mNormalWindowList,pos);
    end
end

function WindowManager:updateActiveWindow()
    if(self:getNormalWindowTail() ~= nil) then
        self:setActiveWindow(self:getNormalWindowTail());
    elseif #self.mWindowListByNormal>0 then
        self:setActiveWindow(self.mWindowListByNormal[#self.mWindowListByNormal])
    else
        self:setActiveWindow(self:getTopWindow());
    end
end

function WindowManager:onCallBackFunction()

    if(self.mActiveWindow ~= nil) then
        self.mActiveWindow.onOjbectCallBackFunction(self.mActiveWindow);
    end
end

function WindowManager:allShowAndHide(bool)
    for _, v in pairs(ui) do
        v:setVisible(bool)
    end
end

return WindowManager.new()



