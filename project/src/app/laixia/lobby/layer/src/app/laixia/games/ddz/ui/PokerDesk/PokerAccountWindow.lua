local PokerAccountWindow = class("PokerAccountWindow",import("..CBaseDialog").new())
local soundConfig =  laixiaddz.soundcfg
local Packet = import("...net.Packet")
local EffectDict =  laixiaddz.EffectDict;
local EffectAni = laixiaddz.EffectAni;
--local DownloaderHead = import("..DownloaderHead")
local l_OPHIDObject = import("..layer.DownloaderHead")

function PokerAccountWindow:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
    self.mIsShow = false
end

function PokerAccountWindow:getName()
    return "PokerAccountWindow"
end

function PokerAccountWindow:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_TABLERESULT_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_TABLERESULT_WINDOW, handler(self, self.destroy))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_IS_GAOONSELFBUILDING, handler(self, self.onRoomClose))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_DOWNLOAD_RESULT_SMALL_PICTURE_WINDOW, handler(self, self.headDownloadSuccess))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_GETLAIDOU,handler(self, self.GetLaidou))
end


function PokerAccountWindow:onShow(data)
    self.maxTime = 10
    self.time = 300
    --继续按钮
    self.tryAaginW = self:GetWidgetByName("Button_PokerResult_Continue")--  再来一次按钮
    self.tryAaginW:addTouchEventListener(handler(self, self.tryAgain))
    self.tryAaginW:setVisible(false)

    self.quit = self:GetWidgetByName("Button_PokerResult_Quit")
    self.quit:addTouchEventListener(handler(self, self.goBackFun))
    self.quit:setVisible(false)

    --继续旁的时间label
   -- self.mTime = self:GetWidgetByName("Label_Time_Self")
    -- if laixiaddz.LocalPlayercfg.LaixiaSelfBuildTable ~= nil and laixiaddz.LocalPlayercfg.LaixiaSelfBuildTable > 0 then
    --     local x = self.tryAaginW:getPositionX()
    --     self.tryAaginW:setPositionX(display.width/2)
    --     self.quit:setVisible(false)
    --     self.mTime:setVisible(false)
    -- else
    --     self.mTime:setVisible(false)
    -- end
    --通：
    --分享按钮 在自建房大结算的时候显示
    self.share = self:GetWidgetByName("Button_PokerResult_Share")
    if ui.CardTableDialog.mRoomID == 50 then
        self.share:setVisible(false)
    else
        self.share:setVisible(false)
    end
    self.share:addTouchEventListener(handler(self,self.onShare))

    --游戏场ui
    self.beijing = self:GetWidgetByName("beijing")
    
    self.Boob = self:GetWidgetByName("Text_4_Copy_Copy")
    self.Boob:enableOutline(cc.c4b(123,53,10,255), 2)

    self.BoobNum = self:GetWidgetByName("Label_Player_Boob")
    self.BoobNum:enableOutline(cc.c4b(123,53,10,255), 2)

    self.huojian = self:GetWidgetByName("Text_28")
    self.huojian:enableOutline(cc.c4b(123,53,10,255), 2)

    self.huojianNum = self:GetWidgetByName("Text_29")
    self.huojianNum:enableOutline(cc.c4b(123,53,10,255), 2)

    self.spring = self:GetWidgetByName("Text_4_Copy")
    self.spring:enableOutline(cc.c4b(123,53,10,255), 2)

    self.springNum = self:GetWidgetByName("Label_Player_Spring")
    self.springNum:enableOutline(cc.c4b(123,53,10,255), 2)

    self.Text_difen = self:GetWidgetByName("Text_difen")
    self.Text_difen:enableOutline(cc.c4b(123,53,10,255), 2)

    self.difenNum = self:GetWidgetByName("Label_Player_Difen")
    self.difenNum:enableOutline(cc.c4b(123,53,10,255), 2)

    self.beishu = self:GetWidgetByName("Text_4")
    self.beishu:enableOutline(cc.c4b(123,53,10,255), 2)

    self.beishuNum = self:GetWidgetByName("Label_Player_Times")
    self.beishuNum:enableOutline(cc.c4b(123,53,10,255), 2)

    self.Label_Player_Gold = self:GetWidgetByName("Label_Player_Gold")
    self.Label_Player_Gold_reduce = self:GetWidgetByName("Label_Player_Gold_reduce")
    self.goldSign = self:GetWidgetByName("Image_18")
    self.ld = self:GetWidgetByName("Image_19")
    self.ldNum = self:GetWidgetByName("Text_31")
    self:GetWidgetByName("Text_31"):setVisible(false)
    self:GetWidgetByName("Image_19"):setVisible(false)

    self.beijing:setVisible(false)
    self.Boob:setVisible(false)
    self.BoobNum:setVisible(false)
    self.huojian:setVisible(false)
    self.huojianNum:setVisible(false)
    self.spring:setVisible(false)
    self.springNum:setVisible(false)
    self.Text_difen:setVisible(false)
    self.difenNum:setVisible(false) 
    self.beishu:setVisible(false)
    self.beishuNum:setVisible(false) 
    self.Label_Player_Gold:setVisible(false) 
    self.Label_Player_Gold_reduce:setVisible(false) 
    self.goldSign:setVisible(false) 

    --自建房ui
    self.image_zbg1 = self:GetWidgetByName("image_zbg1")
    self.Image_zbg2 = self:GetWidgetByName("Image_zbg2")
    self.Image_zbg3 = self:GetWidgetByName("Image_zbg3")
    self.Panel_7 = self:GetWidgetByName("Panel_7")
    self.Panel_8 = self:GetWidgetByName("Panel_8")
    self.Panel_9 = self:GetWidgetByName("Panel_9")
    self.difen_ = self:GetWidgetByName("Text_69")
    self.difen_:enableOutline(cc.c4b(123,53,10,255), 2)

    self.difen_Num = self:GetWidgetByName("Text_70")
    self.difen_Num:enableOutline(cc.c4b(123,53,10,255), 2)

    self.beishu_ = self:GetWidgetByName("Text_71")
    self.beishu_:enableOutline(cc.c4b(123,53,10,255), 2)

    self.beishu_Num = self:GetWidgetByName("Text_72")
    self.beishu_Num:enableOutline(cc.c4b(123,53,10,255), 2)

    self.sprite_ = self:GetWidgetByName("Text_73")
    self.sprite_:enableOutline(cc.c4b(123,53,10,255), 2)

    self.sprite_Num = self:GetWidgetByName("Text_74")
    self.sprite_Num:enableOutline(cc.c4b(123,53,10,255), 2)

    self.boob_ = self:GetWidgetByName("Text_75")
    self.boob_:enableOutline(cc.c4b(123,53,10,255), 2)

    self.boob_Num = self:GetWidgetByName("Text_76")
    self.boob_Num:enableOutline(cc.c4b(123,53,10,255), 2)

    self.hjj = self:GetWidgetByName("Text_wz")
    self.hjj:enableOutline(cc.c4b(123,53,10,255), 2)

    self.hj_Num = self:GetWidgetByName("Text_wzs")
    self.hj_Num:enableOutline(cc.c4b(123,53,10,255), 2)
    
    self.rocket_Num = self:GetWidgetByName("Text_29")

    self.Text_83 = self:GetWidgetByName("Text_83")
    self.Text_way = self:GetWidgetByName("Text_84")
    self.Text_85 = self:GetWidgetByName("Text_85")
    self.playNum = self:GetWidgetByName("Text_86")
    self.Text_87 = self:GetWidgetByName("Text_87")
    self.time1 = self:GetWidgetByName("Text_88")
    self.time2 = self:GetWidgetByName("Text_89")

    self.Text_90 = self:GetWidgetByName("Text_90")
    self.roomNum = self:GetWidgetByName("Text_91")
    -- self.ld = self:GetWidgetByName("Image_19")
    -- self.ldNum = self:GetWidgetByName("Text_31")

    self.image_zbg1:setVisible(false) 
    self.Image_zbg2:setVisible(false) 
    self.Image_zbg3:setVisible(false)  
    self.Panel_7:setVisible(false)  
    self.Panel_8:setVisible(false)  
    self.Panel_9:setVisible(false) 
    self.difen_:setVisible(false)  

    self.difen_Num:setVisible(false)  
    self.beishu_:setVisible(false)
    self.beishu_Num:setVisible(false)  
    self.sprite_:setVisible(false) 
    self.sprite_Num:setVisible(false) 
    self.boob_:setVisible(false)   
    self.boob_Num:setVisible(false)   
    self.hjj:setVisible(false)
    self.hj_Num:setVisible(false)

    self.Text_83:setVisible(false)  
    self.Text_way:setVisible(false) 
    self.Text_85:setVisible(false)  
    self.playNum:setVisible(false) 
    self.Text_87:setVisible(false)  
    self.time1:setVisible(false)  
    self.time2:setVisible(false)  

    self.Text_90:setVisible(false) 
    self.roomNum:setVisible(false) 
    self.ld:setVisible(false)  
    self.ldNum:setVisible(false)  

    self.selfInfo = nil
    self.user1 = nil
    self.user2 = nil

    self.info = data.data
    self:initInfo()

    --服务费
    local fuwufei = self:GetWidgetByName("Text_fuwufei")
    --
    if laixiaddz.LocalPlayercfg.LaixiaSelfBuildTable ~= nil and laixiaddz.LocalPlayercfg.LaixiaSelfBuildTable > 0 or self.info.gametype == 4 then
        fuwufei:setVisible(false)
    else
        local l_RoomDataMgr =  laixiaddz.JsonTxtData:queryTable("room_list")
        local roomInfo = l_RoomDataMgr:query("roomid",tonumber(ui.CardTableDialog.mRoomID))
        fuwufei:setString("服务费:"..roomInfo["fuwufei"]) ---TODO 底分乘 一个倍数 modify by wangtianye
    end


    self.mInterfaceRes:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.3),
        cc.CallFunc:create(
            function()
                self:showAccountInfo()
                if self.isNeedShowLaidou~=nil then
                    self.itemData = laixiaddz.JsonTxtData:queryTable("items")
                    table.insert(self.mItemArray,self.isNeedShowLaidou.data)
                    local data = self.mItemArray[1]
                    local itemmsg = self.itemData:query("ItemID",data[1].ItemID)
                    if data[1].ItemCount > 0 then  --如果为空也显示
                        --紧急解决显示30000来豆的情况 找到问题在进行修改 TODO
                        if data[1].ItemCount >= 10000 then
                            self.ld:setVisible(true)
                            self.ldNum:setVisible(true)
                            local str = tonumber(data[1].ItemCount)/10000
                            self.ldNum:setString(str)
                        else
                            self.ld:setVisible(true)
                            self.ldNum:setVisible(true)
                            local str = tonumber(data[1].ItemCount)
                            self.ldNum:setString(str)
                        end
                    else
                        self.ld:setVisible(false)
                        self.ldNum:setVisible(false)
                    end
                    self.isNeedShowLaidou = nil
                end
            end),
        cc.DelayTime:create(0.2),
        cc.CallFunc:create(function()
            self:showBankruptcyBag()
        end)
    ))

