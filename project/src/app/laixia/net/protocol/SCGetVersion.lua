local Type = import("..DataType")
local StatusCode = import("..StatusCode")
local function stringSplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} 
    local i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
local function onScGetVersionPacket(packet)
    
    local StatusID = packet:getValue("StatusID")    
    if laixia.LocalPlayercfg.LaixiaCurrentWindow == "LoadingWindow" then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_GETVERSION,packet.data);
    else
        local StatusID = packet:getValue("StatusID")
        local Version = packet:getValue("Version")
        print("onScGetVersionInPacket--StatusID"..StatusID)
        print("onScGetVersionInPacket--CurVersion"..Version)
        
        local CurVersion = cc.UserDefault:getInstance():getStringForKey("version")
        if CurVersion == nil or CurVersion == "" then
                CurVersion = "2.0.14"
        end
        
        local myVersionVector = stringSplit(CurVersion,".")
        local serverVersionVector = stringSplit(Version,".")
        

        local isNeedUpdate = false
        if StatusID==0 then
            isNeedUpdate = tonumber(myVersionVector[3])<tonumber(serverVersionVector[3])
        else
            isNeedUpdate = true
        end
        if isNeedUpdate then 
             ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW,
                    {Text = "发现新版本，请退出游戏后更新",
                        OnCallFunc = function()
                            os.exit();
                        end,
                    })
        end
    end
   
end 

local SCGetVersion =
{
    ID = _LAIXIA_PACKET_SC_GETVERSION,
    name = "SCGetVersion",
    data_array =
    {
        { "StatusID", Type.Short },
        { "Version", Type.UTF8 },
    },
    HandlerFunction = onScGetVersionPacket,
}

return SCGetVersion