local Type = import("..DataType")

CSReliefFund =
    {
        ID=_LAIXIA_PACKET_CS_ReliefFundID ,
        name = "CSReliefFund",
        data_array =
        {
            {"Code",Type.Short},
            {"GameID",Type.Short},
        },

    };
return  CSReliefFund

