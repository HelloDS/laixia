local Type = import("..DataType")
local StatusCode = import("..StatusCode")

local function onSCFindPwdPacket(packet)
    laixia.dump(packet)
    local StatusID = packet:getValue("StatusID")
    if StatusID == 0 then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW,"您的密码已经发送到手机上\n请查收")
    else
        StatusCode.new(StatusID)
    end

    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_FINDPWD_WINDOW)
end

local  SCFindPwd =
    {
        ID = _LAIXIA_PACKET_SC_FindPwdID ,
        name = "SCFindPwd",
        data_array=
        {
            {"StatusID",    Type.Short},        --状态码

        },
        HandlerFunction = onSCFindPwdPacket,
    }

return SCFindPwd