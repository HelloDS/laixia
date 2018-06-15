-- 快速开始 返回消息

local Type = import("...DataType")
local StatusCode = import("...StatusCode")

local function onGCQuickStartRetPacket(packet)

    local StatusID = packet:getValue("StatusID")
    if StatusCode.new( StatusID ):isOK() == true then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_CLEAR_DATELANDLORDTABLE_WINDOW, "快速开始清理数据")
        laixia.LocalPlayercfg.LaixiaRoomID = packet:getValue("RoomID")
        if laixia.LocalPlayercfg.LaixiaRoomID ~= laixia.config.LAIXIA_SUPERROOM_ID then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_LANDLORDTABLE_WINDOW,packet.data)
        end
        laixia.LocalPlayercfg.LaixiaInGolds = packet:getValue("InGold") -- 获取当前进入房间的金数
    end
end

local SCQuickOpen =
    {
        ID = _LAIXIA_PACKET_SC_QuickOpenID,
        name = "SCQuickOpen",
        data_array =
        {
            { "StatusID", Type.Short },
            { "RoomID", Type.Byte },-- 房间ID
            { "InGold", Type.Int },-- 当前牌桌携带金数
            { "CardCountTime", Type.Double },-- 记牌器过期时间
            { "TimesTamp", Type.Double },-- 服务器时间
        },
        HandlerFunction = onGCQuickStartRetPacket,
    }

return SCQuickOpen