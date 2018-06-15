



local GameStTageWait = class("GameStTageWait", import("...CBaseDialog"):new())-- 
local soundConfig =  laixia.soundcfg    
local Packet = import("....net.Packet") 

function GameStTageWait:ctor(...)

    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function GameStTageWait:getName()

    return "GameStTageWait"
end

function GameStTageWait:onInit()
    self.super:onInit(self)
    -- 初始化  CBaseDialog:onInit() --调用父类方法


    -- printInfo("LobbyWindow:onInit")
    -- 注册事件
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHIOW_MATCHWAITLOADING_WINDOW, handler(self, self.show))

    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_HIDE_MATCHWAITLOADING_WINDOW, handler(self, self.destroy))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_UPDATE_MATCHWAITLOADING_WINDOW, handler(self, self.update))
end


function GameStTageWait:onShow(mesg)

    laixia.LocalPlayercfg.LaixiaisConnectCardTable = false
--    if laixia.LocalPlayercfg.LaixiaMatchRoomType == 1  then
--        self.root:runAction(cc.Sequence:create(
--                cc.DelayTime:create(1.8),
--                cc.CallFunc:create(
--                    function()   
--                        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_CLEAR_DATELANDLORDTABLE_WINDOW,"进入等待界面清除数据")
--                    end),nil))  
--    end
    -- if laixia.LocalPlayercfg.LaixiaisLIUJU == 5 then
    --     ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_CLEAR_DATELANDLORDTABLE_WINDOW,"进入等待界面清除数据")
    -- end
    self:AddWidgetEventListenerFunction("GSW_Button_Award", handler(self, self.onShowAward))
    self:AddWidgetEventListenerFunction("GSW_Button_Rank", handler(self, self.onShowRanking))

    self.mRank = self:GetWidgetByName("GSW_Label_Ranking")
    self.mTotoal = self:GetWidgetByName("GSW_Label_Integral")
    -- self.mRank:enableOutline(cc.c4b(145, 10, 0, 255), 1)
    self.Panel_16 = self:GetWidgetByName("Panel_16")

    local data= mesg.data
    if data == nil then
        return
    end
    self.mTabNum = self:GetWidgetByName("GSW_Label_Surplus")
    --第一阶段隐藏self.mTabNum
    --晋级阶段 第一名显示动画(界面上东西全部隐藏) 第二名显示这个并显示self.mTabNum
    -- if laixia.LocalPlayercfg.LaixiaMatchRoundNum  == 1 then
    --     if laixia.LocalPlayercfg.LaixiaMatchStage == 3 then --定居积分
    --         self.mTabNum:setVisible(false)
    --         self.mRank:setString("当前排名：".."1/3" )
    --     elseif laixia.LocalPlayercfg.LaixiaMatchStage == 1 then--大力出局
    --         self.mTabNum:setVisible(false)
    --         self.mRank:setString("当前排名：".."1/"..laixia.LocalPlayercfg.LaixiaMatchTotalNum )
    --     end
    --     --laixia.LocalPlayercfg.LaixiaMatchStage = 1
    --     --laixia.LocalPlayercfg.LaixiaMatchlastStage = 2
    -- elseif laixia.LocalPlayercfg.LaixiaMatchRoundNum >= 2  then
        --self.mTabNum:setVisible(true)

   
    if laixia.LocalPlayercfg.LaixiaMatchStage == 3 then 
        --  if laixia.LocalPlayercfg.LaixiaMatchRank == 1 then
        --     local system = laixia.ani.CocosAnimManager
        --     self.doudizhu_wait = system:playAnimationAt(self.Panel_16,"doudizhu_promotion")
        --     self.doudizhu_wait:setPositionX(display.cx)
        --     self.doudizhu_wait:setPositionY(display.height/5*3)
        --     self.doudizhu_wait:setLocalZOrder(10)
        -- end
        
            self:GetWidgetByName("Text_mathName"):setPositionY(self:GetWidgetByName("Text_mathName"):getPositionY()-15)
            self:GetWidgetByName("Text_dalidingju"):setVisible(false)
            self.mRank:setVisible(false)
            self.mTabNum:setVisible(true)
    elseif laixia.LocalPlayercfg.LaixiaMatchStage == 1 then--打立出局
            -- if laixia.LocalPlayercfg.LaixiaMatchRank == 1 then
            --     local system = laixia.ani.CocosAnimManager
            --     self.doudizhu_wait = system:playAnimationAt(self.Panel_16,"doudizhu_promotion")
            --     self.doudizhu_wait:setPositionX(display.cx)
            --     self.doudizhu_wait:setPositionY(display.height/5*3)
            --     self.doudizhu_wait:setLocalZOrder(10)
            -- end
            self:GetWidgetByName("Text_mathName"):setPositionY(self:GetWidgetByName("Text_mathName"):getPositionY()-15)
            self:GetWidgetByName("Text_dalidingju"):setVisible(false)
            self.mRank:setVisible(false)
            self.mTabNum:setVisible(true)
            self.mRank:setString( "当前排名："..laixia.LocalPlayercfg.LaixiaMatchRank.."/"..laixia.LocalPlayercfg.LaixiaMatchTotalNum )
    end

    self.mTabNum:setString("未结束桌数："..data.TabNum)--"剩余"..data.TabNum.."桌未结束，请稍后...")

    self:GetWidgetByName("Text_mathName"):setString(laixia.LocalPlayercfg.LaixiaMatchName)

    self.mTotoal:setString("当前积分：".. laixia.LocalPlayercfg.LaixiaMatchIntegral)

    local dalichuju=self:GetWidgetByName("GSW_Label_Surplus_Copy")
    if data.mesg ~= nil then       
        dalichuju:setString(data.mesg)
    end
    if laixia.LocalPlayercfg.LaixiaMatchStage==laixia.LocalPlayercfg.LaixiaMatchlastStage then
        if laixia.LocalPlayercfg.LaixiaMatchStage == 1  then
            self:GetWidgetByName("Text_dalidingju"):setString("第一阶段：打立出局")
        elseif laixia.LocalPlayercfg.LaixiaMatchStage == 3 then
            self:GetWidgetByName("Text_dalidingju"):setString("第一阶段：定局积分")
        end
    else
        if laixia.LocalPlayercfg.LaixiaMatchStage == 1  then
            self:GetWidgetByName("Text_dalidingju"):setString("第二阶段：打立出局")
        elseif laixia.LocalPlayercfg.LaixiaMatchStage == 3 then
            self:GetWidgetByName("Text_dalidingju"):setString("第二阶段：定局积分")
        end
    end
    --self:GetWidgetByName("GSW_Label_Surplus"):setVisible(false)
    
    -- if  then
    --     self:GetWidgetByName("GSW_Label_Surplus"):setVisible(true)
    -- end


   if laixia.LocalPlayercfg.LaixiaMatchStage == 3 then        -- 定局积分
        dalichuju:setVisible(true)
    elseif laixia.LocalPlayercfg.LaixiaMatchStage == 1 then
        dalichuju:setVisible(true)        
    end
    -- self.mTotoal:setVisible(dalichuju:isVisible())

   

