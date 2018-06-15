
local Type = require("rebot.DataType")

local function onPacketMatchRegistration(packet)
    _G.EventDispatch:pushEvent("Resp_Rebot_SignUpMatch", packet)
end


return
    {
        ID=_LAIXIA_PACKET_SC_MatchRegisterID,

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
