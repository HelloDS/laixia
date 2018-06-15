
local RankingListWindow = class("RankingListWindow", import("...CBaseDialog"):new())-- 
local soundConfig = laixia.soundcfg;  
local Packet = import("....net.Packet")
local DownloaderHead = import("..DownloaderHead")

local laixia = laixia

function RankingListWindow:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
    self.mIsShow = false   
    self.rankIcon = {}
end

function RankingListWindow:getName()
    return "RankingListWindow"
end

function RankingListWindow:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_RANK_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_UPDATE_RANK_WINDOW, handler(self, self.updateWindow))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_REQUEST_RANKLIST_WINDOW, handler(self, self.sendRankListPacket))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_DOWNLOADRANK_PICTURE_WINDOW, handler(self,self.headDownloadSuccess))
end

function RankingListWindow:sendRankListPacket(msg)
    local rankType = 0 
    if msg.data and msg.data.rankType then 
        rankType = msg.data.rankType
    end 
    local stream = Packet.new("CSRank", _LAIXIA_PACKET_CS_RankID)
    stream:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    stream:setValue("GameID", laixia.config.GameAppID)
    stream:setValue("RankType", rankType)
    laixia.net.sendHttpPacketAndWaiting(stream, nil, 1)
end

function RankingListWindow:onShowPersonal(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        local player = sender.player
        local newPlayer = {}
        newPlayer.ID = player.UserID
        newPlayer.Name = player.NickName
        newPlayer.WinNum = player.Win
        newPlayer.LostNum = player.Loss
        newPlayer.Level = player.Level
        newPlayer.gold = player.Coin
        newPlayer.Sex = player.Sex
        newPlayer.SignStr = player.Signature

        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_USEINFO_WINDOW,newPlayer)
    end
end


function RankingListWindow:addRankCell(begin, over)
    for i = begin, over do
        local rankdate = self.AllRankdata[i]
        local rankCell = self.mRankCell:clone()
        rankCell:setVisible(true)
        
        rankCell.player = rankdate
        if rankdate.UserID  ==laixia.LocalPlayercfg.LaixiaPlayerID then
           -- self:GetWidgetByName("Image_Item_HL", rankCell):setVisible(true)
        else
           -- self:GetWidgetByName("Image_Item_HL", rankCell):setVisible(false)
        end

        rankCell:setTouchEnabled(true)
--        rankCell:addTouchEventListener(
--             function(sender, eventType)
--                self:onShowPersonal(sender, eventType)
--            end
--        )
        self.mRankinglisview:pushBackCustomItem(rankCell)
        self:GetWidgetByName("Label_Item_Name", rankCell):setString(rankdate["NickName"])
        self:GetWidgetByName("Label_Money_Num", rankCell):setString(rankdate["Coin"])

        if self.indexs == 1 then
            self:GetWidgetByName("Image_7", rankCell):setVisible(true)
            self:GetWidgetByName("Image_6", rankCell):setVisible(true)
            self:GetWidgetByName("Text_jbs", rankCell):setVisible(false)
        else
            self:GetWidgetByName("Image_7", rankCell):setVisible(false)
            self:GetWidgetByName("Image_6", rankCell):setVisible(false)
            self:GetWidgetByName("Text_jbs", rankCell):setVisible(true)
        end

        --2222
        -- self:GetWidgetByName("Label_Item_Describe", rankCell):setString( rankdate["Signature"])
        
        local PlayerHead=self:GetWidgetByName("Image_Item_Photo", rankCell)
        self:addHead(PlayerHead ,rankdate["UserID"] ,rankdate["Sex"] ,rankdate["imgPath"])

        local rank_ico = self:GetWidgetByName("Image_Item_Num", rankCell)  
        local AtlasLabelRank = self:GetWidgetByName("BitmapLabel_Num", rankCell)

        if i <= 3 then
            local path = "RankListWindows/bisaichang_mingci_" .. i .. ".png"
            --rank_ico:loadTexture(path, 1)  
            rank_ico:setVisible(true)
            AtlasLabelRank:setVisible(false)

            local sign = cc.Sprite:create(path)
            sign:setPosition(cc.p(0,0))
            sign:setAnchorPoint(cc.p(0,0))
            sign:addTo(rank_ico)
        else

            rank_ico:setVisible(false)
            AtlasLabelRank:setVisible(true)
            AtlasLabelRank:setString(i)
        end
    end
