--关于wifi和电源的显示操作

local JAVAMETHODNAMEISE = "isElectricity"
local JAVAPARAMSISE = {}
local JAVAMETHODSIGISE = "()Z"
local JAVAMETHODNAMEE = "onElectricity"
local JAVAPARAMSE = {}
local JAVAMETHODSIGE = "()F"
local JAVAMETHODNAMEN = "onWiFiIntensity"
local JAVAPARAMSN = {}
local JAVAMETHODSIGN = "()I"

local Env = APP_ENV;
local luaj = Env.luaj;

local BatteryWifiTime = class("BatteryWifiTime")

function BatteryWifiTime:ctor(widget, posX, posY)
    self.Img_time = nil
    self.Img_wifi = nil
    self.Img_battery = nil
    self.Img_nowifi = nil
    self.widget = nil
    self.ProgressBar_battery = nil
    self.Img_nobattery = nil
    self.label_Time=nil
    self.Img_isChanging=nil
    self:onInit(widget, posX, posY)
end
function BatteryWifiTime:onInit(widget, posX, posY)
    if widget == nil then
        return
    end

    --电量的节点
    self.widget = widget
    --self.widget:setPosition(posX, posY)
    --self.Img_wifi = ccui.Helper:seekWidgetByName(self.widget,"Image_wifi")
    self.Img_battery = ccui.Helper:seekWidgetByName(self.widget,"Image_battery")
    --self.Img_nowifi = ccui.Helper:seekWidgetByName(self.widget,"Image_nowifi")
    self.ProgressBar_battery =  ccui.Helper:seekWidgetByName(self.Img_battery,"ProgressBar_battery")
    --self.ProgressBar_lowbattery =  ccui.Helper:seekWidgetByName(self.Img_battery,"ProgressBar_lowbattery")

    -- wifi的东西
    self.Img_wifi = ccui.Helper:seekWidgetByName(self.widget,"Image_Wifi")

    --时间的节点
    self.label_Time=ccui.Helper:seekWidgetByName(self.widget,"Label_time")
    --self.isChanging=ccui.Helper:seekWidgetByName(self.Img_battery,"Image_changing")
    self.mTime = ""
    self.label_Time:setString(self.mTime)
end
function BatteryWifiTime:ElectricityUpdate()
    if device.platform == "android" then

        if luaj ~= nil then
            local status1, per = luaj.callStaticMethod(APP_ACTIVITY, JAVAMETHODNAMEE, JAVAPARAMSE, JAVAMETHODSIGE)
            local status2, isCharging = luaj.callStaticMethod(APP_ACTIVITY, JAVAMETHODNAMEISE, JAVAPARAMSISE, JAVAMETHODSIGISE)
            laixiaddz.loggame("两个函数调用完成")
            if self.Img_battery ~= nil or self.ProgressBar_battery ~= nil then --or self.ProgressBar_lowbattery ~= nil 
                if isCharging then
                    laixiaddz.loggame("正在充电")
                    --self.ProgressBar_lowbattery:hide()
                    self.Img_battery:show()
                    self.ProgressBar_battery:show()
                    --self.isChanging:show()

                    self.ProgressBar_battery:setPercent(math.floor(per * 100))
                else
                    if per > 0.1 then
                        laixiaddz.loggame("电量大于0.1")
                        --self.ProgressBar_lowbattery:hide()
                        self.Img_battery:show()
                        self.ProgressBar_battery:show()
                        --self.isChanging:hide()
                        self.ProgressBar_battery:setPercent(math.floor(per * 100))
                    else
                        laixiaddz.loggame("电量小于0.1")
                        --self.ProgressBar_lowbattery:show()
                        self.Img_battery:show()
                        self.ProgressBar_battery:hide()
                        --self.isChanging:hide()
                        --self.ProgressBar_lowbattery:setPercent(math.floor(per * 100))
                    end
                end
            end
        end
    end

    -- ios实现
    if device.platform == "ios" then

        local ok1,isCharging = luaoc.callStaticMethod("GetGeneralInfo", "isBatteryStateCharging");
        local ok2,per = luaoc.callStaticMethod("GetGeneralInfo", "getBatteryLevel");

        if self.Img_battery ~= nil --or self.ProgressBar_lowbattery ~= nil
            or self.ProgressBar_battery ~= nil then

            if isCharging == 1 then
                laixiaddz.loggame("正在充电")
                --self.ProgressBar_lowbattery:hide()
                self.Img_battery:show()
                self.ProgressBar_battery:show()
                --self.isChanging:show()

                self.ProgressBar_battery:setPercent(math.floor(per * 100))
            else
                if per > 0.1 then
                    laixiaddz.loggame("电量大于0.1")
                    --self.ProgressBar_lowbattery:hide()
                    self.Img_battery:show()
                    self.ProgressBar_battery:show()
                    --self.isChanging:hide()
                    self.ProgressBar_battery:setPercent(math.floor(per * 100))
                else
                    laixiaddz.loggame("电量小于0.1")
                    --self.ProgressBar_lowbattery:show()
                    self.Img_battery:show()
                    self.ProgressBar_battery:hide()
                    --self.isChanging:hide()
                    --self.ProgressBar_lowbattery:setPercent(math.floor(per * 100))
                end
            end
        end
    end

end
function BatteryWifiTime:NetworkUpdate()
    if device.platform == "android" then
        --local luaj = require "cocos.cocos2d.luaj"
        local netstatus = network.getInternetConnectionStatus()
        local wifistatus = network.isLocalWiFiAvailable()
        local status, level = luaj.callStaticMethod(APP_ACTIVITY, JAVAMETHODNAMEN, JAVAPARAMSN, JAVAMETHODSIGN)
        if netstatus == 0 then
        self.Img_wifi:hide()
        --self.Img_nowifi:hide()
        elseif netstatus == 1 then
            if level == 1 then
                self.Img_wifi:loadTexture("new_ui/CardTableDialog/wifi4.png")
            elseif level == 2 then
                self.Img_wifi:loadTexture("new_ui/CardTableDialog/wifi3.png")
            elseif level == 3 then
                self.Img_wifi:loadTexture("new_ui/CardTableDialog/wifi2.png")
            elseif level == 4 or level == 5 then
                self.Img_wifi:loadTexture("new_ui/CardTableDialog/wifi1.png")
            end
            self.Img_wifi:show()
        --self.Img_nowifi:hide()
        elseif netstatus == 2 then
            self.Img_wifi:hide()
        --self.Img_nowifi:show()
        end
    elseif device.platform == "ios" then

        local netstatus = network.getInternetConnectionStatus()
        if netstatus == 0 then
        --self.Img_wifi:hide()
        --self.Img_nowifi:hide()
        elseif netstatus == 1 then
            self.Img_wifi:show()
        --self.Img_nowifi:hide()
        elseif netstatus == 2 then
        --self.Img_wifi:hide()
        --self.Img_nowifi:show()
        end
    end

end
function BatteryWifiTime:TimeUpdate()
    local temp = os.date("%H") .. ":" .. os.date("%M")
    if(self.label_Time ~= nil and self.mTime ~=temp ) then
        self.mTime = temp
        self.label_Time:setString(self.mTime)
    end
end
return BatteryWifiTime
-- endregion
