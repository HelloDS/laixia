
local Type = import("...DataType")
local StatusCode = import("...StatusCode")

local function onSCEnterRoomPacket(packet)

    local StatusID = packet:getValue("StatusID")
    if StatusCode.new(StatusID):isOK() then
        laixia.LocalPlayercfg.LaixiaRoomID = packet:getValue("RoomID")

        if packet.data.FlowBureau == 1 then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_CLEAR_DATELANDLORDTABLE_WINDOW,"进入房间清除数据")
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_ANIMATION_LIUJU)
        end

        if laixia.LocalPlayercfg.LaixiaRoomID ~= laixia.config.LAIXIA_SUPERROOM_ID then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_LANDLORDTABLE_WINDOW,packet.data)
        end
    end
end

return
    {
        ID = _LAIXIA_PACKET_SC_EnterRoomID,
        name = "SCEnterRoom",
        data_array =
        {
            { "StatusID", Type.Short },
            { "EnterType", Type.Byte },-- 进入牌桌类型 0无牌桌 1在牌桌内
            { "FlowBureau", Type.Byte },-- 流局标记 0正常 1流局
            { "RoomID", Type.Byte },--进入房间返回未完成的房间ID 或者 返回正确的进入房间的房间ID
            { "TotalInning", Type.Int },-- 当前牌桌进行的局数
            { "CardCountTime", Type.Double },-- 记牌器过期时间
            { "TimesTamp", Type.Double },-- 服务器时间
        },
        HandlerFunction = onSCEnterRoomPacket
    }