end

function RankingListWindow:onTick(dt)
    DownloaderHead:tick()

    self.m_time = self.m_time + dt
    if self.m_time < 0.3  then
        return 
    end


    if self.AllRankdata == nil or self.mIndex == #self.AllRankdata then
        return
    end

    local old = self.mIndex + 1
    if self.mIndex + 1 > #self.AllRankdata then
        self.mIndex = #self.AllRankdata
    else
        self.mIndex = self.mIndex + 1
    end
    self:addRankCell(old, self.mIndex)


--    local old = self.mIndex + 1
--    if self.mIndex + 7 > #self.AllRankdata then
--        self.mIndex = #self.AllRankdata
--    else
--        self.mIndex = self.mIndex + 7
--    end
--    self:addRankCell(old, self.mIndex)
--    print(old.."================================"..self.mIndex)
end

function RankingListWindow:headDownloadSuccess(msg)
    local data = msg.data    
    local mHeadInUse = data.savePath
    --local localIconPath = cc.FileUtils:getInstance():getWritablePath() .. data.playerID..".png";
    local fileExist = cc.FileUtils:getInstance():isFileExist(mHeadInUse)
    local image_rank_di = self.rankIcon[tostring(data.playerID)]
    if(fileExist) and image_rank_di~=nil then
        local sprite = display.newSprite(mHeadInUse) 
        sprite:setScaleX(image_rank_di:getContentSize().width/sprite:getContentSize().width)
        sprite:setScaleY(image_rank_di:getContentSize().height/sprite:getContentSize().height)
        sprite:setPosition(image_rank_di:getContentSize().width/2,image_rank_di:getContentSize().height/2)
        image_rank_di:addChild(sprite)
--        image_rank_di:loadTexture(mHeadInUse)
--            local templet = soundConfig.IMG_HEAD_TEMPLET_RECT
--            image_rank_di:removeAllChildren()
--            laixia.UItools.addHead(image_rank_di, mHeadInUse, templet)
    end       
end

function RankingListWindow:addHead(image,userid,gender,iconPath)
    -- 默认头像图片路径
    self.rankIcon[tostring(userid)] = image
    local path = "images/ic_morenhead"..tostring(tonumber(userid)%10)..".png"
    -- if iconPath ~= nil and iconPath ~= "" then
        -- local localIconName = DownloaderHead:SplitLastStr(iconPath, "/")
        local localIconName = cc.FileUtils:getInstance():getWritablePath() .. userid..".png"
        local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
        if (fileExist) then
            path = localIconName
        else
            local netIconUrl = iconPath
            DownloaderHead:pushTask(userid, netIconUrl,3)
        end
        local sprite = display.newSprite(path) 
        sprite:setScaleX(image:getContentSize().width/sprite:getContentSize().width)
        sprite:setScaleY(image:getContentSize().height/sprite:getContentSize().height)
        sprite:setPosition(image:getContentSize().width/2,image:getContentSize().height/2)
        image:addChild(sprite)
end


function RankingListWindow:onShow()
    if not self.mIsShow then
        self:setAdaptation()
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_COMMONTOP_WINDOW,
        {
            goBackFun = function()
                ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW)
                self:destroy()
            end,
        } )
        self.BG = self:GetWidgetByName("Image_bg")
        self.BG:setTouchEnabled(true)
        self.BG:setTouchSwallowEnabled(true)
        self.indexs = 1
        self.mRankinglisview = self:GetWidgetByName("ListView_Ranking_List")
        self.mRankCell = self:GetWidgetByName("Image_Ranking_Item")
        self.mButton_Cfb = self:GetWidgetByName("Button_Cfb")   --财富榜
        self.mButton_Cfb:addTouchEventListener(handler(self, self.onShowGoldRank))
        self.mButton_Thb = self:GetWidgetByName("Button_Thb")  --土豪榜
        self.mButton_Thb:addTouchEventListener(handler(self, self.onRichRank))

        self.mImageCfb = self:GetWidgetByName("Button_Cfb_Down") 
        self.mImageCfb:setVisible(false)
        self.mImageThb = self:GetWidgetByName("Button_Thb_Down") 
        self.mImageThb:setVisible(false)

        self.text_count = self:GetWidgetByName("Text_count")
        self.text_count:setVisible(false)

        -- 关闭①
        --self:AddWidgetEventListenerFunction("Button_Panel_Close", handler(self, self.onShutDown))
        
        self:GetWidgetByName("Label_Ranking_NoNum"):setVisible(false)
        self:GetWidgetByName("Label_Ranking_Num"):setVisible(false)
        self:updateBtnStatu(1)

        self.AllRankdata = nil
        self.mIndex = 0
        self.m_time = 0
        self.mIsShow = true
    end

