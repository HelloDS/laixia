
DialogTypeDef = { }
DialogTypeDef.DEFINE_NORMAL_DIALOG = 0   -- 正常的窗口
DialogTypeDef.DEFINE_SINGLE_DIALOG = 1   -- 单窗口
DialogTypeDef.DEFINE_INNER_DIALOG = 2    -- 组件页面


local CBaseDialog = class("CBaseDialog")

local laixia = laixia;
laixiaddz.ui.CBaseDialog = CBaseDialog;
local L_JT_window = laixia.JsonTxtData:queryTable("window");

local display = display;
--修1
local XScale = display.widthInPixels / display.config_width --/ display.contentScaleFactor;
local YScale = display.heightInPixels / display.config_height --/ display.contentScaleFactor;

-- 构造函数
function CBaseDialog:ctor(...)
    self.root = nil
    self.mDialogName = "None" -- 基本上，这里保证的是和表里的Window名相同
    self.mIsLoad = false
    self.mDialogItemData = nil
    self.mInterfaceRes = nil     -- 这个是 真正的界面
    self.mDialogObj = nil
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG   --默认窗口
end

--析构函数 ，模拟，所有的最好删除调用一下   ~~
function CBaseDialog:dtor(...)
    self.mDialogObj = nil
    self.mDialogItemData = nil
    self.root:removeFromParent() --
    self.bShowColorLayer = true;
    self.root = nil
end

function CBaseDialog:getName()
    return "CBaseDialog";
end

--有些界面需要层级高的可以这样设置
function CBaseDialog:getZorder()
    return  0
end

--有些界面需要不需要显示动画
function CBaseDialog:isShowAnimation()
    return  true
end

function CBaseDialog:onInit(hDialog)
    self:SetShowColorLayerFunc(true);
    self.mDialogName = hDialog:getName();
    self.mDialogObj = hDialog;
    self.mDialogItemData =  L_JT_window:query("WindowName",self.mDialogName);
end

function CBaseDialog:isLoaded()
    return self.mIsLoad
end

function CBaseDialog:IsShowColorLayerFunc()
    return self.bShowColorLayer;
end

function CBaseDialog:SetShowColorLayerFunc(bVal)
    self.bShowColorLayer = bVal;
end

--进行适配
function CBaseDialog:Adaptation()
    local view = self.mInterfaceRes;
    view:setAnchorPoint(0.5,0.5)
    view:pos(display.cx, display.cy)
    --view:setScale(display.contentScaleFactor)
    -- view:setScaleY(display.widthInPixels/display.width)
    if(self.hDialogType ~= DialogTypeDef.DEFINE_SINGLE_DIALOG) then
        --view:setScale(display.contentScaleFactor)
            -- :scaleX(XScale)
            -- :scaleY(YScale)
    end
end

function CBaseDialog:AddWidgetEventListenerFunction(ctrlName,event,ctrlParent)

    local  control = nil
    control = self:GetWidgetByName(ctrlName,ctrlParent)

    if(control  ~= nil ) then
        control:addTouchEventListener(event)
    end
end

function CBaseDialog:update(...)
    if self.mIsLoad then
        self.mDialogObj:onUpdate(...)
    end
end


--start ADD by wangtianye
function CBaseDialog:GetWidgetByName(ctrlName,parentControl)
    --	if(nil == parentControl) then
    --    	return ccui.Helper:seekWidgetByName(self.mInterfaceRes,ctrlName)
    --	else
    --		return ccui.Helper:seekWidgetByName(parentControl,ctrlName)
    --	end
    if(nil == parentControl) then
        return self:findNodeByName(self.mInterfaceRes,ctrlName)
    else
        return self:findNodeByName(parentControl,ctrlName)
    end

    return nil
end
---- 遍历UI节点,返回指定名字的Node, 递归
function CBaseDialog:findNodeByName(root,name)
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
--end ADD by wangtianye
function CBaseDialog:tick(dt)
    if(self.mIsLoad) then
        self:onTick(dt)
    end
end

function CBaseDialog:isActiveDialog()
    local winManager = laixiaddz.ui.WindowManager
    return self.mDialogObj == winManager:getActiveWindow();
