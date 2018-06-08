

local PersonalCenterWindow = class("PersonalCenterWindow", import("...CBaseDialog"):new())-- 
local soundConfig = laixiaddz.soundcfg;   
local Packet = import("....net.Packet")
local laixiaUITools = import("....tools.UITools")
local DownloaderHead = import("..DownloaderHead")

function PersonalCenterWindow:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
    self.mIsShow = false
end

function PersonalCenterWindow:getName()
    return "PersonalCenterWindow"
end
function PersonalCenterWindow:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_LOBBYDETAILS_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SUCCESS_REVISESEXNICK_WINDOW, handler(self, self.ChangeNameSuccess))

end


--发送绑定推广消息
function PersonalCenterWindow:onShowExtension(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local CSExtensionRule = Packet.new("CSExtensionRule", _LAIXIA_PACKET_CS_ExtensionRuleID)
        CSExtensionRule:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
        laixia.net.sendHttpPacket(CSExtensionRule)
    end
end

function PersonalCenterWindow:onShowChangeUI()
    self.labelNewName:setVisible( not self.labelNewName:isVisible())
    self.PlayerName :setVisible(not self.PlayerName:isVisible())
    self.NewSignature :setVisible(not self.NewSignature:isVisible())
    self.LabelSignature:setVisible(not self.LabelSignature:isVisible())
    -- self.Gender:setVisible(not self.Gender:isVisible())

    for i,v in ipairs(self.mBor_Girl) do
        v:setVisible(not v:isVisible());
    end
end

function PersonalCenterWindow:onCancelNickName()

    self.PlayerName:setVisible(true)
    self.labelNewName:setVisible(false)
    self.labelNewName:setText(self.PlayerName:getString())
    self.Button_ModifyNickName:setVisible(false)
    self.Button_CancelNickName:setVisible(false)
    self.Button_Xiugainicheng:setVisible(true)
    self.IsXiuGaiNiChengBtn = false
end
function PersonalCenterWindow:onCancelSignName()
    self.LabelSignature:setVisible(true)
    self.NewSignature:setVisible(false)
    self.NewSignature:setText(self.LabelSignature:getString())
    self.Button_ModifySignName:setVisible(false)
    self.Button_CancelSignName:setVisible(false)
    self.Button_Xiugaiqianming:setVisible(true)
    self.IsXiuGaiSignBtn = false
end
function PersonalCenterWindow:onShow()
    self.Button_PersonalCenter_Bdsj = self:GetWidgetByName("Button_PersonalCenter_Bdsj")
    if self.mIsShow == false then

        -- 审核
        if laixia.config.isAudit then
            self:GetWidgetByName("Button_goPerson"):setVisible(true)
            self:GetWidgetByName("Button_PersonalCenter_Bdsj"):setPositionX(self.Button_PersonalCenter_Bdsj:getPositionX()-30)
            self:AddWidgetEventListenerFunction("Button_goPerson", handler(self, self.goPerson)) 
        else
            self:GetWidgetByName("Button_goPerson"):setVisible(false)
        end
        

        local GamePlatformID = cc.UserDefault:getInstance():getIntegerForKey("GamePlatformID")
        -- if GamePlatformID ~= 5 then
        --     self:AddWidgetEventListenerFunction("Button_PersonalCenter_Qhzh", handler(self, self.switchAccount)) --切换账号
        -- else
        --     self:GetWidgetByName("Button_PersonalCenter_Qhzh"):setVisible(false) 
        -- end
        self.BG = self:GetWidgetByName("Image_1")
        self.BG:setTouchEnabled(true)
        self.BG:setTouchSwallowEnabled(true)
        self.Image_HeadBg = self:GetWidgetByName("Image_PersonalCenter_Photo")
        self:AddWidgetEventListenerFunction("Button_PersonalCenter_Bdsj", handler(self, self.baindingPhone)) --绑定手机
        self:AddWidgetEventListenerFunction("Button_PersonalCenter_Close", handler(self, self.onShutDown))
        -- self:AddWidgetEventListenerFunction("Button_MoneyBtn", handler(self, self.goShop))
        -- self:AddWidgetEventListenerFunction("Image_MoneyIcon",handler(self,self.goShop));
        self:GetWidgetByName("Button_shiming"):setVisible(false)
        self.Button_Xiugaiqianming = self:GetWidgetByName("Button_Xiugaiqianming")
        self:AddWidgetEventListenerFunction("Button_Xiugaiqianming", handler(self, self.onXiugaiqianming));  
        -- self.mButtonBaoCun = self:GetWidgetByName("Button_PersonalCenter_BaoCun")                --保存
        -- self.mButtonBaoCun :setVisible(false)
        -- self.mButtonBaoCun :addTouchEventListener(handler(self,self.onSendToSever))
        self.Button_Xiugainicheng = self:GetWidgetByName("Button_Xiugainicheng")
        self:AddWidgetEventListenerFunction("Button_Xiugainicheng",handler(self,self.onXiugainicheng))

        self.Button_ModifyNickName = self:GetWidgetByName("Button_ModifyNickName")
        self.Button_ModifyNickName.ModifyType = 1
        self.Button_ModifyNickName:addTouchEventListener(handler(self,self.onSendToSever))
        self.Button_CancelNickName = self:GetWidgetByName("Button_CancelNickName")
        self.Button_CancelNickName:addTouchEventListener(handler(self,self.onCancelNickName))

        self.Button_ModifySignName = self:GetWidgetByName("Button_ModifySignName")
        self.Button_ModifySignName.ModifyType = 2
        self.Button_ModifySignName:addTouchEventListener(handler(self,self.onSendToSever))
        self.Button_CancelSignName = self:GetWidgetByName("Button_CancelSignName")
        self.Button_CancelSignName:addTouchEventListener(handler(self,self.onCancelSignName))
        
        self.Button_ModifySignName:setVisible(false)
        self.Button_CancelSignName:setVisible(false)
        
        self.Button_ModifyNickName:setVisible(false)
        self.Button_CancelNickName:setVisible(false)

        self.IsXiuGaiNiChengBtn = false
        self.IsXiuGaiSignBtn = false
        self.LabelSignature = self:GetWidgetByName("Label_PersonalCenter_Signature")
        self.mBor_Girl = {}
--        self:AddWidgetEventListenerFunction("CheckBox_PersonalCenter_Sex1", handler(self,self.isMan))
        self:AddWidgetEventListenerFunction("CheckBox_PersonalCenter_Sex1_1", handler(self,self.isMan))
        local center_sex1 =self:GetWidgetByName("CheckBox_PersonalCenter_Sex1")
        local center_sex1_1 =self:GetWidgetByName("CheckBox_PersonalCenter_Sex1_1")
        center_sex1.ModifyType = 3
        center_sex1:setVisible(false)
        center_sex1_1:setVisible(false)
        table.insert(self.mBor_Girl,center_sex1)
        table.insert(self.mBor_Girl,center_sex1_1)

--        self:AddWidgetEventListenerFunction("CheckBox_PersonalCenter_Sex2", handler(self,self.isWoman))
        self:AddWidgetEventListenerFunction("CheckBox_PersonalCenter_Sex2_1", handler(self,self.isWoman))
        local center_sex2 =self:GetWidgetByName("CheckBox_PersonalCenter_Sex2")
        local center_sex2_1 =self:GetWidgetByName("CheckBox_PersonalCenter_Sex2_1")
        center_sex2.ModifyType = 3
        center_sex2 :setVisible(false)
        center_sex2_1:setVisible(false)
        table.insert(self.mBor_Girl,center_sex2)
        table.insert(self.mBor_Girl,center_sex2_1)
   
        --胜率
        -- self.labelShenglv = self:GetWidgetByName("Label_PersonalCenter_SlV")
 
        self.Label_PersonalCenter_BingPhone = self:GetWidgetByName("Label_PersonalCenter_BingPhone")
        if laixiaddz.LocalPlayercfg.LaixiaPhoneNum == "" then
            self.Label_PersonalCenter_BingPhone:setString("手机绑定:未绑定")
            self:AddWidgetEventListenerFunction("Button_Extension", handler(self, self.onShowExtension)) --绑定手机
            self:GetWidgetByName("Button_PersonalCenter_Bdsj"):setVisible(true)
            self:GetWidgetByName("Text_11"):setVisible(true)
        else
            self.Label_PersonalCenter_BingPhone:setString("已绑定手机号"..laixiaddz.LocalPlayercfg.LaixiaPhoneNum)
            self:GetWidgetByName("Button_PersonalCenter_Bdsj"):setVisible(false)
            self:GetWidgetByName("Text_11"):setVisible(false)
        end
        
        self.sex = 0
        self.mTempName="" 
        self:AddWidgetEventListenerFunction("Image_PersonalCenter_PhotoBG", handler(self, self.onHead))
        -- self:AddWidgetEventListenerFunction("Button_PersonalCenter_ChangePhoto", handler(self, self.onHead))

--         self.progressbar_level = self:GetWidgetByName("ProgressBar_EXPBar")

--         local levelData =  laixiaddz.JsonTxtData:queryTable("gradeArray").buf;
--         local mNextExp
--         local mNowExp
--         if laixiaddz.LocalPlayercfg.LaixiaPlayerLevel+1>#levelData then
--             mNextExp = tonumber(levelData[laixiaddz.LocalPlayercfg.LaixiaPlayerLevel].GradeExperience)
--         else
--             mNextExp = tonumber(levelData[laixiaddz.LocalPlayercfg.LaixiaPlayerLevel+1].GradeExperience)
--         end
--         if laixiaddz.LocalPlayercfg.LaixiaPlayerLevel == 1 then
--             mNowExp = 0
--         else
--             mNowExp = tonumber(levelData[laixiaddz.LocalPlayercfg.LaixiaPlayerLevel].GradeExperience)
--         end

--         self.label_level_detail = self:GetWidgetByName("Label_EXPNum");
--         if mNowExp==mNextExp then --等级到头的处理方法
--             self.progressbar_level:setPercent(100)
--             self.label_level_detail:setVisible(false)
--         else
--             local per =(laixiaddz.LocalPlayercfg.LaixiaExperience - mNowExp) /(mNextExp - mNowExp)
--             self.progressbar_level:setPercent(per * 100)
--             self.label_level_detail:setString((laixiaddz.LocalPlayercfg.LaixiaExperience - mNowExp).."/"..(mNextExp - mNowExp));
--         end
-- -------------------------------------------------------------------------------
        --玩家ID
        self.PlayerID = self:GetWidgetByName("Label_PersonalCenter_YhidV")
        if laixia.config.isAudit then
            self.PlayerID:setString("用户编号:"..laixiaddz.LocalPlayercfg.LaixiaPlayerID)
        else
            self.PlayerID:setString("用户ID:"..laixiaddz.LocalPlayercfg.LaixiaPlayerID)
        end
        -- --玩家称号
        -- self.PlayerTitle = self:GetWidgetByName("Label_PersonalCenter_ChV")
        -- self.PlayerTitle:setString(levelData[laixiaddz.LocalPlayercfg.LaixiaPlayerLevel].GradeTitle)

        -- --游戏局数
        -- self.labelJuShu = self:GetWidgetByName("Label_PersonalCenter_JsV")
        -- --最大赢取倍数
        -- self.labelBeiShu = self:GetWidgetByName("Label_PersonalCenter_ZdbsV")
        -- self.labelBeiShu:setString(laixiaddz.LocalPlayercfg.LaixiaPlayerMaxWintimes)
        --  --等级
        -- self.Level = self:GetWidgetByName("Label_PersonalCenter_DjV")
        -- local userLevel = laixiaddz.LocalPlayercfg.LaixiaPlayerLevel
        -- self.Level:setString("Lv." .. userLevel)

        self.labelNewName1 = self:GetWidgetByName("TextField_PersonalCenter_Nickname") 
        self.labelNewName1:setVisible(false)
        
        self.labelNewName = ccui.EditBox:create(cc.size(266,46),"new_ui/PersonalCenterWindow/tiao1.png")
        self.labelNewName:setPosition(self.labelNewName1:getContentSize().width/2+10,self.labelNewName1:getContentSize().height/2+5)
        self.labelNewName:setFontSize(24)
        self.labelNewName:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND ) 
        local function editboxHandle( strEventName,sender ) 
          if strEventName == "began" then
          elseif strEventName == "ended" then
                local test = 1 
          elseif strEventName == "return" then
                local test = 1
          elseif strEventName == "changed" then
                local test = 1
          end
        end
        self.labelNewName:registerScriptEditBoxHandler(function(eventname,sender) editboxHandle(eventname,sender) end) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
        self:GetWidgetByName("Image_4"):addChild(self.labelNewName)
        self.labelNewName:setVisible(false)


        -- self.labelNewName:enableOutline(cc.c4b(131,82,5,255),2)
        --玩家金币
        self.PlayerGold = self:GetWidgetByName("BitmapLabel_MoneyNum")
        --玩家奖券
        self.PlayerJiangQuan = self:GetWidgetByName("BitmapLabel_JqNum")
        --玩家昵称
        self.PlayerName = self:GetWidgetByName("Label_PersonalCenter_Nickname")