end

--金币榜
function RankingListWindow:onShowGoldRank(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self:GetWidgetByName("Image_9"):setVisible(true)
        self:GetWidgetByName("Image_10"):setVisible(true)
        self:GetWidgetByName("Text_money"):setVisible(true)
        self.indexs = 1
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:updateBtnStatu(1)
        self.rankIcon = {}
        self.mRankinglisview:removeAllItems()
        self.AllRankdata = nil
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_REQUEST_RANKLIST_WINDOW,{rankType = 0})
        self:updateSelfRank()
        self.mIndex = 0
    end
end

-- 关闭
function RankingListWindow:onShutDown(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
end

--土豪榜
function RankingListWindow:onRichRank(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self:GetWidgetByName("Image_9"):setVisible(false)
        self:GetWidgetByName("Image_10"):setVisible(false)
        self:GetWidgetByName("Text_money"):setVisible(false)
        --self:GetWidgetByName("Text_money"):setString()
        self.indexs = 2
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self.rankIcon = {}
        self:updateBtnStatu(2)
        self.mRankinglisview:removeAllItems()
        self.AllRankdata = nil
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_REQUEST_RANKLIST_WINDOW,{rankType = 1})
        self:updateSelfRank()
        self.mIndex = 0
    end
end

function RankingListWindow:updateBtnStatu(status)
    if status == 1 then 
        self.mButton_Cfb:setVisible(false)
        self.mButton_Thb:setVisible(true)
        self.mImageCfb:setVisible(true)
        self.mImageThb:setVisible(false)
    elseif status ==2 then 
        self.mButton_Cfb:setVisible(true)
        self.mButton_Thb:setVisible(false)
        self.mImageCfb:setVisible(false)
        self.mImageThb:setVisible(true)
    end
end

function RankingListWindow:updateWindow()
    if self.mIsShow then
        self:GetWidgetByName("Label_Ranking_NoNum"):setVisible(true)

        self.mSelfRank = 0
        self.AllRankdata = laixia.LocalPlayercfg.LaixiaRankingData
        self.mSelfRank = laixia.LocalPlayercfg.SelfRank 
        --self.name = laixia.LocalPlayercfg.

        self:updateSelfRank()
    end
end

function RankingListWindow:setAdaptation()
    if device.platform == "ios" then
        --暂时先 适配 iphoneX
        if display.widthInPixels  == 2436 and display.heightInPixels == 1125 then
            self:GetWidgetByName("Image_bg"):setScaleX(2436/3*2/1280)
        end
    end
end
function RankingListWindow:updateSelfRank()
   
    -- if self.selfdata["Coin"] == nil then
    --     self:GetWidgetByName("Image_10"):setVisible(false)
    --     self:GetWidgetByName("Image_9"):setVisible(false)
    --     self:GetWidgetByName("Text_money"):setVisible(false)
    -- end
    
    --TODO 这里应该后台改
    self.playhead = self:GetWidgetByName("Image_head_")
    if self.mSelfRank == 0 or self.mSelfRank>50 then
        self:GetWidgetByName("Image_rank_"):setVisible(false)
        self:GetWidgetByName("Label_Ranking_NoNum"):setString("暂未上榜")
        self:GetWidgetByName("Label_Ranking_Num"):setVisible(false)--7
        self:GetWidgetByName("Label_Ranking_NoNum"):setVisible(true)--7

        self:GetWidgetByName("Text_count"):setVisible(false)
        self:GetWidgetByName("Image_10"):setVisible(false)
        self:GetWidgetByName("Image_9"):setVisible(false)
        self:GetWidgetByName("Text_money"):setVisible(false)
        self:GetWidgetByName("Text_self_jbs"):setVisible(false)

        if self.indexs == 2 then
            self:GetWidgetByName("Text_self_jbs"):setVisible(true)
            self:GetWidgetByName("Text_count"):setVisible(true)
            self:GetWidgetByName("Text_count"):setString(laixia.LocalPlayercfg.SelfRank)
        else
            self:GetWidgetByName("Image_10"):setVisible(true)
            self:GetWidgetByName("Image_9"):setVisible(true)
            self:GetWidgetByName("Text_money"):setVisible(true)
            self:GetWidgetByName("Text_money"):setString(laixia.LocalPlayercfg.LaixiaPlayerGold)
        end

        -- if self.indexs == 1 then
        --     self:GetWidgetByName("Image_10"):setVisible(true)
        --     self:GetWidgetByName("Image_9"):setVisible(true)
        --     self:GetWidgetByName("Text_money"):setVisible(true)
        --     self:GetWidgetByName("Text_self_jbs"):setVisible(false)
        -- else
        --     self:GetWidgetByName("Image_10"):setVisible(false)
        --     self:GetWidgetByName("Image_9"):setVisible(false)
        --     self:GetWidgetByName("Text_money"):setVisible(true)
        --     self:GetWidgetByName("Text_self_jbs"):setVisible(true)
        --     --self:GetWidgetByName("Text_money"):setString(0)
        -- end
        -- if self.selfdata["Coin"] == nil or self.selfdata["Coin"] == 0 then
        --     self:GetWidgetByName("Text_money"):setString(0)
        -- else
        --     self:GetWidgetByName("Text_money"):setString(self.selfdata["Coin"])
        -- end


    else
        self.selfdata = self.AllRankdata[self.mSelfRank]
        if self.selfdata ~= nil then
            self:GetWidgetByName("Text_name_"):setString(self.selfdata["NickName"])
        end
        self.ranking_num = self:GetWidgetByName("Label_Ranking_Num")
        self.ranking_nonum = self:GetWidgetByName("Label_Ranking_NoNum")
        self.rank_ = self:GetWidgetByName("Image_rank_")
        if self.mSelfRank <= 3 then
            local path = "RankListWindows/bisaichang_mingci_" .. self.mSelfRank .. ".png"
            self.rank_:setVisible(true)
            self.rank_:loadTexture(path)  

            -- local sign = cc.Sprite:create(path)
            -- sign:setPosition(cc.p(0,0))
            -- sign:setScale(0.6)
            -- sign:setAnchorPoint(cc.p(0,0))
            -- sign:addTo(self.rank_)
            self.ranking_num:setVisible(false)
            self.ranking_nonum:setVisible(false)
        else
            self.ranking_num:setString(self.mSelfRank)
            self.ranking_num:setVisible(true)
            self.ranking_nonum:setVisible(false)
            self.rank_:setVisible(false)  
        end
        
        self:GetWidgetByName("Text_money"):setString(laixia.LocalPlayercfg.LaixiaPlayerGold)
        
        if self.indexs == 1 then
            self:GetWidgetByName("Image_10"):setVisible(true)
            self:GetWidgetByName("Image_9"):setVisible(true)
            self:GetWidgetByName("Text_money"):setVisible(true)
            self:GetWidgetByName("Text_count"):setVisible(false)
            self:GetWidgetByName("Text_self_jbs"):setVisible(false)
        else
            self:GetWidgetByName("Image_10"):setVisible(false)
            self:GetWidgetByName("Image_9"):setVisible(false)
            self:GetWidgetByName("Text_money"):setVisible(false)
            self:GetWidgetByName("Text_self_jbs"):setVisible(true)
            self:GetWidgetByName("Text_count"):setVisible(true)
            self:GetWidgetByName("Text_count"):setString(self.selfdata["Coin"])
        end
        
        --在主界面存一下id 和路径
        
    end

    self.mSelfRank = 0
    self:addHead(self.playhead ,laixia.LocalPlayercfg.LaixiaPlayerID ,1 ,laixia.LocalPlayercfg.LaixiaPlayerHeadUse )
    self:GetWidgetByName("Text_name_"):setString(laixia.helper.StringRules_6(laixia.LocalPlayercfg.LaixiaPlayerNickname))
    
end


function RankingListWindow:onDestroy()
    self.mIsShow = false
    self.rankIcon = {}
    DownloaderHead:reset()
end

return RankingListWindow.new()