end

function CBaseDialog:onCallBackFunction()

    if self:getName() == "LobbyWindow" then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_ANDROIDBACKTK_WINDOW)
    elseif self:getName() == "GameListWindow" or self:getName() == "GameRoomGround" then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW)
    elseif self.hDialogType == DialogTypeDef.DEFINE_SINGLE_DIALOG and laixia.LocalPlayercfg.OnReturnFunction then
        ObjectEventDispatch:pushEvent(laixia.LocalPlayercfg.OnReturnFunction)
    elseif self.hDialogType == DialogTypeDef.DEFINE_NORMAL_DIALOG then
        self:destroy()
    end
end

function CBaseDialog:setVisible(boval)
    if nil~= self.root then
        self.root:setTouchEnabled(boval)
        self.root:setVisible(boval)
    end
end

function CBaseDialog:onOjbectCallBackFunction()
    if(self.mDialogObj.onCallBackFunction ~= nil) then
        self.mDialogObj:onCallBackFunction();
    end
end


function CBaseDialog:load()

    if(not self.mIsLoad) then
        if self.hDialogType ~= DialogTypeDef.DEFINE_INNER_DIALOG and self.hDialogType ~= DialogTypeDef.DEFINE_SINGLE_DIALOG then
            self.layer= display.newLayer()



            if(self:IsShowColorLayerFunc())  then
                self.layer_temp= cc.LayerColor:create(cc.c4b(0,0,0,125),display.width, display.height)
            else
                self.layer_temp= cc.LayerColor:create(cc.c4b(0,0,0,0),display.width, display.height)
            end
            self.layer_temp:setTouchEnabled(true)
            self.layer_temp:setTouchMode(1);
            -- self.layer:setTouchSwallowEnabled(true)
            self.layer_temp:setPosition(cc.p(0,0))
            self.layer_temp:addTo(self.layer)
            local function touchBegan(touch, event) 
                return true
            end

            local function touchMoved(touch, event)
            end
            local function touchEnded(touch, event)
                if  laixia.LocalPlayercfg.LaixiaCurrentNomarlWindow~="TiShiYu" and laixia.LocalPlayercfg.LaixiaCurrentNomarlWindow ~= "GameListResult" and laixia.LocalPlayercfg.LaixiaCurrentNomarlWindow ~= "PokerResultWindow_SelfBuilding" and laixia.LocalPlayercfg.LaixiaCurrentNomarlWindow ~= "GameStTageWait" and laixia.LocalPlayercfg.LaixiaCurrentNomarlWindow ~= "GameListJoin" and laixia.LocalPlayercfg.LaixiaCurrentNomarlWindow ~= "BindPhone" and laixia.LocalPlayercfg.LaixiaisSNG == false then
                    self:destroy()
                end    
            end
            local listener = cc.EventListenerTouchOneByOne:create()  
            listener:registerScriptHandler(touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)  
            listener:registerScriptHandler(touchMoved, cc.Handler.EVENT_TOUCH_MOVED)  
            listener:registerScriptHandler(touchEnded, cc.Handler.EVENT_TOUCH_ENDED)  
            cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self.layer_temp)  
            listener:setSwallowTouches(true)
            -- local function onTouch(eventType,x,y)
            --     -- ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MARKEDWORDS_WINDOW)
            --     if self.layer then
            --         self.layer:removeFromParent()
            --         self.layer = nil
            --     end.
            --     return true;
            -- end
            -- self.layer:registerScriptTouchHandler(onTouch);

            print("wang加载文件"..self.mDialogItemData.Resource)
            if(string.find(self.mDialogItemData.Resource,".csb")) then
                self.mInterfaceRes = laixiaddz.Layout.loadLayer(self.mDialogItemData.Resource)
            else
                self.mInterfaceRes = ccs.GUIReader:getInstance():widgetFromJsonFile(self.mDialogItemData.Resource);
            end
            self.mInterfaceRes:setTouchEnabled(true)
            -- local function onTouchBegan(touch, event) 
            --     return true
            -- end

            -- local function onTouchMoved(touch, event)
            -- end

            -- local function onTouchEnded(touch, event)
            -- end
            -- local listener2 = cc.EventListenerTouchOneByOne:create()  
            -- listener2:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)  
            -- listener2:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)  
            -- listener2:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)  
            -- cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener2, self.mInterfaceRes)  
            -- listener2:setSwallowTouches(true)

            
            self.mInterfaceRes:addTo(self.layer)
            self.layer:addTo(self.root)

            self.mInterfaceRes:setLocalZOrder(100)
            self:Adaptation()
        else
            self.layer= display.newLayer()

             print("wang加载文件"..self.mDialogItemData.Resource)
            if(string.find(self.mDialogItemData.Resource,".csb")) then
                self.mInterfaceRes = laixiaddz.Layout.loadLayer(self.mDialogItemData.Resource)
            else
                self.mInterfaceRes = ccs.GUIReader:getInstance():widgetFromJsonFile(self.mDialogItemData.Resource);
            end
            self.mInterfaceRes:setTouchEnabled(true)
            -- local function onTouchBegan2(touch, event) 
            --     return true
            -- end

            -- local function onTouchMoved2(touch, event)
            -- end

            -- local function onTouchEnded2(touch, event)
            -- end
            -- local listener3 = cc.EventListenerTouchOneByOne:create()  
            -- listener3:registerScriptHandler(onTouchBegan2, cc.Handler.EVENT_TOUCH_BEGAN)  
            -- listener3:registerScriptHandler(onTouchMoved2, cc.Handler.EVENT_TOUCH_MOVED)  
            -- listener3:registerScriptHandler(onTouchEnded2, cc.Handler.EVENT_TOUCH_ENDED)  
            -- cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener3, self.mInterfaceRes)  
            -- listener3:setSwallowTouches(true)
            self.mInterfaceRes:addTo(self.layer)
            self.layer:addTo(self.root)

            self.mInterfaceRes:setLocalZOrder(100)
            self:Adaptation()
        end

       
    end
    self.mIsLoad = true
