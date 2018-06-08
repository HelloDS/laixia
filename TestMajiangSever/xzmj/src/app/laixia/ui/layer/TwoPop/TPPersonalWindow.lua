
local TPPersonalWindow= class("TPPersonalWindow",import("...CBaseDialog"):new())
local soundConfig =  laixia.soundcfg    
local Packet =import("....net.Packet")
local laixiaUITools = laixia.UItools    
local DownloaderHead = import("..DownloaderHead")

function TPPersonalWindow:ctor(...) 
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG      
    self.mIsShow = false
end

function TPPersonalWindow:getName()
	return "UserInfoWindow"
end

function TPPersonalWindow:onInit()
    self.super:onInit(self)        
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_USEINFO_WINDOW,handler(self,self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_HIDE_USEINFO_WINDOW,handler(self,self.destroy))
    -- ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_UPDATE_USERINFO_WINDOW,handler(self,self.updateSignature))
    --ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_DOWNLOADPERSONAL_PICTURE_WINDOW, handler(self,self.headImageDSuccess))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_DOWNLOAD_SELFROOM_PERSONAL_PICTURE_WINDOW, handler(self, self.onHeadDoSuccess))
end

function TPPersonalWindow:sendPersonalPacket(userID)
    local CSPlayerRankInfo = Packet.new("CSPlayerRankInfo", _LAIXIA_PACKET_CS_PlayerRankInfoID)
    CSPlayerRankInfo:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    CSPlayerRankInfo:setValue("GameID", laixia.config.GameAppID)
    CSPlayerRankInfo:setValue("UserID", userID)
    laixia.net.sendHttpPacket(CSPlayerRankInfo)
end


function TPPersonalWindow:updateSignature(msg)
    if self.mIsShow~= true then 
        return 
    end 
    -- if msg.data and msg.data.signStr ~= false then 
    --     self:GetWidgetByName("PLA_Label_Message"):setVisible(true)
    --     if msg.data.signStr == "" then 
    --         self:GetWidgetByName("PLA_Label_Message"):setString("记录此刻的心情")
    --     else 
    --         self:GetWidgetByName("PLA_Label_Message"):setString(msg.data.signStr)
    --     end
    -- end 
end

--  function TPPersonalWindow:onHeadDoSuccess(msg)
--     if self.mIsShow~= true then 
--         return 
--     end 
--     local event = msg.data  
--     local savePath = event.savePath  
--     local path = "images/ic_morenhead"..tostring(tonumber(msg.data["playerID"])%10)..".png"

--     if(savePath ~= nil) and (savePath ~= "") then 
--         path = savePath --.. ".png"--cc.FileUtils:getInstance():getWritablePath() .. 
--     end
--     if self.headpice == nil then
--         self.headpice = self:GetWidgetByName("PLA_Image_Hae")--dImage_HeadPice
--     end
--     self.headpice:removeAllChildren()
--     local sp = display.newSprite(path)
--     sp:setScaleX(self.headpice:getContentSize().width/sp:getContentSize().width)
--     sp:setScaleY(self.headpice:getContentSize().height/sp:getContentSize().height)
--     sp:setPosition(cc.p(0,0))
--     sp:setAnchorPoint(cc.p(0,0))
--     sp:addTo(self.headpice)
--     --self.headpice:loadTexture(path)
--     --再添加新头像
--     --laixiaUITools.addHead(self.headpice, path, soundConfig.IMG_HEAD_TEMPLET_RECT)
-- end

function TPPersonalWindow:shutdown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_USEINFO_WINDOW)
    end
end


function TPPersonalWindow:onTick()
	DownloaderHead:tick()
end


function TPPersonalWindow:onDestroy()
    DownloaderHead:reset()
    self.mIsShow = false
    self.mPlayerGender = nil
end



