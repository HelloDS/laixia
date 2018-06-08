
local Type = import("...DataType")

local function onPacketSCSelfBuildRewardRet(packet)
    local data = packet.data
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SELFBUILDING_REWARDS,data)
end

return
    {
        ID = _laixiaddz_PACKET_SC_SelfBuildRewardRetID,
        name = "SCSelfBuildRewardRet",
        data_array =
        {
            {"Rank", Type.Byte},
            {"PlayerID", Type.Int},
            {"Rewards",Type.Array,Type.TypeArray.RewardVo},

        },
        HandlerFunction = onPacketSCSelfBuildRewardRet,
    }