--        self.PlayerName:enableOutline(cc.c4b(131,82,5,255),2)
        --个性签名
        --修改信息
        self.Button_ChangeMsg=self:GetWidgetByName("Button_PersonalCenter_Xgxx")
        --新的个性签名
        self.NewSignature1 = self:GetWidgetByName("TextField_PersonalCenter_Signature")
        self.NewSignature1:setVisible(false)
        self.NewSignature = ccui.EditBox:create(cc.size(494,46),"new_ui/PersonalCenterWindow/tiao2.png")
        self.NewSignature:setPosition(self.NewSignature1:getContentSize().width/2+30,self.NewSignature1:getContentSize().height/2+6)
        self.NewSignature:setFontSize(24)
        self.NewSignature:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND) 
        local function editboxHandle( strEventName,sender ) 
            if strEventName == "began" then
            elseif strEventName == "ended" then
                local test = 1 
            elseif strEventName == "return" then
                local test = 1
            elseif strEventName == "changed" then
                local test = 1
            end
        end
        self.NewSignature:registerScriptEditBoxHandler(function(eventname,sender) editboxHandle(eventname,sender) end) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
        self:GetWidgetByName("Image_4_Copy_Copy"):addChild(self.NewSignature)
        self.NewSignature:setVisible(false)
        --性别
        -- self.Gender  = self:GetWidgetByName("Label_PersonalCenter_Gender")

        self.LoginType = self:GetWidgetByName("Label_PersonalCenter_LoginType")
