--
-- Author: feng
-- Date: 2018-03-26 14:41:39
--

local Type = import("...DataType") 
local CSMatchSign =
    {
        ID = _LAIXIA_PACKET_CS_MatchSignID ,
        name = "CSMatchSign",

        data_array =
        {
        	--点击比赛场 请求比赛列表  发什么数据？
            {"GameID", Type.Byte},
            -- {"PageType",Type.Byte},
        }
    }
return CSMatchSign