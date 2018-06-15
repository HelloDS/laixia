local Type = import("...DataType")
local StatusCode = import("...StatusCode")


local function TenThousandQuitRetCallBack(packet)
    if packet.data.StatID == 0 then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MAININTERFACE_WINDOW)
    else
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"当前阶段无法退出")
    end
end

local SCTenThousandQuitRet =
    {
        ID = _LAIXIA_PACKET_SC_TenThousandQuitRetID,
        name = "SCTenThousandQuitRet",
        data_array =
        {
            --进入状态
            {"StatID",Type.Short} ,

        },
        HandlerFunction = TenThousandQuitRetCallBack
    }
return SCTenThousandQuitRet
 