-----------------------------------------------------------------------------------------------      

        
        if type(laixiaddz.LocalPlayercfg.LaixiaPlayerVictoryTimes) ~= "number" then
            laixiaddz.LocalPlayercfg.LaixiaPlayerVictoryTimes = 0 
        end

        if type(laixiaddz.LocalPlayercfg.LaixiaPlayerFailureTimes)~= "number" then
            laixiaddz.LocalPlayercfg.LaixiaPlayerFailureTimes = 0 
        end
        local totalJuShu = laixiaddz.LocalPlayercfg.LaixiaPlayerVictoryTimes + laixiaddz.LocalPlayercfg.LaixiaPlayerFailureTimes 

---add by wangtianye
        self.Text_zongfushu = self:GetWidgetByName("Text_zongfushu")
        self.Text_zongfushu:setString(totalJuShu)
        self.Text_zongfushu:enableOutline(cc.c4b(107,62,27,255),2)
        self.Text_shenglifushu = self:GetWidgetByName("Text_shenglifushu")
        self.Text_shenglifushu:setString(laixiaddz.LocalPlayercfg.LaixiaPlayerVictoryTimes )
        self.Text_shenglifushu:enableOutline(cc.c4b(107,62,27,255),2)
        self.Text_youxichangshenglv = self:GetWidgetByName("Text_youxichangshenglv")
        if totalJuShu == 0 or totalJuShu==nil then
            self.Text_youxichangshenglv:setString("0")
        else
            self.Text_youxichangshenglv:setString(string.format("%d",laixiaddz.LocalPlayercfg.LaixiaPlayerVictoryTimes/totalJuShu*100).."%" )
        end
        self.Text_youxichangshenglv:enableOutline(cc.c4b(107,62,27,255),2)
        self.Text_zongcansaicishu = self:GetWidgetByName("Text_zongcansaicishu")
        self.Text_zongcansaicishu:setString(laixiaddz.LocalPlayercfg.LaixiaBisaiNum)
        self.Text_zongcansaicishu:enableOutline(cc.c4b(107,62,27,255),2)
        self.Text_guanjuncishu = self:GetWidgetByName("Text_guanjuncishu")
        self.Text_guanjuncishu:setString(laixiaddz.LocalPlayercfg.LaixiaBisaiWin)
        self.Text_guanjuncishu:enableOutline(cc.c4b(107,62,27,255),2)
        self.Text_yajuncishu = self:GetWidgetByName("Text_yajuncishu")
        self.Text_yajuncishu:setString(laixiaddz.LocalPlayercfg.LaixiaBisaiSecond)
        self.Text_yajuncishu:enableOutline(cc.c4b(107,62,27,255),2)

        self.Text_before_zongfushu = self:GetWidgetByName("Text_ZONGFUSHU")
        self.Text_before_zongfushu:enableOutline(cc.c4b(107,62,27,255),2)
        self.Text_before_shenglifushu = self:GetWidgetByName("Text_SHENGLIFUSHU")
        self.Text_before_shenglifushu:enableOutline(cc.c4b(107,62,27,255),2)
        self.Text_before_youxichangshenglv = self:GetWidgetByName("Text_YOUXICHANGSHENGLV")
        self.Text_before_youxichangshenglv:enableOutline(cc.c4b(107,62,27,255),2)
        self.Text_before_zongcaisaicishu = self:GetWidgetByName("Text_ZONGCANSAICISHU")
        self.Text_before_zongcaisaicishu:enableOutline(cc.c4b(107,62,27,255),2)
        self.Text_before_guanjuncishu = self:GetWidgetByName("Text_GUANJUNCISHU")
        self.Text_before_guanjuncishu:enableOutline(cc.c4b(107,62,27,255),2)
        self.Text_before_yajuncishu = self:GetWidgetByName("Text_YAJUNCISHU")
        self.Text_before_yajuncishu:enableOutline(cc.c4b(107,62,27,255),2)


        -- Text_name_new 姓名  Button_107  手机绑定的按钮   绑定过了就显示手机号码   Text_126 -- 指示金币   Text_125 金币  Text_124  来都
        -- Text_133 游戏场总副数  Text_133_Copy_1 参赛总场次：  Text_133_Copy  游戏胜利副数： Text_133_Copy_2 冠军总次数：   Text_133_Copy_0 游戏场胜率：   
        -- 亚军总次数： Text_133_Copy_3 
        if laixia.kconfig.isYingKe == true then
            self.PlayerID:setFontSize(20)
            self:GetWidgetByName("Panel_1"):setVisible(false)
            self:GetWidgetByName("Panel_2"):setVisible(true)
            self:GetWidgetByName("Text_name_new"):setString(laixiaddz.LocalPlayercfg.LaixiaPlayerNickname)

            self:GetWidgetByName("Text_126"):setString(laixiaddz.LocalPlayercfg.ZhiShiBiNum)
            self:GetWidgetByName("Text_125"):setString(laixiaddz.LocalPlayercfg.LaixiaPlayerGold)
            self:GetWidgetByName("Text_124"):setString(laixiaddz.LocalPlayercfg.LaixiaPlayerGiftCoupon)

            self:GetWidgetByName("Text_133"):setString(totalJuShu)
            self:GetWidgetByName("Text_133_Copy_1"):setString(laixiaddz.LocalPlayercfg.LaixiaBisaiNum)
            self:GetWidgetByName("Text_133_Copy"):setString(laixiaddz.LocalPlayercfg.LaixiaPlayerVictoryTimes)
            self:GetWidgetByName("Text_133_Copy_2"):setString(laixiaddz.LocalPlayercfg.LaixiaBisaiWin)
            self:GetWidgetByName("Button_shiming_zhishi"):setVisible(false)
            if totalJuShu == 0 or totalJuShu == nil then
                self:GetWidgetByName("Text_133_Copy_0"):setString("0")
            else
                self:GetWidgetByName("Text_133_Copy_0"):setString(string.format("%d",laixiaddz.LocalPlayercfg.LaixiaPlayerVictoryTimes/totalJuShu*100).."%" )
            end
            self:GetWidgetByName("Text_133_Copy_3"):setString(laixiaddz.LocalPlayercfg.LaixiaBisaiSecond)

            ---这里先读id
            self:GetWidgetByName("Label_PersonalCenter_YhidV"):setString("芝士号:"..laixiaddz.LocalPlayercfg.LaixiaUserID)
            -- self.PlayerID:setString("芝士号：123456")
            self:AddWidgetEventListenerFunction("Button_107", handler(self, self.baindingPhone)) --绑定手机
        end