end

function GameStTageWait:update(mesg)
    if not self.mIsLoad then
        return 
    end

    local data = mesg.data
    --self.mTabNum:setVisible(true)  
     if laixia.LocalPlayercfg.LaixiaMatchStage == 3 then 
            self.mRank:setVisible(false)
            self.mTabNum:setVisible(true)
    elseif laixia.LocalPlayercfg.LaixiaMatchStage == 1 then--打立出局
            self.mRank:setVisible(false)
            self.mTabNum:setVisible(true)
            self.mRank:setString( "当前排名："..laixia.LocalPlayercfg.LaixiaMatchRank.."/"..laixia.LocalPlayercfg.LaixiaMatchTotalNum )
    end
    --if laixia.LocalPlayercfg.LaixiaMatchRoundNum  == 1 then
    if laixia.LocalPlayercfg.LaixiaMatchStage==laixia.LocalPlayercfg.LaixiaMatchlastStage then
        if laixia.LocalPlayercfg.LaixiaMatchStage == 1  then
            self:GetWidgetByName("Text_dalidingju"):setString("第一阶段：打立出局")
        elseif laixia.LocalPlayercfg.LaixiaMatchStage == 3 then
            self:GetWidgetByName("Text_dalidingju"):setString("第一阶段：定局积分")
        end
    else
        if laixia.LocalPlayercfg.LaixiaMatchStage == 1  then
            self:GetWidgetByName("Text_dalidingju"):setString("第二阶段：打立出局")
        elseif laixia.LocalPlayercfg.LaixiaMatchStage == 3 then
            self:GetWidgetByName("Text_dalidingju"):setString("第二阶段：定局积分")
        end
    end
    --else
    --    self:GetWidgetByName("Text_dalidingju"):setVisible(false)
    --end
    self.mTabNum:setString("未结束桌数："..data.TabNum)--"剩余"..data.TabNum.."桌未结束，请稍后...")
    self.mTotoal:setString("当前积分：".. laixia.LocalPlayercfg.LaixiaMatchIntegral)
    self:GetWidgetByName("Text_mathName"):setString(laixia.LocalPlayercfg.LaixiaMatchName)

end


function GameStTageWait:onShowAward(sender, eventType)
    if ccui.TouchEventType.ended == eventType then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        laixia.LocalPlayercfg.LaixiaIsShowMatchRank = false
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_GOMATCHRANK_WINDOW)
     end
end

function GameStTageWait:onShowRanking(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        laixia.LocalPlayercfg.LaixiaIsShowMatchRank = true 
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_GOMATCHRANK_WINDOW)
    end
end



function GameStTageWait:onTick()

end


function GameStTageWait:onDestroy()
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MATCHRANK_WINDOW) --关闭中间等级界面
end

function GameStTageWait:onCallBackFunction()
end


return GameStTageWait.new()