end

function PokerAccountWindow:GetLaidou(msg)
    self.mItemArray = {}
    self.isNeedShowLaidou = msg
--    self.itemData = laixiaddz.JsonTxtData:queryTable("items")
--    table.insert(self.mItemArray,msg.data)
--    local data = self.mItemArray[1]
--    --local icon = self:GetWidgetByName("Gain_Circle_Icon"..str, cell)
--    local itemmsg = self.itemData:query("ItemID",data[1].ItemID);
--    --icon:loadTexture(itemmsg.ImagePath, 1) 
--   
--    --self:GetWidgetByName("Gain_Title"):setString(itemmsg.ItemName)
--    if data[1].ItemCount > 0 then  --如果为空也显示
--       -- self:GetWidgetByName("Text_31"):setString(tostring(data[1].ItemCount))
--        --self:GetWidgetByName("Text_31"):setVisible(true)
--        self.ld:setVisible(true)
--        self.ldNum:setVisible(true)
--        local str = tostring(data[1].ItemCount)
--        self.ldNum:setString(str)
--        
--        --self:GetWidgetByName("Image_18"):setVisible(true)
--        --self.ld：setVisible(false)
--    else
--        -- self:GetWidgetByName("Text_31"):setVisible(false)
--        -- self:GetWidgetByName("Image_18"):setVisible(false)
--        self.ld:setVisible(false)
--        self.ldNum:setVisible(false)
--        --self.ld:setVisible(true)
--    end
    --self:GetWidgetByName("Text_31", cell):setLocalZOrder(50)
