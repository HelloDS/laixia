
local Type = import("...DataType")

local function onPacketGCMatchSeverCompensationRet(packet)
    laixiaddz.LocalPlayercfg.laixiaddzIsInMatch = false
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "服务器维护中")

    local laixiaddz = laixiaddz;
    local db2 = laixiaddz.JsonTxtData;
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

    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,{ text = str , OnCallFunc = function()
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW)

    end } )

end

return
    {
        ID = _laixiaddz_PACKET_SC_MatchStopCompensationID,
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
