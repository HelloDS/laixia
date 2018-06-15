
local Type = import("..DataType")

local CSBankruptBag =
    {
        ID = _LAIXIA_PACKET_CS_BankruptBagID ,
        name = "CSBankruptBag" ,
        data_array=
        {
            {"Code",Type.Short},
            {"GameID",Type.Byte}
        }
    }

return CSBankruptBag
