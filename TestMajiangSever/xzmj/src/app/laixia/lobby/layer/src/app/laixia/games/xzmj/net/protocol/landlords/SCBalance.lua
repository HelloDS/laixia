
local Type = import("...DataType")

local function SCBalancePacket(packet)
    --dump(packet.data)
    laixiaddz.loggame("牌桌结算消息 _LAIXIA_PACKET_SC_BalanceID") 
    dumpGameData(packet.data,"")

    if  laixia.LocalPlayercfg.LaixiaCurrentWindow == "CardTableDialog" and ui.CardTableDialog.mRoomID == packet.data.RoomID then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SPRING_LANDLORDTABLE_WINDOW,packet.data)
    else
  
    end
end

SCBalance =   -- 结算,
{
    ID = _LAIXIA_PACKET_SC_BalanceID,
    
    name = "SCBalance",
    data_array =
    {
        { "RoomID",Type.Byte },
        { "TableID",Type.Int },
        { "Status", Type.Byte },--地主胜负，0失败1胜利
        { "BaseValue", Type.Int }, --底分
        { "Spring",Type.Byte },-- 是否春天  1为春天 0表示非春天
        { "DoubuleValue", Type.Int },--倍数
        { "difen", Type.Int}, --底分
        { "boomTimes" ,Type.Int},--炸弹数
        { "RooketTimes",Type.Int},--火箭数
        { "CSBalance", Type.Array, Type.TypeArray.CSBalance },--玩家胜负数据
       
        
        
        
    },
        HandlerFunction = SCBalancePacket,
};
return  SCBalance