--end by wangtianye 

--        self.labelJuShu:setString(totalJuShu)
    
--        if totalJuShu == 0 then
--            self.labelShenglv:setString("0%")
--        else 
--            local shenglv = math.floor(laixiaddz.LocalPlayercfg.LaixiaPlayerVictoryTimes * 100 / totalJuShu)
--            self.labelShenglv:setString(shenglv .. "%")
--        end
        
        if laixiaddz.LocalPlayercfg.LaixiaLastLoginPlatform == 1 then
            self.LoginType:setString("账号登陆:游客登陆")
            self.Label_PersonalCenter_BingPhone:setVisible(false)
            self:GetWidgetByName("Text_11"):setVisible(false)
            self:GetWidgetByName("Text_123"):setVisible(false)
            self:GetWidgetByName("Button_PersonalCenter_Bdsj"):setVisible(false)
            self:GetWidgetByName("Button_107"):setVisible(false)
        elseif laixiaddz.LocalPlayercfg.LaixiaLastLoginPlatform == 2 then
            self.LoginType:setString("账号登陆:手机登陆")
        elseif laixiaddz.LocalPlayercfg.LaixiaLastLoginPlatform == 5 then
            self.LoginType:setString("账号登陆:微信登陆")
        end


        -- if  laixiaddz.LocalPlayercfg.LaixiaLastLoginPlatform == 1   then
        --     self:GetWidgetByName("Button_PersonalCenter_Xgmm"):hide()
        -- elseif 2 == laixiaddz.LocalPlayercfg.LaixiaLastLoginPlatform  then  --如果手机登录
        --     self:GetWidgetByName("Button_PersonalCenter_Xgmm"):show()
        --     self:AddWidgetEventListenerFunction("Button_PersonalCenter_Xgmm", handler(self, self.Button_PersonalCenter_Xgmm))
        --     self:GetWidgetByName("Button_PersonalCenter_Bdsj"):setVisible(false)
        -- end
        self:ShowNameAndSex()
        self.mIsShow = true
        self:updateHead()
    end
