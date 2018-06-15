local AppleDismissLayer = class("AppleDismissLayer", import("..CBaseDialog"):new())
local l_OPHIDObject = import("..layer.DownloaderHead")
local soundConfig =  laixia.soundcfg
local Packet = import("...net.Packet")

function AppleDismissLayer:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
    self.mIsShow = false
end

function AppleDismissLayer:getName()
    return "AppleDismissLayer"
end

function AppleDismissLayer:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_APPLYDISMISS_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_UPDATE_APPLYDISMISS_WINDOW, handler(self, self.updateInfo))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_HIDE_APPLYDISMISS_WINDOW, handler(self, self.destroy))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_DOWNLOAD_APPLEDISMISS_WINDOW, handler(self,self.onHeadDoSuccess))
    -- ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_IS_GAOONSELFBUILDING, handler(self, self.onRoomClose))
end


function AppleDismissLayer:onShow(data)
    --进度条
    self.loadingbar = self:GetWidgetByName("LoadingBar_2")
    self.Text_time = self:GetWidgetByName("Text_times")
    self.Text_time:setString("")
    self.Text = self:GetWidgetByName("Text_5")
    -- self:GetWidgetByName("Button_Agree"):setVisible(true)
    -- self:GetWidgetByName("Button_Rejust"):setVisible(true)

    if self.mIsShow == false then
        if data.data.data.AppleDissTime==nil then
            self.maxTime = 300
        else
            self.maxTime = 300-(os.time()-data.data.data.AppleDissTime)
        end
        self.mIsShowAllData = false
        --self.mTime = self:GetWidgetByName("Text_times")
        --self.mTime:setString(self.maxTime.."秒")

        --剩余时间：240秒v1012552...提出解散游戏房间
        -- --设置进度条起始进度
         self.loadingbar:setPercent(100)
        -- --设置剩余时间的描边
        self.mTime = cc.Label:createWithSystemFont("剩余时间：300秒", "Arial", 20)
        self.mTime:setAnchorPoint(cc.p(0,0))                   
        self.mTime:setPosition(cc.p(-55,-13))     
        self.mTime:enableOutline(cc.c4b(111,42,0,255), 2)
        self.Text_time:addChild(self.mTime)
        -- self.mTime = display.newTTFLabel({ text="剩余时间：300秒",
        -- font="arial",--系统自带的字体库
        -- size=18,
        -- color=cc.c3b(255,255,255), --白色颜色
        -- align=cc.TEXT_ALIGNMENT_CENTER, --水平对齐方式
        -- valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,--垂直对齐方式
        -- })
        -- self.mTime:setAnchorPoint(cc.p(0,0)) --设置锚点
        -- self.mTime:setPosition(-50,-12) --设置摆放位置
        -- self.mTime:enableOutline(cc.c4b(80,41,0,0), 2) --描边颜色为红色，描边宽度为2pix。
        -- self.mTime:addTo(self.Text_time) --添加到显示的场景中

        --设置提出解散游戏房间的描边
        self.label = cc.Label:createWithSystemFont("解散游戏房间", "Arial", 30)
        self.label:setAnchorPoint(cc.p(0,0))                   
        self.label:setPosition(cc.p(-80,-20))     
        --self.Text_bt:setColor(cc.c4b(108,139,154,255))
        self.label:enableOutline(cc.c4b(111,42,0,255), 1)
        self.Text:addChild(self.label)
        -- self.label = display.newTTFLabel({ text="剩余时间：240秒",
        -- font="arial",--系统自带的字体库
        -- size=18,
        -- color=cc.c3b(255,255,255), --白色颜色
        -- align=cc.TEXT_ALIGNMENT_CENTER, --水平对齐方式
        -- valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,--垂直对齐方式
        -- })
        -- self.label:setAnchorPoint(cc.p(0,0)) --设置锚点
        -- self.label:setPosition(200+2,200+2) --设置摆放位置
        -- self.label:enableOutline(cc.c4b(157,82,36,0), 1) --描边颜色为红色，描边宽度为2pix。
        -- self.label:addTo(self.Text) --添加到显示的场景中

        self.mIsShow = true

        self.dataInfo = data.data.data.AppleDissUserSet
        if ui.CardTableDialog.mSynchronousData == nil then
            return
        end
        local player = ui.CardTableDialog.mSynchronousData.Players

        self:GetWidgetByName("Button_Agree"):setVisible(false)
        self:GetWidgetByName("Button_Rejust"):setVisible(false)
        for i=1,3 do
            local image_PokerResult =  self:GetWidgetByName("Panel_"..i)
            local index =1
            for j = 1,3 do
                if self.dataInfo[i].playerId ==  player[j].PID then
                    self:OnRefreshHeadIconFunction(self:GetWidgetByName("Image_Head",image_PokerResult),player[j].PID,player[j].Icon)
                    index = j
                    break
                end
            end

            self:GetWidgetByName("Text_PlayerNickname",image_PokerResult):setString(laixia.helper.StringRules_6(player[index].Nickname))

            if self.dataInfo[i].status == 1 then
                --self:GetWidgetByName("Text_IsAgree",image_PokerResult):setString("已同意")
            elseif self.dataInfo[i].status == 0 then
               -- self:GetWidgetByName("Text_IsAgree",image_PokerResult):setString("已拒绝")
                --                end
            elseif self.dataInfo[i].status == 2 then --默认状态
