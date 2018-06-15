
local Type = import("...DataType")

local function TalkingPacket(packet)

    laixiaddz.logGame("表情消息" )
    dumpGameData(packet.data,"表情数据")
    local mesg={}
    mesg.seatId = packet:getValue("SeatID")
    mesg.chatType = packet:getValue("Type")
    mesg.info = packet:getValue("Info")
    --  print("------------------------------------------------------------------------------talk",mesg.info )
    if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" and laixiaddz.LocalPlayercfg.laixiaddzisConnectCardTable == true then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_TALKINGINFO_WINDOW, mesg)
    end
end

return
    {
        ID=_laixiaddz_PACKET_SC_TableTalkingID ,--聊天,
        name = "SCTableTalking",
        data_array =
        {
            {"Type",Type.Byte},
            {"SeatID",Type.Byte}, --座位号
            {"Info",Type.UTF8},
        },
        HandlerFunction = TalkingPacket,
    };

