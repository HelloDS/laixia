local Type = import("..DataType")

local function onSCHeartBeatPacket(packet)
    print(laixiaddz.kconfig.isYingKe)
    if device.platform == "android" then
        local javaClassName = APP_ACTIVITY
        local javaMethodName = "removeLaunchImage"
        local javaParams = { }
        local javaMethodSig = "()V"        
        local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    end
    local SeverTime = packet:getValue("SeverTime")
    if laixiaddz.LocalPlayercfg.laixiaddzHeartBeatTime>0 and os.date("%d", SeverTime/1000) ~= os.date("%d", laixiaddz.LocalPlayercfg.laixiaddzHeartBeatTime/1000) then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_RELIEFINFO_WINDOW)
    end
    laixiaddz.LocalPlayercfg.laixiaddzHeartBeatTime = SeverTime
    cc.UserDefault:getInstance():setStringForKey("heartTime", laixiaddz.LocalPlayercfg.laixiaddzHeartBeatTime )
    laixiaddz.net.recvHeartBeat();
end

local SCHeartBeat =
    {
        ID = _laixiaddz_PACKET_SC_HeartBeatID ,
        name = "SCHeartBeat",
        data_array =
        {
            {"SeverTime", Type.Double},
        },
        HandlerFunction = onSCHeartBeatPacket,
    }

return SCHeartBeat