end

--自建房 自动就那啥了。。
function PokerAccountWindow:onTick(dt)
    -- if ui.CardTableDialog.mRoomID  ~= 50  then
    --  --    self.mTime:setVisible(true)
    --     self.time = self.time - dt
    --     if self.time <= 0 then
    --        -- time = 0
    --        -- self.maxTime = self.maxTime - 1
    --        -- self.mTime:setString('('..self.maxTime..'s)')
    --        -- if self.maxTime == 0 then
    --        --    self:onTryAgain()
    --        --    self.mTime:setVisible(false)
    --        -- end
    --        laixiaddz.LocalPlayercfg.LaixiaisTrusteeship = false
    --         ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW)
    --     end
    --  end
end

--离开按钮
function PokerAccountWindow:goBackFun(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.LocalPlayercfg.LaixiaisTrusteeship = false
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        if laixiaddz.LocalPlayercfg.LaixiaSelfTotalInning ~= false then
            if laixiaddz.LocalPlayercfg.LaixiaSelfInning  == laixiaddz.LocalPlayercfg.LaixiaSelfTotalInning and laixiaddz.LocalPlayercfg.LaixiaSelfTotalInning >0 then
                self:onRoomClose()
                return
            end
        end
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_EXITROOM_LANDLORDTABLE_WINDOW)
    end
