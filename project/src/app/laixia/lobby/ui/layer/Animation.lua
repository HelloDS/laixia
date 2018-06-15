local soundConfig =  laixia.soundcfg    


local Animation = class("Animation", function()
    return ccs.GUIReader:getInstance():widgetFromBinaryFile("new_ui/Animation.csb")
end )

function Animation:ctor(...)
    self.mViewList = {}
    self.mCallFuncList = {}
    self.mIndex = 0
    self.mPanel = ccui.Helper:seekWidgetByName(self,"Panel_Animation")
    self.mAiAdder = ccui.Helper:seekWidgetByName(self,"Image_TiShiyuConnectCircle_center")
    
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, handler(self, self.addInfo)) --显示飘字动画
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_EFFECTGOLD_WINDOW, handler(self, self.jinbitexiao)) --显示金币掉落

    self.mPanel:setPosition(cc.p(display.cx,display.cy))
    self.isShow = true
end

function Animation:jinbitexiao(data)
    laixia.soundTools.playSound(soundConfig.EVENT_SOUND.ui_evevt_achieve_gold)
    -- local system = laixia.ani.CObjectAnimationManager;
    -- local node  = system:playAnimationAt(self.mPanel,"jinbidiaoluo","Default Timeline",
    -- function()                
    -- end )
    -- node:setPosition(cc.p(-display.width/2,-display.height/2)) 

    self.layer= cc.LayerColor:create(cc.c4b(0,0,0,160),display.width, display.height)
    self.layer:setTouchEnabled(true)
    --self.layer:setTouchMode(1);
    self.layer:setPosition(cc.p(-display.cx,-display.cy))
    
    --self.layer:setSwallowsTouches(true)
    -- local function onTouch(eventType,x,y)
        
    --     return true;
    -- end
    -- self.layer:registerScriptTouchHandler(onTouch);
    self.layer:addTo(self.mPanel) 

    local function touchBegan(touch, event) 
        return true
    end

    local function touchMoved(touch, event)
    end

    local function touchEnded(touch, event)
        if self.layer then
            self.mPanel:removeAllChildren()
            self.layer = nil
        end     
    end

    local listener = cc.EventListenerTouchOneByOne:create()  
    listener:registerScriptHandler(touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)  
    listener:registerScriptHandler(touchMoved, cc.Handler.EVENT_TOUCH_MOVED)  
    listener:registerScriptHandler(touchEnded, cc.Handler.EVENT_TOUCH_ENDED)  
   --listener:registerScriptHandler(touchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED)  
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self.layer)  
    listener:setSwallowTouches(true)
    
    -- self.BG = display.newColorLayer(cc.c4b(0,0,0,120))
    -- self.BG:setPosition(cc.p(-display.cx,-display.cy))
    -- self.BG:setLocalZOrder(10)
    -- self.BG:addTo(self.mPanel)
    -- if self.BG then
    --     -- local function onTouch(eventType,x,y)
    --     --     return true;
    --     -- end
    --     self.BG:registerScriptTouchHandler(self.removeLayer);
    -- end
    local system = laixia.ani.CocosAnimManager
    local node = system:playAnimationAt(self.layer,"doudizhu_turntable_ordinary")
    node:setPosition(cc.p(display.cx,display.cy))
    if data.data ~= nil then
        local icon = display.newSprite(data.data.iconpath)
        icon:setAnchorPoint(cc.p(0.5,0.5))
        icon:addTo(self.layer)
        icon:setLocalZOrder(10)
        icon:setPosition(cc.p(display.cx,display.cy))   
        local tipsBG =  display.newSprite("new_ui/TurnWindow/zhongjiangdi.png")
        tipsBG:setAnchorPoint(cc.p(0.5,0.5))
        tipsBG:setPosition(cc.p(display.cx,display.cy-140))
        tipsBG:addTo(self.layer)
        local jinbiNum = cc.Label:createWithSystemFont("", "Arial", 30)
        jinbiNum:setAnchorPoint(cc.p(0.5,0.5))                   
        jinbiNum:setPosition(cc.p(tipsBG:getContentSize().width/2,tipsBG:getContentSize().height/2))    
        jinbiNum:setLocalZOrder(20)
        jinbiNum:enableOutline(cc.c4b(111,42,0,255), 2)
        jinbiNum:addTo(tipsBG)
        jinbiNum:setString(data.data.jinbiNum)
    else                                
        local icon = display.newSprite("new_ui/common/new_common/day2.png")
        icon:setAnchorPoint(cc.p(0.5,0.5))
        icon:addTo(self.layer)
        icon:setLocalZOrder(10)
        icon:setPosition(cc.p(display.cx,display.cy))
    end
    self.layer:runAction(cc.Sequence:create(
                    cc.DelayTime:create(2.2),
                    cc.CallFunc:create(
                        function()
                            if self.layer then
                                self.layer:removeFromParent()
                                self.layer = nil
                            end                          
                        end),nil))  