end

--打开窗口动画
function CBaseDialog:windowOpenEffects()
    self.mInterfaceRes:setScale(0.3)
    local actionTo = cc.EaseBackOut:create(cc.ScaleTo:create(0.28, 1.02))
    local actionTo2 = cc.EaseSineIn:create(cc.ScaleTo:create(0.1, 1.0))
    local seq = cc.Sequence:create(actionTo,actionTo2)
    self.mInterfaceRes:runAction(seq)
end

--关闭窗口动画
function CBaseDialog:windowCloseEffects()
    --self.mInterfaceRes:setScale(0.3)
    local actionTo = cc.EaseBackIn:create(cc.ScaleTo:create(0.25, 0.3))
    self.mInterfaceRes:runAction(actionTo)
end


function CBaseDialog:show(...)

    if(self.root == nil) then
        self.root = cc.Node:create()
            :addTo(laixiaddz.ui.UILayer)
    end
    self:load()

    if(self.hDialogType == DialogTypeDef.DEFINE_SINGLE_DIALOG) then
        laixia.LocalPlayercfg.LaixiaCurrentWindow = self.mDialogName
    end
    if(self.hDialogType == DialogTypeDef.DEFINE_NORMAL_DIALOG) then
        laixia.LocalPlayercfg.LaixiaCurrentNomarlWindow = self.mDialogName
        if self:isShowAnimation()  then
            self:windowOpenEffects()
        end

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


function CBaseDialog:destroy()

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
        --self:windowCloseEffects()
        laixiaddz.ui.WindowManager:destoryNormalWindowsByList(self)
    end

    if(self:isActiveDialog()) then
        laixiaddz.ui.WindowManager:updateActiveWindow();
    end
    if self.layer_temp then
        self.layer_temp:removeFromParent()
        self.layer_temp = nil
    end
    self.mDialogObj = nil
    self.layer:removeFromParent()
    self.layer= nil
   

end

function CBaseDialog:onTick(dt)
end
function CBaseDialog:onShow()
end
function CBaseDialog:onUpdate()
end
function CBaseDialog:onEnter()
end
function CBaseDialog:onDestroy()
end


return CBaseDialog
                