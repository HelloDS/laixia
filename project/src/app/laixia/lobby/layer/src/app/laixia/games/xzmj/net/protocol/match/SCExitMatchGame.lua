-- Desc: 退赛

local Type = import("...DataType")
local StatusCode = import("...StatusCode")

local function onPacketQuitRegistrationRet(packet) -- 退出比赛报名
    local StatusID = packet:getValue("Status")
    local cost = packet:getValue("Cost")
    local laixia = laixia;
    local db2 = laixiaddz.JsonTxtData;
    local itemDBM = db2:queryTable("items");

    for i, v in pairs(cost) do
        print(v.ItemID)
        local Itemsdata = itemDBM:query("ItemID",v.ItemID);
        --laixia.db.ItemsDataManager:getItemByItemID(v.ItemID)

        if v.ItemID == 1001 then
            laixia.LocalPlayercfg.LaixiaPlayerGold = laixia.LocalPlayercfg.LaixiaPlayerGold + v.ItemCount
        end
        if v.ItemID == 1002 then
            laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon = laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon + v.ItemCount
        end
    end

    if StatusCode.new(packet.data.Status):isOK() then
        laixia.LocalPlayercfg.LaixiaIsInMatch = false
        laixia.LocalPlayercfg.LaixiaisMatchDetail = false

        local match = laixia.LocalPlayercfg.LaixiaMatchdata
        if #match == 0 then
            return
        end
        local red_temp = match[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms
        for i = 1, #red_temp do
            if (laixia.LocalPlayercfg.LaixiaMatchRoom == red_temp[i].RoomID) then
                laixia.LocalPlayercfg.LaixiaMatchdata[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms[i].CurJoinNum = laixia.LocalPlayercfg.LaixiaMatchdata[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms[i].CurJoinNum - 1
                laixia.LocalPlayercfg.LaixiaMatchdata[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms[i].Sate = 2
                laixia.LocalPlayercfg.LaixiaMatchdata[laixia.LocalPlayercfg.LaixiaGameListIndex].rooms[i].SelfJoin = 0
            end
        end
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MATCHLISTDETAIL_WINDOW) -- 关闭详情页
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MATCHSTATE_WINDOW)
        --ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_QUIT_MATCHJOIN_WINDOW)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MAST_MATCHJOIN_WINDOW) -- 进入比赛

        if laixia.LocalPlayercfg.LaixiaJoinMatch == true then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, "已取消上一场报名")
        else
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, "退赛成功")
        end
    else
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MATCHJOIN_WINDOW)
    end

end

return
    {
        ID = _LAIXIA_PACKET_SC_ExitMatchGameID,

        name = "SCExitMatchGame",
        data_array =
        {
            { "GameID", Type.Byte },
            { "Status", Type.Short },
            { "Cost", Type.Array, Type.TypeArray.ResultItem },-- 返回的消耗
        },
        HandlerFunction = onPacketQuitRegistrationRet,
    }