end


--破产礼包
function PokerAccountWindow:showBankruptcyBag()
    if laixiaddz.LocalPlayercfg.LaixiaBankruptItemID ~= nil then
        local userGolds = self.selfInfo.haveGold
        local callBack = function()
            local checkCoins = laixiaddz.JsonTxtData:queryTable("common"):query("key","limitMoney");
            if userGolds < checkCoins.Num then   --检测当前金是否低于阀值
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_RELIEF_WINDOW)
            end
        end
        -- giftMoney 破产礼包阈值
        local giftMoney = laixiaddz.JsonTxtData:queryTable("common"):query("key","giftMoney");
        if userGolds <= giftMoney.Num then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_BANKRUPTBAG_WINDOW,{OnCallFunc=callBack})    --请求破产礼包
        end
    end
end

--分享
function PokerAccountWindow:onShare(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(laixiaddz.soundcfg.BUTTON_SOUND.ui_button_open)

        local screenshotFileName = "screenShare.png"--string.format("wx-%s.png", os.date("%Y-%m-%d_%H:%M:%S", os.time()))
        if device.platform == "android" then
            local layerSize = self.mInterfaceRes:getContentSize()
            local screenshot = cc.RenderTexture:create(layerSize.width, layerSize.height)
            local scene = cc.Director:getInstance():getRunningScene()
            screenshot:begin()
            scene:visit()
            screenshot:endToLua()
            screenshot:saveToFile(screenshotFileName, cc.IMAGE_FORMAT_PNG, false)

            self.shareImgFilePath = cc.FileUtils:getInstance():getWritablePath() .. screenshotFileName
           
        else--苹果包
            --分享链接
            local winsize = cc.Director:getInstance():getWinSize()
            local fileName = cc.FileUtils:getInstance():getWritablePath() .. "/screenShare.png"
            cc.utils:captureScreen(function ( success,outputFile )
                  if success then
                    self.shareImgFilePath = cc.FileUtils:getInstance():getWritablePath() .. screenshotFileName
                  end
            end,fileName)
        end
        self.scheduleHandler = gt.scheduler:scheduleScriptFunc(handler(self, self.update), 0, false)
        
    end
end
function PokerAccountWindow:update()
    if self.shareImgFilePath and cc.FileUtils:getInstance():isFileExist(self.shareImgFilePath) then
        gt.scheduler:unscheduleScriptEntry(self.scheduleHandler)

        if gt.isIOSPlatform() then
            local luaoc = require("cocos.cocos2d.luaoc")
            local args = { imgFilePath = fileName }
            local state ,value = luaoc.callStaticMethod("WXinShareManager", "sendImageContent", args);
        elseif gt.isAndroidPlatform() then
            local luaj = require "cocos.cocos2d.luaj"
            local javaClassName = APP_ACTIVITY
            local javaMethodName = "shareImageToWX"
            local javaParams = {fileName}
            local javaMethodSig = "(Ljava/lang/String;)V"
            local state, value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            return value
        end
        self.shareImgFilePath = nil
    end
end

--显示账户信息
function PokerAccountWindow:showAccountInfo()
    local resultAnimation

    local index =0
    for i,v in ipairs(self.info.player ) do
        if self.info.player[i].changeGold==0 then
            index = index + 1
        end
    end
    if index == 3 then --三个人都是0
        resultAnimation = EffectAni:createAni(EffectDict._ID_DICT_TYPE_DESK_LIUJU)
    else

        if self.selfInfo.spriting ~= 0 then   --春天
             resultAnimation = EffectAni:createAni(EffectDict._ID_DICT_TYPE_RESULT_SPRING)
            local playerInfo =self.info.player
            for i,v in ipairs(playerInfo) do
                if i == 1 then
                    if playerInfo[i].changeGold>0 then
                        resultAnimation = EffectAni:createAni(EffectDict._ID_DICT_TYPE_RESULT_WIN)
                    else
                        resultAnimation = EffectAni:createAni(EffectDict._ID_DICT_TYPE_RESULT_LOST)
                    end
                    break
                end
            end

        elseif self.selfInfo.isWin ~= 1 then   --失败
            resultAnimation = EffectAni:createAni(EffectDict._ID_DICT_TYPE_RESULT_LOST)
        else  --获胜
            resultAnimation = EffectAni:createAni(EffectDict._ID_DICT_TYPE_RESULT_WIN)
            resultAnimation:setPosition(cc.p(640,450))
        end
    end

    resultAnimation:setPosition(cc.p(0,50-10))
    resultAnimation:addTo(self.mInterfaceRes,4)

    self:updateInfo()
end
--初始化信息
function PokerAccountWindow:initInfo()
    local playerInfo =self.info.player
    for i,v in ipairs(playerInfo) do
        if i == 1 then
            self.selfInfo =  playerInfo[i]
            self.selfInfo.spriting = self.info.spriting  --自己是否春天
        elseif i== 2 then
            if playerInfo[i].isLandlord == 1 then
                self.user1 = playerInfo[i]
            else
                self.user2 = playerInfo[i]
            end
        elseif i==3 then
            if self.user2 == nil then
                self.user2 = playerInfo[i]
            else
                self.user1 = playerInfo[i]
            end
        end
    end
end

--更新
function PokerAccountWindow:updateInfo()
    local playerInfo =self.info.player
    self.tryAaginW:setVisible(true)
    --self.quit:setVisible(true)

    for i=1,3 do
        ---if i == 1  then
            if ui.CardTableDialog.mRoomID == 50  then -- 自建桌
                self.quit:setVisible(false)
                self.tryAaginW:setVisible(true)
                self.tryAaginW:setPosition(cc.p(640,113))
                local image_PokerResult = self:GetWidgetByName("Panel_" .. i+6)
                image_PokerResult:setVisible(true)
                --local image_PokerResult =  self:GetWidgetByName("Image_PokerResult_PlayerBG0"..i)
                self:OnRefreshHeadIconFunction(self:GetWidgetByName("Image_head",image_PokerResult),playerInfo[i].PID,playerInfo[i].Icon)
                self:GetWidgetByName("Label_Player_Name",image_PokerResult):setString(laixiaddz.helper.StringRules_6(playerInfo[i].Nickname))

                self.image_zbg1:setVisible(true) 
                self.Image_zbg2:setVisible(true) 
                self.Image_zbg3:setVisible(true)  
                -- self.Panel_7:setVisible(true)  
                -- self.Panel_8:setVisible(true)  
                -- self.Panel_9:setVisible(true) 
                self.difen_:setVisible(true)     

                self.difen_Num:setVisible(true)  
                self.beishu_:setVisible(true)
                self.beishu_Num:setVisible(true)  
                self.sprite_:setVisible(true) 
                self.sprite_Num:setVisible(true) 
                self.boob_:setVisible(true)   
                self.boob_Num:setVisible(true)  
                self.hjj:setVisible(true)
                self.hj_Num:setVisible(true) 

                ---- 如果是自建房的最后一局 那么显示设置副数和时间!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- self.Text_83:setVisible(false)  
                -- self.Text_way:setVisible(false) 
                -- self.Text_85:setVisible(false)  
                -- self.playNum:setVisible(false) 
                -- self.playNum:setString("")
                -- self.Text_87:setVisible(false)  
                -- self.time1:setVisible(false)  
                -- self.time1:setString("")
                -- self.time2:setVisible(false)  
                -- self.time2:setString("")

                --设置自建房的房间号!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- self.Text_90:setVisible(true) 
                -- self.roomNum:setVisible(true) 
                -- self.roomNum:setString("")
               
                self.golda = self:GetWidgetByName("gold_add",image_PokerResult)  
                self.golda:enableOutline(cc.c4b(123,53,10,255), 2)

                self.goldr = self:GetWidgetByName("gold_reduce",image_PokerResult)           
                self.goldr:enableOutline(cc.c4b(123,53,10,255), 2)
               

                --分数
                if playerInfo[i].changeGold>0 then
                    self.golda:setVisible(true)
                    self.golda:setString("+" .. playerInfo[i].changeGold)
                    self.goldr:setVisible(false)
                else
                    self.goldr:setVisible(true)
                    self.goldr:setString(playerInfo[i].changeGold)
                    self.golda:setVisible(false)
                end

                --倍数。。。
                --print("NNNNNNNNNNNNNNNNNNNNNNNNNNN" .. self.info.boomTimes)
                self.difen_Num:setString("x" .. self.info.BaseValue)
                self.beishu_Num:setString("x" .. self.info.times) 
                self.sprite_Num:setString("x" .. self.info.spriting)
                self.boob_Num:setString("x" .. self.info.boomTimes)
                self.hj_Num:setString("x"..self.info.RooketTimes)

                --self:GetWidgetByName("Label_Player_Times",image_PokerResult):setString("x"..self.info.times)
                --if ui.CardTableDialog.mRoomID == 50  then -- 自建桌
                --self:GetWidgetByName("Image_Player_Icon",image_PokerResult):loadTexture("table_bisai_jifen.png", 1)
                -- self:GetWidgetByName("Image_Jifen"):setVisible(true)  --
                -- self:GetWidgetByName("Image_Gold"):setVisible(false)
                --else
                --self:GetWidgetByName("Image_Player_Icon",image_PokerResult):loadTexture("gold_icon.png", 1)
                -- self:GetWidgetByName("Image_Jifen"):setVisible(false)  --
                -- self:GetWidgetByName("Image_Gold"):setVisible(true)
                --end
                -- if playerInfo[i].isLandlord == 1 then
                --     self:GetWidgetByName("Image_Player_Landlord",image_PokerResult):setVisible(true)
                -- else
                --     self:GetWidgetByName("Image_Player_Landlord",image_PokerResult):setVisible(false)
                -- end
            elseif i == 1 then --游戏场
                self.quit:setVisible(true)
                self.beijing:setVisible(true)
                self.Boob:setVisible(true)
                self.BoobNum:setVisible(true)
                self.huojian:setVisible(true)
                self.huojianNum:setVisible(true)
                self.spring:setVisible(true)
                self.springNum:setVisible(true)
                self.Text_difen:setVisible(true)
                self.difenNum:setVisible(true) 
                self.beishu:setVisible(true)
                self.beishuNum:setVisible(true) 
                self.Label_Player_Gold:setVisible(true) 
                self.Label_Player_Gold_reduce:setVisible(true) 
                self.goldSign:setVisible(true) 
                -- self.ld:setVisible(true) 
                -- self.ldNum:setVisible(true) 
                --来斗 (到六局设置来斗奖励)!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- if  then
                --     self:GetWidgetByName("Text_31"):setVisible(true)
                --     self:GetWidgetByName("Image_19"):setVisible(true)
                --     self:GetWidgetByName("Text_31"):setString()
                -- else
                    -- self:GetWidgetByName("Text_31"):setVisible(false)
                    -- self:GetWidgetByName("Image_19"):setVisible(false)
                -- end
                
                if playerInfo[i].changeGold>0 then
                    self:GetWidgetByName("Label_Player_Gold"):setVisible(true)
                    self:GetWidgetByName("Label_Player_Gold"):setString("+" .. playerInfo[i].changeGold)
                    self:GetWidgetByName("Label_Player_Gold_reduce"):setVisible(false)
                else
                    self:GetWidgetByName("Label_Player_Gold_reduce"):setVisible(true)
                    self:GetWidgetByName("Label_Player_Gold_reduce"):setString(playerInfo[i].changeGold)
                    self:GetWidgetByName("Label_Player_Gold"):setVisible(false)
                end
                self:GetWidgetByName("Label_Player_Difen"):setString("x" .. self.info.BaseValue)
                self:GetWidgetByName("Label_Player_Times"):setString("x" .. self.info.times) --总倍数
                self:GetWidgetByName("Label_Player_Spring"):setString("x" .. self.info.spriting)
                self:GetWidgetByName("Label_Player_Boob"):setString("x" .. self.info.boomTimes)
                --火箭!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                self:GetWidgetByName("Text_29"):setString("x"..self.info.RooketTimes)
            end
        --end
    end  
end

function PokerAccountWindow:tryAgain(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.LocalPlayercfg.LaixiaisTrusteeship = false
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:onTryAgain()
    end
end


--房间关闭提示显示
function PokerAccountWindow:onRoomClose()
    local obj       = {};
    obj.rightCall   = function ( ... )
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_EXITROOM_LANDLORDTABLE_WINDOW)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_PACKET_CREATESELFBUILF)
    end
    obj.rightBtnText= "创  建";
    obj.leftCall    = function ( ... )
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_EXITROOM_LANDLORDTABLE_WINDOW)
    end
    obj.leftBtnText = "离  开";
    obj.mainText    = "房间已关闭，是否需要开新房间。";
    obj.time = 10
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_TISHIYUOTHER_WINDOW,obj)
end

