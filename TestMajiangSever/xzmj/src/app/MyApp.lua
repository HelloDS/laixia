require("config")
require("cocos.init")
require("framework.init")
require("common.LXConstant")
require("common.LXEngine")
require("common.CommonInterFace")
ObjectEventDispatch = require("common.MonitorSystem") 
APP_ENV = {}
require("logger")
print("调用的lua启动接口")
local Env = APP_ENV;
Env.platform  = cc.Application:getInstance():getTargetPlatform()
Env.director  = cc.Director:getInstance()
Env.fileUtils = cc.FileUtils:getInstance()
Env.userDefault = cc.UserDefault:getInstance() --

local MyApp = class("MyApp", cc.mvc.AppBase)
function MyApp:ctor()
    MyApp.super.ctor(self)
    -- local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    -- local customListenerBg = cc.EventListenerCustom:create("APP_ENTER_BACKGROUND_EVENT",
    --                             handler(self, self.onEnterBackground))
    -- eventDispatcher:addEventListenerWithFixedPriority(customListenerBg, 1)
    -- local customListenerFg = cc.EventListenerCustom:create("APP_ENTER_FOREGROUND_EVENT",
    --                             handler(self, self.onEnterForeground))
    -- eventDispatcher:addEventListenerWithFixedPriority(customListenerFg, 1)

    cc.Device:setKeepScreenOn(true)

    _G.setCommonDisplay(false)
end

function MyApp:run()
    print( laixia.m_isUpdate)
    if device.platform == "windows" then
        laixia.m_isUpdate = true
    end
    laixia.m_isUpdate = false
    if not laixia.m_isUpdate then
        local loginScene = require("app/scenes/MainScene").new()
        display.replaceScene(loginScene)
    else
        if not cc.UserDefault:getInstance():getBoolForKey("isUpdateSuccessful", false) then
            --只走一次 下次硬更新修复此问题
            local storagePath = cc.FileUtils:getInstance():getWritablePath() .. "upd/" 
            local function removeUpdFile(fileName)
                if (cc.FileUtils:getInstance():isFileExist(storagePath .. fileName)) then 
                    cc.FileUtils:getInstance():removeFile(storagePath .. fileName)
                end
            end
            removeUpdFile("version.manifest")
            removeUpdFile("project.manifest")
            removeUpdFile("project.manifest.temp")
        end
        local updateScene = require("app/scenes/UpLoadScene").new()
        display.replaceScene(updateScene)
    end

--    self.entryId = cc.Director:getInstance():getScheduler():scheduleScriptFunc( function(dt) 
--        local perMem = collectgarbage("count")

--        for i =1,3 do
--            collectgarbage("collect")
--        end
--    end, 30, false)
end
 
--[[
    切换到背景
]]--
function MyApp:onEnterBackground()
--    audio.pauseAllSounds()
--    audio:stopMusic()
    print("====onEnterBackground===")
    if device.platform == "android" then
        luaj.callStaticMethod(APP_ACTIVITY, "unRegistMessageCallback", {}, "()V") 
    elseif device.platform == "ios" then
        --ios不用
    end
end

--[[
    切换到游戏
]]--
function MyApp:onEnterForeground()
--    audio.resumeAllSounds()
--    audio.resumeMusic()

   print("====onEnterForeground===")

    local isBackgroundOn = Env.userDefault:getIntegerForKey("isBackgroundOn", 1)==1 -- 音乐
    local isEffectOn = Env.userDefault:getIntegerForKey("isEffectOn", 1)==1 -- 音效

    local state = isBackgroundOn
    if state == true then
        audio.resumeMusic()
        audio.resumeMusic()         
    else
        audio.pauseMusic()
    end
    
    if device.platform == "android" then
        luaj.callStaticMethod(APP_ACTIVITY, "registMessageCallback", {}, "()V") 
    elseif device.platform == "ios" then
        --ios不用
    end

    -- local lastScene = cc.Director:getInstance():getRunningScene()
    -- if lastScene and lastScene.UpdateNetAndElectricity then
    --     lastScene:UpdateNetAndElectricity()
    -- else
    --     print("切换游戏刷新电量wifi失败==========")
    -- end

--    local state = isEffectOn
--    local pt = nil
--    if state == true then
--        audio.resumeAllSounds()
--    else
--        audio.pauseAllSounds()
--        audio.stopAllSounds()
--    end
end

return MyApp
