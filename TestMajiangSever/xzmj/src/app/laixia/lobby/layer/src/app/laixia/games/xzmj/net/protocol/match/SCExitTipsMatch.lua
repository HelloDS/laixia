
local Type = import("...DataType")

local function onPacketMatchFailQuite(packet)

    local Mesg = packet:getValue("Mesg")
    print(Mesg)
    local Items =  packet:getValue("Items")--道具
    local str =""
    local laixia = laixia;
    local db2 = laixiaddz.JsonTxtData;
    local itemdbm = db2:queryTable("items");

    for i, v in ipairs(Items) do
        --laixia.db.ItemsDataManager:getItemByItemID(v.ItemID)
        local item = itemdbm:query("ItemId",v.ItemID);
        if v.ItemID == 1001 then--如果是金币
            laixia.LocalPlayercfg.LaixiaPlayerGold = laixia.LocalPlayercfg.LaixiaPlayerGold + v.Count
        end
        if item ~= nil then
            if str == "" then
                str = "返还" .. item.ItemName .. v.Count
            else
                str = str .. "\n" .. item.ItemName .. v.Count
            end
        end
    end
    if laixia.LocalPlayercfg.LaixiaJoinMatch == true then
        laixia.LocalPlayercfg.LaixiaJoinMatch = false
    end

    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_WAITSTATE_WINDOW)         -- 删掉显示阶段
    if laixia.LocalPlayercfg.LaixiaisConnectCardTable == false then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_GAMELIST_GOGAMELIST)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MATCHLISTDETAIL_WINDOW)
        laixia.LocalPlayercfg.LaixiaIsInMatch = false --当不再拍桌的时候才会置成false
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,{ text = str .. Mesg, OnCallFunc = function() end } )
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MATCHJOIN_WINDOW)
    end
    --这里退赛了 执行退出牌桌功能
    if laixia.LocalPlayercfg.LaixiaIsInMatch==false and laixia.LocalPlayercfg.LaixiaCurrentWindow ~= "CardTableDialog" then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_CLEAR_DATELANDLORDTABLE_WINDOW, "退出牌桌")
        laixia.LocalPlayercfg.LaixiaRoomID = 0
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW);
    end
    
end


return
    {
        ID =  _LAIXIA_PACKET_SC_ExitTipsMatchID,

        name = "SCExitTipsMatch", --报名失败返还报名费
        data_array =
        {
            {"GameID",Type.Byte},
            {"Mesg",Type.UTF8},
            {"Items",Type.Array,Type.TypeArray.ReturnITem},
        },

        HandlerFunction = onPacketMatchFailQuite,
    }