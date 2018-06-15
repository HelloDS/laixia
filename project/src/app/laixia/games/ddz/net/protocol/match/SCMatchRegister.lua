
local Type = import("...DataType")
local StatusCode = import("...StatusCode")

local function onPacketMatchRegistration(packet)

    local db2 = laixiaddz.JsonTxtData;
    local itemDBM = db2:queryTable("items");


    if (packet:getValue("Status")==0)  then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW, "报名成功")-- 报名成功飘字
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHRESULT_WINDOW) -- 隐藏结算
        laixiaddz.LocalPlayercfg.laixiaddzRoomID = packet:getValue("RoomID")
        laixiaddz.LocalPlayercfg.laixiaddzMatchRoom = packet:getValue("RoomID")
        laixiaddz.LocalPlayercfg.laixiaddzMatchRoomType = packet:getValue("RoomType")
        laixiaddz.LocalPlayercfg.laixiaddzMatchLimit = packet:getValue("Limit")

        --减掉报名费
        local cost = packet:getValue("Cost")
        for i, v in pairs(cost) do
            local Itemsdata = itemDBM:query("ItemID",v.ItemID);
            --laixiaddz.db.ItemsDataManager:getItemByItemID(v.ItemID)
            if v.ItemID == 1001 then
                laixiaddz.LocalPlayercfg.laixiaddzPlayerGold = laixiaddz.LocalPlayercfg.laixiaddzPlayerGold + v.Count
            end
            if v.ItemID == 1002 then
                laixiaddz.LocalPlayercfg.laixiaddzPlayerGiftCoupon = laixiaddz.LocalPlayercfg.laixiaddzPlayerGiftCoupon + v.Count
            end
        end

        if 1 == packet.data.RoomType then
            if laixiaddz.LocalPlayercfg.laixiaddzCurrentNomarlWindow ~= "GameListWindow_detail" and laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow  =="GameListWindow"  then  -- 如果是比赛列表并且不是比赛详情，则请求比赛前详情（比赛结束继续比赛用）
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_MATCHDETAIL_WINDOW)
            end
            laixiaddz.LocalPlayercfg.laixiaddzisMatchDetail = true  --报名成功显示，人满的的进度条
        elseif 0 == packet.data.RoomType then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHLISTDETAIL_WINDOW)         -- 关闭详情页
            if laixiaddz.LocalPlayercfg.laixiaddzGamePageType == 0 then
                laixiaddz.LocalPlayercfg.laixiaddzGamePageType = 1
            end
        end

        local match = laixiaddz.LocalPlayercfg.laixiaddzMatchdata
        if #match == 0 then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_MATCHDETAIL_WINDOW) 
            return
        end
        local red_temp = match[laixiaddz.LocalPlayercfg.laixiaddzGameListIndex].rooms
        for i = 1, #red_temp do
            if (laixiaddz.LocalPlayercfg.laixiaddzMatchRoom == red_temp[i].RoomID) then
                laixiaddz.LocalPlayercfg.laixiaddzMatchdata[laixiaddz.LocalPlayercfg.laixiaddzGameListIndex].rooms[i].CurJoinNum = laixiaddz.LocalPlayercfg.laixiaddzMatchdata[laixiaddz.LocalPlayercfg.laixiaddzGameListIndex].rooms[i].CurJoinNum + 1
                laixiaddz.LocalPlayercfg.laixiaddzMatchdata[laixiaddz.LocalPlayercfg.laixiaddzGameListIndex].rooms[i].Sate = 2
                laixiaddz.LocalPlayercfg.laixiaddzMatchdata[laixiaddz.LocalPlayercfg.laixiaddzGameListIndex].rooms[i].SelfJoin = 1
            end
        end
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_JOIN_MATCHJOIN_WINDOW,packet.data)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_MATCHSTATE_WINDOW) -- 更新按钮状态 

    elseif (packet:getValue("Status")==1 ) then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHLISTDETAIL_WINDOW)
        if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "GameListWindow" then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_GAMELIST_GOGAMELIST)
        end
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW, "报名失败，比赛已过期。")
    else

        laixiaddz.LocalPlayercfg.laixiaddzInGolds  = packet:getValue("Value")
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHLISTDETAIL_WINDOW)--关闭详情页
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_GAMELIST_GOGAMELIST)
        StatusCode.new(packet.data.Status)

    end
end


return
    {
        ID=_laixiaddz_PACKET_SC_MatchRegisterID,

        name = "SCMatchRegister",
        data_array =
        {
            { "GameID", Type.Byte },-- 游戏ID
            { "RoomType", Type.Byte },-- 房间类型，1，人满开赛 。0，定时开赛
            { "Status", Type.Short },-- 结果状态
            { "RoomID",Type.Int},
            { "Limit", Type.Int },-- 人满开赛人数限制
            { "Value", Type.Int },-- 当前人数或者剩余时间
            { "Cost", Type.Array, Type.TypeArray.Cost },-- 返回消耗
        },

        HandlerFunction = onPacketMatchRegistration,
    }
