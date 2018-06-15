--获取最近的定时开赛的比赛

local Type = import("...DataType")

local CSMatchOpenRecentTime = {

        ID = _LAIXIA_PACKET_CS_MatchOpenRecentTimeID,

        name = "CSMatchOpenRecentTime",

        data_array =
        {
            {"GameID",Type.Byte},
        },
}

return CSMatchOpenRecentTime

--endregion
