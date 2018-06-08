local Type = import("...DataType")

return
    {
        ID = _LAIXIA_PACKET_CS_TenThousandBetID,
        name = "CSTenThousandBet",
        data_array =
        {
            { "Type", Type.Byte }, --���ͣ�0 ����1�ϣ�2 �� 3 ����
            { "Chip", Type.Int },  -- ��ע���
        },
    }
