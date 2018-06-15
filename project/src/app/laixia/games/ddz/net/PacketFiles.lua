-- 协议模块

local CURRENT_MODULE_NAME = ...

import(".PacketID") --
local _M = {}
local Protocols = _M

_M.dataType = import(".DataType")
_M.Protocols =  {}

--
--
----广播推送  走马灯
--_M.Protocols[_laixiaddz_PACKET_SC_RotateNoticeID] = import(".protocol.SCRotateNotice")
--
----服务器维护踢人下线
--_M.Protocols[_laixiaddz_PACKET_SC_CutLineID] = import(".protocol.SCCutLine")

-- 斗地主消息相关
-- 房间列表
_M.Protocols[_laixiaddz_PACKET_CS_ListRoomID]= import(".protocol.landlords.CSRoomList")
_M.Protocols[_laixiaddz_PACKET_SC_ListRoomID] = import(".protocol.landlords.SCRoomList")

-- 进入房间
_M.Protocols[_laixiaddz_PACKET_CS_EnterRoomID]= import(".protocol.landlords.CSEnterRoom")
_M.Protocols[_laixiaddz_PACKET_SC_EnterRoomID] = import(".protocol.landlords.SCEnterRoom")

--快速开始
_M.Protocols[_laixiaddz_PACKET_CS_QuickOpenID ]= import(".protocol.landlords.CSQuickOpen")
_M.Protocols[_laixiaddz_PACKET_SC_QuickOpenID ]= import(".protocol.landlords.SCQuickOpen")

--退出房间
_M.Protocols[_laixiaddz_PACKET_CS_ExitRoomID ]= import(".protocol.landlords.CSExitRoom")
_M.Protocols[_laixiaddz_PACKET_SC_ExitRoomID ]= import(".protocol.landlords.SCExitRoom")

--继续游戏
_M.Protocols[_laixiaddz_PACKET_CS_ContinueGameID]= import(".protocol.landlords.CSContinueGame")
_M.Protocols[_laixiaddz_PACKET_SC_ContinueGameID]= import(".protocol.landlords.SCContinueGame")

--自建桌奖励推送
_M.Protocols[_laixiaddz_PACKET_SC_SelfBuildRewardRetID]= import(".protocol.selfbuild.SCSelfBuildRewardRet")

--站内玩家信息查看
_M.Protocols[_laixiaddz_PACKET_CS_TablePlayerID]= import(".protocol.landlords.CSTablePlayer")
_M.Protocols[_laixiaddz_PACKET_SC_TablePlayerID]= import(".protocol.landlords.SCTablePlayer")

--断网时再牌桌内
_M.Protocols[_laixiaddz_PACKET_CS_OnlineRoomID]= import(".protocol.landlords.CSOnlineRoom")
_M.Protocols[_laixiaddz_PACKET_SC_OnlineRoomID]= import(".protocol.landlords.SCOnlineRoom")

--发底牌
_M.Protocols[_laixiaddz_PACKET_SC_DealHandID] =import(".protocol.landlords.SCDealHand")

--叫地主抢地主
_M.Protocols[_laixiaddz_PACKET_CS_CallBidID] =import(".protocol.landlords.CSCallBid")
_M.Protocols[_laixiaddz_PACKET_SC_CallBidID] =import(".protocol.landlords.SCCallBid")

--出手牌
_M.Protocols[_laixiaddz_PACKET_CS_PlayCardsID] =import(".protocol.landlords.CSPlayCards")
_M.Protocols[_laixiaddz_PACKET_SC_PlayCardsID] =import(".protocol.landlords.SCPlayCards")

--结算
_M.Protocols[_laixiaddz_PACKET_SC_BalanceID] =import(".protocol.landlords.SCBalance")

--属性变化
_M.Protocols[_laixiaddz_PACKET_SC_AttriChangeID] =import(".protocol.landlords.SCAttriChange")

--明牌
_M.Protocols[_laixiaddz_PACKET_CS_ShowCardID] =import(".protocol.landlords.CSShowCard")
_M.Protocols[_laixiaddz_PACKET_SC_ShowCardID] =import(".protocol.landlords.SCShowCard")

--牌桌阶段
_M.Protocols[_laixiaddz_PACKET_SC_TableSyncStageRetID] =import(".protocol.landlords.SCTableSyncStage")

--牌桌同步
_M.Protocols[_laixiaddz_PACKET_SC_TableSyncID] =import(".protocol.landlords.SCTableSync")

