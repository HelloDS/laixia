--
-- Author: peter
-- Date: 2017-12-21 14:43:04
--
local Type = import("..DataType")
local CSPersonBill =
    {
        ID = _LAIXIA_PACKET_CS_PERSONBILL,
        name = "CSPersonBill",
        data_array =
        {
           {"Code",Type.Short},
        }
    }

return CSPersonBill