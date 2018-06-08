--比赛结算界面
local GameListResult= class("GameListResult",import("...CBaseDialog"):new())
local soundConfig = laixiaddz.soundcfg;     
local Packet =import("....net.Packet")

local laixia = laixia;
local db2  =laixiaddz.JsonTxtData;
local itemDBM;

function GameListResult:ctor(...) 
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG   
end

function GameListResult:getName()
	return "GameListResult"
end

function GameListResult:onInit()
    self.super:onInit(self)
    self.HasJD = false   --判断有没有京东卡的字段
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_MATCHRESULT_WINDOW,handler(self,self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_MATCHRESULT_WINDOW,handler(self,self.destroy))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_CONTINUEMATCH_WINDOW,handler(self,self.SendMatchPacket))
    --失败 没有奖励
    --ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_FAILE_WINDOW,handler(self, self.FaileAnimate))
end

function GameListResult:onShow(mesg)
    self.mData = mesg.data
    if self.mData == nil then
        return
    end
    self.root:runAction(cc.Sequence:create(
                cc.DelayTime:create(1.3),
                cc.CallFunc:create(
                    function()   
                        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_CLEAR_DATELANDLORDTABLE_WINDOW,"结算清除数据")
                    end),nil))  
    -- if laixiaddz.LocalPlayercfg.LaixiaisLIUJU == 5 then
    --     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_CLEAR_DATELANDLORDTABLE_WINDOW,"结算清除数据")
    -- end
    self.Image_share_erweima = self:GetWidgetByName("Image_share_erweima")
    self.Image_share_erweima:setVisible(false)
    self:GetWidgetByName("Image_bg"):setTouchEnabled(true)
    self:GetWidgetByName("Image_bg"):setTouchSwallowEnabled(true)
    self.nextbutton = self:GetWidgetByName("Button_GamePrize_Next")
    self.back = self:GetWidgetByName("Button_GamePrize_Back")
    self.Image_Faile = self:GetWidgetByName("Image_Faile")
    self.Image_Faile:setTouchEnabled(true)
    self.Image_Faile:setTouchSwallowEnabled(true)
    self.win = self:GetWidgetByName("Image_bg")
    self.Button_share = self:GetWidgetByName("Button_share")
    self.Button_share:setVisible(false)

    local GameType = self.mData.GameType
    --2:人满开赛 1：2mtt 打立出局（）
    -- self.Button_share = self:GetWidgetByName("Button_share")
    self:AddWidgetEventListenerFunction("Button_GamePrize_Next", handler(self, self.goNextMatch))--报名下一场
    self:AddWidgetEventListenerFunction("Button_GamePrize_Back", handler(self, self.GoBackToGameList))--返回
    self:AddWidgetEventListenerFunction("Button_share", handler(self, self.goShare))
    if GameType == 1 then --MTT
        self.nextbutton:setVisible(false)
        self.back:setPosition(cc.p(display.cx,123))
        -- self.back:setPosition(cc.p(display.cx-150,123))
        -- self.Button_share:setPosition(cc.p(display.cx+150,123))
    else--SNG
        self.nextbutton:setVisible(true)
    end
    -- if device.platform == "android" then
    --     self.Button_share:setVisible(false)
    -- else  
    --     self.Button_share:setVisible(false)
    -- end 
    -----比赛结束清楚轮次字段
    laixiaddz.LocalPlayercfg.LaixiaMatchRoundNum = 0
    if self.mData.rewards ~= nil then

        self.Image_Faile:setVisible(false)
        itemDBM = db2:queryTable("items");
        laixiaddz.soundTools.playSound(soundConfig.EVENT_SOUND.ui_evevt_bear_palm)
        laixiaddz.LocalPlayercfg.LaixiaMatchRank = 0
        laixiaddz.LocalPlayercfg.LaixiaMatchTotalNum = 0
        laixiaddz.LocalPlayercfg.LaixiaisConnectCardTable = false


        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHWAITLOADING_WINDOW)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHRANK_WINDOW)

        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHEASTER_WINDOW);

        local day = os.time()   -- 得到当前的秒数
         --local str = os.date("20%y年".."%m月" .. "%d日" ..  "  %X", day, day, day,day)
        local resultStr = ""
        if laixiaddz.LocalPlayercfg.LaixiaMatchName == nil or laixiaddz.LocalPlayercfg.LaixiaMatchName=="" then
            resultStr = cc.UserDefault:getInstance():getStringForKey("MatchName")
        else
            resultStr = laixiaddz.LocalPlayercfg.LaixiaMatchName
        end
        local resultStr = os.date("恭喜您在%X时"..resultStr.."比赛荣获",day)
         self:GetWidgetByName("Label_GamePrize_Time"):setString(resultStr )
         self:GetWidgetByName("Text_time"):setString( os.date("20%y年".."%m月" .. "%d日", day, day, day))

        laixiaddz.LocalPlayercfg.LaixiaMatchquite = true
        -- local CGEnterLobby = Packet.new("CGEnterLobby", _LAIXIA_PACKET_CS_HallLobbyID)
        -- CGEnterLobby:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
        -- CGEnterLobby:setValue("GameID", laixia.config.GameAppID)
        -- laixia.net.sendHttpPacketAndWaiting(CGEnterLobby)
        


        
        self:GetWidgetByName("Label_GamePrize_Name"):setString(laixiaddz.LocalPlayercfg.LaixiaPlayerNickname) --玩家昵称
        self:GetWidgetByName("AtlasLabel_GamePrize_Num"):setString(self.mData.rank)--获得名次
        -- for j =1,4  do
        --    local cell = self:GetWidgetByName("Image_GamePrize_JP_0" .. j)
        --    cell:setVisible(false)
        -- end
        

        local MatchName = ""
        local match = laixiaddz.LocalPlayercfg.LaixiaMatchdata
        if match then
            if #match == 0 then
                MatchName = laixiaddz.LocalPlayercfg.LaixiaMatchName
            else
                local red_temp = match[laixiaddz.LocalPlayercfg.LaixiaGameListIndex].rooms
                for i = 1, #red_temp do
                    if (laixiaddz.LocalPlayercfg.LaixiaMatchRoom == red_temp[i].RoomID) then
                        MatchName = red_temp[i].RoomName
                    end
                end
            end
        end

        if MatchName == "" then
            MatchName = cc.UserDefault:getInstance():getStringForKey("MatchName")
        end
        local  renshu =laixiaddz.LocalPlayercfg.LaixiaMatchLimit
        if renshu ==0  then
          renshu = "N"
        end
        --奖励
        --local str = MatchName:gsub("金币",laixia.utilscfg.CoinType());
        --self:GetWidgetByName("Label_GamePrize_Title"):setString("恭喜您在<" .. str .. ">" .. renshu .. "人中获得")
        laixiaddz.LocalPlayercfg.laixiaddzIsInMatch = false

        if self.mData.rank <= 3 then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW, "比赛结束，恭喜您获得好成绩！")
            -- 报名成功飘字
        end

        for i=1,5 do
            local cell = self:GetWidgetByName("Image_GamePrize_JP_0" .. i)
            cell:setVisible(false)
        end
        local redbagNum = 0
        local redbagGeShu = 0
        for i, v in pairs(self.mData.rewards) do
            local Itemsdata =  itemDBM:query("ItemID",tonumber(v.ItemID));
            if string.sub(tostring(v.ItemID),1,2) == "15" and tonumber(string.sub(tostring(v.ItemID),3,4)) <= 10 then   
                redbagGeShu = redbagGeShu + 1 
                redbagNum = redbagNum + tonumber(string.split(Itemsdata.ItemName,"红包")[1])
            elseif string.sub(tostring(v.ItemID),1,2) == "15" and tonumber(string.sub(tostring(v.ItemID),3,4)) >= 11 then
                redbagGeShu = redbagGeShu + 1 
                redbagNum = redbagNum + tonumber(string.split(Itemsdata.ItemName,"元京东卡")[1])
                self.HasJD = true
            end
        end
        if redbagNum == 0 then
            if #self.mData.rewards == 1 then
                for i,v in pairs(self.mData.rewards) do
                    local cell = self:GetWidgetByName("Image_GamePrize_JP_03")
                    cell:setVisible(true)
                    local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                    local Itemsdata =  itemDBM:query("ItemID",tonumber(v.ItemID));

                    dump(Itemsdata,"Itemsdata")
                    
                    if tonumber(Itemsdata.ItemType) == 1 then
                        if tonumber(v.ItemID) == 1001 then
                            node:loadTexture("new_ui/common/red_packet/bisaizhuanyongjinbi.png")
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("金币" .. "x" .. v.ItemCount)
                            self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.17)
                        elseif tonumber(v.ItemID) == 1002 then
                            --来豆
                            node:loadTexture("new_ui/common/new_common/laidou.png")
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("来豆" .. "x" .. v.ItemCount)
                            self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.73)
                        end
                    else
                        local baoming_Array = string.split(Itemsdata.ImagePath ,'/')
                        if #baoming_Array > 1 then  
                            node:loadTexture(Itemsdata.ImagePath)
                        else
                            node:loadTexture(Itemsdata.ImagePath, 1)
                        end
                        self:GetWidgetByName("AtlasLabel_Num" ,cell):setString(Itemsdata.ItemName .. "x" .. v.ItemCount)
                        --Image_JPIcon   奖品图片
                        self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                    end
                end
            elseif #self.mData.rewards == 2 or #self.mData.rewards == 3 then
                for i,v in pairs(self.mData.rewards) do
                    local cell = self:GetWidgetByName("Image_GamePrize_JP_0" .. (i+1))
                    cell:setVisible(true)
                    local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                    local Itemsdata =  itemDBM:query("ItemID",tonumber(v.ItemID));
                    
                    if tonumber(Itemsdata.ItemType) == 1 then
                        if tonumber(v.ItemID) == 1001 then
                            node:loadTexture("new_ui/common/red_packet/bisaizhuanyongjinbi.png")
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("金币" .. "x" .. v.ItemCount)
                            self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.17)
                        elseif tonumber(v.ItemID) == 1002 then
                            --来豆
                            node:loadTexture("new_ui/common/new_common/laidou.png")
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("来豆" .. "x" .. v.ItemCount)
                            self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.73)
                        end
                    else
                        local baoming_Array = string.split(Itemsdata.ImagePath ,'/')
                        if #baoming_Array > 1 then  
                            node:loadTexture(Itemsdata.ImagePath)
                        else
                            node:loadTexture(Itemsdata.ImagePath, 1)
                        end
                        self:GetWidgetByName("AtlasLabel_Num" ,cell):setString(Itemsdata.ItemName .. "x" .. v.ItemCount)
                        --Image_JPIcon   奖品图片
                        self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                    end    
                end
            else
                for i,v in pairs(self.mData.rewards) do
                    local cell = self:GetWidgetByName("Image_GamePrize_JP_0" ..i)
                    cell:setVisible(true)
                    local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                    local Itemsdata =  itemDBM:query("ItemID",tonumber(v.ItemID));
                    
                    if tonumber(Itemsdata.ItemType) == 1 then
                        if tonumber(v.ItemID) == 1001 then
                            node:loadTexture("new_ui/common/red_packet/bisaizhuanyongjinbi.png")
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("金币" .. "x" .. v.ItemCount)
                            self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.17)
                         elseif tonumber(v.ItemID) == 1002 then
                            --来豆
                            node:loadTexture("new_ui/common/new_common/laidou.png")
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("来豆" .. "x" .. v.ItemCount)
                            self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.73)
                        end
                    else
                        local baoming_Array = string.split(Itemsdata.ImagePath ,'/')
                        if #baoming_Array > 1 then  
                            node:loadTexture(Itemsdata.ImagePath)
                        else
                            node:loadTexture(Itemsdata.ImagePath, 1)
                        end
                        self:GetWidgetByName("AtlasLabel_Num" ,cell):setString(Itemsdata.ItemName .. "x" .. v.ItemCount)
                        --Image_JPIcon   奖品图片
                        self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                    end    
                end
            end
        elseif redbagNum ~= 0 then
            local tableLen = #self.mData.rewards - redbagGeShu + 1
            if tableLen == 1 then
                local cell = self:GetWidgetByName("Image_GamePrize_JP_03")
                cell:setVisible(true)
                local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                if self.HasJD == true then
                    node:loadTexture("new_ui/common/red_packet/bisaizhuanyongJD.png")
                    self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("京东卡" .. redbagNum .. "元")
                else
                    node:loadTexture("new_ui/common/red_packet/hongbao.png")
                    self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("微信红包" .. redbagNum .. "元")
                end    
                --Image_JPIcon   奖品图片
                self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
            elseif tableLen == 2 then
                local ItemType = 2
                for i,v in pairs(self.mData.rewards) do
                    local Itemsdata =  itemDBM:query("ItemID",tonumber(v.ItemID));
                    if string.sub(tostring(v.ItemID),1,2) ~= "15" and tonumber(Itemsdata.ItemType) == 3 then
                        local cell = self:GetWidgetByName("Image_GamePrize_JP_0" .. ItemType)
                        cell:setVisible(true)
                        local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                        local baoming_Array = string.split(Itemsdata.ImagePath ,'/')
                        if #baoming_Array > 1 then  
                            node:loadTexture(Itemsdata.ImagePath)
                        else
                            node:loadTexture(Itemsdata.ImagePath, 1)
                        end
                        self:GetWidgetByName("AtlasLabel_Num" ,cell):setString(Itemsdata.ItemName .. "x" .. v.ItemCount)
                        --Image_JPIcon   奖品图片
                        self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                        ItemType = ItemType + 1
                    elseif string.sub(tostring(v.ItemID),1,2) ~= "15" and tonumber(Itemsdata.ItemType) ~= 3 then
                        local cell = self:GetWidgetByName("Image_GamePrize_JP_03")
                        cell:setVisible(true)
                        local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)

                        if tonumber(Itemsdata.ItemType) == 1 then
                            if tonumber(v.ItemID) == 1001 then
                                node:loadTexture("new_ui/common/red_packet/bisaizhuanyongjinbi.png")
                                self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("金币" .. "x" .. v.ItemCount)
                                self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.17)
                            elseif tonumber(v.ItemID) == 1002 then
                                --来豆
                                node:loadTexture("new_ui/common/new_common/laidou.png")
                                self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("来豆" .. "x" .. v.ItemCount)
                                self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.73)
                            end
                        else
                            local baoming_Array = string.split(Itemsdata.ImagePath ,'/')
                            if #baoming_Array > 1 then  
                                node:loadTexture(Itemsdata.ImagePath)
                            else
                                node:loadTexture(Itemsdata.ImagePath, 1)
                            end
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString(Itemsdata.ItemName .. "x" .. v.ItemCount)
                            --Image_JPIcon   奖品图片
                            self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                        end
                    end
                end
                if redbagNum ~= 0 then
                    local cell = self:GetWidgetByName("Image_GamePrize_JP_0".. ItemType)
                    cell:setVisible(true)
                    local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                    if self.HasJD == true then
                        node:loadTexture("new_ui/common/red_packet/bisaizhuanyongJD.png")
                        self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("京东卡" .. redbagNum .. "元")
                    else
                        node:loadTexture("new_ui/common/red_packet/hongbao.png")
                        self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("微信红包" .. redbagNum .. "元")
                    end   
                    --Image_JPIcon   奖品图片
                    self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                end
            elseif tableLen == 3 then
                local hasWuPin = false
                for i,v in pairs(self.mData.rewards) do
                    local Itemsdata =  itemDBM:query("ItemID",tonumber(v.ItemID));
                    if string.sub(tostring(v.ItemID),1,2) ~= "15" and tonumber(Itemsdata.ItemType) == 3  then
                        hasWuPin = true
                    end
                end
                if hasWuPin == true then
                    for i,v in pairs(self.mData.rewards) do
                        local Itemsdata =  itemDBM:query("ItemID",tonumber(v.ItemID));
                        if string.sub(tostring(v.ItemID),1,2) ~= "15" and tonumber(Itemsdata.ItemType) == 3  then
                            local cell = self:GetWidgetByName("Image_GamePrize_JP_02")
                            cell:setVisible(true)
                            local baoming_Array = string.split(Itemsdata.ImagePath ,'/')
                            local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                            if #baoming_Array > 1 then  
                                node:loadTexture(Itemsdata.ImagePath)
                            else
                                node:loadTexture(Itemsdata.ImagePath, 1)
                            end
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString(Itemsdata.ItemName .. "  x" .. v.ItemCount)
                            --Image_JPIcon   奖品图片
                            self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                        elseif string.sub(tostring(v.ItemID),1,2) ~= "15" and tonumber(Itemsdata.ItemType) ~= 3 then
                            local cell = self:GetWidgetByName("Image_GamePrize_JP_04")
                            cell:setVisible(true)
                            local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                            
                            if tonumber(Itemsdata.ItemType) == 1 then
                                if tonumber(v.ItemID) == 1001 then
                                    node:loadTexture("new_ui/common/red_packet/bisaizhuanyongjinbi.png")
                                    self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("金币" .. "x" .. v.ItemCount)
                                    self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.17)
                                elseif tonumber(v.ItemID) == 1002 then
                                    --来豆
                                    node:loadTexture("new_ui/common/new_common/laidou.png")
                                    self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("来豆" .. "x" .. v.ItemCount)
                                    self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.73)
                                end
                            else
                                local baoming_Array = string.split(Itemsdata.ImagePath ,'/')
                                if #baoming_Array > 1 then  
                                    node:loadTexture(Itemsdata.ImagePath)
                                else
                                    node:loadTexture(Itemsdata.ImagePath, 1)
                                end
                                self:GetWidgetByName("AtlasLabel_Num" ,cell):setString(Itemsdata.ItemName .. "x" .. v.ItemCount)
                                --Image_JPIcon   奖品图片
                                self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                            end
                        end
                    end
                    if redbagNum ~= 0 then
                        local cell = self:GetWidgetByName("Image_GamePrize_JP_03")
                        cell:setVisible(true)
                        local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                        if self.HasJD == true then
                            node:loadTexture("new_ui/common/red_packet/bisaizhuanyongJD.png")
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("京东卡" .. redbagNum .. "元")
                        else
                            node:loadTexture("new_ui/common/red_packet/hongbao.png")
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("微信红包" .. redbagNum .. "元")
                        end   
                        --Image_JPIcon   奖品图片
                        self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                    end
                else
                   local ItemType = 3
                   for i,v in pairs(self.mData.rewards) do
                        local Itemsdata =  itemDBM:query("ItemID",tonumber(v.ItemID));
                        if string.sub(tostring(v.ItemID),1,2) ~= "15" and tonumber(Itemsdata.ItemType) ~= 3 then
                            local cell = self:GetWidgetByName("Image_GamePrize_JP_0"..ItemType)
                            cell:setVisible(true)
                            local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                            
                            if tonumber(Itemsdata.ItemType) == 1 then
                                if tonumber(v.ItemID) == 1001 then
                                    node:loadTexture("new_ui/common/red_packet/bisaizhuanyongjinbi.png")
                                    self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("金币" .. "x" .. v.ItemCount)
                                    self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.17)
                                elseif tonumber(v.ItemID) == 1002 then
                                    --来豆
                                    node:loadTexture("new_ui/common/new_common/laidou.png")
                                    self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("来豆" .. "x" .. v.ItemCount)
                                    self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.73)
                                end
                            else
                                local baoming_Array = string.split(Itemsdata.ImagePath ,'/')
                                if #baoming_Array > 1 then  
                                    node:loadTexture(Itemsdata.ImagePath)
                                else
                                    node:loadTexture(Itemsdata.ImagePath, 1)
                                end
                                self:GetWidgetByName("AtlasLabel_Num" ,cell):setString(Itemsdata.ItemName .. "x" .. v.ItemCount)
                                --Image_JPIcon   奖品图片
                                self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                            end
                            ItemType = ItemType + 1
                        end   
                    end
                    if redbagNum ~= 0 then
                        local cell = self:GetWidgetByName("Image_GamePrize_JP_02")
                        cell:setVisible(true)
                        local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                        if self.HasJD == true then
                            node:loadTexture("new_ui/common/red_packet/bisaizhuanyongJD.png")
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("京东卡" .. redbagNum .. "元")
                        else
                            node:loadTexture("new_ui/common/red_packet/hongbao.png")
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("微信红包" .. redbagNum .. "元")
                        end   
                        --Image_JPIcon   奖品图片
                        self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                    end
                end
            elseif tableLen == 4 then
                local hasWuPin = false
                for i,v in pairs(self.mData.rewards) do
                    local Itemsdata =  itemDBM:query("ItemID",tonumber(v.ItemID));
                    if string.sub(tostring(v.ItemID),1,2) ~= "15" and tonumber(Itemsdata.ItemType) == 3  then
                        hasWuPin = true
                    end
                end
                if hasWuPin == true then
                    local ItemType = 3
                    for i,v in pairs(self.mData.rewards) do
                        local Itemsdata =  itemDBM:query("ItemID",tonumber(v.ItemID));
                        if string.sub(tostring(v.ItemID),1,2) ~= "15" and tonumber(Itemsdata.ItemType) == 3  then
                            local cell = self:GetWidgetByName("Image_GamePrize_JP_01")
                            local baoming_Array = string.split(Itemsdata.ImagePath ,'/')
                            if #baoming_Array > 1 then  
                                node:loadTexture(Itemsdata.ImagePath)
                            else
                                node:loadTexture(Itemsdata.ImagePath, 1)
                            end
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString(Itemsdata.ItemName .. "x" .. v.ItemCount)
                            --Image_JPIcon   奖品图片
                            self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                        elseif string.sub(tostring(v.ItemID),1,2) ~= "15" and tonumber(Itemsdata.ItemType) ~= 3 then
                            local cell = self:GetWidgetByName("Image_GamePrize_JP_0"..ItemType)
                            cell:setVisible(true)
                            local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                            
                            if tonumber(Itemsdata.ItemType) == 1 then
                                if tonumber(v.ItemID) == 1001 then
                                    node:loadTexture("new_ui/common/red_packet/bisaizhuanyongjinbi.png")
                                    self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("金币" .. "x" .. v.ItemCount)
                                    self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.17)
                                elseif tonumber(v.ItemID) == 1002 then
                                    --来豆
                                    node:loadTexture("new_ui/common/new_common/laidou.png")
                                    self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("来豆" .. "x" .. v.ItemCount)
                                    self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.73)
                                end
                            else
                                local baoming_Array = string.split(Itemsdata.ImagePath ,'/')
                                if #baoming_Array > 1 then  
                                    node:loadTexture(Itemsdata.ImagePath)
                                else
                                    node:loadTexture(Itemsdata.ImagePath, 1)
                                end
                                self:GetWidgetByName("AtlasLabel_Num" ,cell):setString(Itemsdata.ItemName .. "x" .. v.ItemCount)
                                --Image_JPIcon   奖品图片
                                self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                            end
                            ItemType = ItemType + 1
                        end
                    end
                    if redbagNum ~= 0 then
                        local cell = self:GetWidgetByName("Image_GamePrize_JP_02")
                        cell:setVisible(true)
                        local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                        if self.HasJD == true then
                            node:loadTexture("new_ui/common/red_packet/bisaizhuanyongJD.png")
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("京东卡" .. redbagNum .. "元")
                        else
                            node:loadTexture("new_ui/common/red_packet/hongbao.png")
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("微信红包" .. redbagNum .. "元")
                        end   
                        --Image_JPIcon   奖品图片
                        self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                    end
                else
                   local ItemType = 2
                   for i,v in pairs(self.mData.rewards) do
                        local Itemsdata =  itemDBM:query("ItemID",tonumber(v.ItemID));
                        if string.sub(tostring(v.ItemID),1,2) ~= "15" and tonumber(Itemsdata.ItemType) ~= 3 then
                            local cell = self:GetWidgetByName("Image_GamePrize_JP_0"..ItemType)
                            cell:setVisible(true)
                            local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                            
                            if tonumber(Itemsdata.ItemType) == 1 then
                                if tonumber(v.ItemID) == 1001 then
                                    node:loadTexture("new_ui/common/red_packet/bisaizhuanyongjinbi.png")
                                    self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("金币" .. "x" .. v.ItemCount)
                                    self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.17)
                                elseif tonumber(v.ItemID) == 1002 then
                                    --来豆
                                    node:loadTexture("new_ui/common/new_common/laidou.png")
                                    self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("来豆" .. "x" .. v.ItemCount)
                                    self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.73)
                                end
                            else
                                local baoming_Array = string.split(Itemsdata.ImagePath ,'/')
                                if #baoming_Array > 1 then  
                                    node:loadTexture(Itemsdata.ImagePath)
                                else
                                    node:loadTexture(Itemsdata.ImagePath, 1)
                                end
                                self:GetWidgetByName("AtlasLabel_Num" ,cell):setString(Itemsdata.ItemName .. "x" .. v.ItemCount)
                                --Image_JPIcon   奖品图片
                                self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                            end
                            ItemType = ItemType + 1
                        end   
                    end
                    if redbagNum ~= 0 then
                        local cell = self:GetWidgetByName("Image_GamePrize_JP_01")
                        cell:setVisible(true)
                        local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                        if self.HasJD == true then
                            node:loadTexture("new_ui/common/red_packet/bisaizhuanyongJD.png")
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("京东卡" .. redbagNum .. "元")
                        else
                            node:loadTexture("new_ui/common/red_packet/hongbao.png")
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("微信红包" .. redbagNum .. "元")
                        end   
                        --Image_JPIcon   奖品图片
                        self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                    end
                end
            else
                for i,v in pairs(rewardsTable) do
                    local Itemsdata =  itemDBM:query("ItemID",tonumber(v.ItemID));
                    if string.sub(tostring(v.ItemID),1,2) ~= "15" and tonumber(Itemsdata.ItemType) == 3 then
                        local cell = self:GetWidgetByName("Image_GamePrize_JP_01")
                        cell:setVisible(true)
                        local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                        local baoming_Array = string.split(Itemsdata.ImagePath ,'/')
                        if #baoming_Array > 1 then  
                            node:loadTexture(Itemsdata.ImagePath)
                        else
                            node:loadTexture(Itemsdata.ImagePath, 1)
                        end
                        self:GetWidgetByName("AtlasLabel_Num" ,cell):setString(Itemsdata.ItemName .. "x" .. v.ItemCount)
                        --Image_JPIcon   奖品图片
                        self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                    elseif tonumber(Itemsdata.ItemType) == 2 then
                        local cell = self:GetWidgetByName("Image_GamePrize_JP_05")
                        cell:setVisible(true)
                        local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                        local baoming_Array = string.split(Itemsdata.ImagePath ,'/')
                        if #baoming_Array > 1 then  
                            node:loadTexture(Itemsdata.ImagePath)
                        else
                            node:loadTexture(Itemsdata.ImagePath, 1)
                        end
                        self:GetWidgetByName("AtlasLabel_Num" ,cell):setString(Itemsdata.ItemName .. "x" .. v.ItemCount)
                        --Image_JPIcon   奖品图片
                        self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)  
                    elseif tonumber(Itemsdata.ItemType) == 1 then
                        if tonumber(v.ItemID) == 1001 then
                            local cell = self:GetWidgetByName("Image_GamePrize_JP_03")
                            cell:setVisible(true)
                            local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                            local baoming_Array = string.split(Itemsdata.ImagePath ,'/')
                            node:loadTexture("new_ui/common/red_packet/bisaizhuanyongjinbi.png")
                            self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("金币" .. "x" .. v.ItemCount)
                            self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.17)
                       elseif tonumber(v.ItemID) == 1002 then
                                --来豆
                                node:loadTexture("new_ui/common/new_common/laidou.png")
                                self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("来豆" .. "x" .. v.ItemCount)
                                self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.73)
                        end
                    end
                end
                if redbagNum~=0 then
                    local cell = self:GetWidgetByName("Image_GamePrize_JP_02")
                    cell:setVisible(true)
                    local node  =  self:GetWidgetByName("Image_JPIcon" ,cell)
                    if self.HasJD == true then
                        node:loadTexture("new_ui/common/red_packet/bisaizhuanyongJD.png")
                        self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("京东卡" .. redbagNum .. "元")
                    else
                        node:loadTexture("new_ui/common/red_packet/hongbao.png")
                        self:GetWidgetByName("AtlasLabel_Num" ,cell):setString("微信红包" .. redbagNum .. "元")
                    end   
                    --Image_JPIcon   奖品图片
                    self:GetWidgetByName("Image_JPIcon" ,cell):setScale(0.2)
                end

            end
        end
    else
        for i=1,5 do
            local cell = self:GetWidgetByName("Image_GamePrize_JP_0" .. i)
            cell:setVisible(false)  
        end
        -- if self.mData.IsOut and self.mData.IsOut == 1 then
        --     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHWAITLOADING_WINDOW)
        --     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHRANK_WINDOW)
        --     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHEASTER_WINDOW)
        --     if GameType == 2 then
        --         self.back:setPositionX(display.cx)
        --     end
        --     self.Button_share:setVisible(false)
        --     self:GetWidgetByName("Label_GamePrize_Time"):setVisible(false)
        --     self:GetWidgetByName("Text_time"):setVisible(false)
        --     self:GetWidgetByName("Label_GamePrize_Name"):setVisible(false)
        --     self:GetWidgetByName("Image_3"):setVisible(false)
        --     self:GetWidgetByName("Text_3"):setVisible(false)
        --     self:GetWidgetByName("Image_4"):setVisible(false)
        --     self:GetWidgetByName("Image_4_Copy"):setVisible(false)
        --     self:GetWidgetByName("AtlasLabel_GamePrize_Num"):setVisible(false)
        --     self:GetWidgetByName("Image_bg"):setVisible(false)
        -- end
    end
    if self.mData.IsOut then
        local system = laixiaddz.ani.CocosAnimManager
        -- if self.mData.IsOut == 1 then--不用isout
        if self.mData.rewards == nil then
            -- 失败 or 淘汰
            self.eliminate = system:playAnimationAt(self.Image_Faile,"doudizhu_eliminate")
            self.eliminate:setLocalZOrder(1005)
            self.eliminate:setPositionX(self.Image_Faile:getContentSize().width/2)
            self.eliminate:setPositionY(self.Image_Faile:getContentSize().height-15)
            local resultStr = ""
            if laixiaddz.LocalPlayercfg.LaixiaMatchName == nil or laixiaddz.LocalPlayercfg.LaixiaMatchName=="" then
                resultStr = cc.UserDefault:getInstance():getStringForKey("MatchName")
            else
                resultStr = laixiaddz.LocalPlayercfg.LaixiaMatchName
            end
            self.Text_6 = self:GetWidgetByName("Text_6",self.Image_Faile)
            self.Text_6:setString("您在本场" .. resultStr .. "比赛中遗憾出局。")
            self.Image_Faile:setVisible(true)

            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHWAITLOADING_WINDOW)
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHRANK_WINDOW)
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHEASTER_WINDOW)
            if GameType == 2 then
                self.back:setPositionX(display.cx)
            end
            self.Button_share:setVisible(false)
            self:GetWidgetByName("Label_GamePrize_Time"):setVisible(false)
            self:GetWidgetByName("Text_time"):setVisible(false)
            self:GetWidgetByName("Label_GamePrize_Name"):setVisible(false)
            self:GetWidgetByName("Image_3"):setVisible(false)
            self:GetWidgetByName("Text_3"):setVisible(false)
            self:GetWidgetByName("Image_4"):setVisible(false)
            self:GetWidgetByName("Image_4_Copy"):setVisible(false)
            self:GetWidgetByName("AtlasLabel_GamePrize_Num"):setVisible(false)
            self:GetWidgetByName("Image_bg"):setVisible(false)

        elseif self.mData.rewards ~= nil then
            -- 胜利
            self.promotion = system:playAnimationAt(self.win,"win")
            self.promotion:setLocalZOrder(1005)
            self.promotion:setPositionX(self.win:getContentSize().width/2)
            self.promotion:setPositionY(self.win:getContentSize().height-15)
            self.Image_Faile:setVisible(false)
            self.win:setVisible(true)
        end
    end
