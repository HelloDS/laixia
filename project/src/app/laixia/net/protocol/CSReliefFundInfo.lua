local Type = import("..DataType")

CSReliefFundInfo =
    {
        ID=_LAIXIA_PACKET_CS_ReliefFundInfoID ,--领取救济金,
        name = "CSReliefFundInfo",
        data_array =
        {
            {"Code",Type.Short},
            {"GameID",Type.Short},
        },

    };
return  CSReliefFundInfo

