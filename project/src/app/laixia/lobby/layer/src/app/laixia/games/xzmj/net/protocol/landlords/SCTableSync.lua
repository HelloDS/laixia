-- region 牌桌同步

local Type = import("...DataType")

local function TableSynchronousPacket(packet)
    laixiaddz.loggame("\n\n牌桌同步消息 _LAIXIA_PACKET_SC_TableSyncID\n\n")
    dumpGameData(packet.data, "牌桌同步数据")
    laixiaddz.loggame("RoomID " .. packet.data.RoomID)
    laixiaddz.loggame("TableID " .. packet.data.TableID)

    -- 断网重连时 清除用
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MATCHWAITLOADING_WINDOW)
    -- 比赛断线重连时候关闭等待界面
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_WAITSTATE_WINDOW)
    -- 删掉显示阶段
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MATCHRESULT_WINDOW)
    -- 隐藏结算

    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_CLEAR_DATELANDLORDTABLE_WINDOW, "牌桌同步清除数据")
    laixia.LocalPlayercfg.LaixiaisConnectCardTable = true
    if packet.data.TimesTamp == nil then
        packet.data.TimesTamp = socket.gettime() * 1000
    end
    laixia.LocalPlayercfg.LaixiaRoomID = packet.data.RoomID

    laixia.LocalPlayercfg.LaixiaLandlordSeat = packet.data.BottomSeat
    for k, v in ipairs(packet.data.Players) do
        if v.PID == laixia.LocalPlayercfg.LaixiaPlayerID then
            laixia.LocalPlayercfg.LaixiaMySeat = v.Seat
            laixia.LocalPlayercfg.MatchGold = v.Coin
            break
        end
    end
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_INITSYN_LANDLORDTABLE_WINDOW, packet.data)

end

SCTableSync =
    {
        ID = _LAIXIA_PACKET_SC_TableSyncID,
        -- 牌桌同步,
        name = "SCTableSync",
        data_array =
        {
            { "RoomID", Type.Byte },-- 房间号
            { "CreateType", Type.Byte },-- 创建牌桌类型，0 组桌，1 开桌
            { "RoomType", Type.Byte}, --房间类型

            { "TableType", Type.Byte },-- 牌桌类型 显示 0表示叫分模式  1表示抢分模式
            { "TableID", Type.Int },-- 牌桌号
            { "MasterID", Type.Int },-- 创建牌桌房主ID
            { "Stage", Type.Byte },-- 牌桌阶段(0:"Idle"空闲  1:"Bid"叫分 2:"Grab"抢地主 3:"Ming"名牌 4:"Opening"开局 5:"End"结算)
            --牌桌阶段(0:"Idle"空闲  1:"Bid"叫分 2:"Grab"抢地主 3:"Ming"开具 4:"Opening"结算 5:"End"流局 6 创建牌桌等待开局 7解散中)
            { "Inning", Type.Byte },-- 创建牌桌当前局数
            { "TotalInning", Type.Byte },-- 创建牌桌总局数
            { "Ming", Type.Byte },-- 明牌
            { "BottomSeat", Type.Byte },-- 庄家座号 --地主座号
            { "Laizi", Type.Byte },-- 癞子牌
            { "CurrentSeat", Type.Byte },-- 当前操作玩家
            { "BaseValue", Type.Int },-- 底分
            { "DoubleValue", Type.Int },-- 倍数
            { "Expense", Type.Int },-- 每局牌桌消费数--手续费
            { "Time", Type.Int },-- 状态剩余时间
            { "ItemCount", Type.Int },-- 奖券数量--奖励数量
            { "Cond", Type.Int },-- 连续N局获得奖励
            { "Info", Type.UTF8 },-- 房间内显示房间所属的名字--比赛房间名称
            { "BottomCards", Type.Array, Type.TypeArray.Card },-- 底牌
            { "TimesTamp", Type.Double },-- 同步时间
            { "CurChip" , Type.Byte}, --叫的分数
            --是否确认了继续
            { "isJixu" , Type.Byte},
            { "Players", Type.Array, Type.TypeArray.Players },--玩家基本信息

        },
        HandlerFunction = TableSynchronousPacket,
    };

return SCTableSync

