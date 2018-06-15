local Type = import("..DataType")
local tinsert = table.insert;
local tonumber = tonumber;
local laixia = laixia;
local db2 = laixia.JsonTxtData;

local function onPacketHandler(packet)

    local param = packet.data
    print(param)
    local broadcastDBM = laixia.JsonTxtData:queryTable("mail_mode");
    local msg = broadcastDBM:queryMessageByID(param.noticeIds,param.Param);

    print(msg)
    if not msg then
        return;
    end
    local shows = msg.show
    local showArr = string.split(shows,"|")
    if #showArr <= 0 then
        return
    end
    for k,v in ipairs(showArr) do
        local key = tonumber(v)
        if key == 1 then
            tinsert(laixia.LocalPlayercfg.LaixiaBroadCastInPokerRoom,msg)
            tinsert(laixia.LocalPlayercfg.LaixiaBroadCastInPokerRoomCoupon,msg)
            tinsert(laixia.LocalPlayercfg.LaixiaBroadCastInPokerRoomMatch,msg)
            tinsert(laixia.LocalPlayercfg.LaixiaBroadCastInInHall,msg)
        elseif key == 2 then
            tinsert(laixia.LocalPlayercfg.LaixiaBroadCastInPokerRoom,msg)
        elseif key == 3 then
            tinsert(laixia.LocalPlayercfg.LaixiaBroadCastInPokerRoomCoupon,msg)
        elseif key == 4 then
            tinsert(laixia.LocalPlayercfg.LaixiaBroadCastInPokerRoomMatch,msg)
        elseif key == 5 then

        elseif key == 6 then
            tinsert(laixia.LocalPlayercfg.LaixiaBroadCastInInHall,msg)
        elseif key== 7 then

        elseif key == 8 then

        elseif key == 100 then
            tinsert(laixia.LocalPlayercfg.LaixiaBroadCastInPokerRoom,msg)
            tinsert(laixia.LocalPlayercfg.LaixiaBroadCastInPokerRoomCoupon,msg)
            tinsert(laixia.LocalPlayercfg.LaixiaBroadCastInPokerRoomMatch,msg)
            tinsert(laixia.LocalPlayercfg.LaixiaBroadCastInInHall,msg)


        end
    end
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_BROADCASTS_WINDOW)

end

return
    {
        ID = _LAIXIA_PACKET_SC_RotateNoticeID,
        name = "SCRotateNotice",
        data_array =
        {
            {"GameID",Type.Byte},
            {"noticeIds",Type.UTF8},
            {"Param",Type.Array,Type.UTF8},
        },
        HandlerFunction = onPacketHandler,
    }


