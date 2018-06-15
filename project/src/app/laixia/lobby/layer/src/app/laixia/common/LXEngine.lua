--[[
    来下引擎
    所有对接服务器接口，此处做统一处理
]]

local json = json or require("framework.json")
LXEngine = LXEngine or {}


if device.platform == "android" then
    luaj.callStaticMethod(APP_ACTIVITY, "registMessageCallback", {}, "()V") 
    luaj.callStaticMethod(APP_ACTIVITY, "registerConnectionCallback", {}, "()V") 
elseif device.platform == "ios" then
    --ios不用
end

--[[
    接收广播消息
]]
function received(event)
    print("3333333333333-----------")

	dump(event, "lua_received")
	local res = json.decode(event);
	local response
	for k,v in ipairs(res.ms) do
		response = v
		break
	end

	dump(response,"response")
	if response.tp == "PLO_RANK" then
	    local data={}
	    laixiaddz.LocalPlayercfg.LaixiaMatchRank=response.rank
	    laixiaddz.LocalPlayercfg.LaixiaMatchTotalNum=response.leftcnt
	    -- data.TabNum = packet:getValue("TabNum")
	    laixiaddz.LocalPlayercfg.laixiaddzIsInMatch = true

	    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_MATCHWAITLOADING_WINDOW, data);  --更新比赛等待界面数据
	    dump(data,"PLO_RANK")
	elseif response.tp == "PLO_ST_T_LEFT" then
		local data={}
	    -- laixiaddz.LocalPlayercfg.LaixiaMatchRank=response.rank
	    -- laixiaddz.LocalPlayercfg.LaixiaMatchTotalNum=response.leftcnt
	    data.TabNum = response.tabel_left
	    laixiaddz.LocalPlayercfg.laixiaddzIsInMatch = true

	    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_MATCHWAITLOADING_WINDOW, data);  --更新比赛等待界面数据
	    dump(data,"PLO_ST_T_LEFT")
	elseif response.tp == "SETS_T_LEFT" then --定居积分 用户

	elseif response.tp == "BEGIN_WAIT" then
		-- response = {key,uid,m_ins_id,start_time}
	    if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "ShopWindow" then 
	        --在商店界面不弹出 去比赛的弹窗
	        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHJOIN_WINDOW)
	    elseif laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" and laixiaddz.LocalPlayercfg.laixiaddzIsInMatch== true  then  
	        --此时在比赛牌桌内
	        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHJOIN_WINDOW)
	    elseif laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" and laixiaddz.LocalPlayercfg.laixiaddzisConnectCardTable == true then  
	        --此时在常规牌桌内
	        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHJOIN_WINDOW)  
	    else
	    	laixiaddz.LocalPlayercfg.laixiaddzIsInMatch = true
	    	local matchId
	    	-- m_ins_id 第一个"-"前是matchId
	    	local arr = string.split(response.m_ins_id or "","_")
	    	if arr and type(arr) == "table" then
	    		matchId = arr[1]
	    	end
	        -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHJOIN_WINDOW,
	        -- 	{
		       --  	START_TIME = tonumber(math.floor(response.start_time)), --秒
		       --  	MATCH_ID = matchId,
	        -- 	} 
	        -- )
	        local data = {}
	        data.RoomID = matchId
	        data.RoomType = 4 --比赛场标识位
        	laixia.LocalPlayercfg.laixiaddzJoinMatch = true
        	data.match_ins_id = response.match_ins_id
	        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_LANDLORDTABLE_WINDOW,data)
	    end
	    dump(response,"BEGIN_WAIT")
	elseif response.tp == "cancel_trusteeship" then
		   laixiaddz.logGame("取消托管消息" )
		    laixiaddz.logGame(response.seat)
		    laixiaddz.logGame(response.mandType)
		    local data = {}
		    data.Trusteeship =  response.mandType
		    data.Seat  = response.seat
		    	  
		    if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" and laixiaddz.LocalPlayercfg.LaixiaisConnectCardTable == true  then
		        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_MANDATE_LANDLORDTABLE_WINDOW,data)
		    end
	elseif response.tp == "create_table" or response.tp == "table_sys"  then
			local result = {}
			result.RoomID = response.roomID
			result.CreateType = response.createType-- 创建牌桌类型，0 组桌，1 开桌
			result.RoomType = response.roomType--房间类型
			result.TableType = response.tableType-- 牌桌类型 显示 0表示叫分模式  1表示抢分模式
			result.TableID = response.tableID -- 牌桌号
			result.MasterID =response.boss_id-- 创建牌桌房主ID
			result.Stage = response.stageType   -- 牌桌阶段(0:"Idle"空闲  1:"Bid"叫分 2:"Grab"抢地主 3:"Ming"名牌 4:"Opening"开局 5:"End"结算)
            --牌桌阶段(0:"Idle"空闲  1:"Bid"叫分 2:"Grab"抢地主 3:"Ming"开具 4:"Opening"结算 5:"End"流局 6 创建牌桌等待开局 7解散中)
            result.Inning = response.inning-- 创建牌桌当前局数
            result.TotalInning = response.totalInning-- 创建牌桌总局数
            -- result.Ming =response.dz_ming-- 明牌
            result.BottomSeat = response.bottomSeat -- 庄家座号 --地主座号
            -- result.Laizi = response.laizi-- 癞子牌
            result.CurrentSeat = response.currentSeat -- 当前操作玩家
            result.BaseValue = response.baseValue-- 底分
            result.DoubleValue = response.doubleValue -- 倍数
            result.Expense  = response.fee-- 每局牌桌消费数--手续费
            result.Time =  response.remainOperTm -- 状态剩余时间
            result.ItemCount = response.itemCnt-- 奖券数量--奖励数量
            result.Cond = response.cond-- 连续N局获得奖励
            result.Info = response.roomName-- 房间内显示房间所属的名字--比赛房间名称
            result.BottomCards = {}
            for k,CardValue in pairs(response.lordCards) do
            	local card = {}
            	card.CardValue = CardValue
            	table.insert(result.BottomCards,card)
            end
            result.TimesTamp = response.curTime-- 同步时间
            result.CurChip = response.curChip--叫的分数
            result.isJixu  = response.goOnState

            result.Players = {}
            for k,v in pairs(response.players) do
            	local player = {}
            	player.PID = v.uid

            	local stream =  laixia.Packet.new("userInfo", "LXG_USER_INFO")
			    stream:setReqType("get")
			    stream:setValue("uid", v.uid)
			    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
			        local data1 = event.userinfo
			        if event.dm_error == 0 then
			            player.NickName = data1.nick
			            player.Icon = data1.portrait
			        else
			            print("LXG_USER_INFO===获取失败")
			        end 
			    end) 

            	player.Nickname = v.nickname or "无名"
            	player.Icon = v.photo or  "http://39.106.111.17:11121/examples/ic_morenhead13.png"
            	player.Seat = v.seat
            	player.Coin = v.chip
            	player.Trust = v.trust
            	player.Sex = v.sex
            	player.PlayerCards = {}
            	dump(v.cards,"cards")
            	for k,cardtemp in pairs(v.cards) do
            		local  card = {}
            		card.CardValue = cardtemp
            		table.insert(player.PlayerCards,card)
            	end
            	player.MaxCard = v.num
            	player.PlayCards = {}
            	for k,outcard in pairs(v.playCards) do
            		local card = {}
            		card.CardValue = outcard
            		table.insert(player.PlayCards,card)
            	end
            	player.ReplaceCardss = {}
            	for k,repcard in pairs(v.replaceCards) do
            		local card = {}
            		card.CardValue = repcard
            		table.insert(player.ReplaceCardss,card)
            	end
            	player.Inning = v.inning
            	player.CardCountTime = v.noAdTime
            	player.DeskCards = {}
            	for k,allcard in pairs(v.playAll) do
            		local card = {}
            		card.CardValue = allcard
            		table.insert(player.DeskCards,card)
            	end
            	table.insert(result.Players,player)
            end

		    dump("\n\n牌桌同步消息 _laixiaddz_PACKET_SC_TableSyncID")
		    dump(result, "牌桌同步数据")

		    -- 断网重连时 清除用
		    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHWAITLOADING_WINDOW)
		    -- 比赛断线重连时候关闭等待界面

		    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_WAITSTATE_WINDOW)
		    -- 删掉显示阶段
		    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHRESULT_WINDOW)
		    -- 隐藏结算

		    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_CLEAR_DATELANDLORDTABLE_WINDOW, "牌桌同步清除数据")
		    laixiaddz.LocalPlayercfg.LaixiaisConnectCardTable = true
		    if result.TimesTamp == nil then
		        result.TimesTamp = socket.gettime() * 1000
		    end
		    laixiaddz.LocalPlayercfg.LaixiaRoomID = result.RoomID

		    laixiaddz.LocalPlayercfg.LaixiaLandlordSeat = result.BottomSeat

		    dump(laixiaddz.LocalPlayercfg.LaixiaPlayerID,"laixiaddz.LocalPlayercfg.LaixiaPlayerID")

		    for k, v in ipairs(result.Players) do
		        if v.PID == laixiaddz.LocalPlayercfg.LaixiaPlayerID then
		            laixiaddz.LocalPlayercfg.LaixiaMySeat = v.Seat
		            laixiaddz.LocalPlayercfg.MatchGold = v.Coin
		            break
		        end
		    end
		    dump(laixiaddz.LocalPlayercfg.LaixiaMySeat,"laixiaddz.LocalPlayercfg.LaixiaMySeat")
		    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_INITSYN_LANDLORDTABLE_WINDOW, result)
	elseif response.tp == "deal_hand" then
		local data = {}
		data.Reelect = response.type
		data.Seats = response.seat
		data.ButtomSeat = response.buttomSeat
		data.Cards = {}
		for k,v in pairs(response.cards) do
			local card = {}
			card.CardValue = v
			table.insert(data.Cards,card)
		end

		laixiaddz.logGame("发牌消息 ButtomSeat：" .. data.ButtomSeat .. "       Seats:" .. data.Seats)
	    dump(data, "发牌表数据")
	    if #data.Cards == 3 then
	        laixiaddz.LocalPlayercfg.LaixiaLandlordSeat = data.ButtomSeat
	    end


	    dump(laixiaddz.LocalPlayercfg,"laixiaddzCurrentWindow=======")
	    dump(laixiaddz.LocalPlayercfg.LaixiaCurrentWindow,"laixia.LocalPlayercfg.LaixiaCurrentWindow")
	    --TODO 发牌有问题
	    if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" and laixia.LocalPlayercfg.LaixiaisConnectCardTable == true then
	        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_DEAL_LANDLORDTABLE_WINDOW, data)
	        -- 开始发手牌标志比赛没有结束
	        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHWAITLOADING_WINDOW)
	        -- 删除中间等待界面
	    end

	    dump(data,"deal_hand")
	elseif response.tp == "call_point" then
		local result = {}
		result.Type = response.type
		result.Chip = response.chip
		result.Seat = response.seat
		result.Constraint = response.force

		dump(laixiaddz.LocalPlayercfg.LaixiaCurrentWindow ,"laixiaddz.LocalPlayercfg.LaixiaCurrentWindow ")
        if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog"  and laixiaddz.LocalPlayercfg.LaixiaisConnectCardTable == true then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_CALL_LANDLORDTABLE_WINDOW,result)
        end

        dump(result,"call_point")
    elseif response.tp == "ddz_end" then
    	dump("牌桌结算消息 _LAIXIA_PACKET_SC_BalanceID") 
    	local result = {}
    	result.RoomID = response.roomId
    	result.tableId = response.tableId
    	result.Status = response.status
    	result.BaseValue = response.baseValue
    	result.Spring = response.isSpring
    	result.DoubuleValue = response.doubleValue
    	result.difen = response.difen
    	result.boomTimes = response.boomTimes
    	result.CSBalance = {}
    	for k,v in pairs(response.players) do
    		local balance = {}
    		balance.PID = v.pId
    		balance.Inning = v.inning
    		balance.Chip = v.chip
    		balance.CurrentGold = v.tol

    		--TODO 玩家余额 不确定是多少 需要查询哇
    		table.insert(result.CSBalance,balance)
    	end
    	result.RooketTimes = response.rocket
	    if  laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" and ui.CardTableDialog.mRoomID == result.RoomID then
	        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SPRING_LANDLORDTABLE_WINDOW,result)
	    end
	    dump(result,"ddz_end")
    elseif response.tp == "play_card" then
        local result = {}
        result.StatusID = response.status
        result.State = response.stateType
        result.TableID = response.tableId
        result.ReplaceCardss = {}
        for k,v in pairs(response.replaceCards) do
        	local card = {}
        	card.CardValue = v
        	table.insert(result.ReplaceCardss,card)
        end
        result.NextSeat = response.nextSeat
        result.Cards = {}
        for k,v in pairs(response.cards) do
        	local card = {}
        	card.CardValue = v
        	table.insert(result.Cards,card)
        end
        result.Times = response.times
        result.Seat = response.current
        result.RoomID = response.roomId

        dump(result,"result")

    	dump("\n\n出牌消息消息\n\n")
	    if result.StatusID~=0  then
	        laixiaddz.logGame("出牌状态失败" )
	        return
	    end
	    if #result.Cards > 0 then
	        laixiaddz.logGame("#packet.data.Cards > 0")
	        laixiaddz.LocalPlayercfg.LaixiaOutCards = nil
	        laixiaddz.LocalPlayercfg.LaixiaOutCards = result

	        laixiaddz.LocalPlayercfg.LaixiaOutCardsCount = laixiaddz.LocalPlayercfg.LaixiaOutCardsCount + 1
	        -- 管上牌次数
	        laixiaddz.LocalPlayercfg.LaixiaOutCards.count = 0

	        laixiaddz.LocalPlayercfg.LaixiaOutCardsIndex = clone(result.Cards)

	        laixiaddz.LocalPlayercfg.LaixiaLaiziReplaceCards = clone(result.ReplaceCardss)

	        for i =1 ,#laixiaddz.LocalPlayercfg.LaixiaOutCardsIndex  do
	            dump(laixiaddz.LocalPlayercfg.LaixiaOutCardsIndex[i].CardValue,"cardValue")
	        end

	        for i =1 ,#laixiaddz.LocalPlayercfg.LaixiaLaiziReplaceCards  do
	            dump(laixiaddz.LocalPlayercfg.LaixiaLaiziReplaceCards[i].CardValue,"replaceCardValue")
	        end

	    else
	        dump("#packet.data.Cards <= 0")
	        local count = nil

	        if laixiaddz.LocalPlayercfg.LaixiaOutCards ~= nil then
	            count = laixiaddz.LocalPlayercfg.LaixiaOutCards.count
	        else
	            count = 0
	        end
	        laixiaddz.LocalPlayercfg.LaixiaOutCards = nil
	        laixiaddz.LocalPlayercfg.LaixiaOutCards = clone(result)
	        laixiaddz.LocalPlayercfg.LaixiaOutCards.count = count + 1
	        
	        if laixiaddz.LocalPlayercfg.LaixiaOutCards.count == 2 then
	            laixiaddz.LocalPlayercfg.LaixiaOutCardsIndex = nil
	        end
	    end
	    if result.NextSeat == 255 then
	        result.NextSeat = -1
	    end
	    local stageStep = {
	        ["State"] = result.State,
	        ["Seat"] = result.NextSeat,
	        ["Times"] = result.Times,
	    }
	    dump(stageStep,"stageStep")
	    if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" and laixiaddz.LocalPlayercfg.LaixiaisConnectCardTable == true then
	        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_PLAY_LANDLORDTABLE_WINDOW)
	        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_SYNTABLESTAGE_WINDOW, stageStep)
	    end
	end
end

--[[
    用户连接"ua"连接成功
]]
function socketDidConnected()
    print("用户连接\"ua\"连接成功")
end

--[[
    用户连接"ua"连接断开或者失败
]]
function socketDidDisconnect()
    print("用户连接\"ua\"连接断开或者失败")
end