end

-- 审核包个人账单
function PersonalCenterWindow:goPerson(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local PersonBill = Packet.new("CSPersonBill", _LAIXIA_PACKET_CS_PERSONBILL)
        PersonBill:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
        laixia.net.sendHttpPacket(PersonBill)
    end
end 

--修改签名
function PersonalCenterWindow:onXiugaiqianming(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.IsXiuGaiNiChengBtn == false then
            -- self:onShowChangeUI()
            -- self.mButtonBaoCun :setVisible(true)
            -- self.Button_ChangeMsg :setVisible(false)
            self.LabelSignature:setVisible(false)
            self.NewSignature:setVisible(true)
            self.Button_Xiugaiqianming:setVisible(false)
            self.Button_ModifySignName:setVisible(true)
            self.Button_CancelSignName:setVisible(true)
            self.IsXiuGaiSignBtn = true 
        elseif self.IsXiuGaiNiChengBtn == true then
            self:onCancelNickName()
            self.LabelSignature:setVisible(false)
            self.NewSignature:setVisible(true)
            self.Button_Xiugaiqianming:setVisible(false)
            self.Button_ModifySignName:setVisible(true)
            self.Button_CancelSignName:setVisible(true)
            self.IsXiuGaiSignBtn = true 
        end
    end
end
--修改昵称
function PersonalCenterWindow:onXiugainicheng(sender,eventType)
    -- self:onShowChangeUI()
    if self.IsXiuGaiSignBtn == false then
        self.PlayerName:setVisible(false)
        self.labelNewName:setVisible(true)
        self.Button_Xiugainicheng:setVisible(false)
        self.Button_ModifyNickName:setVisible(true)
        self.Button_CancelNickName:setVisible(true)
        self.IsXiuGaiNiChengBtn = true 
    elseif self.IsXiuGaiSignBtn == true then
        self:onCancelSignName()
        self.PlayerName:setVisible(false)
        self.labelNewName:setVisible(true)
        self.Button_Xiugainicheng:setVisible(false)
        self.Button_ModifyNickName:setVisible(true)
        self.Button_CancelNickName:setVisible(true)
        self.IsXiuGaiNiChengBtn = true 
    end
end

--保存消息
function PersonalCenterWindow:onSendToSever(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if sender.ModifyType ~=nil then
            self:sendChangeMsgPacket(sender.ModifyType)
        else
            self:sendChangeMsgPacket(1)
        end
        -- self:onShowChangeUI()
--        self.mButtonBaoCun :setVisible(false)
--        self.Button_ChangeMsg :setVisible(true)
    end
end

function PersonalCenterWindow:filterContainsEmoji(s)
    local ss = {}  
    for k = 1, #s do 
        local c = string.byte(s,k)  
        if not c then break end  
        if (c>=48 and c<=57) or (c>= 65 and c<=90) or (c>=97 and c<=122) then  
            table.insert(ss, string.char(c))  
        elseif c>=228 and c<=233 then  
            local c1 = string.byte(s,k+1)  
            local c2 = string.byte(s,k+2)  
            if c1 and c2 then  
                local a1,a2,a3,a4 = 128,191,128,191 
                if c == 228 then a1 = 184 
                elseif c == 233 then a2,a4 = 190,c1 ~= 190 and 191 or 165 
                end  
                if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then  
                    k = k + 2 
                    table.insert(ss, string.char(c,c1,c2))  
                end  
            end  
        end  
    end  
    return table.concat(ss)
end
function PersonalCenterWindow:sendChangeMsgPacket(ModifyType)
        self.mTempName = self.labelNewName:getText()
        self.mSignStr = self.NewSignature:getText()
        local nickLen = string.utf8len2( self.mTempName)
        self.mSignStrLen =  string.utf8len2(self.NewSignature:getText())
        if ModifyType == 1 then
            if nickLen > 16 or nickLen < 6 then
                --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "昵称长度为3-8个汉字或6-16个字符")  
                 ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"昵称长度为3-8个汉字或6-16个字符")
                return 
            end
            if nickLen <= 0 then
                --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "昵称不能为空")  
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"昵称不能为空")
                return 
            end
        end
        -- if self.mSignStrLen<=0 then
        --    -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "签名不能为空") 
        --      ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"签名不能为空") 
        --     return
        if ModifyType == 2 then
            if self.mSignStrLen>40 then
                --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "签名长度为0~20个汉字")  
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"签名长度为0~20个汉字") 
                return
            end
            self.mSignStr = self:filterContainsEmoji(self.mSignStr)
        end
        if ModifyType == 3 then
            self:onCancelNickName()
            self:onCancelSignName()
        end
        local stream = Packet.new("CSModifySexNickSign", _LAIXIA_PACKET_CS_ModifySexNickSignID)
        stream:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
        stream:setValue("Gender", self.sex)
        stream:setValue("NickName",  self.mTempName)
        stream:setValue("SignStr",  self.mSignStr)
        stream:setValue("ModifyType", ModifyType)
        laixia.net.sendHttpPacket(stream)
