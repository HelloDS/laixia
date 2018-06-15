
local GameSetsWindow = class("GameSetsWindow", import("...CBaseDialog"):new()) -- 
local soundConfig = laixia.soundcfg;   
local DownloaderHead = import("..DownloaderHead")

function GameSetsWindow:ctor(...)
     self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function GameSetsWindow:getName()
    return "GameSets"
end

function GameSetsWindow:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_SETUP_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_HIDE_SETUP_WINDOW, handler(self, self.destroy))
end   


function GameSetsWindow:onMusicChange(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        -- local checkBool = self.checkBoxMusic:isSelected()
        -- self.checkBoxMusic:setSelected(not checkBool)
--        if checkBool then
--            self.SinaMusicValue = 0
--        else
--            self.SinaMusicValue = 1
--        end
--        laixia.LocalPlayercfg.LaixiaMusicValue = self.SinaMusicValue
--        audio.setMusicVolume(laixia.LocalPlayercfg.LaixiaMusicValue)
        print ( laixia.LocalPlayercfg.LaixiaMusicValue)
        if laixia.LocalPlayercfg.LaixiaMusicValue==1 then
            self:GetWidgetByName("SetAlert_Content_CheckBox_Music1"):setVisible(false)
            self:GetWidgetByName("SetAlert_Content_CheckBox_Music2"):setVisible(true)
            laixia.LocalPlayercfg.LaixiaMusicValue = 2

        else
            self:GetWidgetByName("SetAlert_Content_CheckBox_Music1"):setVisible(true)
            self:GetWidgetByName("SetAlert_Content_CheckBox_Music2"):setVisible(false)
            laixia.LocalPlayercfg.LaixiaMusicValue = 1
        end

        if laixia.LocalPlayercfg.LaixiaMusicValue == 1 then
            laixia.soundTools.openMusic(true)
        else
            laixia.soundTools.openMusic(false)
        end
        cc.UserDefault:getInstance():setIntegerForKey("MusicValue", laixia.LocalPlayercfg.LaixiaMusicValue)
        -- laixia.LocalPlayercfg.LaixiaMusicValue = self.checkBoxMusic:isSelected()
        -- laixia.soundTools.openMusic(laixia.LocalPlayercfg.LaixiaMusicValue)
        cc.UserDefault:getInstance():setBoolForKey("GameSets", true)
    end
end

function GameSetsWindow:onSoundChange(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        -- local checkBool = self.checkBoxSound:isSelected()
        -- self.checkBoxSound:setSelected(not checkBool)
--        if checkBool then
--            self.SinaSoundValue = 0
--        else
--            self.SinaSoundValue = 1
--        end
--        laixia.LocalPlayercfg.LaixiaSoundValue = self.SinaSoundValue
--        audio.setSoundsVolume(laixia.LocalPlayercfg.LaixiaSoundValue)
        if laixia.LocalPlayercfg.LaixiaSoundValue==1 then
            self:GetWidgetByName("SetAlert_Content_CheckBox_Effect1"):setVisible(false)
            self:GetWidgetByName("SetAlert_Content_CheckBox_Effect2"):setVisible(true)
            laixia.LocalPlayercfg.LaixiaSoundValue = 2
        else
            self:GetWidgetByName("SetAlert_Content_CheckBox_Effect1"):setVisible(true)
            self:GetWidgetByName("SetAlert_Content_CheckBox_Effect2"):setVisible(false)
            laixia.LocalPlayercfg.LaixiaSoundValue = 1
        end
              
        -- laixia.LocalPlayercfg.LaixiaSoundValue = self.checkBoxSound:isSelected()
        if laixia.LocalPlayercfg.LaixiaSoundValue == 1 then
            laixia.soundTools.openSound(true)
        else
            laixia.soundTools.openSound(false)
        end
       cc.UserDefault:getInstance():setIntegerForKey("SoundValue", laixia.LocalPlayercfg.LaixiaSoundValue)
        --cc.UserDefault:getInstance():setBoolForKey("GameSets", true)
        -- cc.UserDefault:getInstance():setBoolForKey("", value)
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
    end
end

function GameSetsWindow:onShakeFun(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        -- local checkBool = self.checkBoxShake:isSelected()
        -- self.checkBoxShake:setSelected(not checkBool)

        if laixia.LocalPlayercfg.LaixiaIsShake==1 then
            self:GetWidgetByName("SetAlert_Content_CheckBox_Shake1"):setVisible(false)
            self:GetWidgetByName("SetAlert_Content_CheckBox_Shake2"):setVisible(true)
            laixia.LocalPlayercfg.LaixiaIsShake = 2
        else
            self:GetWidgetByName("SetAlert_Content_CheckBox_Shake1"):setVisible(true)
            self:GetWidgetByName("SetAlert_Content_CheckBox_Shake2"):setVisible(false)
            laixia.LocalPlayercfg.LaixiaIsShake = 1

            if device.platform == "android" then
                local params = { 1000 }
                local state, value = luaj.callStaticMethod(JAVA_SHAKE_CLASSPATH, "gameShake", params, "(I)V")
            elseif device.platform == "ios" then
                local state, value = luaoc.callStaticMethod("GetGeneralInfo", "gameShake")
            end
        end

        --laixia.LocalPlayercfg.LaixiaIsShake = self.mIsShake
        cc.UserDefault:getInstance():setIntegerForKey("Shake", laixia.LocalPlayercfg.LaixiaIsShake)
        cc.UserDefault:getInstance():setBoolForKey("GameSets", true)
    end
end


function GameSetsWindow:goGameHelp(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HELP_WINDOW)
    end
end

function GameSetsWindow:goComplaint(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_COMPLAIN_WINDOW)
    end
end

function GameSetsWindow:goExchangeCode(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_REDEEMGIFT_WINDOW)
    end
end


function GameSetsWindow:onShow(msg)

    self.data = msg.data                                                                                                                                                                      
    if self.data == 1 then
        self:GetWidgetByName("Button_Login"):setVisible(false)
    else
        self:GetWidgetByName("Button_Login"):setVisible(true)
    end
    self.BG = self:GetWidgetByName("bg")
    self.BG:setTouchEnabled(true)
    self.BG:setTouchSwallowEnabled(true)


    
    self.checkBoxMusic =self:GetWidgetByName("SetAlert_Content_CheckBox_Music")
--    self.checkBoxMusic = ccui.Helper:seekWidgetByName(self.mInterfaceRes, "SetAlert_Content_CheckBox_Music")
--    self.SinaMusicValue = laixia.LocalPlayercfg.LaixiaMusicValue
--    if self.SinaMusicValue > 0 then
--        self.checkBoxMusic:setSelected(true)
--    else
--        self.checkBoxMusic:setSelected(false)
--    end
    if cc.UserDefault:getInstance():getIntegerForKey("MusicValue") == 0 then
        cc.UserDefault:getInstance():setIntegerForKey("MusicValue",1)
        laixia.LocalPlayercfg.LaixiaMusicValue=1
        self:GetWidgetByName("SetAlert_Content_CheckBox_Music1"):setVisible(true)
        self:GetWidgetByName("SetAlert_Content_CheckBox_Music2"):setVisible(false)
    end
    if laixia.LocalPlayercfg.LaixiaMusicValue==1 then
        self:GetWidgetByName("SetAlert_Content_CheckBox_Music1"):setVisible(true)
        self:GetWidgetByName("SetAlert_Content_CheckBox_Music2"):setVisible(false)
    else
        self:GetWidgetByName("SetAlert_Content_CheckBox_Music1"):setVisible(false)
        self:GetWidgetByName("SetAlert_Content_CheckBox_Music2"):setVisible(true)
    end
--    self.checkBoxMusic:setSelected(laixia.LocalPlayercfg.LaixiaMusicValue)

    self.checkBoxSound =self:GetWidgetByName("SetAlert_Content_CheckBox_Effect")
--    self.checkBoxSound = ccui.Helper:seekWidgetByName(self.mInterfaceRes, "SetAlert_Content_CheckBox_Effect")
--    self.SinaSoundValue = laixia.LocalPlayercfg.LaixiaSoundValue
--    if self.SinaSoundValue > 0 then
--        self.checkBoxSound:setSelected(true)
--    else
--        self.checkBoxSound:setSelected(false)
--    end

    if cc.UserDefault:getInstance():getIntegerForKey("SoundValue") == 0 then
        cc.UserDefault:getInstance():setIntegerForKey("SoundValue",1)
        laixia.LocalPlayercfg.LaixiaSoundValue=1
        self:GetWidgetByName("SetAlert_Content_CheckBox_Effect1"):setVisible(true)
        self:GetWidgetByName("SetAlert_Content_CheckBox_Effect2"):setVisible(false)
    end
    if laixia.LocalPlayercfg.LaixiaSoundValue==1 then
        self:GetWidgetByName("SetAlert_Content_CheckBox_Effect1"):setVisible(true)
        self:GetWidgetByName("SetAlert_Content_CheckBox_Effect2"):setVisible(false)
    else
        self:GetWidgetByName("SetAlert_Content_CheckBox_Effect1"):setVisible(false)
        self:GetWidgetByName("SetAlert_Content_CheckBox_Effect2"):setVisible(true)
    end

--    self.checkBoxSound:setSelected(laixia.LocalPlayercfg.LaixiaSoundValue)

    self.checkBoxShake =self:GetWidgetByName("SetAlert_Content_CheckBox_Shake")
--    self.checkBoxShake = ccui.Helper:seekWidgetByName(self.mInterfaceRes, "SetAlert_Content_CheckBox_Shake")
--    self.mIsShake = laixia.LocalPlayercfg.LaixiaIsShake
--    if self.mIsShake then
--        self.checkBoxShake:setSelected(true)
--    else
--        self.checkBoxShake:setSelected(false)
--    end
--    self.checkBoxShake:setSelected(laixia.LocalPlayercfg.LaixiaIsShake)
    if cc.UserDefault:getInstance():getIntegerForKey("Shake") == 0 then
        cc.UserDefault:getInstance():setIntegerForKey("Shake",1)
        laixia.LocalPlayercfg.LaixiaIsShake=1
        self:GetWidgetByName("SetAlert_Content_CheckBox_Shake1"):setVisible(true)
        self:GetWidgetByName("SetAlert_Content_CheckBox_Shake2"):setVisible(false)
    end
    if laixia.LocalPlayercfg.LaixiaIsShake==1 then
        self:GetWidgetByName("SetAlert_Content_CheckBox_Shake1"):setVisible(true)
        self:GetWidgetByName("SetAlert_Content_CheckBox_Shake2"):setVisible(false)
    else
        self:GetWidgetByName("SetAlert_Content_CheckBox_Shake1"):setVisible(false)
        self:GetWidgetByName("SetAlert_Content_CheckBox_Shake2"):setVisible(true)
    end
    
    self:GetWidgetByName("Text_Fuwuhao"):setString("微信服务号："..laixia.LocalPlayercfg.LaixiaWechatServiceNum)

    self:GetWidgetByName("Text_fuwuxuje"):setString("《来下科技许可及服务协议》")
    self:AddWidgetEventListenerFunction("Text_fuwuxuje",handler(self,self.onShowServiceXieyi))
    --点击版本
    -- self:AddWidgetEventListenerFunction("Text_Version",handler(self,self.Button_GoFrientRoom))
    self:AddWidgetEventListenerFunction("Button_About",handler(self,self.onShowAbout))
    self.RemCurrentCount = 0
    local version = cc.UserDefault:getInstance():getStringForKey("version")
    if version == nil  then
        self:GetWidgetByName("Text_Version"):setString(getAppVersion())   
    else
        self:GetWidgetByName("Text_Version"):setString(version)
    end

    self:AddWidgetEventListenerFunction("Button_Login",handler(self,self.Login))
    self:GetWidgetByName("Button_tuichuyouxi"):setVisible(false)
    self:AddWidgetEventListenerFunction("Button_Shake", handler(self, self.onShakeFun))
    self:AddWidgetEventListenerFunction("Button_Music", handler(self, self.onMusicChange))
    self:AddWidgetEventListenerFunction("Button_Sound", handler(self, self.onSoundChange))
--   self:AddWidgetEventListenerFunction("SetAlert_Content_CheckBox_Shake", handler(self, self.onShakeFun))
--   self:AddWidgetEventListenerFunction("SetAlert_Content_CheckBox_Music", handler(self, self.onMusicChange))
--   self:AddWidgetEventListenerFunction("SetAlert_Content_CheckBox_Effect", handler(self, self.onSoundChange))
    -- self:AddWidgetEventListenerFunction("SetAlert_Button_Help", handler(self, self.goGameHelp))
    -- self:AddWidgetEventListenerFunction("SetAlert_Button_Service", handler(self, self.goComplaint))
    -- self:AddWidgetEventListenerFunction("SetAlert_Button_GiftCode", handler(self, self.goExchangeCode))
    self:updateHead()
    self:AddWidgetEventListenerFunction("SetAlert_Button_Close", handler(self, self.onShutDown))

    if laixia.kconfig.isYingKe == true then
        self:GetWidgetByName("Text_fuwuxuje"):setString("《芝士超人服务协议》")
        self:GetWidgetByName("Image_3_Copy"):setScaleY(0.8)
        self:GetWidgetByName("Button_Login"):setVisible(false)
        self:GetWidgetByName("Button_tuichuyouxi"):setVisible(false)
        self:GetWidgetByName("Text_qq"):setVisible(true)
        self:GetWidgetByName("Text_qq"):setString("QQ群：684101446")
        self:GetWidgetByName("Text_zhishihao"):setVisible(true)
        self:GetWidgetByName("Text_zhishihao"):setString("芝士号:"..laixia.LocalPlayercfg.LaixiaUserID)
        self:AddWidgetEventListenerFunction("Button_tuichuyouxi",handler(self,self.Exit))
    end

end

function GameSetsWindow:Button_GoFrientRoom(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.RemCurrentCount = self.RemCurrentCount+1
        if self.RemCurrentCount == 20 then
            laixia.LocalPlayercfg.OnReturnFunction = _LAIXIA_EVENT_PACKET_CREATESELFBUILF
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_PACKET_CREATESELFBUILF)
        end
    end
end

function GameSetsWindow:Exit()
    os.exit()
end

function GameSetsWindow:updateHead()
        -- 默认头像图片路径
        local path = "images/ic_morenhead"..tostring(tonumber(laixia.LocalPlayercfg.LaixiaPlayerID%10))..".png"
        local headIcon = laixia.LocalPlayercfg.LaixiaPlayerHeadPicture;
        local headIcon_new = laixia.LocalPlayercfg.LaixiaPlayerHeadUse; --头像要用的

        --微信渠道要看头像是否有变化
        if cc.Application:getInstance():getTargetPlatform() == 4 and headIcon_new~=cc.UserDefault:getInstance():getStringForKey("headimgurl") then
            headIcon = nil
            headIcon_new = cc.UserDefault:getInstance():getStringForKey("headimgurl")
            laixia.LocalPlayercfg.LaixiaPlayerHeadUse = headIcon_new
            laixia.LocalPlayercfg.LaixiaHeadPortraitPath = ""
            laixia.config.HEAD_URL = cc.UserDefault:getInstance():getStringForKey("headimgurl")
            
        end
        
       
        -- local    testPath = cc.FileUtils:getInstance():getWritablePath() .. "head_image/" .. laixia.LocalPlayercfg.LaixiaPlayerID..".png"
        local    testPath = cc.FileUtils:getInstance():getWritablePath() .. laixia.LocalPlayercfg.LaixiaPlayerID..".png"
        print(testPath)

        local fileExist = cc.FileUtils:getInstance():isFileExist(testPath)

        print(fileExist)
        if (fileExist) then
            path = testPath
        else
        --下载图片
            local headIconUrl = laixia.config.HEAD_URL .. laixia.LocalPlayercfg.LaixiaHeadPortraitPath
            print(headIconUrl)
            DownloaderHead:pushTask(laixia.LocalPlayercfg.LaixiaPlayerID, headIconUrl,2)
        end
        self:addHeadIcon(path);
end 

function GameSetsWindow:addHeadIcon(path)
 
        local head_btn = self:GetWidgetByName("Image_Head")
        if (head_btn == nil or head_btn == "") then
            return
        end
        local templet = soundConfig.IMG_HEAD_TEMPLET_RECT
        head_btn:removeAllChildren()
        --laixia.UItools.addHead(head_btn, path, templet)
        local sprite = display.newSprite(path) 
        sprite:setScaleX(head_btn:getContentSize().width/sprite:getContentSize().width)
        sprite:setScaleY(head_btn:getContentSize().height/sprite:getContentSize().height)
        sprite:setPosition(head_btn:getContentSize().width/2,head_btn:getContentSize().height/2)
        head_btn:addChild(sprite)
end

--退出登录
function GameSetsWindow:Login(sender,eventtype)
    --下限 切到登录界面
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_LOADIN_WINDOW,{data=true})
end
--服务协议
function GameSetsWindow:onShowServiceXieyi(sender,eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_GAMEDESCRIBE_WINDOW,{data="xieyi"})
    end
end
--显示关于 --帮助
function GameSetsWindow:onShowAbout(sender,eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_GAMEDESCRIBE_WINDOW,{data="guanyu"})
    end
end
function GameSetsWindow:onShutDown(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
--        cc.UserDefault:getInstance():setDoubleForKey("SoundValue", self.SinaSoundValue)
--        cc.UserDefault:getInstance():setDoubleForKey("MusicValue", self.SinaMusicValue)
--        cc.UserDefault:getInstance():setBoolForKey("Shake", self.mIsShake)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_SETUP_WINDOW)
    end
end

return GameSetsWindow.new()