--是否删除由牌桌逻辑判断
function PokerAccountWindow:onTryAgain()
    if laixiaddz.LocalPlayercfg.LaixiaSelfTotalInning ~= false then
        if laixiaddz.LocalPlayercfg.LaixiaSelfInning  == laixiaddz.LocalPlayercfg.LaixiaSelfTotalInning and laixiaddz.LocalPlayercfg.LaixiaSelfTotalInning >0 then
            self:onRoomClose()
            return
        end
    end

    if laixiaddz.LocalPlayercfg.LaixiaSelfBuildTable ~= nil and laixiaddz.LocalPlayercfg.LaixiaSelfBuildTable > 0 then
        local CreateGoon = Packet.new("CSCreateGoon", _LAIXIA_PACKET_CS_CreateGoonID)
        CreateGoon:setValue("TableID",laixiaddz.LocalPlayercfg.LaixiaSelfBuildTable)
        laixia.net.sendPacket(CreateGoon)
    else
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_BEGIN_LANDLORDTABLE_WINDOW)
    end

end


function PokerAccountWindow:onCallBackFunction()
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_EXITROOM_LANDLORDTABLE_WINDOW)
end

function PokerAccountWindow:onDestroy()
    self.mIsShow = false
end

function PokerAccountWindow:headDownloadSuccess(msg)
    local data = msg.data    
    local mHeadInUse = data.savePath
    local localIconPath = cc.FileUtils:getInstance():getWritablePath() .. mHeadInUse
    local fileExist = cc.FileUtils:getInstance():isFileExist(mHeadInUse)
    print(data.playerID)
    local image_rank_di = self.rankIcon[tostring(data.playerID)]
    if(fileExist) and image_rank_di~=nil then
        --image_rank_di:loadTexture(localIconPath)
        local sprite = display.newSprite(mHeadInUse)
        sprite:setScaleX(head_btn:getContentSize().width/sprite:getContentSize().width)
        sprite:setScaleY(head_btn:getContentSize().height/sprite:getContentSize().height)
        sprite:setPosition(head_btn:getContentSize().width/2,head_btn:getContentSize().height/2)
        image_rank_di:addChild(sprite)
    end       