--                self:GetWidgetByName("Text_IsAgree",image_PokerResult):setString("未应答")
                if self.dataInfo[i].playerId == laixia.LocalPlayercfg.LaixiaPlayerID then --如果这个人是我
                    self:GetWidgetByName("Button_Agree"):setVisible(true)
                    self:GetWidgetByName("Button_Rejust"):setVisible(true)
                    --                    self:GetWidgetByName("Button_Agree"):setTouchEnabled(true)
                    --                    self:GetWidgetByName("Button_Rejust"):setTouchEnabled(true)
                end
            end
        end
    else
        self:updateInfo(data)
    end
    --    self.mSelfHead = self:GetWidgetByName("Panel_1"):GetWidgetByName("Image_Head")

    self.AgreeButton = self:GetWidgetByName("Button_Agree")--  再来一次按钮
    self.AgreeButton:addTouchEventListener(handler(self, self.onAgree))

    self.Button_Rejust = self:GetWidgetByName("Button_Rejust")--拒绝
    self.Button_Rejust:addTouchEventListener(handler(self, self.onRejust))
    self.mIsShowAllData = true
end

function AppleDismissLayer:updateInfo(data)
    if self.mIsShow then
        if data.data.data.AppleDissTime==nil then
            self.maxTime = self.maxTime or 300
        else
            self.maxTime = 300-(os.time()-data.data.data.AppleDissTime)
        end
        self.dataInfo = data.data.data.AppleDissUserSet
        local player = ui.CardTableDialog.mSynchronousData.Players
        self:GetWidgetByName("Button_Agree"):setVisible(false)
        self:GetWidgetByName("Button_Rejust"):setVisible(false)
        for i=1,3 do
            local image_PokerResult =  self:GetWidgetByName("Panel_"..i)
            local index =1
            for j = 1,3 do
                if self.dataInfo[i].playerId ==  player[j].PID then
                    self:OnRefreshHeadIconFunction(self:GetWidgetByName("Image_Head",image_PokerResult),player[j].PID,player[j].Icon)
                    index = j
                    break
                end
            end

            self:GetWidgetByName("Text_PlayerNickname",image_PokerResult):setString(player[index].Nickname)

            if self.dataInfo[i].status == 1 then
               -- self:GetWidgetByName("Text_IsAgree",image_PokerResult):setString("已同意")
            elseif self.dataInfo[i].status == 0 then
                --self:GetWidgetByName("Text_IsAgree",image_PokerResult):setString("已拒绝")
            elseif self.dataInfo[i].status == 2 then --默认状态
               -- self:GetWidgetByName("Text_IsAgree",image_PokerResult):setString("未应答")
                if self.dataInfo[i].playerId == laixia.LocalPlayercfg.LaixiaPlayerID then --如果这个人是我
                    self:GetWidgetByName("Button_Agree"):setVisible(true)
                    self:GetWidgetByName("Button_Rejust"):setVisible(true)
                    --                    self:GetWidgetByName("Button_Agree"):setTouchEnabled(true)
                    --                    self:GetWidgetByName("Button_Rejust"):setTouchEnabled(true)
                end
            end
        end
    end
    self.AgreeButton = self:GetWidgetByName("Button_Agree")--  再来一次按钮
    self.AgreeButton:addTouchEventListener(handler(self, self.onAgree))

    self.Button_Rejust = self:GetWidgetByName("Button_Rejust")--拒绝
    self.Button_Rejust:addTouchEventListener(handler(self, self.onRejust))
