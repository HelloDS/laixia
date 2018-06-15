local Type = import("...DataType")

local CSFruitAddBet = {

        ID = _LAIXIA_PACKET_CS_FruitAddBetID,

        name = "CSFruitAddBet",

        data_array =
        {
            { "FruitType", 	Type.Int },  --ˮ������
            { "BetAmount", 	Type.Int },  --��ע���
        },
}

return CSFruitAddBet