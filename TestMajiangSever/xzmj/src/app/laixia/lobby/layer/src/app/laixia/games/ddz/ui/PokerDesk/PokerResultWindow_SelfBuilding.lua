local PokerResultWindow_SelfBuilding = class("PokerResultWindow_SelfBuilding", import("..CBaseDialog"):new())  
local soundConfig =  laixiaddz.soundcfg
local l_OPHIDObject = import("..layer.DownloaderHead")
--local DownloaderHead = import("...DownloaderHead")

function PokerResultWindow_SelfBuilding:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end



function PokerResultWindow_SelfBuilding:getName()
    return "PokerResultWindow_SelfBuilding"
end

function PokerResultWindow_SelfBuilding:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_SELFBUILDINGRESULT_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_SELFBUILDINGRESULT_WINDOW, handler(self, self.destroy))
--    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SELFBUILDING_REWARDS, handler(self, self.getRewards))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_DOWNLOAD_RESULT_BIG_PICTURE_WINDOW, handler(self, self.onHeadDoSuccess))
end

function PokerResultWindow_SelfBuilding:getRewards(msg)
    self.Rewards ={}
    local data   = msg.data

    self.Rewards.rank = data.Rank
    for i,v  in ipairs(data.Rewards) do
        local items = {}
        items.ItemID = v.ID 
        items.ItemCount = v.Num 
        table.insert(self.Rewards,items)
    end
    self.Rewards.overFun  =  function() ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW) end

end

