-- region 继续游戏

local Type = import("...DataType")
local StatusCode = import("...StatusCode")

local function ContinueGamePacket(packet)
    dumpGameData(packet.data)
    if StatusCode.new(packet.data.StatusID):isOK() == true then
        laixiaddz.LocalPlayercfg.laixiaddzRoomID = packet.data.RoomID
        if laixiaddz.LocalPlayercfg.laixiaddzRoomID ~= laixiaddz.config.laixiaddz_SUPERROOM_ID then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_CONTINUEGOLD_LANDLORDTABLE_WINDOW, packet.data)
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_CLEAR_DATELANDLORDTABLE_WINDOW, "继续游戏调用")
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_WAITTINGCARTOON_WINDOW)
        end
    end
end

return
    {
        ID = _laixiaddz_PACKET_SC_ContinueGameID,-- 继续游戏
        name = "CSContinueGame",
        data_array =
        {
            { "StatusID", Type.Short },
            { "RoomID", Type.Byte },
            { "Gold", Type.Double },-- 房间内带入的金数量
        },

        HandlerFunction = ContinueGamePacket,
    };

