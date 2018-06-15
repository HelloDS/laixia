
local Type = import("...DataType")
local StatusCode = import("...StatusCode")

local function onPacketSCOnlineRoom(packet)
    local roomID = packet:getValue("RoomID");
   
    if roomID == laixia.config.LAIXIA_SUPERROOM_ID or (roomID > 0 and roomID <100) then
        laixia.LocalPlayercfg.LaixiaRoomID = roomID;
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_RECONNECTION_WINDOW,roomID)
    else
        local reconn_str = cc.UserDefault:getInstance():getStringForKey("lastwindow")
        local reconn_time = cc.UserDefault:getInstance():getDoubleForKey("lastwindow_time")
        local reSign_time = cc.UserDefault:getInstance():getDoubleForKey("sign_time")
        if tonumber(os.time()) - tonumber(reconn_time) <=5*60 then
             
            local stream = laixia.Packet.new("CSHallLobbyy", _LAIXIA_PACKET_CS_HallLobbyID)
            stream:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
            stream:setValue("GameID", laixia.config.GameAppID)
            laixia.net.sendHttpPacketAndWaiting(stream)
            
            local CSHasShouChong = laixia.Packet.new("CSFirstSuperBag", _LAIXIA_PACKET_CS_FirstSuperBagID)
            CSHasShouChong:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
            CSHasShouChong:setValue("GameID", laixia.config.GameAppID)
            laixia.net.sendHttpPacket(CSHasShouChong)

            local stream = laixia.Packet.new("CSSignLanding", _LAIXIA_PACKET_CS_SignLandingID)
            stream:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
            stream:setValue("GameID", laixia.config.GameAppID)
            laixia.net.sendHttpPacketAndWaiting(stream)
            --小于五分钟 则回到之前的界面
            if laixia.kconfig.isYingKe ~= true then
                if reconn_str == "ddz_GameRoomGround" then
                    local mRoomType = 2 --经典场
                    laixia.LocalPlayercfg.OnReturnFunction = _LAIXIA_EVENT_UPDATE_SELECTROOM_WINDOW
                    local stream = laixia.Packet.new("EnterListRoom", _LAIXIA_PACKET_CS_ListRoomID)
                    stream:setValue("RoomType", mRoomType)
                    laixia.net.sendPacketAndWaiting(stream)
                elseif reconn_str == "ddz_GameListWindow" then
                     --发送我本地版本号
                    --if device.platform~="windows" then
                        local version = cc.UserDefault:getInstance():getStringForKey("version")
                        if version ~=nil and version~="" then
                        elseif version==nil or version=="" then
                                version = "2.0.14"
                        end
                        
                        local stream = laixia.Packet.new("CSGetVersion", _LAIXIA_PACKET_CS_GETVERSION)
                        stream:setValue("Code", 0)
                        stream:setValue("GameID", 1)
                        stream:setValue("GameVersion",version)
                        laixia.net.sendHttpPacketAndWaiting(stream,nil,2)       
                    --end

                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MATCHLIST_WINDOW)
                    laixia.LocalPlayercfg.OnReturnFunction = _LAIXIA_EVENT_SHOW_MATCHLIST_WINDOW
                    --请求比赛场标签页
                    local CSMatchSignPacket = laixia.Packet.new("CSMatchSign", _LAIXIA_PACKET_CS_MatchSignID)
                    CSMatchSignPacket:setValue("GameID", laixia.config.GameAppID)
                    laixia.net.sendPacketAndWaiting(CSMatchSignPacket)  
                    -- --请求比赛场数据
                    -- local CSMatchListPacket = laixia.Packet.new("CSMatchGame", _LAIXIA_PACKET_CS_MatchGameID)
                    -- CSMatchListPacket:setValue("GameID", laixia.config.GameAppID)
                    -- CSMatchListPacket:setValue("PageType", 1 )
                    -- laixia.net.sendPacketAndWaiting(CSMatchListPacket)
                else
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW);
                end
            else
                ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW);
            end
        else
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW);
        end
        if laixia.LocalPlayercfg.LaixiaContinuousLoginData ~= nil then
            if tonumber(os.time()) - tonumber(reSign_time) >= 60*60 and laixia.LocalPlayercfg.LaixiaContinuousLoginData.IsSign == 1 then  --1个小时后重登，显示活动界面
                 -- ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_ACTIVITY_WINDOW)
                local CSPackItems = laixia.Packet.new("CSActivity",_LAIXIA_PACKET_CS_ActivityID)
                CSPackItems:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
                CSPackItems:setValue("GameID", laixia.config.GameAppID)
                laixia.net.sendHttpPacketAndWaiting(CSPackItems)
            end
        end

        laixia.LocalPlayercfg.LaixiaisConnectCardTable = false

    end

end

return
    {
        ID = _LAIXIA_PACKET_SC_OnlineRoomID,
        name = "SCOnlineRoom",
        data_array =
        {
            {"Status", Type.Short },
            {"RoomID", Type.Byte },
        },
        HandlerFunction = onPacketSCOnlineRoom,
    }

--endregion
