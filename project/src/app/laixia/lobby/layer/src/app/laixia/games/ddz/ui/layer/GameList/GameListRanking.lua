
-- 比赛排行榜界面 
local GameListRanking = class("GameListRanking", import("...CBaseDialog"):new())-- 
local soundConfig = laixiaddz.soundcfg;     
local Packet = import("....net.Packet") 

local laixia = laixia;
local db2 = laixiaddz.JsonTxtData;
local itemDBM  

function GameListRanking:ctor(...)

    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function GameListRanking:getName()
    -- 返回当前界面的名字，用来在表中索引表在WindowManager中
    return "GameListRanking"
end

function GameListRanking:onInit()
    self.super:onInit(self)
    -- 注册事件
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_MATCHRANK_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_MATCHRANK_WINDOW, handler(self, self.destroy))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_GOMATCHRANK_WINDOW,handler(self,self.goGameListRanking))
end

function GameListRanking:goGameListRanking()
        local MatchIntergralRanking = Packet.new("MatchIntergralRanking", _LAIXIA_PACKET_CS_MatchIntegralRankID)
        local matchid = 0
        if laixiaddz.LocalPlayercfg.LaixiaMatchID == 0 then
            matchid = cc.UserDefault:getInstance():getDoubleForKey("matdchId")
        else
            matchid = laixiaddz.LocalPlayercfg.LaixiaMatchID
        end
        MatchIntergralRanking:setValue("GameID", laixia.config.GameAppID)
        MatchIntergralRanking:setValue("MatchID", matchid)
        laixia.net.sendPacketAndWaiting(MatchIntergralRanking)
end

function GameListRanking:onShow(mesg)

    itemDBM = db2:queryTable("items");
    self:AddWidgetEventListenerFunction("Image_MatchRanking_ShutDown", handler(self, self.onShutDown))
    self:AddWidgetEventListenerFunction("Button_MatchRanking_KJL", handler(self, self.onShowReward))
    self:AddWidgetEventListenerFunction("Button_MatchRanking_KPM", handler(self, self.onShowRanking))

    self.mMatchRankListview = self:GetWidgetByName("ListView_MatchRanking_List")

    self.mMRNode = self:GetWidgetByName("Image_Ranking")
    self.mMRNode:setVisible(false)

    self.mMDNode = self:GetWidgetByName("Image_Prize")
    self.mMDNode:setVisible(false)


    self.mRank = self:GetWidgetByName("Image_GameDesk_KPM")
    self.mDetails = self:GetWidgetByName("Image_GameDesk_KJL")

 
    self.data = {}
    self.nowNumber = 0

    local data = mesg.data
    if data == nil then
        return 
    end
        self.RankRds =data.RankRds
        self.data = data.Ranks
    if  laixiaddz.LocalPlayercfg.LaixiaIsShowMatchRank == true then  -- 如果显示比赛排行
        self.mRank:setVisible(true)
        self.mDetails:setVisible(false)
        self.mMatchRankListview:removeAllItems()
    else
        self:addReward(self.RankRds)
    end
  
end



function GameListRanking:onShowRanking(sender, eventType)
    if ccui.TouchEventType.ended == eventType then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
       if self.mRank:isVisible() then
            return 
       end
       laixiaddz.LocalPlayercfg.LaixiaIsShowMatchRank = true
       ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_GOMATCHRANK_WINDOW)
    end
end

--看奖励
function GameListRanking:onShowReward(sender, eventType)
    if ccui.TouchEventType.ended == eventType then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
       if self.mDetails:isVisible() then
            return 
       end
       laixiaddz.LocalPlayercfg.LaixiaIsShowMatchRank = false
       self:addReward(self.RankRds)
    end
end

function GameListRanking:addReward(data)
    if self.mIsLoad == false then
        return
    end
    self.mRank:setVisible(false)
    self.mDetails:setVisible(true)
    self.mMatchRankListview:removeAllItems()

    for i, v in pairs(data) do
        local model = self.mMDNode:clone()
        model:setVisible(true)
        self.mMatchRankListview:pushBackCustomItem(model)
        local str = ""
        if v.RankStart == v.RankEnd then --如果不是奖励区间
           self:GetWidgetByName("Label_JiangLi_Ranking", model):setString(v.RankStart)

            self:GetWidgetByName("Image_JiangLi_Icon", model):setVisible(false)
            if v.RankStart<=3 then
                 local path = "rank_num" .. v.RankStart .. ".png"
                 self:GetWidgetByName("Image_JiangLi_Icon", model):loadTexture(path,1)
                 self:GetWidgetByName("Image_JiangLi_Icon", model):setVisible(true)
                 self:GetWidgetByName("Label_JiangLi_Ranking", model):setVisible(false)
            end
        else
            self:GetWidgetByName("Label_JiangLi_Ranking", model):setString(v.RankStart..'-'..v.RankEnd)
        end

          str =""
            for j, m in pairs(v.Reward) do
                local ItemsdataReward =  itemDBM:query("ItemID",m.ID);
                --laixia.db.ItemsDataManager:getItemByItemID(m.ID)
                if nil == m.ID then
                    ItemsdataReward.ItemName = ""
                end
                if nil == m.Num then
                    m.Num = 0
                end
                if  m.Num == 1 and m.ID~=1001 and m.ID~=1002 then
                 m.Num =""
                end
                if str == "" then
                    str = m.Num .. ItemsdataReward.ItemName
                else
                    str = str .. "  " .. m.Num .. ItemsdataReward.ItemName
                end
            end
        str = str:gsub("金币",laixia.utilscfg.CoinType());
        self:GetWidgetByName("Label_Award", model):setString(str)
    
    end

end


function GameListRanking:addRank(begin,over)
    if self.mIsLoad == false then
        return
    end

     for i= begin, over do 
     local v = self.data[i]
        print(v.PlayerID)
        print(v.NickName)
        print(v.Coin)
        local model = nil
        if laixiaddz.LocalPlayercfg.LaixiaPlayerNickname == v.NickName then --突出自己
            model = self.mMRNode:clone()
        else
            model = self.mMRNode:clone()
        end
  
        model:setVisible(true)
        self:GetWidgetByName("Label_Ranking_Num", model):setString(i)
        self:GetWidgetByName("Image_Ranking_Icon",model):setVisible(false)
        if i<=3 then
             local path = "rank_num" .. i .. ".png"
             self:GetWidgetByName("Image_Ranking_Icon", model):loadTexture(path,1)
             self:GetWidgetByName("Image_Ranking_Icon",model):setVisible(true)
             self:GetWidgetByName("Label_Ranking_Num", model):setVisible(false)
        end
        self:GetWidgetByName("Label_Name", model):setString(v.NickName)        
        self:GetWidgetByName("Label_Integral", model):setString(v.Coin)
        self.mMatchRankListview:pushBackCustomItem(model)

    end


end


function GameListRanking:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)

        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHRANK_WINDOW)

    end
end





function GameListRanking:onTick()
    if self.mIsLoad == true and laixiaddz.LocalPlayercfg.LaixiaIsShowMatchRank == true then
        if #self.data == 0 then
            return
        end
        local temp = 10
        local begin = self.nowNumber + 1
        self.nowNumber = self.nowNumber + temp
        if self.nowNumber > #self.data then
            self.nowNumber = #self.data
        end
        self:addRank(begin, self.nowNumber)
    end
end


function GameListRanking:onDestroy()
    laixiaddz.LocalPlayercfg.LaixiaIsShowMatchRank = true

end


return GameListRanking.new()

