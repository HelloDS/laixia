--region 出牌请求

local Type = import("...DataType")
CSPlayCards =
    {
        ID=_laixiaddz_PACKET_CS_PlayCardsID ,--出手牌,
        name = "CSPlayCards",
        data_array =
        {
            {"TableID",Type.Int},      --桌号
            {"CardType",Type.Byte},    --出牌类型对应（0-16）
            {"ReplaceCards",Type.Array,Type.TypeArray.Card},      --被替换的牌值      -- 出牌有癞子牌并且癞子牌不是其本身才赋值
            {"PlayCards",Type.Array,Type.TypeArray.Card},      --出的牌值
            {"RoomID",Type.Byte},      --房间号
        },

    };

return CSPlayCards


