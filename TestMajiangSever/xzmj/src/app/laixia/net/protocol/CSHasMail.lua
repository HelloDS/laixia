local Type = import("..DataType")

local CSHasMail =
    {
        ID = _LAIXIA_PACKET_CS_HasMailID ,
        name = "CSHasMail" ,
        data_array=
        {
            {"GameID",Type.Short},
            {"Type", Type.Byte},
        }

    }

return CSHasMail