--取消托管
_M.Protocols[_laixiaddz_PACKET_CS_CancelMandateID] =import(".protocol.landlords.CSCancelMandate")
_M.Protocols[_laixiaddz_PACKET_SC_CancelMandateID] =import(".protocol.landlords.SCCancelMandate")

--聊天
_M.Protocols[_laixiaddz_PACKET_CS_TableTalkingID]=import(".protocol.landlords.CSTableTalking")
_M.Protocols[_laixiaddz_PACKET_SC_TableTalkingID]=import(".protocol.landlords.SCTableTalking")

--结算亮牌推送
_M.Protocols[_laixiaddz_PACKET_SC_EndShowCardsID]=import(".protocol.landlords.SCEndShowCards")

_M.Protocols[_laixiaddz_PACKET_SC_LeaveRoomID] = import(".protocol.landlords.SCLeaveRoom")

--创建桌超时删除
_M.Protocols[_laixiaddz_PACKET_SC_CreateOverTimeRetID] =import(".protocol.selfbuild.SCCreateOverTimeRet")

--创建牌桌大结算
_M.Protocols[_laixiaddz_PACKET_SC_CreateEndResultRetID] =import(".protocol.selfbuild.SCCreateEndResultRet")

---------------------------------------------------------------------------------------------------
--自建房
--创建房间
_M.Protocols[_laixiaddz_PACKET_CS_CreateTableID] =import(".protocol.selfbuild.CSCreateTable")
_M.Protocols[_laixiaddz_PACKET_SC_CreateTableRetID] =import(".protocol.selfbuild.SCCreateTableRet")

--加入已有房间
_M.Protocols[_laixiaddz_PACKET_CS_JoinTableID] =import(".protocol.selfbuild.CSJoinTable")
_M.Protocols[_laixiaddz_PACKET_SC_JoinTableRetID] =import(".protocol.selfbuild.SCJoinTableRet")

--解散自建桌
_M.Protocols[_laixiaddz_PACKET_CS_CreateDelID] =import(".protocol.selfbuild.CSCreateDel")
_M.Protocols[_laixiaddz_PACKET_SC_CreateDelRetID] =import(".protocol.selfbuild.SCCreateDelRet")

--进入房间--推送同步消息

_M.Protocols[_laixiaddz_PACKET_SC_JoinSyncRetID] =import(".protocol.selfbuild.SCJoinSyncRet")

--创建房间有人退出
_M.Protocols[_laixiaddz_PACKET_SC_CreateExitRetID] =import(".protocol.selfbuild.SCCreateExitRet")

--创建房间列表
_M.Protocols[_laixiaddz_PACKET_CS_CreateListID] =import(".protocol.selfbuild.CSCreateList")
_M.Protocols[_laixiaddz_PACKET_SC_CreateListRetID] =import(".protocol.selfbuild.SCCreateListRet")

--申请解散房间
_M.Protocols[_laixiaddz_PACKET_CS_AppleDismissID] =import(".protocol.selfbuild.CSAppleDismiss")
_M.Protocols[_laixiaddz_PACKET_SC_AppleDismissID] =import(".protocol.selfbuild.SCAppleDismiss")

--闯将房间继续开始
_M.Protocols[_laixiaddz_PACKET_CS_CreateGoonID] =import(".protocol.selfbuild.CSCreateGoon")
_M.Protocols[_laixiaddz_PACKET_SC_CreateGoonRetID] =import(".protocol.selfbuild.SCCreateGoonRet")
---------------------------------------------------------------------------------------------------
-- 比赛相关
_M.Protocols[_laixiaddz_PACKET_CS_MatchRegisterID] = import(".protocol.match.CSMatchRegister") --报名 +1
_M.Protocols[_laixiaddz_PACKET_SC_MatchRegisterID] =import(".protocol.match.SCMatchRegister")

_M.Protocols[_laixiaddz_PACKET_CS_MatchGameID] = import(".protocol.match.CSMatchGame") --比赛列表   +2
_M.Protocols[_laixiaddz_PACKET_SC_MatchGameID] = import(".protocol.match.SCMatchGame")

_M.Protocols[_laixiaddz_PACKET_CS_ExitMatchGameID] = import(".protocol.match.CSExitMatchGame") --比赛退出报名 + 3
_M.Protocols[_laixiaddz_PACKET_SC_ExitMatchGameID]=import(".protocol.match.SCExitMatchGame")

