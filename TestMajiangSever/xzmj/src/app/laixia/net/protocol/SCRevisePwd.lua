local Type = import("..DataType")
local StatusCode = import("..StatusCode")

local function onSCRevisePwdPacket(packet)

    local StatusID = packet:getValue("StatusID")
    if StatusID == 0 then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW,"修改成功！")
        laixia.LocalPlayercfg.LaixiaPassword = laixia.LocalPlayercfg.LaixiaPasswordTMP
        laixia.LocalPlayercfg.LaixiaLastLoginPlatform = 2
        cc.UserDefault:getInstance():setStringForKey("password",laixia.LocalPlayercfg.LaixiaPassword)
    else
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW,"原密码错误修改失败！")
    end
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_REVISEPASSWD_WINDOW)
end
local  SCRevisePwd =
    {
        ID = _LAIXIA_PACKET_SC_RevisePwdID,
        name = "SCRevisePwd",
        data_array=
        {
            {"StatusID",    Type.Short},        --状态码
        },
        HandlerFunction = onSCRevisePwdPacket,
    }

return SCRevisePwd