
local Type = import("...DataType")

local function onPacketMatchResult(packet) -- 胜利结算
    local rank = packet:getValue("Rank")
    local data={}
    data.rank =  packet:getValue("Rank")
    data.rewards =packet:getValue("Rewards")
    data.roomID = packet:getValue("RoomID")
    data.GameType = packet:getValue("GameType")
    data.ISWin= true

    laixiaddz.LocalPlayercfg.laixiaddzMatchRoom= packet:getValue("RoomID")
    laixiaddz.LocalPlayercfg.laixiaddzIsInMatch = false

    local isHas = false
   
        if laixiaddz.LocalPlayercfg.laixiaddzPropsData then
            for k,v in ipairs(packet.data.Rewards) do
                 if v.ItemID==1001 then
                    laixiaddz.LocalPlayercfg.laixiaddzPlayerGold = laixiaddz.LocalPlayercfg.laixiaddzPlayerGold + v.ItemCount
                elseif v.ItemID==1002 then
                    laixiaddz.LocalPlayercfg.laixiaddzPlayerGiftCoupon = laixiaddz.LocalPlayercfg.laixiaddzPlayerGiftCoupon + v.ItemCount
                elseif v.ItemObjectID==0 then
                else
                    if not v.ItemObjectID and v.ItemObjectID ~= 0 then
                        isHas=false
                        for j, k in  ipairs(laixiaddz.LocalPlayercfg.laixiaddzPropsData) do
                            if k.ItemObjectID == v.ItemObjectID then
                                isHas=true
                                k.ItemCount = v.ItemCount
                            end
                        end
                    end
                    if isHas==false then
                        table.insert(laixiaddz.LocalPlayercfg.laixiaddzPropsData,v)
                    end
                end
            end
        end
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHRESULT_WINDOW,data);
end

return
    {
        ID = _laixiaddz_PACKET_SC_MatchResultID,
        name = "SCMatchResult",
        data_array =
        {
            {"GameID",Type.Byte},
            {"RoomID",Type.Int},
            {"Rewards",Type.Array,Type.TypeArray.ResultItem},
            {"Rank",Type.Int},
            {"GameType",Type.Int},
        },
        HandlerFunction = onPacketMatchResult,
    }