function TPPersonalWindow:onShow(mesg)
    if self.mIsShow == false then
        -- if not mesg.data["SignStr"] then 
        --     self:sendPersonalPacket(mesg.data["ID"])
        -- else    
        --     self:GetWidgetByName("PLA_Label_Message"):setVisible(true)
        --     if mesg.data["SignStr"] == "" then 
        --         self:GetWidgetByName("PLA_Label_Message"):setString("记录此刻的心情")
        --     else 
        --         self:GetWidgetByName("PLA_Label_Message"):setString(mesg.data["SignStr"])
        --     end
        -- end
        if ui.CardTableDialog.mSelfRoomID == 50 then
            -- 积分
            -- self:GetWidgetByName("PLA_Label_Gold_Name"):setString("积分:")
            self:GetWidgetByName("PLA_Label_Gold"):setString(laixia.LocalPlayercfg.LaixiaSelfBuildIntegral)
            self:GetWidgetByName("Image_14"):loadTexture("new_ui/CardTableDialog/jifen_icon.png")
            self:GetWidgetByName("Image_14"):setScale(1)
        else
            --金币数
            -- self:GetWidgetByName("PLA_Label_Gold_Name"):setString(laixia.utilscfg.CoinType() .. ":")
            -- self:AddWidgetEventListenerFunction("Image_ShutDown", handler(self, self.shutdown))
            --金币数
            local numbergold = laixia.helper.numeralRules_2(tonumber(mesg.data["gold"]))
            self:GetWidgetByName("PLA_Label_Gold"):setString(tonumber(mesg.data["gold"]))
        end
        self.Panel = self:GetWidgetByName("Panel_13")
        self.Panel:addTouchEventListener( handler(self,self.shutdown))
    
        self:GetWidgetByName("PLA_Label_Name"):setString(laixia.helper.StringRules_6(mesg.data["Name"]))
        
        self.labelShengLv = self:GetWidgetByName("PLA_Label_Win")
        -- self.mGender = self:GetWidgetByName("PLA_Image_SexSign")
        -- local playerGender = 0
        -- if self.mPlayerGender~= nil then 
        --     playerGender = self.mPlayerGender
        -- elseif mesg.data["Sex"] then 
        --     playerGender =  mesg.data["Sex"]
        -- end
        -- if playerGender == 1 then  
        --     self.mGender:loadTexture("table_player_girl.png",1)
        -- else 
        --     self.mGender:loadTexture("table_player_boy.png",1)
        -- end 
        --local vipLevel = mesg.data["VIPLevel"]--vip等级

        -- local headFrame = self:GetWidgetByName("PLA_Image_Haed_BG")
        -- headFrame:setVisible(false)

        --self:GetWidgetByName("PLA_Image_Level_BG"):setVisible(false)
        --self.labelLevel = self:GetWidgetByName("PLA_Label_Level") --等级
        --self.labelLevel:setString("Lv." .. mesg.data["Level"] )

        -- 金币


        local guanjuncishu = self:GetWidgetByName("PLA_Label_Round") 
        local winNum = mesg.data["WinNum"] 
        local lostNum = mesg.data["LostNum"]
    
        local totalTimes = winNum + lostNum 
    
        if totalTimes == 0 then
            self.labelShengLv:setString("0%")
        else 
            local shenglv = math.floor(winNum * 100 / totalTimes)
            self.labelShengLv:setString(shenglv .. "%")
        end

        -- 冠军次数
        guanjuncishu:setString(mesg.data["bisaiWin"])
    
        self.headpice = self:GetWidgetByName("PLA_Image_Haed")
        local iconPath = mesg.data["imgPath"]
        self:addHead(self.headpice,mesg.data["ID"],iconPath)
        
        -- if(iconPath ~= nil) and (iconPath ~= "") then
        --     local localIconName = DownloaderHead:SplitLastStr(iconPath, "/")
        --     local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
        --     if(fileExist == true) then
        --         local localIconPath
        --         if string.find(localIconName,".png") then
        --             localIconPath = cc.FileUtils:getInstance():getWritablePath() .. localIconName
        --         else
        --             localIconPath = cc.FileUtils:getInstance():getWritablePath() .. localIconName ..".png"
        --         end
        --         self.headpice:removeAllChildren()
        --         laixiaUITools.addHead(self.headpice, localIconPath, soundConfig.IMG_HEAD_TEMPLET_RECT)
        --     else
        --         local netIconUrl = laixia.config.HEAD_URL .. iconPath
        --         DownloaderHead:pushTask(0, netIconUrl,4)
        --         self.headpice:removeAllChildren()
                
        --         laixiaUITools.addHead(self.headpice,"images/ic_morenhead"..tostring(tonumber(mesg.data["ID"])%10)..".png", soundConfig.IMG_HEAD_TEMPLET_RECT)
        --     end
        -- else    
        --     self.headpice:removeAllChildren()
        --     laixiaUITools.addHead(self.headpice,"images/ic_morenhead"..tostring(tonumber(mesg.data["ID"])%10)..".png", soundConfig.IMG_HEAD_TEMPLET_RECT)
        -- end
        

        -- 显示男女
        self.Image_boy = self:GetWidgetByName("Image_boy")
        self.Image_girl = self:GetWidgetByName("Image_girl")
        if mesg.data["Sex"] == 0 then
            self.Image_boy:setVisible(true)
            self.Image_girl:setVisible(false)
        else
            self.Image_boy:setVisible(false)
            self.Image_girl:setVisible(true)
        end

        -- 位置的调整
        self:GetWidgetByName("Panel_13"):setPosition(ui.CardTableDialog.posX1, ui.CardTableDialog.posY1)

        self.mIsShow = true
    end
