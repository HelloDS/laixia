

DialogTypeDef = { }
DialogTypeDef.DEFINE_NORMAL_DIALOG = 0   -- 正常的窗口
DialogTypeDef.DEFINE_SINGLE_DIALOG = 1   -- 单窗口
DialogTypeDef.DEFINE_INNER_DIALOG = 2    -- 组件页面


local CSBBase = class("CSBBase")

local laixia = laixia;
laixiaddz.ui.CSBBase = CSBBase;
local L_JT_window = laixia.JsonTxtData:queryTable("window");

local display = display;
local XScale = display.widthInPixels / display.config_width / display.contentScaleFactor;
local YScale = display.heightInPixels / display.config_height / display.contentScaleFactor;

-- 构造函数
function CSBBase:ctor(...)
    self.root = nil
    self.mDialogName = "None" -- 基本上，这里保证的是和表里的Window名相同
    self.mIsLoad = false
    self.mDialogItemData = nil
    self.mInterfaceRes = nil     -- 这个是 真正的界面
    self.mDialogObj = nil
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG   --默认窗口
end

--析构函数 ，模拟，所有的最好删除调用一下   ~~
function CSBBase:dtor(...)
    self.mDialogObj = nil
    self.mDialogItemData = nil
    self.root:removeFromParent() --
    self.bShowColorLayer = true;
    self.root = nil
end

function CSBBase:getName()
    return "CSBBase";
end

--有些界面需要层级高的可以这样设置
function CSBBase:getZorder()
    return  0
end


function CSBBase:onInit(hDialog)
    self:SetShowColorLayerFunc(true);
    self.mDialogName = hDialog:getName();
    self.mDialogObj = hDialog;
    self.mDialogItemData =  L_JT_window:query("WindowName",self.mDialogName);
end

function CSBBase:isLoaded()
    return self.mIsLoad
end

function CSBBase:IsShowColorLayerFunc()
    return self.bShowColorLayer;
end

function CSBBase:SetShowColorLayerFunc(bVal)
    self.bShowColorLayer = bVal;
end

-- --进行适配
--function CSBBase:Adaptation()

--        local view = self.mInterfaceRes;
--        if (self:getName() == "LoadingWindow") then
--            view:pos(display.cx, display.cy)
--            view
--            :scaleX(XScale)
--            :scaleY(YScale)
--        else
--            view:pos(display.cx, display.cy)
--            view
--            :scaleX(XScale)
--            :scaleY(YScale)
--        end
--end

function CSBBase:AddWidgetEventListenerFunction(ctrlName,event,ctrlParent)

    local  control = nil
    control = self:GetWidgetByName(ctrlName,ctrlParent)

    if(control  ~= nil ) then
        control:addTouchEventListener(event)
    end
end


---- 遍历UI节点,返回指定名字的Node, 递归
function CSBBase:findNodeByName(root,name)
    if root == nil then return nil end
    if not root.getChildByName then return nil end
    local widget = root:getChildByName(name)
    if widget then
        return widget
    else
        local children = root:getChildren()
        for _, ch in pairs(children) do
            widget = self:findNodeByName(ch, name)
            if widget then
                return widget
            end
        end
        return nil
    end
end

function CSBBase:GetWidgetByName(ctrlName,parentControl)
    if(nil == parentControl) then
        return self:findNodeByName(self.mInterfaceRes,ctrlName)
    else
        return self:findNodeByName(parentControl,ctrlName)
    end

    return nil
end

function CSBBase:tick(dt)
    if(self.mIsLoad) then
        self:onTick(dt)
    end
end

function CSBBase:isActiveDialog()
    local winManager = laixiaddz.ui.WindowManager
    return self.mDialogObj == winManager:getActiveWindow();
end

function CSBBase:onCallBackFunction()

    if self:getName() == "LoadingWindow" then
        return
    elseif self:getName() == "LobbyWindow" then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_ANDROIDBACKTK_WINDOW)
    elseif self:getName() == "GameListWindow" or self:getName() == "GameRoomGround" then
    -- ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW)
    elseif self.hDialogType == DialogTypeDef.DEFINE_SINGLE_DIALOG and laixia.LocalPlayercfg.OnReturnFunction then
        ObjectEventDispatch:pushEvent(laixia.LocalPlayercfg.OnReturnFunction)
    elseif self.hDialogType == DialogTypeDef.DEFINE_NORMAL_DIALOG then
        self:destroy()
    end
end

