local Type = import("...DataType")
local StatusCode = import("...StatusCode")

--所有创建房间的roomID 为50
local function onPacketSCCreateTableRet(packet)
    if StatusCode.new(packet.data.StatuID):isOK() == true  then
        local data = packet.data

        local packetArray = {}
        packetArray.RoomID = 50
        packetArray.RoomType  = data.RoomType
        packetArray.BaseScore  = data.difen--1
        packetArray.MinCoin  = 0
        packetArray.TableID  = data.TableID
        packetArray.Count  = 1
        packetArray.CardCountTime  = data.CardCountTime
        packetArray.TimesTamp  = data.TimesTamp
        packetArray.BossID  =  laixia.LocalPlayercfg.LaixiaPlayerID

        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_LANDLORDTABLE_WINDOW,packetArray)
    end
end

return
    {
        ID = _LAIXIA_PACKET_SC_CreateTableRetID,
        name = "SCCreateTableRet",
        data_array =
        {
            {"StatuID", Type.Short},
            {"RoomType", Type.Byte}, --  0表示欢乐场，1表示癞子场 5表示经典场
            {"TableID", Type.Int},   --牌桌ID
            {"Count", Type.Byte},    --局数  --总局数
            {"CardCountTime", Type.Double },-- 记牌器过期时间
            {"TimesTamp", Type.Double },-- 服务器时间
            {"difen",Type.Byte},--底分

        },
        HandlerFunction = onPacketSCCreateTableRet,
    }
