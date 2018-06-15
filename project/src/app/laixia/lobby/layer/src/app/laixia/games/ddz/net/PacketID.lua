
local flag = 0x80000000

local BASIC_ID 			= 0x00010000;
local LANDLORDS_TABLE_ID= 0x00050000;
local LANDLORDS_ROOM_ID = 0x00070000; 	-- 斗地主房间
local MATCH_ID			= 0x00090000;	-- 比赛
local DRAGON_TIGER_ID   = 0x00600000;    -- 龙虎斗id

local BIGTURNTABLE_ID   = 0x00500000; --大转盘
local WANRENNIUNIU_ID   = 0x00400000  --万人牛牛
local FRUITS_ID         = 0x00300000;  --水果机
local THREECARDS_ID		= 0x00200000;	-- 三张牌基础id

local function GET_PACKET_RETID(ID)
    return bit.bor(flag,ID);
end

------------------------------------------------------------------------------------------------
-- 房间列表
_laixiaddz_PACKET_CS_ListRoomID = LANDLORDS_ROOM_ID+1
_laixiaddz_PACKET_SC_ListRoomID = (bit.bor(flag,_laixiaddz_PACKET_CS_ListRoomID))

-- 进入房间
_laixiaddz_PACKET_CS_EnterRoomID = LANDLORDS_ROOM_ID+2
_laixiaddz_PACKET_SC_EnterRoomID = (bit.bor(flag,_laixiaddz_PACKET_CS_EnterRoomID))

--快速开始
_laixiaddz_PACKET_CS_QuickOpenID = LANDLORDS_ROOM_ID+3
_laixiaddz_PACKET_SC_QuickOpenID = (bit.bor(flag,_laixiaddz_PACKET_CS_QuickOpenID))

--退出房间
_laixiaddz_PACKET_CS_ExitRoomID = LANDLORDS_ROOM_ID+4
_laixiaddz_PACKET_SC_ExitRoomID = (bit.bor(flag,_laixiaddz_PACKET_CS_ExitRoomID))

--继续游戏
_laixiaddz_PACKET_CS_ContinueGameID = LANDLORDS_ROOM_ID+5
_laixiaddz_PACKET_SC_ContinueGameID = (bit.bor(flag,_laixiaddz_PACKET_CS_ContinueGameID))

--自建牌桌奖励推送
_laixiaddz_PACKET_CS_SelfBuildRewardID = LANDLORDS_ROOM_ID+6
_laixiaddz_PACKET_SC_SelfBuildRewardRetID = (bit.bor(flag,_laixiaddz_PACKET_CS_SelfBuildRewardID))

--站内玩家信息查看
_laixiaddz_PACKET_CS_TablePlayerID = LANDLORDS_ROOM_ID+7
_laixiaddz_PACKET_SC_TablePlayerID = (bit.bor(flag,_laixiaddz_PACKET_CS_TablePlayerID))

--断网时在牌桌内
_laixiaddz_PACKET_CS_OnlineRoomID = LANDLORDS_ROOM_ID+9
_laixiaddz_PACKET_SC_OnlineRoomID = (bit.bor(flag,_laixiaddz_PACKET_CS_OnlineRoomID))

----------------------------------------------------------------------------
--自建房
--斗地主创建牌桌
_laixiaddz_PACKET_CS_CreateTableID = LANDLORDS_ROOM_ID + 15
_laixiaddz_PACKET_SC_CreateTableRetID = (bit.bor(flag,_laixiaddz_PACKET_CS_CreateTableID))

--加入已有牌桌
_laixiaddz_PACKET_CS_JoinTableID = LANDLORDS_ROOM_ID + 16
_laixiaddz_PACKET_SC_JoinTableRetID = (bit.bor(flag,_laixiaddz_PACKET_CS_JoinTableID))

--解散自建桌
_laixiaddz_PACKET_CS_CreateDelID = LANDLORDS_ROOM_ID + 17
_laixiaddz_PACKET_SC_CreateDelRetID = (bit.bor(flag,_laixiaddz_PACKET_CS_CreateDelID))

--进入房间--推送同步消息
_laixiaddz_PACKET_CS_JoinSyncID = LANDLORDS_ROOM_ID + 18
_laixiaddz_PACKET_SC_JoinSyncRetID = (bit.bor(flag,_laixiaddz_PACKET_CS_JoinSyncID))

--创建房间有人退出
_laixiaddz_PACKET_CS_CreateExitID = LANDLORDS_ROOM_ID + 19
_laixiaddz_PACKET_SC_CreateExitRetID = (bit.bor(flag,_laixiaddz_PACKET_CS_CreateExitID))

--创建房间列表（用于显示自建列表）
_laixiaddz_PACKET_CS_CreateListID = LANDLORDS_ROOM_ID + 20
_laixiaddz_PACKET_SC_CreateListRetID = (bit.bor(flag,_laixiaddz_PACKET_CS_CreateListID))