end


function PersonalCenterWindow:updateHead()
    --如果是苹果包
    if self.mIsShow then
        
        -- 默认头像图片路径
        self.rankIcon = {}
        local icon = laixiaddz.LocalPlayercfg.LaixiaPlayerHeadUse
        --local path = "images/ic_morenhead"..tostring(tonumber(laixiaddz.LocalPlayercfg.LaixiaPlayerID%10))..".png"
        --local headIcon_new = laixiaddz.LocalPlayercfg.LaixiaPlayerHeadUse; --微信头像要用的
        self.rankIcon[tostring(laixiaddz.LocalPlayercfg.LaixiaPlayerID)] = self.Image_HeadBg
        local path = "images/ic_morenhead"..tostring(tonumber(laixiaddz.LocalPlayercfg.LaixiaPlayerID)%10)..".png"
        --if icon ~= nil and icon ~= "" then
            -- local localIconName = DownloaderHead:SplitLastStr(iconPath, "/")
            local localIconName = cc.FileUtils:getInstance():getWritablePath() .. laixiaddz.LocalPlayercfg.LaixiaPlayerID..".png"
            local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
            if (fileExist) then
                path = localIconName
                -- self:addHeadIcon(self.Image_HeadBg,localIconPath)
            else
                -- self:addHeadIcon(self.Image_HeadBg,path)
                local netIconUrl = icon
                DownloaderHead:pushTask(laixiaddz.LocalPlayercfg.LaixiaPlayerID, netIconUrl,4)
            end
        --else
            self:addHeadIcon(self.Image_HeadBg,path)
        --end

    end
end 



function PersonalCenterWindow:addHeadIcon(head_btn,path)
 
        local head_btn = self:GetWidgetByName("Image_PersonalCenter_Photo")
        if (head_btn == nil or head_btn == "") then
            return
        end
        local templet = soundConfig.IMG_HEAD_TEMPLET_RECT
        head_btn:removeAllChildren()
        --laixia.UItools.addHead(head_btn, path, templet)
        local sprite = cc.Sprite:create(path) 
        sprite:setScaleX(head_btn:getContentSize().width/sprite:getContentSize().width)
        sprite:setScaleY(head_btn:getContentSize().height/sprite:getContentSize().height)
        sprite:setPosition(head_btn:getContentSize().width/2,head_btn:getContentSize().height/2)
        head_btn:addChild(sprite)

end