end

function TPPersonalWindow:onHeadDoSuccess(msg)
    local data = msg.data

    -- print("downloadSuccess")
    -- print(laixia.LocalPlayercfg.LaixiaPlayerHeadUse)
    -- print(data.savePath)
    -- laixia.LocalPlayercfg.LaixiaPlayerHeadUse = data.savePath
    laixia.LocalPlayercfg.LaixiaPlayerHeadPicture = nil
    --self:updateHead()
    --self:addHead()

    local mHeadInUse = data.savePath
    local localIconPath = cc.FileUtils:getInstance():getWritablePath() .. data.playerID..".png";
    local fileExist = cc.FileUtils:getInstance():isFileExist(localIconPath)
    local image_rank_di = self.rankIcon[tostring(data.playerID)]
    if(fileExist) and image_rank_di~=nil then
        local sprite = display.newSprite(mHeadInUse) 
        sprite:setScaleX(image_rank_di:getContentSize().width/sprite:getContentSize().width)
        sprite:setScaleY(image_rank_di:getContentSize().height/sprite:getContentSize().height)
        sprite:setPosition(image_rank_di:getContentSize().width/2,image_rank_di:getContentSize().height/2)
        image_rank_di:addChild(sprite)
        --self:addHeadIcon(image_rank_di,mHeadInUse)
    end  

end

function TPPersonalWindow:addHead(head,id,headIcon_new)
    -- 默认头像图片路径
    self.rankIcon = {}
    headIcon_new = laixia.LocalPlayercfg.LaixiaPlayerHeadUse; --微信头像要用的
    self.rankIcon[tostring(id)] = head
    local path = "images/ic_morenhead"..tostring(tonumber(id)%10)..".png"
    -- if headIcon_new ~= nil and headIcon_new ~= "" then
        -- local localIconName = DownloaderHead:SplitLastStr(iconPath, "/")
        local localIconName = cc.FileUtils:getInstance():getWritablePath() .. id..".png"
        local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
        if (fileExist) then
            path = localIconName
            self:addHeadIcon(head,path)
            -- local sprite = cc.Sprite:create(localIconPath) 
            -- sprite:setScaleX(image:getContentSize().width/sprite:getContentSize().width)
            -- sprite:setScaleY(image:getContentSize().height/sprite:getContentSize().height)
            -- sprite:setPosition(image:getContentSize().width/2,image:getContentSize().height/2)
            -- image:addChild(sprite)
            --image:loadTexture(localIconPath)
            --image:setScale(0.08)
        else
            -- local sprite = cc.Sprite:create(localIconPath) 
            -- sprite:setScaleX(image:getContentSize().width/sprite:getContentSize().width)
            -- sprite:setScaleY(image:getContentSize().height/sprite:getContentSize().height)
            -- sprite:setPosition(image:getContentSize().width/2,image:getContentSize().height/2)
            -- image:addChild(sprite)
--            image:loadTexture(path)
--            image:setScale(1)
            -- self:addHeadIcon(head,path)
            local netIconUrl = headIcon_new
            DownloaderHead:pushTask(id, netIconUrl,6)
        end
    -- else
        self:addHeadIcon(head,path)
        -- local sprite = cc.Sprite:create(localIconPath) 
        -- sprite:setScaleX(image:getContentSize().width/sprite:getContentSize().width)
        -- sprite:setScaleY(image:getContentSize().height/sprite:getContentSize().height)
        -- sprite:setPosition(image:getContentSize().width/2,image:getContentSize().height/2)
        -- image:addChild(sprite)
--        image:loadTexture(path)
--        image:setScale(1)
    -- end
end        

function TPPersonalWindow:addHeadIcon(head_btn,path)
    --local head_btn = self:GetWidgetByName("Image_Head_Frame")
    if (head_btn == nil or head_btn == "") then
        return
    end
    -- head_btn:removeAllChildren()
    local templet = soundConfig.IMG_HEAD_TEMPLET_RECT
    --laixia.UItools.addHead(head_btn, path, templet)
    local sprite = display.newSprite(path)
    sprite:setScaleX(head_btn:getContentSize().width/sprite:getContentSize().width)
    sprite:setScaleY(head_btn:getContentSize().height/sprite:getContentSize().height)
    sprite:setPosition(head_btn:getContentSize().width/2,head_btn:getContentSize().height/2)
    head_btn:addChild(sprite)
end


return TPPersonalWindow.new()
