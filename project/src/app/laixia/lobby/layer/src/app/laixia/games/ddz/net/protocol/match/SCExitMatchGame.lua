-- Desc: 退赛

local Type = import("...DataType")
local StatusCode = import("...StatusCode")

local function onPacketQuitRegistrationRet(packet) -- 退出比赛报名
    local StatusID = packet:getValue("Status")
    local cost = packet:getValue("Cost")
    local laixiaddz = laixiaddz;
    local db2 = laixiaddz.JsonTxtData;
    local itemDBM = db2:queryTable("items");

    for i, v in pairs(cost) do
        print(v.ItemID)
        local Itemsdata = itemDBM:query("ItemID",v.ItemID);
        --laixiaddz.db.ItemsDataManager:getItemByItemID(v.ItemID)

        if v.ItemID == 1001 then
            laixiaddz.LocalPlayercfg.laixiaddzPlayerGold = laixiaddz.LocalPlayercfg.laixiaddzPlayerGold + v.ItemCount
        end
        if v.ItemID == 1002 then
            laixiaddz.LocalPlayercfg.laixiaddzPlayerGiftCoupon = laixiaddz.LocalPlayercfg.laixiaddzPlayerGiftCoupon + v.ItemCount
        end
    end

    if StatusCode.new(packet.data.Status):isOK() then
        laixiaddz.LocalPlayercfg.laixiaddzIsInMatch = false
        laixiaddz.LocalPlayercfg.laixiaddzisMatchDetail = false

        local match = laixiaddz.LocalPlayercfg.laixiaddzMatchdata
        if #match == 0 then
            return
        end
        local red_temp = match[laixiaddz.LocalPlayercfg.laixiaddzGameListIndex].rooms
        for i = 1, #red_temp do
            if (laixiaddz.LocalPlayercfg.laixiaddzMatchRoom == red_temp[i].RoomID) then
                laixiaddz.LocalPlayercfg.laixiaddzMatchdata[laixiaddz.LocalPlayercfg.laixiaddzGameListIndex].rooms[i].CurJoinNum = laixiaddz.LocalPlayercfg.laixiaddzMatchdata[laixiaddz.LocalPlayercfg.laixiaddzGameListIndex].rooms[i].CurJoinNum - 1
                laixiaddz.LocalPlayercfg.laixiaddzMatchdata[laixiaddz.LocalPlayercfg.laixiaddzGameListIndex].rooms[i].Sate = 2
                laixiaddz.LocalPlayercfg.laixiaddzMatchdata[laixiaddz.LocalPlayercfg.laixiaddzGameListIndex].rooms[i].SelfJoin = 0
            end
        end
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHLISTDETAIL_WINDOW) -- 关闭详情页
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_MATCHSTATE_WINDOW)
        --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_QUIT_MATCHJOIN_WINDOW)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_MAST_MATCHJOIN_WINDOW) -- 进入比赛

        if laixiaddz.LocalPlayercfg.laixiaddzJoinMatch == true then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW, "已取消上一场报名")
        else
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW, "退赛成功")
        end
    else
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHJOIN_WINDOW)
    end

end

return
    {
        ID = _laixiaddz_PACKET_SC_ExitMatchGameID,

        name = "SCExitMatchGame",
        data_array =
        {
            { "GameID", Type.Byte },
            { "Status", Type.Short },
            { "Cost", Type.Array, Type.TypeArray.ResultItem },-- 返回的消耗
        },
        HandlerFunction = onPacketQuitRegistrationRet,
    }