function PersonalCenterWindow:isBoyorGirl(mIndex)
--      if mIndex <= #self.mBor_Girl then
--        for i,v in ipairs(self.mBor_Girl) do
--            if i == mIndex then
--               v:setSelected(true)
--               v:setTouchEnabled(false);
--            else
--               v:setSelected(false)
--               v:setTouchEnabled(true);
--            end
--        end
--      end
    if mIndex == 1 then
        self:GetWidgetByName("CheckBox_PersonalCenter_Sex1"):setVisible(true)
        self:GetWidgetByName("CheckBox_PersonalCenter_Sex1_1"):setVisible(false)
        self:GetWidgetByName("CheckBox_PersonalCenter_Sex2"):setVisible(false)
        self:GetWidgetByName("CheckBox_PersonalCenter_Sex2_1"):setVisible(true)
        laixiaddz.LocalPlayercfg.LaixiaPlayerGender = 0
    elseif mIndex == 2 then
        self:GetWidgetByName("CheckBox_PersonalCenter_Sex1"):setVisible(false)
        self:GetWidgetByName("CheckBox_PersonalCenter_Sex1_1"):setVisible(true)
        self:GetWidgetByName("CheckBox_PersonalCenter_Sex2"):setVisible(true)
        self:GetWidgetByName("CheckBox_PersonalCenter_Sex2_1"):setVisible(false)
        laixiaddz.LocalPlayercfg.LaixiaPlayerGender = 1
    end
end

function PersonalCenterWindow:ShowNameAndSex()
    self.PlayerName:setString(laixiaddz.LocalPlayercfg.LaixiaPlayerNickname)
    if laixiaddz.LocalPlayercfg.LaixiaPlayerGeXingqianming == "" then 
        self.LabelSignature:setString("记录此刻的心情")
    else
        self.LabelSignature:setString(laixiaddz.LocalPlayercfg.LaixiaPlayerGeXingqianming)
        self.NewSignature:setText(laixiaddz.LocalPlayercfg.LaixiaPlayerGeXingqianming)
    end
    self.labelNewName:setText(laixiaddz.LocalPlayercfg.LaixiaPlayerNickname)
    if 0 == laixiaddz.LocalPlayercfg.LaixiaPlayerGender then
        self.sex = 0
        --self.Gender :setString("男")
        self:isBoyorGirl(1)
    else
        self.sex = 1 
        --self.Gender :setString("女")
        self:isBoyorGirl(2)
    end   
end

function PersonalCenterWindow:isMan(sender,eventType)
--    if eventType == ccui.CheckBoxEventType.selected then
--        sender:setTouchEnabled(false); 
--        self.sex = 0
--        self:isBoyorGirl(1)
--    end 
    if eventType == ccui.TouchEventType.ended then
        self.sex = 0
        self:isBoyorGirl(1)
        self:sendChangeMsgPacket(3)
    end
end 

function PersonalCenterWindow:ChangeNameSuccess()
    if self.mIsShow~= true then 
        return 
    end 
    
   if self.Button_Xiugainicheng:isVisible()== false then
        self.PlayerName:setVisible(true)
        self.labelNewName:setVisible(false)
        self.PlayerName:setString(self.labelNewName:getText())

        self.Button_Xiugainicheng:setVisible(true)
        self.Button_ModifyNickName:setVisible(false)
        self.Button_CancelNickName:setVisible(false)
   elseif self.Button_Xiugaiqianming:isVisible() == false then
        self.LabelSignature:setVisible(true)
        self.NewSignature:setVisible(false)
        self.NewSignature:setText(self.NewSignature:getText())
        
         self.Button_Xiugaiqianming:setVisible(true)
        self.Button_ModifySignName:setVisible(false)
        self.Button_CancelSignName:setVisible(false)
   end
    laixiaddz.LocalPlayercfg.LaixiaPlayerGender = self.sex
    laixiaddz.LocalPlayercfg.LaixiaPlayerNickname = self.mTempName 
    laixiaddz.LocalPlayercfg.LaixiaPlayerGeXingqianming = self.mSignStr
    --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_DUIHUAN_SHOW_WINDOW, "保存成功!")
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"保存成功!")
    self:ShowNameAndSex()
end

function PersonalCenterWindow:isWoman(sender,eventType)
--    if eventType == ccui.CheckBoxEventType.selected then
--        sender:setTouchEnabled(false);        
--        self.sex = 1 
--        self:isBoyorGirl(2)
--    end 
    if eventType == ccui.TouchEventType.ended then
        self.sex = 1 
        self:isBoyorGirl(2)
        self:sendChangeMsgPacket(3)
    end
end 


local function luafun(param)
   if nil == param then
        return
    end
    laixiaddz.LocalPlayercfg.LaixiaPlayerHeadPicture = param
    laixiaddz.LocalPlayercfg.LaixiaIsChangeHead = true
end

