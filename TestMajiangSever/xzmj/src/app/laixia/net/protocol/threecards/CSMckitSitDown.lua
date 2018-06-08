local Type = import("...DataType")

return
    {
        ID = _LAIXIA_PACKET_CS_MckitSitDownID,
        name = "CSMckitSitDown",
        data_array =
        {
            {"roomId", Type.Byte},  --  ������
            {"tableId", Type.Int}   --  ����id
        },
    }