function PokerResultWindow_SelfBuilding:onShow(msg)
    self:AddWidgetEventListenerFunction("Button_GoAway", handler(self,self.onShutDown))
    self:AddWidgetEventListenerFunction("Button_3", handler(self,self.onShare))

    self:GetWidgetByName("Button_GoAway"):setPosition(cc.p(640,125))
    self:GetWidgetByName("Button_3"):setVisible(false)

    --隐藏自建房的 拒绝状态 --这个不一定需要 因为重连以后还是应该是状态中
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_APPLYDISMISS_WINDOW)

    self.Rewards ={}
    local player = ui.CardTableDialog.mSynchronousData.Players
    if ui.CardTableDialog.mSynchronousData == nil then
        self:onDestroy() --连牌桌都连不回去了 你显示结果干毛线
        return
    end
      local playerInfo =msg.data

      local data = msg.data.Bureaus
      for i=1,3 do
            local image_PokerResult =  self:GetWidgetByName("Image_PokerResult_PlayerBG0"..i)
            local index =1
            for j = 1,3 do
                if data[i].PlayerID ==  player[j].PID then
                    self:OnRefreshHeadIconFunction(self:GetWidgetByName("Image_head",image_PokerResult),player[j].PID,player[j].Icon)
                    index = j
                    break
                end
            end
            --self:OnRefreshHeadIconFunction(self:GetWidgetByName("Image_head",image_PokerResult),data[i].PlayerID,playerInfo[i].Icon)
            
            self:GetWidgetByName("Label_Player_Name",image_PokerResult):setString(laixiaddz.helper.StringRules_6(player[index].Nickname))

            if data[index].AllFen>0 then
                self:GetWidgetByName("Label_Player_Gold",image_PokerResult):setVisible(true)
                self:GetWidgetByName("Label_Player_Gold",image_PokerResult):setString(data[index].AllFen)
                self:GetWidgetByName("Label_Player_Gold_reduce",image_PokerResult):setVisible(false)
            else
                self:GetWidgetByName("Label_Player_Gold_reduce",image_PokerResult):setVisible(true)
                self:GetWidgetByName("Label_Player_Gold_reduce",image_PokerResult):setString(data[index].AllFen)
                self:GetWidgetByName("Label_Player_Gold",image_PokerResult):setVisible(false)
            end
      end

      local wanfaName = ""
      if playerInfo.TableType == 0 then
        self:GetWidgetByName("Label_Player_wanfa"):setString("经典斗地主")
      elseif playerInfo.TableType == 1 then
        self:GetWidgetByName("Label_Player_wanfa"):setString("欢乐斗地主")
      end
      self.Text_4_Copy = self:GetWidgetByName("Text_4_Copy")
      self.Text_4_Copy:enableOutline(cc.c4b(111,42,0,255), 2)

      self:GetWidgetByName("Label_Player_Jushu"):setString(playerInfo.Jushu) --总局数
      self:GetWidgetByName("Label_Player_Jushu"):enableOutline(cc.c4b(111,42,0,255), 2)
      
      self.tableId = self:GetWidgetByName("Label_Player_TableID")
      self.tableId:setString(playerInfo.TableID)
      self.tableId:enableOutline(cc.c4b(111,42,0,255), 2)

      local day = os.time()
      local dataTime = os.date("20%y-".."%m-" .. "%d " ..  " %X", day, day, day,day)
      self:GetWidgetByName("Label_Player_Time"):setString(dataTime)

      ---比对三个人的最终得分 分数最多的 显示 分数相同切不为0则 两个都显示大赢家
      --如果分数最高的 且为0则都不现实
      --
      for i=1,2 do
         for j=2,3 do
            if data[i].AllFen<data[j].AllFen then
                local temp = data[j]
                data[j] = data[i]
                data[i] = temp
            end
         end  
      end
       if data[1].AllFen == 0 and data[2].AllFen == 0 and data[3].AllFen == 0 then--
       else
           if data[1].AllFen == data[2].AllFen then--
                --两个大赢家
                for j = 1,3 do
                    local image_PokerResult =  self:GetWidgetByName("Image_PokerResult_PlayerBG0"..j)
                    if data[1].PlayerID ==  player[j].PID  then
                        self:GetWidgetByName("Image_Player_Landlord",image_PokerResult):setVisible(true)
                        break
                    end
                    if data[2].PlayerID == player[j].PID then
                        self:GetWidgetByName("Image_Player_Landlord",image_PokerResult):setVisible(true)
                        break
                    end
                end
           else
                for j = 1,3 do
                    local image_PokerResult =  self:GetWidgetByName("Image_PokerResult_PlayerBG0"..j)
                    if data[1].PlayerID ==  player[j].PID  then
                        self:GetWidgetByName("Image_Player_Landlord",image_PokerResult):setVisible(true)
                        break
                    end
                end
            end
       end
    -- local PlayerMsg = self:GetWidgetByName("Image_PlayerMsg")
    -- local Jifen =   self:GetWidgetByName("Image_Jifen")
    
    -- local data = msg.data.Bureaus
    -- local player = ui.CardTableDialog.mSynchronousData.Players

    -- local temp =  {}
    -- for s1 = 1,#data-1 do
    --     for s2 = 1,#data - 1 do
    --         if data[s2].AllFen < data[s2+1].AllFen then
    --            temp = data[s2]
    --            data[s2] =  data[s2+1]
    --            data[s2+1] = temp 
    --         end
    --     end
    -- end

    -- local title = nil
    -- if #data[1].Bureaus == 15 then
    --    title = self:GetWidgetByName("Image_TitleFor15")
    -- else
    --    title = self:GetWidgetByName("Image_TitleFor6")
    -- end
    -- title:setVisible(true) 
    
    local uigold ={}
    for jj,vv in ipairs(data) do
        local temp = {}
        temp.playerID = vv.PlayerID
        temp.AllFen  = vv.AllFen
        table.insert(uigold,temp)
    end
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATEGOLD,uigold)          
    
    -- for i,v  in ipairs(data) do --[1] = {PlayerID=441 Bureaus={} }
    --    local playerID = v.PlayerID
    --    local name = ""
    --    local zongfen = v.AllFen
       
    --    for ii,vv in ipairs(player) do 
    --       if vv.PID == playerID then
    --          name = vv.Nickname 
    --       end
    --    end
    --:removeAllItems()
    --:pushBackCustomItem(rankCell)
       -- local list_Path =  "ListView_For0".. i
       -- local listView = self:GetWidgetByName(list_Path,title)
       -- listView:removeAllItems()
       -- local playerNode =  PlayerMsg:clone()
       -- listView:pushBackCustomItem(playerNode)
       
       -- local icon_node = self:GetWidgetByName("Image_RankIcon",playerNode)
       -- local path = "rank_num" .. i .. ".png"
       -- icon_node:loadTexture(path,1)
       -- local name_node = self:GetWidgetByName("Label_PlayerName",playerNode)
       -- name_node:setString(name)
       -- local jifen_node = self:GetWidgetByName("Label_PlayerJifen",playerNode)
       -- jifen_node:setString(zongfen)
       -- if laixiaddz.LocalPlayercfg.LaixiaPlayerID ~= playerID then
       --    jifen_node:setColor(cc.c3b(255,255,255))
       --    name_node:setColor(cc.c3b(255,255,255))
       -- end
       -- for j = #v.Bureaus ,1,-1 do
       --    local add_node = Jifen:clone()
       --    listView:pushBackCustomItem(add_node)
       --    local s_jifen= self:GetWidgetByName("Label_Jifen",add_node)
       --    s_jifen:setString(v.Bureaus[j])
          
       --    if laixiaddz.LocalPlayercfg.LaixiaPlayerID ~= playerID then
       --      s_jifen:setColor(cc.c3b(255,255,255))
       --    end
       -- end

    --end
end

function PokerResultWindow_SelfBuilding:onHeadDoSuccess(msg)
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
----------------------
function PokerResultWindow_SelfBuilding:OnRefreshHeadIconFunction(head,id,icon)
    -- 默认头像图片路径
    self.rankIcon = {}
    --local path = "images/ic_morenhead"..tostring(tonumber(laixiaddz.LocalPlayercfg.LaixiaPlayerID%10))..".png"
    --local headIcon_new = laixiaddz.LocalPlayercfg.LaixiaPlayerHeadUse; --微信头像要用的
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

