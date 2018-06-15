local Type = import("...DataType")
local StatusCode = import("...StatusCode")
local function onPacketSCJoinTableRet(packet)
    if 3 == packet.data.Status then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "房间不存在")
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SELFBUILD_DELALLNUM_WINDOW)
        return
    end

    if StatusCode.new(packet.data.Status):isOK() == true   then
        local  packetArray = {}

        packetArray.RoomID = 50
        packetArray.RoomType  = packet.data.RoomType
        packetArray.BaseScore  = packet.data.difen
        packetArray.MinCoin  = 0
        packetArray.TableID  = packet.data.TableID
        packetArray.Count  = 1   --服务器从0 开始
        --        packetArray.Count  = packet.data.Count   --服务器从0 开始
        packetArray.CardCountTime  = packet.data.CardCountTime
        packetArray.TimesTamp  = packet.data.TimesTamp2
        packetArray.BossID  = packet.data.BossID
        packetArray.isAppleDissmis = packet.data.isAppleDissmis
        packetArray.AppleDissUserSet = packet.data.AppleDissUserSet
        packetArray.AppleDissTime = packet.data.AppleDissTime

        --dumpGameData(packetArray)
        -- if ui.CardTableDialog.isShow == false  then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_LANDLORDTABLE_WINDOW,packetArray)
        -- end

    end
end

return
    {
        ID = _laixiaddz_PACKET_SC_JoinTableRetID,
        name = "SCJoinTableRet",
        data_array =
        {
            {"Status", Type.Short},
            {"RoomType", Type.Byte},
            {"Count", Type.Byte},
            {"TableID", Type.Int},
            {"BossID", Type.Int},   --房主id
            {"CardCountTime", Type.Double },-- 记牌器过期时间
            {"TimesTamp", Type.Double },-- 服务器时间
            {"difen",Type.Int},--底分
            {"isAppleDissmis",Type.Byte}, --1是在解散中
            {"AppleDissUserSet",Type.Array ,Type.TypeArray.AppleDissUserSet},--解散房间的数据
            {"AppleDissTime",Type.Int},
        },
        HandlerFunction = onPacketSCJoinTableRet,
    }
