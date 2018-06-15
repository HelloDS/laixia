
local GameListQuitSelected = class("GameListQuitSelected", import("...CBaseDialog"):new())-- 
local soundConfig = laixia.soundcfg;     
local Packet = import("....net.Packet") 


function GameListQuitSelected:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
    self.rds = nil
end

function GameListQuitSelected:getName()
    return "GameListQuitSelected"
end

function GameListQuitSelected:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_CUEWORDSSELECT_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_HIDE_CUEWORDSSELECT_WINDOW, handler(self, self.destroy))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_MATCHBROADCAST_WINDOW, handler(self, self.addMatchRds))
end

function GameListQuitSelected:addMatchRds(mesg)
    self.rds = mesg.data
end

function GameListQuitSelected:onShow(data)
  	

    self.mText = self:GetWidgetByName("Carnage_Label_Title")  --说明文本
    self.Carnage_Label_tips = self:GetWidgetByName("Carnage_Label_tips")
    self.tiShiBG = self:GetWidgetByName("Image_1")
    self.tiShiBG:setTouchEnabled(true)
    self.tiShiBG:setTouchSwallowEnabled(true)
    
    self:AddWidgetEventListenerFunction("Carnage_Button_Carnage",handler(self,self.leftCallFun)) 
    self:AddWidgetEventListenerFunction("Carnage_Button_Close",handler(self,self.rightCallFun))   
    self:AddWidgetEventListenerFunction("Carnage_Button_GoOn", handler(self, self.rightCallFun))
    if self.rds ~= nil then
        local rds = self.rds[1]
        local itemData = laixia.JsonTxtData:queryTable("items"):query("ItemID",rds.ItemId);
            
            --self:GetWidgetByName("Carnage_Image_Top_sign"):loadTexture(itemData.ImagePath, 1)

            local icon = self:GetWidgetByName("Carnage_Image_Top_sign")
            icon:loadTexture(itemData.ImagePath)

        if rds.ItemCT >= 1 then
            -- self:GetWidgetByName("Carnage_Label_Points"):setString(rds.ItemCT)
            self:GetWidgetByName("Carnage_Label_Points"):setVisible(false)
        end
    end
        -- 前面要加一个判断是否是在
    if laixia.LocalPlayercfg.LaixiaCurrentWindow == "CardTableDialog" and laixia.LocalPlayercfg.LaixiaIsInMatch== true  then
        self.Carnage_Label_tips:setString("退出比赛将会托管")
    end

    if data.data ~= nil then    
        if data.data.Text ~= nil then
            self.mText:setString(data.data.Text)
        end
        if data.data.OnLeftCallFun ~= nil then
            self.mLeftCallFun = data.data.OnLeftCallFun
        end
        if data.data.OnRightCallFun ~= nil then
            self.mRightCallFun = data.data.OnRightCallFun
        end
    end
end

function GameListQuitSelected:leftCallFun(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.mLeftCallFun ~= nil then
            --退出比赛时 更新轮次信息
            laixia.LocalPlayercfg.LaixiaMatchRoundNum = 0
            self.mLeftCallFun()
        else
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_CUEWORDSSELECT_WINDOW)
        end
    end
end

function GameListQuitSelected:rightCallFun(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
   
         if self.mRightCallFun ~= nil then
            self.mRightCallFun()
         else
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_CUEWORDSSELECT_WINDOW)
        end
    end
end

function GameListQuitSelected:onTick()

    if self.mIsLoad== true then
        --self:GetWidgetByName("Carnage_Label_Top"):setString("排名"..laixia.LocalPlayercfg.LaixiaMatchRank.."/"..laixia.LocalPlayercfg.LaixiaMatchTotalNum)
        
        -- self:GetWidgetByName("Carnage_Label_Top"):setString("排名" .. laixia.LocalPlayercfg.NowRankinSNG .. "/" .. "3")

    end
end

function GameListQuitSelected:onDestroy()
end

return GameListQuitSelected.new()


