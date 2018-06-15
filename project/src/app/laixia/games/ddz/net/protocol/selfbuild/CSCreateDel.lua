local Type = import("...DataType")

CSCreateDel =
    {
        ID=_laixiaddz_PACKET_CS_CreateDelID ,
        name = "CSCreateDel",
        data_array =
        {

            { "TableID",Type.Int}, --解散牌桌ID
            { "Status", Type.Int},--1为同意 0不同意

        },

    };
return  CSCreateDel