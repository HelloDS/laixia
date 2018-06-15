local Type = import("..DataType")

local function onSCUserOfflinePacket(packet)
    ObjectEventDispatch:dispatchEvent{
        name = _LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW,
        data = laixia.utilscfg.DICT(_ID_DICT_TYPE_NOTIFY_OFFLINE), --这里稍后修正
        callFunction = function()
            os.exit();
        end,
    }
    local StatusID = packet:getValue("StatusID")
    local function handleError()
        if StatusID == 42 then  --重复登录
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW,
                {Text = "与服务器断开\n点击确定重新登录",
                    OnCallFunc = function(isTry)
                        if(isTry == nil) then isTry = true; end
                        if(isTry) then
                            ObjectEventDispatch:pushEvent(EVENT_RE_CONNECT_REQ)
                        else
                            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_EXITGAME_WINDOW)
                        end
                    end,
                })
        elseif StatusID == 44 then  --强制踢出
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW,"已断开连接，服务器正在维护，请稍候尝试。")
        elseif StatusID == 45 then  --房间维护
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW,"服务器维护中。")
        end
    end

    local network = laixia.net.Net;
    if(network.mProcessState ~= 2) then
        network:registerReadyFunc(handleError);
    else
        handleError();
    end
end

local  SCUserOffline =
    {
        ID = _LAIXIA_PACKET_SC_UserOfflineID ,
        name = "SCUserOffline",
        data_array=
        {
            {"StatusID",Type.Short},
        },

        HandlerFunction = onSCUserOfflinePacket,

    }

return SCUserOffline