-- 点头像触发的事件
function PersonalCenterWindow:onHead(sender, eventType)

    if eventType == ccui.TouchEventType.ended then
        print("this is  on head")
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        if device.platform == "android" then
            -- 给java注册lua函数
            local param = { "luafun", luafun }
            local ok = luaj.callStaticMethod(JAVA_UPLOAD_PHOTO_CLASS_PATH, "headSetLuaFun", param, "(Ljava/lang/String;I)V")

            -- 从相册中寻找头像图片
            local imgSaveDirPath = cc.FileUtils:getInstance():getWritablePath()
            local photoParam = { imgSaveDirPath }
            local state, value = luaj.callStaticMethod(JAVA_UPLOAD_PHOTO_CLASS_PATH, "openPhotoAlbum", photoParam, "(Ljava/lang/String;)V")
        elseif  device.platform == "ios" then
            luaoc.callStaticMethod("HeadPhotoAlbumTools", "registerScriptHandler", {scriptHandler = luafun})
            
            -- 从相册中寻找头像图片 
            local imgSaveDirPath = cc.FileUtils:getInstance():getWritablePath()
            local args = {img_width = 100, img_height = 100, img_path = imgSaveDirPath}
            luaoc.callStaticMethod("HeadPhotoAlbumTools", "openPhotoAlbum", args); 
        else
            laixiaddz.LocalPlayercfg.LaixiaIsChangeHead = true
        end
    end
end

function PersonalCenterWindow:Button_PersonalCenter_Xgmm(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        print("this is Button_PersonalCenter_Xgmm")
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        if  laixiaddz.LocalPlayercfg.LaixiaLastLoginPlatform ~= 2 then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "请先绑定手机")   
        else
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_REVISEPASSWD_WINDOW)
            self:onClose()
        end
    end

end

function PersonalCenterWindow:goShop(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_INCREASEGOLD_WINDOW, {OnCallFunc = function () 
        --     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_INCREASEGOLD_WINDOW)
        -- end})
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_SHOP_WINDOW,{buttonType = 1}) 
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_SHOP_WINDOW) 
        self:destroy()
    end
end

function PersonalCenterWindow:baindingPhone(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_BINDPHONE_WINDOW)
--        self:onClose()
    end
end

function PersonalCenterWindow:switchAccount(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_ACCOUNTLOGIN_WINDOW)
        self:onClose()
    end
end

function PersonalCenterWindow:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:onClose()    
    end
end

function PersonalCenterWindow:onClose()
    self:destroy()
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_PICTURE_WINDOW)
end


function PersonalCenterWindow:onTick(dt)
    if not self.mIsShow then
        return
    end
    if laixiaddz.LocalPlayercfg.LaixiaPhoneNum ~="" then
        self:GetWidgetByName("Button_PersonalCenter_Bdsj"):setVisible(false)
        self:GetWidgetByName("Text_11"):setVisible(false)
        self:GetWidgetByName("Label_PersonalCenter_BingPhone"):setString("已绑定手机号"..laixiaddz.LocalPlayercfg.LaixiaPhoneNum)
    end

    if laixiaddz.LocalPlayercfg.LaixiaPhoneNum ~="" and laixia.kconfig.isYingKe == true then
        self:GetWidgetByName("Button_107"):setVisible(false)
        self:GetWidgetByName("Text_123"):setString("已绑定手机号"..laixiaddz.LocalPlayercfg.LaixiaPhoneNum)
    end

    self.PlayerJiangQuan:setString(tostring(laixiaddz.LocalPlayercfg.LaixiaPlayerGiftCoupon))
    self.PlayerGold:setString(tostring(laixiaddz.LocalPlayercfg.LaixiaPlayerGold))


    if laixiaddz.LocalPlayercfg.LaixiaIsChangeHead then
        if (laixiaddz.LocalPlayercfg.LaixiaPlayerHeadPicture ~= nil) and(laixiaddz.LocalPlayercfg.LaixiaPlayerHeadPicture ~= "") then
            -- 用户自定义头像
            local path
            if string.find(laixiaddz.LocalPlayercfg.LaixiaPlayerHeadPicture,".png") then
                path = cc.FileUtils:getInstance():getWritablePath() .. laixiaddz.LocalPlayercfg.LaixiaPlayerHeadPicture 
            else
                path = cc.FileUtils:getInstance():getWritablePath() .. laixiaddz.LocalPlayercfg.LaixiaPlayerHeadPicture..".png"
            end
            local fileExist = cc.FileUtils:getInstance():isFileExist(path)
            if fileExist  then
                local templet = soundConfig.IMG_HEAD_TEMPLET_RECT
                local head_btn = self:GetWidgetByName("Image_PersonalCenter_Photo")
                head_btn:removeAllChildren()

                laixiaUITools.addHead(head_btn, path, templet)

                self:doUpload(path)
            else
                laixiaddz.LocalPlayercfg.LaixiaPlayerHeadPicture = nil
            end
        end
        laixiaddz.LocalPlayercfg.LaixiaIsChangeHead = false
    end
end

function PersonalCenterWindow:doUpload(imgPath)
    if (imgPath == nil) then
        return
    end

    local head = cc.HelperFunc:getFileData(imgPath)
    local CSHeadUpload = Packet.new("CSHeadUpload", _LAIXIA_PACKET_CS_HeadUploadID)
    CSHeadUpload:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
    CSHeadUpload:setValue("Data", head)
    laixia.net.sendHttpPacket(CSHeadUpload)
end 

function PersonalCenterWindow:onDestroy()
    self.mIsShow = false
end

return PersonalCenterWindow.new()