_M.Protocols[_laixiaddz_PACKET_SC_FailExitMatchID] = import(".protocol.match.SCFailExitMatch")--比赛失败退出 +4

_M.Protocols[_laixiaddz_PACKET_SC_ExitTipsMatchID] = import(".protocol.match.SCExitTipsMatch") --返还报名费 + 5

_M.Protocols[_laixiaddz_PACKET_CS_MatchQuitDeskID] = import(".protocol.match.CSMatchQuitDesk") --比赛退出牌桌  +6
_M.Protocols[_laixiaddz_PACKET_SC_MatchQuitDeskID] =import(".protocol.match.SCMatchQuitDesk")

_M.Protocols[_laixiaddz_PACKET_CS_IsMatchID] = import(".protocol.match.CSIsMatch") --短线重连时，是否进入比赛  +7
_M.Protocols[_laixiaddz_PACKET_SC_IsMatchID] =import(".protocol.match.SCIsMatch")

_M.Protocols[_laixiaddz_PACKET_CS_MatchJoinInID] = import(".protocol.match.CSMatchJoinIn") --确认参加比赛 +8
_M.Protocols[_laixiaddz_PACKET_SC_MatchJoinInID] = import(".protocol.match.SCMatchJoinIn")

_M.Protocols[_laixiaddz_PACKET_SC_MatchWaitQueueID]=import(".protocol.match.SCMatchWaitQueue") --玩家进入等待队列  +9

_M.Protocols[_laixiaddz_PACKET_SC_MatchStageUpID] = import(".protocol.match.SCMatchStageUp") --比赛阶段变化同步 +10

_M.Protocols[_laixiaddz_PACKET_SC_MatchRenManUpID] =import(".protocol.match.SCMatchRenManUp") --人满开赛数据更新  +11

_M.Protocols[_laixiaddz_PACKET_CS_MatchDetailsID] = import(".protocol.match.CSMatchDetails") --比赛详情页  +12
_M.Protocols[_laixiaddz_PACKET_SC_MatchDetailsID] = import(".protocol.match.SCMatchDetails")

_M.Protocols[_laixiaddz_PACKET_CS_MatchIntegralRankID] = import(".protocol.match.CSMatchIntergralRank")  --获取积分榜  +14
_M.Protocols[_laixiaddz_PACKET_SC_MatchIntegralRankID]  = import(".protocol.match.SCMatchIntergralRank")

_M.Protocols[_laixiaddz_PACKET_SC_MatchRankID] = import(".protocol.match.SCMatchRank")  --获取当前排名和积分+15

_M.Protocols[_laixiaddz_PACKET_SC_MatchResultID] = import(".protocol.match.SCMatchResult")  --比赛奖励+16

_M.Protocols[_laixiaddz_PACKET_SC_MatchTimingID] =import(".protocol.match.SCMatchTiming")  --定时开赛中间等待界面+17

_M.Protocols[_laixiaddz_PACKET_SC_MatchStopMaintainID] = import(".protocol.match.SCMatchStopMaintain") -- 比赛服务器维护 +18

_M.Protocols[_laixiaddz_PACKET_SC_MatchResurrectionBackID] = import(".protocol.match.SCMatchResurrectionBack") --可复活退出 +19

_M.Protocols[_laixiaddz_PACKET_CS_MatchResurrectionID] = import(".protocol.match.CSMatchResurrection") --确认复活 +20
_M.Protocols[_laixiaddz_PACKET_SC_MatchResurrectionID] = import(".protocol.match.SCMatchResurrection") --复活

_M.Protocols[_laixiaddz_PACKET_SC_MatchStopCompensationID] = import(".protocol.match.SCMatchStopCompensation") --服务器维护补偿 +21

_M.Protocols[_laixiaddz_PACKET_SC_MatchFloatwordID] = import(".protocol.match.SCMatchFloatword") -- 比赛飘字提示+22

_M.Protocols[_laixiaddz_PACKET_CS_MatchOpenRecentTimeID] = import(".protocol.match.CSMatchOpenRecentTime") -- 获取最近的定时开赛的比赛+23
_M.Protocols[_laixiaddz_PACKET_SC_MatchOpenRecentTimeID] = import(".protocol.match.SCMatchOpenRecentTime")

_M.Protocols[_laixiaddz_PACKET_SC_MatchPhaseChangeID] = import(".protocol.match.SCMatchPhaseChange")-- 阶段改变等待消息

function _M.getProtocol(ID)
    return  _M.Protocols[ID];
end

return Protocols

















   



