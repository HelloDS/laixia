
local GameListWaitting= class("GameListWaitting",import("...CBaseDialog"):new())
local soundConfig =  laixiaddz.soundcfg    
local Packet =import("....net.Packet")

function GameListWaitting:ctor(...) 
    self.hDialogType = DialogTypeDef.DEFINE_SINGLE_DIALOG      
end

function GameListWaitting:getName()
	return "GameListWaitting"
end

function GameListWaitting:onInit()
    self.super:onInit(self) 
     ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_WAITSTATE_WINDOW, handler(self, self.show))
     ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_WAITSTATE_WINDOW, handler(self, self.destroy))
end


function GameListWaitting:onShow(mesg)
    
--    local system = laixiaddz.ani.CObjectAnimationManager;
--    local dizhupao = system:playAnimationAt(self.Panel_waittingAni,"Rain","Default Timeline",
--    function() 
--    end )
--    dizhupao:setPosition(cc.p(-640,-360))
--    dizhupao:setLocalZOrder(10000)
    


    self.ChangeTxt = self:GetWidgetByName("MW_BitmapLabel_Time")
    -- self.progressBar = self:GetWidgetByName("MW_ProgressBar")
    -- self.Image_jiedianNode = self:GetWidgetByName("MW_Image_Sign_Cell")
    -- self.Image_jiedianNode:setVisible(false)
    self.time  =0
    self.maxTime = self.time +1
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHJOIN_WINDOW)
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHWAITLOADING_WINDOW)-- 删掉中间等待界面
     



    -- local x= self:GetWidgetByName("Image_startPoint"):getPositionX()
    -- local y = self:GetWidgetByName("Image_startPoint"):getPositionY()
    -- local  length = self:GetWidgetByName("Image_endPoint"):getPositionX() - x

    local data = mesg.data
    if data == nil then
         return
    end
    local mMatchName=""
    if laixiaddz.LocalPlayercfg.LaixiaMatchName == "" or laixiaddz.LocalPlayercfg.LaixiaMatchName == nil  then
        mMatchName = cc.UserDefault:getInstance():getStringForKey("MatchName")
    else
        mMatchName = laixiaddz.LocalPlayercfg.LaixiaMatchName
    end

    mMatchName = mMatchName:gsub("金币",laixia.utilscfg.CoinType())
    self:GetWidgetByName("MW_BitmapLabel_Title"):setString(mMatchName)

    local  ranks = #data.RANKS
    local rank = 1
    for i = 1, ranks do
        if data.RANK == data.RANKS[i] then
            rank = i
        end
    end
    

    -- local per = (rank-1)/(ranks-1)
    -- if per < 0.1 then
    --     self.progressBar:setVisible(false)
    -- else
    --     self.progressBar:setVisible(true)
    --     self.progressBar:setPercent(per * 100)
    -- end

    
    -- self:GetWidgetByName("MW_Image_Person"):setPositionX(x+per*length)

    -- local  nowlength = length/(ranks -1) --开始和结束不用自己设置
    -- self:GetWidgetByName("MW_Image_SignStart_Label"):setString(data.RANKS[1])
    -- self:GetWidgetByName("MW_Image_SignEnd_Label"):setString(data.RANKS[ranks])
    -- for i=2 ,ranks -1 do
    --     local nodeClone = self.Image_jiedianNode:clone()
    --     local x1,y1 = nodeClone:getPosition()
    --     nodeClone:addTo(self.mInterfaceRes)
    --     nodeClone:setVisible(true)
    --     nodeClone:setPosition(x+(i-1)*nowlength-640,y-360)
    --     self:GetWidgetByName("MW_Image_SignCell_Label",nodeClone):setString(data.RANKS[i])
    -- end
    
    

end

function GameListWaitting:onTick(dt)
    if self.mIsLoad == true then
        --if laixiaddz.LocalPlayercfg.LaixiaMatchShowbar == true then
            self.time = self.time + dt
            if self.time >= self.maxTime then
                self.maxTime = self.maxTime + 1
            end

            if (21 - self.maxTime) >= 0 then
                local str =(21 - self.maxTime)
                if str < 10 then
                    str = "0" .. str
                end
                self.ChangeTxt:setString(str)
            else
                --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_WAITSTATE_WINDOW)         -- 删掉显示阶段
            end
       -- else
       --     self.ChangeTxt:setString(laixiaddz.LocalPlayercfg.LaixiaMatchRank .. "/" .. laixiaddz.LocalPlayercfg.LaixiaMatchTotalNum)
       -- end

    end

end


function GameListWaitting:onDestroy()
	 laixiaddz.LocalPlayercfg.LaixiaMatchShowbar =false
end

return GameListWaitting.new()


--endregion
