--ios充值回调消息
local Type = import("..DataType")

CSWeekOrMonthCard =
    {
        ID=_LAIXIA_PACKET_CS_WeekOrMonthCardID ,
        name = "CSWeekOrMonthCard",
        data_array =
        {
            { "Code",Type.Short},
            { "AppID",Type.Short}, --游戏应用ID

        },

    };
return  CSWeekOrMonthCard


