local Type = import("..DataType")
local StatusCode = import("..StatusCode")

local function onSCBoundPhonePacket(packet)

    
    if StatusCode.new(packet.data.StatusID):isOK() then
        laixia.LocalPlayercfg.LaixiaPhoneNum = laixia.LocalPlayercfg.LaixiaPhoneNumTMP
        laixia.LocalPlayercfg.LaixiaPassword = laixia.LocalPlayercfg.LaixiaPasswordTMP

        -- laixia.LocalPlayercfg.LaixiaLastLoginPlatform = 2
        cc.UserDefault:getInstance():setStringForKey("phone_number", laixia.LocalPlayercfg.LaixiaPhoneNum) --写入本地文件
        cc.UserDefault:getInstance():setStringForKey("password", laixia.LocalPlayercfg.LaixiaPassword)
        -- cc.UserDefault:getInstance():setIntegerForKey("GamePlatformID", 2)
        laixia.LocalPlayercfg:WriteData()
        -- cc.UserDefault:getInstance():setBoolForKey("isauto", true)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, "绑定成功！")
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_BINDPHONE_WINDOW)
    else
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, "验证码错误！")
    end
end

local SCBoundPhone =
    {
        ID = _LAIXIA_PACKET_SC_BoundPhoneID,
        name = "SCBoundPhone",
        data_array =
        {
            { "StatusID", Type.Short },
        },
        HandlerFunction = onSCBoundPhonePacket,

    }

return SCBoundPhone