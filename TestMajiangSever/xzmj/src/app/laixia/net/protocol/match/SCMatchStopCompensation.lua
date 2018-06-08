
local Type = import("...DataType")

local function onPacketGCMatchSeverCompensationRet(packet)
    laixia.LocalPlayercfg.LaixiaIsInMatch = false
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "服务器维护中")

    local laixia = laixia;
    local db2 = laixia.JsonTxtData;
    local itemDBM = db2:queryTable("items");
    local Items = packet:getValue("Items")-- 道具
    local str = ""

    for i, v in ipairs(Items) do
        local item = itemDBM:query("ItemID",v.ItemID);
        if item ~= nil then
            if str == "" then
                str = "返还" .. item.ItemName .. v.Count
            else
                str = str .. "\n" .. item.ItemName .. v.Count
            end
        end
    end

    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,{ text = str , OnCallFunc = function()
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW)

    end } )

end

return
    {
        ID = _LAIXIA_PACKET_SC_MatchStopCompensationID,
        name = "SCMatchStopCompensation",
        data_array =
        {
            {"GameID", Type.Byte },
            {"MatchName",Type.UTF8},
            {"Items", Type.Array, Type.TypeArray.Items},
        },
        HandlerFunction = onPacketGCMatchSeverCompensationRet,
    }


--endregion
