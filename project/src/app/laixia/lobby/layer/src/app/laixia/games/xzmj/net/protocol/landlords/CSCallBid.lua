--region 叫牌/抢地主

local Type = import("...DataType")

CSCallBid =
    {
        ID=_LAIXIA_PACKET_CS_CallBidID ,--叫牌/强地主
        name = "CSCallBid",
        data_array =
        {
            {"CallType",Type.Byte},            --类型    0：叫分  1：抢地主
            {"CallChip",Type.Byte},            --倍数   BidType
            {"TableID",Type.Int},         --牌桌ID
            {"RoomID",Type.Byte},          --房间ID
        },

    };

return CSCallBid