--申请解散房间(自建房)
_laixiaddz_PACKET_CS_AppleDismissID = LANDLORDS_ROOM_ID + 21
_laixiaddz_PACKET_SC_AppleDismissID = (bit.bor(flag,_laixiaddz_PACKET_CS_AppleDismissID))

------------------------------牌桌消息--------------------------------------

_laixiaddz_PACKET_CS_DealHandID=LANDLORDS_TABLE_ID+1                  --底牌
_laixiaddz_PACKET_SC_DealHandID=(bit.bor(flag,_laixiaddz_PACKET_CS_DealHandID))

_laixiaddz_PACKET_CS_CallBidID=LANDLORDS_TABLE_ID+2                  --叫地主、抢地主
_laixiaddz_PACKET_SC_CallBidID=(bit.bor(flag,_laixiaddz_PACKET_CS_CallBidID))

_laixiaddz_PACKET_CS_PlayCardsID=LANDLORDS_TABLE_ID+3                      --出手牌
_laixiaddz_PACKET_SC_PlayCardsID=(bit.bor(flag,_laixiaddz_PACKET_CS_PlayCardsID))

_laixiaddz_PACKET_CS_BalanceID=LANDLORDS_TABLE_ID+4                     --结算
_laixiaddz_PACKET_SC_BalanceID=(bit.bor(flag,_laixiaddz_PACKET_CS_BalanceID))

_laixiaddz_PACKET_CS_AttriChangeID=LANDLORDS_TABLE_ID+5                     --属性变化
_laixiaddz_PACKET_SC_AttriChangeID=(bit.bor(flag,_laixiaddz_PACKET_CS_AttriChangeID))

_laixiaddz_PACKET_CS_ShowCardID=LANDLORDS_TABLE_ID+6                     --明牌
_laixiaddz_PACKET_SC_ShowCardID=(bit.bor(flag,_laixiaddz_PACKET_CS_ShowCardID))

_laixiaddz_PACKET_CS_TableSyncStageID=LANDLORDS_TABLE_ID+7                    --牌桌阶段
_laixiaddz_PACKET_SC_TableSyncStageRetID=(bit.bor(flag,_laixiaddz_PACKET_CS_TableSyncStageID))

_laixiaddz_PACKET_CS_TableSyncID=LANDLORDS_TABLE_ID+8                    --牌桌同步
_laixiaddz_PACKET_SC_TableSyncID=(bit.bor(flag,_laixiaddz_PACKET_CS_TableSyncID))

_laixiaddz_PACKET_CS_CancelMandateID=LANDLORDS_TABLE_ID+9                    --取消托管
_laixiaddz_PACKET_SC_CancelMandateID=(bit.bor(flag,_laixiaddz_PACKET_CS_CancelMandateID))

_laixiaddz_PACKET_CS_TableTalkingID = LANDLORDS_TABLE_ID+10                    --聊天
_laixiaddz_PACKET_SC_TableTalkingID = (bit.bor(flag,_laixiaddz_PACKET_CS_TableTalkingID))

_laixiaddz_PACKET_CS_EndShowCardsID = LANDLORDS_TABLE_ID+11                    --结算亮牌推送
_laixiaddz_PACKET_SC_EndShowCardsID = (bit.bor(flag,_laixiaddz_PACKET_CS_EndShowCardsID))

_laixiaddz_PACKET_CS_LeaveRoomID = LANDLORDS_TABLE_ID+14
_laixiaddz_PACKET_SC_LeaveRoomID = (bit.bor(flag,_laixiaddz_PACKET_CS_LeaveRoomID))

--创建桌继续开始
_laixiaddz_PACKET_CS_CreateGoonID = LANDLORDS_TABLE_ID+15
_laixiaddz_PACKET_SC_CreateGoonRetID = (bit.bor(flag,_laixiaddz_PACKET_CS_CreateGoonID))

_laixiaddz_PACKET_CS_CreateOverTimeID = LANDLORDS_TABLE_ID+16                    --创建桌超时删除
_laixiaddz_PACKET_SC_CreateOverTimeRetID = (bit.bor(flag,_laixiaddz_PACKET_CS_CreateOverTimeID))

_laixiaddz_PACKET_CS_CreateEndResultID = LANDLORDS_TABLE_ID+17                    --创建桌大结算
_laixiaddz_PACKET_SC_CreateEndResultRetID = (bit.bor(flag,_laixiaddz_PACKET_CS_CreateEndResultID))


-------------------------------------------------------------------------------------------
-- 比赛相关
_laixiaddz_PACKET_CS_MatchRegisterID = MATCH_ID +1  --参加比赛
_laixiaddz_PACKET_SC_MatchRegisterID =(bit.bor(flag,_laixiaddz_PACKET_CS_MatchRegisterID))

_laixiaddz_PACKET_CS_MatchGameID=MATCH_ID+2  --比赛列表
_laixiaddz_PACKET_SC_MatchGameID=(bit.bor(flag,_laixiaddz_PACKET_CS_MatchGameID))