function PokerResultWindow_SelfBuilding:addHeadIcon(head_btn,path)
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

-- function PokerResultWindow_SelfBuilding:OnRefreshHeadIconFunction(head,id,icon)
--     -- 默认头像图片路径
--         local path

--         if head == self.mSelfHead then
--             path = "images/ic_morenhead"..tostring(tonumber(laixiaddz.LocalPlayercfg.LaixiaPlayerID)%10)..".png"
--             local headIcon = laixiaddz.LocalPlayercfg.LaixiaPlayerHeadPicture;
--             local headIcon_new = laixiaddz.LocalPlayercfg.LaixiaPlayerHeadUse; --头像要用的
--             --微信渠道要看头像是否有变化
--             if cc.Application:getInstance():getTargetPlatform() == 5 and headIcon_new~=cc.UserDefault:getInstance():getStringForKey("headimgurl") then
--                 headIcon = nil
--                 headIcon_new = cc.UserDefault:getInstance():getStringForKey("headimgurl")
--                 laixiaddz.LocalPlayercfg.LaixiaPlayerHeadUse = headIcon_new
--                 laixiaddz.LocalPlayercfg.LaixiaHeadPortraitPath = ""
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
--                     laixiaddz.LocalPlayercfg.LaixiaPlayerHeadPicture = nil                
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
--                     local headIconUrl = laixia.config.HEAD_URL .. laixiaddz.LocalPlayercfg.LaixiaHeadPortraitPath
--                     l_OPHIDObject:pushTask(id, headIconUrl,2)
--                 end
--             end
--         else
--              path = "images/ic_morenhead"..tostring(tonumber(id)%10)..".png"

-- --            --微信渠道要看头像是否有变化
--             if cc.Application:getInstance():getTargetPlatform() == 5 and headIcon_new~=cc.UserDefault:getInstance():getStringForKey("headimgurl") then
--                 headIcon = nil
--                 headIcon_new = cc.UserDefault:getInstance():getStringForKey("headimgurl")
--                 laixiaddz.LocalPlayercfg.LaixiaPlayerHeadUse = headIcon_new
--                 laixiaddz.LocalPlayercfg.LaixiaHeadPortraitPath = ""
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


--分享
function PokerResultWindow_SelfBuilding:onShare(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(laixiaddz.soundcfg.BUTTON_SOUND.ui_button_open)

        if device.platform == "android" then
            local layerSize = self.mInterfaceRes:getContentSize()
            local screenshot = cc.RenderTexture:create(layerSize.width, layerSize.height)
            local scene = cc.Director:getInstance():getRunningScene()
            screenshot:begin()
            scene:visit()
            screenshot:endToLua()

            local screenshotFileName = "screenShare.png"--string.format("wx-%s.png", os.date("%Y-%m-%d_%H:%M:%S", os.time()))
            screenshot:saveToFile(screenshotFileName, cc.IMAGE_FORMAT_PNG, false)

           
        else--苹果包
            --分享链接
            local winsize = cc.Director:getInstance():getWinSize()
            local fileName = cc.FileUtils:getInstance():getWritablePath() .. "/screenShare.png"
            cc.utils:captureScreen(function ( success,outputFile )
                  if success then
                    self.shareImgFilePath = fileName
                  end
            end,fileName)
        end
        self.shareImgFilePath = cc.FileUtils:getInstance():getWritablePath() .. screenshotFileName
        self.scheduleHandler =cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.update), 0.1, false)
    end
end
function PokerResultWindow_SelfBuilding:update()
    if self.shareImgFilePath and cc.FileUtils:getInstance():isFileExist(self.shareImgFilePath) then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleHandler)
        if device.platform == "ios" then
            local luaoc = require("cocos.cocos2d.luaoc")
            local args = { imgFilePath = self.shareImgFilePath }
            local state ,value = luaoc.callStaticMethod("WXinShareManager", "sendImageContent", args);
        elseif device.platform == "android" then
            local luaj = require "cocos.cocos2d.luaj"
            local javaClassName = APP_ACTIVITY
            local javaMethodName = "shareImageToWX"
            local javaParams = {self.shareImgFilePath}
            local javaMethodSig = "(Ljava/lang/String;)V"
            local state, value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            return value
        end
        self.shareImgFilePath = nil
    end
end
function PokerResultWindow_SelfBuilding:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        --self:destroy()
--        if #self.Rewards >0  then
--              ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_GAIN_WINDOW, self.Rewards)
--              self.Rewards = {}
--        else
              ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW)
--        end
        
    end
end


return PokerResultWindow_SelfBuilding.new()


