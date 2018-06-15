
local Type = import("...DataType")
local function onPacketMatchPhaseChangeRet(packet)
    local Ranks = packet:getValue("Ranks")
    local rank = packet:getValue("Rank")
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_WAITSTATE_WINDOW,{RANKS =Ranks,
        RANK = rank})-- 阶段等待
end

return
    {
        ID = _LAIXIA_PACKET_SC_MatchPhaseChangeID,
        name = "SCMatchPhaseChange",
        data_array =
        {
            {"GameID", Type.Byte }, -- 游戏ID
            {"Rank", Type.Int}, -- 当前晋级数量
            {"Ranks",Type.Array ,Type.Int },  --晋级信息

        },
        HandlerFunction = onPacketMatchPhaseChangeRet,
    }

--endregion