end


function GameListResult:SendMatchPacket()
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_REGISTER_MATCH_WINDOW, 
    {
        ["RoomType"] = 2,
        ["RoomID"] =laixiaddz.LocalPlayercfg.LaixiaMatchRoom,
        ["PaymentMethod"] =laixiaddz.LocalPlayercfg.LaixiaPaymentMethod,
        ["MatchId"] =laixiaddz.LocalPlayercfg.LaixiaMatchInsId,
    })   
end

function GameListResult:goShare(sender, eventType)
    if ccui.TouchEventType.ended == eventType then
        laixiaddz.soundTools.playSound(laixiaddz.soundcfg.BUTTON_SOUND.ui_button_open)
        laixiaddz.LocalPlayercfg.MatchGold = 0
        -- 只有有奖励的时候才会出现分享的图标
        if self.mData.rewards ~= nil then
            self.Image_share_erweima:setVisible(true)
            self.back:setVisible(false)
            self.Button_share:setVisible(false)
            self.nextbutton:setVisible(false)
        end
        
       local screenshotFileName = "screenShare.png"--string.format("wx-%s.png", os.date("%Y-%m-%d_%H:%M:%S", os.time()))
       if device.platform == "android" then
           local winsize = cc.Director:getInstance():getWinSize()
           local fileName = cc.FileUtils:getInstance():getWritablePath() .. "/screenShare.png"
           cc.utils:captureScreen(function ( success,outputFile )
                 if success then
                       local luaj = require "cocos.cocos2d.luaj"
                       local javaClassName = APP_ACTIVITY
                       local javaMethodName = "shareImageToWX"
                       local javaParams = {fileName}
                       local javaMethodSig = "(Ljava/lang/String;)V"
                       local state, value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
                        if self.mData.rewards ~= nil then
                            self.Image_share_erweima:setVisible(false)
                            self.back:setVisible(true)
                            self.Button_share:setVisible(true)
                            self.nextbutton:setVisible(true)
                            if self.mData.GameType == 2 then--self.mData.GameType == 2 then
                                self.nextbutton:setVisible(false)
                                self.Button_share:setVisible(false)
                                self.back:setPosition(cc.p(display.cx,123))
                            else
                                self.nextbutton:setVisible(true)
                                self.Button_share:setVisible(false)
                            end
                        end
                 end
           end,fileName)
       else--苹果包
           --分享链接
           local winsize = cc.Director:getInstance():getWinSize()
           local fileName = cc.FileUtils:getInstance():getWritablePath() .. "/screenShare.png"
           cc.utils:captureScreen(function ( success,outputFile )
                 if success then
                       local luaoc = require("cocos.cocos2d.luaoc")
                       local args = { imgFilePath = fileName }
                       local state ,value = luaoc.callStaticMethod("WXinShareManager", "sendImageContent", args);
                        if self.mData.rewards ~= nil then
                            self.Image_share_erweima:setVisible(false)
                            self.back:setVisible(true)
                            self.Button_share:setVisible(true)
                            self.nextbutton:setVisible(true)
                            if self.mData.GameType == 2 then--self.mData.GameType == 2 then
                                self.nextbutton:setVisible(false)
                                self.Button_share:setVisible(false)
                                self.back:setPosition(cc.p(display.cx,123))
                            else
                                self.nextbutton:setVisible(true)
                                self.Button_share:setVisible(false)
                            end
                        end
                 end
           end,fileName)
       end       
    end
end
function GameListResult:goNextMatch(sender, eventType)
    if ccui.TouchEventType.ended == eventType then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW)
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_GAMELIST_GOGAMELIST)
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_MATCHDETAIL_WINDOW)
            laixiaddz.LocalPlayercfg.MatchGold = 0
            self:SendMatchPacket()
    end
end

function GameListResult:showGameList()
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_GAMELIST_GOGAMELIST)
end
function GameListResult:GoBackToGameList(sender, eventType)

    if ccui.TouchEventType.ended == eventType then
        print("continue")
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        laixiaddz.LocalPlayercfg.MatchGold = 0
        self:showGameList()
    end

end

function GameListResult:onCallBackFunction()
    self:showGameList()
end

function GameListResult:onDestroy()
    self.mData = nil
    self.HasJD = false
end


return GameListResult.new()
