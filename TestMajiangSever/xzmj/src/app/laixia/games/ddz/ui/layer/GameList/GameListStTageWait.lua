local GameStTageWait = class("GameStTageWait", import("...CBaseDialog"):new())-- 
local soundConfig =  laixiaddz.soundcfg    
local Packet = import("....net.Packet") 

function GameStTageWait:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
    self.stageName = {["1"]="第一阶段:",["2"]="第二阶段:",["3"]="第三阶段:",["4"]="第四阶段:",["5"]="第五阶段:",["6"]="第六阶段:",["7"]="第七阶段:",["8"]="第八阶段:"}
    self.stageDesc = {["1"]="打立出局",["2"]="定局积分"}
    -- SCORE = 定局积分 STAND = 打立出局
    self.stageType = {STAND = 1,SCORE = 2} 
end

function GameStTageWait:getName()
    return "GameStTageWait" -- csb = GameStTageWait.csb
end

function GameStTageWait:onInit()
    self.super:onInit(self)
    -- 注册事件
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHIOW_MATCHWAITLOADING_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_MATCHWAITLOADING_WINDOW, handler(self, self.destroy))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_UPDATE_MATCHWAITLOADING_WINDOW, handler(self, self.update))
end

function GameStTageWait:onShow(mesg)
    laixiaddz.LocalPlayercfg.LaixiaisConnectCardTable = false
    self:AddWidgetEventListenerFunction("GSW_Button_Award", handler(self, self.onShowAward))
    self:AddWidgetEventListenerFunction("GSW_Button_Rank", handler(self, self.onShowRanking))
    self.mRank = self:GetWidgetByName("GSW_Label_Ranking")
    self.mTotoal = self:GetWidgetByName("GSW_Label_Integral")
    local data= mesg.data
    if data == nil then return end
    self.mTabNum = self:GetWidgetByName("GSW_Label_Surplus")
    print("wait = 0=",laixiaddz.LocalPlayercfg.LaixiaMatchStage)
    if tonumber(laixiaddz.LocalPlayercfg.LaixiaMatchStage) == tonumber(self.stageType.SCORE) then 
        self.mTotoal:setVisible(true)
        self.mTotoal:setString("当前积分：".. laixiaddz.LocalPlayercfg.LaixiaMatchIntegral or 0)
        self.mTabNum:setString("未结束桌数："..data.TabNum)
        self.mTabNum:setVisible(true)
        self.mRank:setVisible(false)
    elseif tonumber(laixiaddz.LocalPlayercfg.LaixiaMatchStage) == tonumber(self.stageType.STAND) then
        self.mTotoal:setVisible(false)
        self.mTabNum:setVisible(false)
        self.mRank:setVisible(true)
        self.mRank:setString( "当前排名："..laixiaddz.LocalPlayercfg.LaixiaMatchRank.."/"..laixiaddz.LocalPlayercfg.LaixiaMatchTotalNum )
    end
    local dalichuju=self:GetWidgetByName("GSW_Label_Surplus_Copy")
    if data.Status and tonumber(data.Status) == 2 then
        -- 等待阶段
        dalichuju:setString("请等待其他桌结束！")
    elseif data.Status and tonumber(data.Status) == 0  then
        -- 晋级
        dalichuju:setString("您已晋级，请等待其他玩家！")
    end
    dalichuju:setVisible(true)
    self:GetWidgetByName("Text_mathName"):setString(data.match_name or laixiaddz.LocalPlayercfg.LaixiaMatchName)
    print("wait = 1=",data.match_name)
    local str = self.stageName[tonumber(data.StageNum)] or ""
    local str1 = self.stageDesc[tonumber(laixiaddz.LocalPlayercfg.LaixiaMatchStage)] or ""
    print("wait = 2=",str)
    print("wait = 3=",str1)
    self:GetWidgetByName("Text_dalidingju"):setString(str..str1)  
end

--[[
 * 推送 等待信息  -- TODO 可以分两个刷新 1.全局 2.参数
 * @param  mesg = {data={TabNum}}
--]]
function GameStTageWait:update(mesg)
    dump(self.mIsLoad,"self.mIsLoad")
    dump(mesg,"mesg")
    if self.mIsLoad and mesg.data then
        local data = mesg.data
        if laixiaddz.LocalPlayercfg.LaixiaMatchStage and tonumber(laixiaddz.LocalPlayercfg.LaixiaMatchStage) == tonumber(self.stageType.STAND) then--打立出局
            local rank = laixiaddz.LocalPlayercfg.LaixiaMatchRank or 1
            local rankMax = laixiaddz.LocalPlayercfg.LaixiaMatchTotalNum or 1
            local strInfo = "当前排名："..rank.."/"..rankMax
            if self.mRank then
                self.mRank:setString(strInfo)
            end
        end
        self.mTabNum:setString("未结束桌数："..(data.TabNum or 0))
        self.mTotoal:setString("当前积分：".. laixiaddz.LocalPlayercfg.LaixiaMatchIntegral)
    end
end

function GameStTageWait:onShowAward(sender, eventType)
    if ccui.TouchEventType.ended == eventType then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        laixiaddz.LocalPlayercfg.LaixiaIsShowMatchRank = false
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_GOMATCHRANK_WINDOW)
    end
end

function GameStTageWait:onShowRanking(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        laixiaddz.LocalPlayercfg.LaixiaIsShowMatchRank = true 
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_GOMATCHRANK_WINDOW)
    end
end

function GameStTageWait:onTick()
end

function GameStTageWait:onDestroy()
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHRANK_WINDOW) --关闭中间等级界面
end

function GameStTageWait:onCallBackFunction()
end

return GameStTageWait.new()