end
function Animation:removeLayer(sender, event)
    if self.layer then
        self.layer:removeFromParent()
        self.layer = nil
        self.isShow = false
    end   
end
function Animation:addInfo(data)
    if self.isShow == true then
        local moveto = cc.MoveTo:create(1,cc.p(640,540))  
    
        local aiAdder = cc.Node:create()
        local mTag = tostring(self.mIndex)
        self.mIndex = self.mIndex+1

        local bg = ccui.ImageView:create()
    
        -- bg:loadTexture("coming_bar.png",1)
        bg:loadTexture("new_ui/tips_hongbao/di_sangai.png")
        bg:setScale9Enabled(true) --设置九宫格
        bg:setCapInsets(cc.rect(21,21,1,1))
        bg:setAnchorPoint(0.5,0.5)
        bg:addTo(aiAdder,1)   
    
        local label = ccui.Text:create()
        -- label:setFontSize(50)
        label:setFontSize(35)
        label:setTextColor(cc.c3b(255,234,134))
        label:addTo(aiAdder,2) 
        label:setAnchorPoint(0.5,0.5)
        label:setTextHorizontalAlignment(1)
        label:setTextVerticalAlignment(1)
        local x,y = label:getPosition()
        if type(data.data) ~= "table" then
            local str  = data.data:gsub("金币",laixia.utilscfg.CoinType());         
            label:setString(str)
        else
            local str  = data.data.text:gsub("金币",laixia.utilscfg.CoinType()); 
            label:setString(str)
            self.mCallFuncList[mTag]=data.data.OnCallFunc
        end
        local bgSize = bg:getContentSize()   
        local size = label:getContentSize()
        if size.width >670 then
            label:ignoreContentAdaptWithSize(false)
            label:setContentSize(cc.size(670,size.height*math.floor(size.width/670+1)))
            bg:setContentSize(cc.size(720,size.height*math.floor(size.width/670 + 1)))
        elseif (size.width > bgSize.width ) then 
            bg:setContentSize(cc.size(size.width + 50,bgSize.height))
        else
            bg:setContentSize(cc.size(bgSize.width + 50,bgSize.height)) 
        end
       
        bgSize = bg:getContentSize()  
        if (size.height > bgSize.height) then
           bg:setContentSize(cc.size(bgSize.width , size.height)) 
        end    
    
        transition.execute(label, cc.FadeIn:create(2), {
                    delay = 0,
                    onComplete = function()                                 
                                    if self.mCallFuncList[mTag] then
                                        self.mCallFuncList[mTag]()
                                    end
                                    aiAdder:removeFromParent()
                                    self.mCallFuncList[mTag] = nil
                                    self.mViewList[mTag] = nil
                    end,
                })
        -- if mTag > 0 then
        --     self.mViewList[mTag-1]:removeFromParent()
        -- end
    
        aiAdder:setPositionY(aiAdder:getPositionY()+150)
        aiAdder:addTo(self.mPanel)
    
        for k,v in pairs(self.mViewList) do
            if v then
                transition.execute(v, cc.MoveTo:create(0.1,cc.p(v:getPositionX(),v:getPositionY()+size.height*math.floor(size.width/650+1)+8)),nil)
            end
        end
        
        self.mViewList[mTag] = aiAdder
    end
end

return Animation

