local Type = import("...DataType")

CSCreateTable =
    {
        ID=_laixiaddz_PACKET_CS_CreateTableID ,
        name = "CSCreateTable",
        data_array =
        {

            { "RoomType",Type.Byte},    --消耗类型  --  0 金币，1是道具
            { "Count", Type.Byte },     --总局数
            { "CreateID", Type.Byte },  --创建房间ID
            { "OptionID", Type.Byte },  --创建ID
            { "difen",	Type.Byte}, --底分
        },

    };
return  CSCreateTable