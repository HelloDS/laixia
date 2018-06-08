local Type = import("...DataType")

return
    {
        ID = _LAIXIA_PACKET_CS_FlopInitID,
        name = "CSFlopInit",
        data_array =
        {
            { "IsInit", Type.Byte },  --0 ��ʾ������1��ʾ����
        }
    }
