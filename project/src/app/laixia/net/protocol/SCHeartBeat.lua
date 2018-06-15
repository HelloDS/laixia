local Type = import("..DataType")

local function onSCHeartBeatPacket(packet)
    print(laixia.kconfig.isYingKe)
    if device.platform == "android" then
        local javaClassName = APP_ACTIVITY
        local javaMethodName = "removeLaunchImage"
        local javaParams = { }
        local javaMethodSig = "()V"        
        local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
    local SeverTime = packet:getValue("SeverTime")
    if laixia.LocalPlayercfg.LaixiaHeartBeatTime>0 and os.date("%d", SeverTime/1000) ~= os.date("%d", laixia.LocalPlayercfg.LaixiaHeartBeatTime/1000) then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_RELIEFINFO_WINDOW)
    end
    laixia.LocalPlayercfg.LaixiaHeartBeatTime = SeverTime
    cc.UserDefault:getInstance():setStringForKey("heartTime", laixia.LocalPlayercfg.LaixiaHeartBeatTime )
    laixia.net.recvHeartBeat();
end

local SCHeartBeat =
    {
        ID = _LAIXIA_PACKET_SC_HeartBeatID ,
        name = "SCHeartBeat",
        data_array =
        {
            {"SeverTime", Type.Double},
        },
        HandlerFunction = onSCHeartBeatPacket,
    }

return SCHeartBeat