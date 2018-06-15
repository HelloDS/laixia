local Type = import("..DataType")

local CSServiceNotice =
    {
        ID = _LAIXIA_PACKET_CS_ServiceNoticeID ,
        name = "CSServiceNotice" ,
        data_array=
        {
            { "Code",Type.Short},
            { "GameID", Type.Short }
        }
    }

return CSServiceNotice