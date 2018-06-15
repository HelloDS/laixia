
local Type = import("...DataType")
local StatusCode = import("...StatusCode")

local function onPacketSCOnlineRoom(packet)
    local roomID = packet:getValue("RoomID");
   
    if roomID == laixiaddz.config.laixiaddz_SUPERROOM_ID or (roomID > 0 and roomID <100) then
        laixiaddz.LocalPlayercfg.laixiaddzRoomID = roomID;
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_RECONNECTION_WINDOW,roomID)
    else
        local reconn_str = cc.UserDefault:getInstance():getStringForKey("lastwindow")
        local reconn_time = cc.UserDefault:getInstance():getDoubleForKey("lastwindow_time")
        local reSign_time = cc.UserDefault:getInstance():getDoubleForKey("sign_time")
        if tonumber(os.time()) - tonumber(reconn_time) <=5*60 then
             
            local stream = laixiaddz.Packet.new("CSHallLobbyy", _laixiaddz_PACKET_CS_HallLobbyID)
            stream:setValue("Code", laixiaddz.LocalPlayercfg.laixiaddzHttpCode)
            stream:setValue("GameID", laixiaddz.config.GameAppID)
            laixiaddz.net.sendHttpPacketAndWaiting(stream)
            
            local CSHasShouChong = laixiaddz.Packet.new("CSFirstSuperBag", _laixiaddz_PACKET_CS_FirstSuperBagID)
            CSHasShouChong:setValue("Code", laixiaddz.LocalPlayercfg.laixiaddzHttpCode)
            CSHasShouChong:setValue("GameID", laixiaddz.config.GameAppID)
            laixiaddz.net.sendHttpPacket(CSHasShouChong)

            local stream = laixiaddz.Packet.new("CSSignLanding", _laixiaddz_PACKET_CS_SignLandingID)
            stream:setValue("Code", laixiaddz.LocalPlayercfg.laixiaddzHttpCode)
            stream:setValue("GameID", laixiaddz.config.GameAppID)
            laixiaddz.net.sendHttpPacketAndWaiting(stream)
            --小于五分钟 则回到之前的界面
            if laixiaddz.kconfig.isYingKe ~= true then
                if reconn_str == "ddz_GameRoomGround" then
                    local mRoomType = 2 --经典场
                    laixiaddz.LocalPlayercfg.OnReturnFunction = _laixiaddz_EVENT_UPDATE_SELECTROOM_WINDOW
                    local stream = laixiaddz.Packet.new("EnterListRoom", _laixiaddz_PACKET_CS_ListRoomID)
                    stream:setValue("RoomType", mRoomType)
                    laixiaddz.net.sendPacketAndWaiting(stream)
                elseif reconn_str == "ddz_GameListWindow" then
                     --发送我本地版本号
                    --if device.platform~="windows" then
                        local version = cc.UserDefault:getInstance():getStringForKey("version")
                        if version ~=nil and version~="" then
                        elseif version==nil or version=="" then
                            version = laixiaddz_ORIGIN_VERSION or "2.0.1"
                        end
                        
                        local stream = laixiaddz.Packet.new("CSGetVersion", _laixiaddz_PACKET_CS_GETVERSION)
                        stream:setValue("Code", 0)
                        stream:setValue("GameID", 1)
                        stream:setValue("GameVersion",version)
                        laixiaddz.net.sendHttpPacketAndWaiting(stream,nil,2)       
                    --end
                    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW)
                    laixiaddz.LocalPlayercfg.OnReturnFunction = _laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW
                    local CSMatchListPacket = laixiaddz.Packet.new("CSMatchGame", _laixiaddz_PACKET_CS_MatchGameID)
                    CSMatchListPacket:setValue("GameID", laixiaddz.config.GameAppID)
                    CSMatchListPacket:setValue("PageType", 1 )
                    laixiaddz.net.sendPacketAndWaiting(CSMatchListPacket)
                else
                    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW);
                end
            else
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW);
            end
        else
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW);
        end
        if laixiaddz.LocalPlayercfg.laixiaddzContinuousLoginData ~= nil then
            if tonumber(os.time()) - tonumber(reSign_time) >= 60*60 and laixiaddz.LocalPlayercfg.laixiaddzContinuousLoginData.IsSign == 1 then  --1个小时后重登，显示活动界面
                 -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_ACTIVITY_WINDOW)
                local CSPackItems = laixiaddz.Packet.new("CSActivity",_laixiaddz_PACKET_CS_ActivityID)
                CSPackItems:setValue("Code", laixiaddz.LocalPlayercfg.laixiaddzHttpCode)
                CSPackItems:setValue("GameID", laixiaddz.config.GameAppID)
                laixiaddz.net.sendHttpPacketAndWaiting(CSPackItems)
            end
        end

        laixiaddz.LocalPlayercfg.laixiaddzisConnectCardTable = false

    end

end

return
    {
        ID = _laixiaddz_PACKET_SC_OnlineRoomID,
        name = "SCOnlineRoom",
        data_array =
        {
            {"Status", Type.Short },
            {"RoomID", Type.Byte },
        },
        HandlerFunction = onPacketSCOnlineRoom,
    }

--endregion