end
----------------------
function PokerAccountWindow:OnRefreshHeadIconFunction(head,id,icon)
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
            l_OPHIDObject:pushTask(id, netIconUrl,7)
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

function PokerAccountWindow:addHeadIcon(head_btn,path)
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


-- function PokerAccountWindow:OnRefreshHeadIconFunction(head,id,icon)
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
--                     testPath = cc.FileUtils:getInstance():getWritablePath() .. laixiaddz.LocalPlayercfg.LaixiaPlayerID
--                 else
--                     testPath = cc.FileUtils:getInstance():getWritablePath() .. laixiaddz.LocalPlayercfg.LaixiaPlayerID..".png" 
--                 end
--                 print(testPath)

--                 local fileExist = cc.FileUtils:getInstance():isFileExist(testPath)

--                 print(fileExist)
--                 if (fileExist) then
--                     path = testPath
--                 else
--                 --下载图片
--                     local headIconUrl = laixia.config.HEAD_URL 
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
--         --laixia.UItools.addHead(head, path, templet)
--          head:setScale(96/106)
--         local sprite = display.newSprite(path) 
--         sprite:setScaleX(head:getContentSize().width/sprite:getContentSize().width)
--         sprite:setScaleY(head:getContentSize().height/sprite:getContentSize().height)
--         sprite:setPosition(head:getContentSize().width/2,head:getContentSize().height/2)
--         head:addChild(sprite)
-- end
return PokerAccountWindow.new()