end
--同意
function AppleDismissLayer:onAgree(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:GetWidgetByName("Button_Agree"):setVisible(false)
        self:GetWidgetByName("Button_Rejust"):setVisible(false)
        --        self:GetWidgetByName("Button_Agree"):setTouchEnabled(false)
        --        self:GetWidgetByName("Button_Rejust"):setTouchEnabled(false)

        local goback = Packet.new("onCreateDelID", _LAIXIA_PACKET_CS_CreateDelID)
        goback:setValue("TableID", ui.CardTableDialog.mSynchronousData.TableID)
        goback:setValue("Status",1)--同意
        laixia.net.sendPacket(goback)
    end
end
---拒绝
function AppleDismissLayer:onRejust(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:GetWidgetByName("Button_Agree"):setVisible(false)
        self:GetWidgetByName("Button_Rejust"):setVisible(false)
        --        self:GetWidgetByName("Button_Agree"):setTouchEnabled(false)
        --        self:GetWidgetByName("Button_Rejust"):setTouchEnabled(false)

        local goback = Packet.new("onCreateDelID", _LAIXIA_PACKET_CS_CreateDelID)
        goback:setValue("TableID", ui.CardTableDialog.mSynchronousData.TableID)
        goback:setValue("Status",0)--拒绝
        laixia.net.sendPacket(goback)

        ---拒绝的
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_APPLYDISMISS_WINDOW)
        self.mIsShow = false
    end
end

function AppleDismissLayer:onHeadDoSuccess(msg)
    local data = msg.data    
    local mHeadInUse = data.savePath
    local localIconPath = cc.FileUtils:getInstance():getWritablePath() .. mHeadInUse
    local fileExist = cc.FileUtils:getInstance():isFileExist(mHeadInUse)
    print(data.playerID)
    local image_rank_di = self.rankIcon[tostring(data.playerID)]
    if(fileExist) and image_rank_di~=nil then
        --image_rank_di:loadTexture(localIconPath)
        local sprite = display.newSprite(mHeadInUse)
        sprite:setScaleX(image_rank_di:getContentSize().width/sprite:getContentSize().width)
        sprite:setScaleY(image_rank_di:getContentSize().height/sprite:getContentSize().height)
        sprite:setPosition(image_rank_di:getContentSize().width/2,image_rank_di:getContentSize().height/2)
        image_rank_di:addChild(sprite)
    end       
end

function AppleDismissLayer:OnRefreshHeadIconFunction(head,id,icon)
    -- 默认头像图片路径
    self.rankIcon = {}
    --local path = "images/ic_morenhead"..tostring(tonumber(laixia.LocalPlayercfg.LaixiaPlayerID%10))..".png"
    --local headIcon_new = laixia.LocalPlayercfg.LaixiaPlayerHeadUse; --微信头像要用的
    self.rankIcon[tostring(id)] = head
    local path = "images/ic_morenhead"..tostring(tonumber(id)%10)..".png"
    if icon ~= nil and icon ~= "" then
        -- local localIconName = DownloaderHead:SplitLastStr(iconPath, "/")
        local localIconName = cc.FileUtils:getInstance():getWritablePath() .. id..".png"
        local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
        if (fileExist) then
            local localIconPath = localIconName
            self:addHeadIcon(head,localIconPath)
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
            self:addHeadIcon(head,path)
            local netIconUrl = icon
            l_OPHIDObject:pushTask(id, netIconUrl,8)
        end
    else
        self:addHeadIcon(head,path)
        -- local sprite = cc.Sprite:create(localIconPath) 
        -- sprite:setScaleX(image:getContentSize().width/sprite:getContentSize().width)
        -- sprite:setScaleY(image:getContentSize().height/sprite:getContentSize().height)
        -- sprite:setPosition(image:getContentSize().width/2,image:getContentSize().height/2)
        -- image:addChild(sprite)
--        image:loadTexture(path)
--        image:setScale(1)
    end
end

function AppleDismissLayer:addHeadIcon(head_btn,path)
    --local head_btn = self:GetWidgetByName("Image_Head_Frame")
    if (head_btn == nil or head_btn == "") then
        return
    end
    head_btn:removeAllChildren()
    -- local templet = soundConfig.IMG_HEAD_TEMPLET_RECT
    -- laixia.UItools.addHead(head_btn, path, templet)
    local sprite = display.newSprite(path)
    sprite:setScaleX(head_btn:getContentSize().width/sprite:getContentSize().width)
    sprite:setScaleY(head_btn:getContentSize().height/sprite:getContentSize().height)
    sprite:setPosition(head_btn:getContentSize().width/2,head_btn:getContentSize().height/2)
    head_btn:addChild(sprite)
end     


-- function AppleDismissLayer:OnRefreshHeadIconFunction(head,id,icon)
--     -- 默认头像图片路径
--     local path

--     if head == self.mSelfHead then
--         path = "images/ic_morenhead"..tostring(tonumber(laixia.LocalPlayercfg.LaixiaPlayerID)%10)..".png"
--         local headIcon = laixia.LocalPlayercfg.LaixiaPlayerHeadPicture;
--         local headIcon_new = laixia.LocalPlayercfg.LaixiaPlayerHeadUse; --头像要用的
--         --微信渠道要看头像是否有变化
--         if cc.Application:getInstance():getTargetPlatform() == 5 and headIcon_new~=cc.UserDefault:getInstance():getStringForKey("headimgurl") then
--             headIcon = nil
--             headIcon_new = cc.UserDefault:getInstance():getStringForKey("headimgurl")
--             laixia.LocalPlayercfg.LaixiaPlayerHeadUse = headIcon_new
--             laixia.LocalPlayercfg.LaixiaHeadPortraitPath = ""
--             laixia.config.HEAD_URL = cc.UserDefault:getInstance():getStringForKey("headimgurl")

--         end
--         if headIcon ~= nil  and headIcon ~= "" then
--             local testPath
--             if string.find(headIcon,".png") then
--                 testPath = cc.FileUtils:getInstance():getWritablePath() .. headIcon
--             else
--                 testPath = cc.FileUtils:getInstance():getWritablePath() .. headIcon..".png"
--             end
--             local fileExist = cc.FileUtils:getInstance():isFileExist(testPath)
--             if (fileExist) then
--                 path = testPath
--             else
--                 laixia.LocalPlayercfg.LaixiaPlayerHeadPicture = nil                
--             end
--         elseif headIcon_new ~= nil and headIcon_new ~= "" then
--             local testPath
--             if string.find(headIcon_new,".png") then
--                 testPath = cc.FileUtils:getInstance():getWritablePath() .. headIcon_new
--             else
--                 testPath = cc.FileUtils:getInstance():getWritablePath() .. headIcon_new..".png" 
--             end
--             print(testPath)

--             local fileExist = cc.FileUtils:getInstance():isFileExist(testPath)

--             print(fileExist)
--             if (fileExist) then
--                 path = testPath
--             else
--                 --下载图片
--                 local headIconUrl = laixia.config.HEAD_URL .. laixia.LocalPlayercfg.LaixiaHeadPortraitPath
--                 l_OPHIDObject:pushTask(id, headIconUrl,2)
--             end
--         end
--     else
--         path = "images/ic_morenhead"..tostring(tonumber(id)%10)..".png"

--         --            --微信渠道要看头像是否有变化
--         if cc.Application:getInstance():getTargetPlatform() == 5 and headIcon_new~=cc.UserDefault:getInstance():getStringForKey("headimgurl") then
--             headIcon = nil
--             headIcon_new = cc.UserDefault:getInstance():getStringForKey("headimgurl")
--             laixia.LocalPlayercfg.LaixiaPlayerHeadUse = headIcon_new
--             laixia.LocalPlayercfg.LaixiaHeadPortraitPath = ""
--             laixia.config.HEAD_URL = cc.UserDefault:getInstance():getStringForKey("headimgurl")
--             --                
--         end
--         if icon and icon ~= "" then
--             --                local localIconName = l_OPHIDObject:SplitLastStr(icon, "/")
--             local localIconName = cc.FileUtils:getInstance():getWritablePath()..id..".png"
--             local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
--             if (fileExist) then
--                 path = localIconName
--             else
--                 --下载图片
--                 local netIconUrl = icon
--                 l_OPHIDObject:pushTask(id, netIconUrl,1)
--             end
--         end
--     end
--     -- -- 先删除旧头像
--     head:removeAllChildren()
--     -- -- 再添加新头像
--     local templet = soundConfig.IMG_HEAD_TEMPLET_RECT
--     -- laixia.UItools.addHead(head, path, templet)
--     head:setScale(96/106)
--     local sprite = display.newSprite(path) 
--     sprite:setScaleX(head:getContentSize().width/sprite:getContentSize().width)
--     sprite:setScaleY(head:getContentSize().height/sprite:getContentSize().height)
--     sprite:setPosition(head:getContentSize().width/2,head:getContentSize().height/2)
--     head:addChild(sprite)
-- end


local time = 0
function AppleDismissLayer:onTick(dt)
    if ui.CardTableDialog.mRoomID  == 50  then
        time = time + dt
        if self.maxTime<=0 then
            return
        end
        if time >= 1 then
            time = 0
            self.maxTime = self.maxTime - 1
            --时间
            self.mTime:setString("剩余时间:" .. self.maxTime .. "秒")
            --进度条
            local pers = self.maxTime/300 * 100
            self.loadingbar:setPercent(pers)

            if self.maxTime <= 0 then
                self:GetWidgetByName("Button_Agree"):setVisible(false)
                self:GetWidgetByName("Button_Rejust"):setVisible(false)
                --                self:GetWidgetByName("Button_Agree"):setTouchEnabled(false)
                --                self:GetWidgetByName("Button_Rejust"):setTouchEnabled(false)

                local goback = Packet.new("onCreateDelID", _LAIXIA_PACKET_CS_CreateDelID)
                goback:setValue("TableID", ui.CardTableDialog.mSynchronousData.TableID)
                goback:setValue("Status",1)--同意
                laixia.net.sendPacket(goback)
            end
            --sync 头像数据
            if self.mIsShowAllData==false and ui.CardTableDialog.mSynchronousData.Players~=nil then
                local player = ui.CardTableDialog.mSynchronousData.Players

                self:GetWidgetByName("Button_Agree"):setVisible(false)
                self:GetWidgetByName("Button_Rejust"):setVisible(false)
                for i=1,3 do
                    local image_PokerResult =  self:GetWidgetByName("Panel_"..i)
                    local index =1
                    for j = 1,3 do
                        if self.dataInfo[i].playerId ==  player[j].PID then
                            self:OnRefreshHeadIconFunction(self:GetWidgetByName("Image_Head",image_PokerResult),player[j].PID,player[j].Icon)
                            index = j
                            break
                        end
                    end

                    self:GetWidgetByName("Text_PlayerNickname",image_PokerResult):setString(player[index].Nickname)

                    if self.dataInfo[i].status == 1 then
                        --self:GetWidgetByName("Text_IsAgree",image_PokerResult):setString("已同意")
                    elseif self.dataInfo[i].status == 0 then
                       -- self:GetWidgetByName("Text_IsAgree",image_PokerResult):setString("已拒绝")
                    elseif self.dataInfo[i].status == 2 then --默认状态
                      --  self:GetWidgetByName("Text_IsAgree",image_PokerResult):setString("未应答")
                        if self.dataInfo[i].playerId == laixia.LocalPlayercfg.LaixiaPlayerID then --如果这个人是我
                            self:GetWidgetByName("Button_Agree"):setVisible(true)
                            self:GetWidgetByName("Button_Rejust"):setVisible(true)
                        end
                    end
                end
                self.mIsShowAllData = true
            end
        end
    end
end



function AppleDismissLayer:onDestroy()
    self.mIsShow = false
end


-- function AppleDismissLayer:OnRefreshHeadIconFunction(head,id,icon)
--     -- 默认头像图片路径
--         local path

--         if head == self.mSelfHead then
--             path = "images/ic_morenhead"..tostring(tonumber(laixia.LocalPlayercfg.LaixiaPlayerID)%10)..".png"
--             local headIcon = laixia.LocalPlayercfg.LaixiaPlayerHeadPicture;
--             local headIcon_new = laixia.LocalPlayercfg.LaixiaPlayerHeadUse; --头像要用的
--             --微信渠道要看头像是否有变化
--             if cc.Application:getInstance():getTargetPlatform() == 5 and headIcon_new~=cc.UserDefault:getInstance():getStringForKey("headimgurl") then
--                 headIcon = nil
--                 headIcon_new = cc.UserDefault:getInstance():getStringForKey("headimgurl")
--                 laixia.LocalPlayercfg.LaixiaPlayerHeadUse = headIcon_new
--                 laixia.LocalPlayercfg.LaixiaHeadPortraitPath = ""
--                 laixia.config.HEAD_URL = cc.UserDefault:getInstance():getStringForKey("headimgurl")
                
--             end
--             if headIcon ~= nil  and headIcon ~= "" then
--                 local testPath
--                 if string.find(headIcon,".png") then
--                     testPath = cc.FileUtils:getInstance():getWritablePath() .. headIcon
--                 else
--                     testPath = cc.FileUtils:getInstance():getWritablePath() .. headIcon..".png"
--                 end
--                 local fileExist = cc.FileUtils:getInstance():isFileExist(testPath)
--                 if (fileExist) then
--                     path = testPath
--                 else
--                     laixia.LocalPlayercfg.LaixiaPlayerHeadPicture = nil                
--                 end
--             elseif headIcon_new ~= nil and headIcon_new ~= "" then
--                 local testPath
--                 if string.find(headIcon_new,".png") then
--                     testPath = cc.FileUtils:getInstance():getWritablePath() .. headIcon_new
--                 else
--                     testPath = cc.FileUtils:getInstance():getWritablePath() .. headIcon_new..".png" 
--                 end
--                 print(testPath)

--                 local fileExist = cc.FileUtils:getInstance():isFileExist(testPath)

--                 print(fileExist)
--                 if (fileExist) then
--                     path = testPath
--                 else
--                 --下载图片
--                     local headIconUrl = laixia.config.HEAD_URL .. laixia.LocalPlayercfg.LaixiaHeadPortraitPath
--                     l_OPHIDObject:pushTask(id, headIconUrl,2)
--                 end
--             end
--         else
--              path = "images/ic_morenhead"..tostring(tonumber(id)%10)..".png"

-- --            --微信渠道要看头像是否有变化
--             if cc.Application:getInstance():getTargetPlatform() == 5 and headIcon_new~=cc.UserDefault:getInstance():getStringForKey("headimgurl") then
--                 headIcon = nil
--                 headIcon_new = cc.UserDefault:getInstance():getStringForKey("headimgurl")
--                 laixia.LocalPlayercfg.LaixiaPlayerHeadUse = headIcon_new
--                 laixia.LocalPlayercfg.LaixiaHeadPortraitPath = ""
--                 laixia.config.HEAD_URL = cc.UserDefault:getInstance():getStringForKey("headimgurl")
-- --                
--             end
--             if icon and icon ~= "" then
-- --                local localIconName = l_OPHIDObject:SplitLastStr(icon, "/")
--                 local localIconName = cc.FileUtils:getInstance():getWritablePath()..id..".png"
--                 local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
--                 if (fileExist) then
--                     path = localIconName
--                 else
--                     --下载图片
--                     local netIconUrl = icon
--                     l_OPHIDObject:pushTask(id, netIconUrl,1)
--                 end
--             end
--         end
--         -- -- 先删除旧头像
--          head:removeAllChildren()
--         -- -- 再添加新头像
--         local templet = soundConfig.IMG_HEAD_TEMPLET_RECT
--         -- laixia.UItools.addHead(head, path, templet)
--          head:setScale(96/106)
--         local sprite = display.newSprite(path) 
--         sprite:setScaleX(head:getContentSize().width/sprite:getContentSize().width)
--         sprite:setScaleY(head:getContentSize().height/sprite:getContentSize().height)
--         sprite:setPosition(head:getContentSize().width/2,head:getContentSize().height/2)
--         head:addChild(sprite)
-- end
function AppleDismissLayer:onDestroy()
    --self:destroy()
    self.mIsShow = false
    local test = 1
end
return AppleDismissLayer.new()