_laixiaddz_PACKET_CS_ExitMatchGameID = MATCH_ID +3  --比赛退出报名
_laixiaddz_PACKET_SC_ExitMatchGameID =(bit.bor(flag,_laixiaddz_PACKET_CS_ExitMatchGameID))

_laixiaddz_PACKET_SC_FailExitMatchID =(bit.bor(flag,MATCH_ID +4))  --比赛失败退出

_laixiaddz_PACKET_SC_ExitTipsMatchID =(bit.bor(flag,MATCH_ID +5)) --返还报名费

_laixiaddz_PACKET_CS_MatchQuitDeskID =MATCH_ID+6  --比赛退出牌桌
_laixiaddz_PACKET_SC_MatchQuitDeskID =(bit.bor(flag,_laixiaddz_PACKET_CS_MatchQuitDeskID))

_laixiaddz_PACKET_CS_IsMatchID = MATCH_ID +7  --断线重连时，是否进入比赛
_laixiaddz_PACKET_SC_IsMatchID =(bit.bor(flag,_laixiaddz_PACKET_CS_IsMatchID))

_laixiaddz_PACKET_CS_MatchJoinInID = MATCH_ID+8  --确认参加比赛
_laixiaddz_PACKET_SC_MatchJoinInID =(bit.bor(flag,_laixiaddz_PACKET_CS_MatchJoinInID))

_laixiaddz_PACKET_SC_MatchWaitQueueID = (bit.bor(flag,MATCH_ID +9)) --玩家进入等待队列消,牌桌匹配不足的时候会有这个界面

_laixiaddz_PACKET_SC_MatchStageUpID = (bit.bor(flag,MATCH_ID +10)) --比赛阶段同步变化

_laixiaddz_PACKET_SC_MatchRenManUpID = (bit.bor(flag,MATCH_ID +11))  --人满开赛数据更新

_laixiaddz_PACKET_CS_MatchDetailsID = MATCH_ID +12  --比赛详情
_laixiaddz_PACKET_SC_MatchDetailsID =(bit.bor(flag,_laixiaddz_PACKET_CS_MatchDetailsID))

_laixiaddz_PACKET_CS_MatchIntegralRankID= MATCH_ID +14  --获取积分榜
_laixiaddz_PACKET_SC_MatchIntegralRankID=(bit.bor(flag,_laixiaddz_PACKET_CS_MatchIntegralRankID))

_laixiaddz_PACKET_CS_MatchRankID =MATCH_ID + 15  --同步当前排名和积分
_laixiaddz_PACKET_SC_MatchRankID =(bit.bor(flag,_laixiaddz_PACKET_CS_MatchRankID))

_laixiaddz_PACKET_CS_MatchResultID = MATCH_ID +16  --比赛奖励
_laixiaddz_PACKET_SC_MatchResultID =(bit.bor(flag,_laixiaddz_PACKET_CS_MatchResultID))

_laixiaddz_PACKET_CS_MatchTimingID = MATCH_ID +17  --定时开赛中间等待界面
_laixiaddz_PACKET_SC_MatchTimingID =(bit.bor(flag,_laixiaddz_PACKET_CS_MatchTimingID))

_laixiaddz_PACKET_CS_MatchStopMaintainID = MATCH_ID +18 --服务器维护中
_laixiaddz_PACKET_SC_MatchStopMaintainID =(bit.bor(flag,_laixiaddz_PACKET_CS_MatchStopMaintainID))

_laixiaddz_PACKET_CS_MatchResurrectionBackID = MATCH_ID +19 --复活确认消息
_laixiaddz_PACKET_SC_MatchResurrectionBackID =(bit.bor(flag,_laixiaddz_PACKET_CS_MatchResurrectionBackID))

_laixiaddz_PACKET_CS_MatchResurrectionID = MATCH_ID +20 --复活成功
_laixiaddz_PACKET_SC_MatchResurrectionID =(bit.bor(flag,_laixiaddz_PACKET_CS_MatchResurrectionID))

_laixiaddz_PACKET_CS_MatchStopCompensationID = MATCH_ID +21 --服务器维护补偿
_laixiaddz_PACKET_SC_MatchStopCompensationID =(bit.bor(flag,_laixiaddz_PACKET_CS_MatchStopCompensationID))

_laixiaddz_PACKET_CS_MatchFloatwordID = MATCH_ID +22 -- 飘字提示
_laixiaddz_PACKET_SC_MatchFloatwordID =(bit.bor(flag,_laixiaddz_PACKET_CS_MatchFloatwordID))

_laixiaddz_PACKET_CS_MatchOpenRecentTimeID = MATCH_ID +23 --获取最近的定时开赛的比赛
_laixiaddz_PACKET_SC_MatchOpenRecentTimeID =(bit.bor(flag,_laixiaddz_PACKET_CS_MatchOpenRecentTimeID))

_laixiaddz_PACKET_SC_MatchPhaseChangeID =(bit.bor(flag,MATCH_ID +24)) -- 阶段改变等待消息