function CSBBase:setVisible(boval)
    if nil~= self.root then
        self.root:setTouchEnabled(boval)
        self.root:setVisible(boval)
    end
end

function CSBBase:onOjbectCallBackFunction()
    if(self.mDialogObj.onCallBackFunction ~= nil) then
        self.mDialogObj:onCallBackFunction();
    end
end


function CSBBase:loadResource()

    if(not self.mIsLoad) then
        if self.hDialogType ~= DialogTypeDef.DEFINE_INNER_DIALOG then
            if(self:IsShowColorLayerFunc()) then
                self.layer= cc.LayerColor:create(cc.c4b(0,0,0,125),display.width, display.height)
            else
                self.layer= cc.LayerColor:create(cc.c4b(0,0,0,0),display.width, display.height)
            end
            -- self.layer:setTouchEnabled(true)
            -- self.layer:setTouchMode(1);
            -- self.layer:setTouchSwallowEnabled(true)
            self.layer:setPosition(cc.p(0,0))
            -- local function onTouch(eventType,x,y)
            --     return true;
            -- end
            -- self.layer:registerScriptTouchHandler(onTouch);
        else
            self.layer= display.newLayer()
        end
        if(string.find(self.mDialogItemData.Resource,".csb")) then
            self.mInterfaceRes = laixiaddz.Layout.loadLayer(self.mDialogItemData.Resource)
        else
            self.mInterfaceRes = ccs.GUIReader:getInstance():widgetFromJsonFile(self.mDialogItemData.Resource);
        --return
        end

        self.mInterfaceRes:addTo(self.layer)
        self.layer:addTo(self.root)

        self.mInterfaceRes:setLocalZOrder(100)

        --self:Adaptation()
    end
    self.mIsLoad = true
end

function CSBBase:show(...)

    if(self.root == nil) then
        self.root = cc.Node:create()
            :addTo(laixiaddz.ui.UILayer)
    end
    self:loadResource()

    if(self.hDialogType == DialogTypeDef.DEFINE_SINGLE_DIALOG) then
        laixia.LocalPlayercfg.LaixiaCurrentWindow = self.mDialogName
    end
    if(self.hDialogType == DialogTypeDef.DEFINE_NORMAL_DIALOG) then
        laixia.LocalPlayercfg.LaixiaCurrentNomarlWindow = self.mDialogName
    end

    if(self.hDialogType == DialogTypeDef.DEFINE_SINGLE_DIALOG) then
        laixiaddz.ui.WindowManager:onTop(self)
    elseif(self.hDialogType == DialogTypeDef.DEFINE_INNER_DIALOG) then
        laixiaddz.ui.WindowManager:intoInnerList(self)
    elseif(self.hDialogType == DialogTypeDef.DEFINE_NORMAL_DIALOG) then
        laixiaddz.ui.WindowManager:intoNormalList(self)
    end

    laixiaddz.ui.WindowManager:updateZOrder()
    self:onShow(...)

    laixiaddz.ui.WindowManager:setActiveWindow(self);

end


function CSBBase:destroy()

    if(not self.mIsLoad ) then
        if self.hDialogType == DialogTypeDef.DEFINE_NORMAL_DIALOG then
            laixiaddz.ui.WindowManager:destoryNormalWindowsByList(self)
        end
        return;
    end

    self.mDialogObj:onDestroy()
    self.mIsLoad = false

    if(self.mInterfaceRes ~= nil) then
        self.mInterfaceRes:removeFromParent()
    end

    laixiaddz.ui.WindowManager:destoryInnerWindowsByKey(self:getName())
    if(self.hDialogType == DialogTypeDef.DEFINE_SINGLE_DIALOG) then
        if(laixiaddz.ui.WindowManager.mTopWindow == self) then
            laixiaddz.ui.WindowManager.mTopWindow = nil
            laixiaddz.ui.WindowManager:destoryAllNormalWindows()
        end
    elseif self.hDialogType == DialogTypeDef.DEFINE_NORMAL_DIALOG then
        laixiaddz.ui.WindowManager:destoryNormalWindowsByList(self)
    end

    if(self:isActiveDialog()) then
        laixiaddz.ui.WindowManager:updateActiveWindow();
    end
    self.mDialogObj = nil
    self.layer:removeFromParent()
    self.layer= nil

end

function CSBBase:onTick(dt)
end

function CSBBase:onShow()
end

function CSBBase:onUpdate()
end

function CSBBase:onEnter()
end

function CSBBase:onDestroy()
end

return CSBBase
                