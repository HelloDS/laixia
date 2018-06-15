local Type = import("...DataType")

CSCreateGoon =
    {
        ID = _LAIXIA_PACKET_CS_CreateGoonID ,
        name = "CSCreateGoon",
        data_array =
        {

            { "TableID",Type.Int}, --解散牌桌ID

        },

    };
return  CSCreateGoon