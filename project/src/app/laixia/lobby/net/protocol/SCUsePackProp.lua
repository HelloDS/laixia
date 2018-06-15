
local Type = import("..DataType")
local StatusCode = import("..StatusCode")

local function onPacketUseTools(packet)
    if StatusCode.new(packet.data.StatuID):isOK() then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "使用成功！")
        for k,v in ipairs(packet.data.ShowItem) do
            for k1, v1 in ipairs(laixia.LocalPlayercfg.LaixiaPropsData) do
                if v1.ItemObjectID == v.ItemObjID then
                    v1.ItemCount = v.ItemCount
                end
            end
        end

        for i = #laixia.LocalPlayercfg.LaixiaPropsData,1,-1 do
            if laixia.LocalPlayercfg.LaixiaPropsData[i].ItemCount==0 then
                table.remove(laixia.LocalPlayercfg.LaixiaPropsData,i)
            end
        end

        if laixia.LocalPlayercfg.LaixiaCurrentWindow == "MyBagWindow" then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_TOOLBOX_WINDOW)
        end

        if laixia.LocalPlayercfg.LaixiaCurrentWindow == "ExchangeWindow" then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_EXCHANGE_WINDOW)
        end

    end
end


return
    {
        ID = _LAIXIA_PACKET_SC_UsePackPropID,

        name = "GCUseToolsRet",
        data_array =
        {
            {"StatuID",Type.Short},
            {"ShowItem",Type.Array,Type.TypeArray.ShowItem},
        },

        HandlerFunction = onPacketUseTools,
    }
