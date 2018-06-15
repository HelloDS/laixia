-- 协议模块

local CURRENT_MODULE_NAME = ...

import(".PacketID") --
local _M = {}
local Protocols = _M

_M.dataType = import(".DataType")
_M.Protocols =  {}

_M.Protocols[_LAIXIA_PACKET_CS_Login_ID] = import(".protocol.CSLogin")
_M.Protocols[_LAIXIA_PACKET_SC_Login_ID] = import(".protocol.SCLoginRet")

_M.Protocols[_LAIXIA_PACKET_CS_EnterGameID]= import(".protocol.CSEnterGame")
_M.Protocols[_LAIXIA_PACKET_SC_EnterGameID]= import(".protocol.SCEnterGame")

--进入个人信息
_M.Protocols[_LAIXIA_PACKET_CS_PersonalCenterID] = import(".protocol.CSPersonalCenter");
_M.Protocols[_LAIXIA_PACKET_SC_PersonalCenterID] = import(".protocol.SCPersonalCenter");

--排行榜
_M.Protocols[_LAIXIA_PACKET_CS_RankID] = import(".protocol.CSRank")
_M.Protocols[_LAIXIA_PACKET_SC_RankID] = import(".protocol.SCRank")

--点击某个玩家
_M.Protocols[_LAIXIA_PACKET_CS_PlayerRankInfoID] = import(".protocol.CSPlayerRankInfo")
_M.Protocols[_LAIXIA_PACKET_SC_PlayerRankInfoID] = import(".protocol.SCPlayerRankInfo")

--是否有站内信
_M.Protocols[_LAIXIA_PACKET_CS_HasMailID] = import(".protocol.CSHasMail")
_M.Protocols[_LAIXIA_PACKET_SC_HasMailID] = import(".protocol.SCHasMail")

--请求站内信
_M.Protocols[_LAIXIA_PACKET_CS_SmsListID] = import(".protocol.CSSmsList")
_M.Protocols[_LAIXIA_PACKET_SC_SmsListID] = import(".protocol.SCSmsList")

--签到表（连续登陆）
_M.Protocols[_LAIXIA_PACKET_CS_SignLandingID] = import(".protocol.CSSignLanding")
_M.Protocols[_LAIXIA_PACKET_SC_SignLandingID] = import(".protocol.SCSignLanding")

--签到
_M.Protocols[_LAIXIA_PACKET_CS_SignID] = import(".protocol.CSSign")
_M.Protocols[_LAIXIA_PACKET_SC_SignID] = import(".protocol.SCSign")

--快充礼包
_M.Protocols[_LAIXIA_PACKET_CS_QuickSuperBagID] = import(".protocol.CSQuickSuperBag")
_M.Protocols[_LAIXIA_PACKET_SC_QuickSuperBagID] = import(".protocol.SCQuickSuperBag")

--破产礼包
_M.Protocols[_LAIXIA_PACKET_CS_BankruptBagID] = import(".protocol.CSBankruptBag")
_M.Protocols[_LAIXIA_PACKET_SC_BankruptBagID] = import(".protocol.SCBankruptBag")

--首充礼包
_M.Protocols[_LAIXIA_PACKET_CS_FirstSuperBagID] = import(".protocol.CSFirstSuperBag")
_M.Protocols[_LAIXIA_PACKET_SC_FirstSuperBagID] = import(".protocol.SCFirstSuperBag")

--商城
_M.Protocols[_LAIXIA_PACKET_CS_ShopID] = import(".protocol.CSShop")
_M.Protocols[_LAIXIA_PACKET_SC_ShopID] = import(".protocol.SCShop")

--修改密码
_M.Protocols[_LAIXIA_PACKET_CS_RevisePwdID] = import(".protocol.CSRevisePwd")
_M.Protocols[_LAIXIA_PACKET_SC_RevisePwdID] = import(".protocol.SCRevisePwd")

--找回密码
_M.Protocols[_LAIXIA_PACKET_CS_FindPwdID] = import(".protocol.CSFindPwd")
_M.Protocols[_LAIXIA_PACKET_SC_FindPwdID] = import(".protocol.SCFindPwd")

--获取包裹
_M.Protocols[_LAIXIA_PACKET_CS_PackItemsID] = import(".protocol.CSPackItems")
_M.Protocols[_LAIXIA_PACKET_SC_PackItemsID] = import(".protocol.SCPackItems")

--使用道具
_M.Protocols[_LAIXIA_PACKET_CS_UsePacksID] = import(".protocol.CSUsePacks")
_M.Protocols[_LAIXIA_PACKET_SC_UsePacksID] = import(".protocol.SCUsePacksRet")

--绑定手机获取验证码
_M.Protocols[_LAIXIA_PACKET_CSCodeBindingID] = import(".protocol.CSCodeBinding")
_M.Protocols[_LAIXIA_PACKET_SC_SCCodeBindingID] = import(".protocol.SCCodeBinding")

--绑定玩家手机
_M.Protocols[_LAIXIA_PACKET_CS_BoundPhoneID] = import(".protocol.CSBoundPhone")
_M.Protocols[_LAIXIA_PACKET_SC_BoundPhoneID] = import(".protocol.SCBoundPhone")

--获取兑换列表
_M.Protocols[_LAIXIA_PACKET_CS_ExchangeDataID] = import(".protocol.CSExchangeData")
_M.Protocols[_LAIXIA_PACKET_SC_ExchangeDataID] = import(".protocol.SCExchangeData")

--兑换
_M.Protocols[_LAIXIA_PACKET_CS_ExchangeID] = import(".protocol.CSExchange")
_M.Protocols[_LAIXIA_PACKET_SC_ExchangeID] = import(".protocol.SCExchange")

--头像上传
_M.Protocols[_LAIXIA_PACKET_CS_HeadUploadID] = import(".protocol.CSHeadUpload")
_M.Protocols[_LAIXIA_PACKET_SC_HeadUploadID] = import(".protocol.SCHeadUpload")

--心跳
_M.Protocols[_LAIXIA_PACKET_CS_HeartBeatID] = import(".protocol.CSHeartBeat")
_M.Protocols[_LAIXIA_PACKET_SC_HeartBeatID] = import(".protocol.SCHeartBeat")

--兑换码兑换
_M.Protocols[_LAIXIA_PACKET_CS_RedeemCodeID] = import(".protocol.CSRedeemCode")
_M.Protocols[_LAIXIA_PACKET_SC_RedeemCodeID] = import(".protocol.SCRedeemCode")

--请求救济金
_M.Protocols[_LAIXIA_PACKET_CS_ReliefFundID] = import(".protocol.CSReliefFund")
_M.Protocols[_LAIXIA_PACKET_SC_ReliefFundID] = import(".protocol.SCReliefFund")

--请求救济金剩余次数
_M.Protocols[_LAIXIA_PACKET_CS_ReliefFundInfoID] = import(".protocol.CSReliefFundInfo")
_M.Protocols[_LAIXIA_PACKET_SC_ReliefFundInfoID] = import(".protocol.SCReliefFundInfo")

--进入大厅获取个人数据
_M.Protocols[_LAIXIA_PACKET_CS_HallLobbyID] = import(".protocol.CSHallLobby")
_M.Protocols[_LAIXIA_PACKET_SC_HallLobbyID] = import(".protocol.SCHallLobby")



--广播推送  走马灯
_M.Protocols[_LAIXIA_PACKET_SC_RotateNoticeID] = import(".protocol.SCRotateNotice")

--服务器维护踢人下线
_M.Protocols[_LAIXIA_PACKET_SC_CutLineID] = import(".protocol.SCCutLine")


--推广活动绑定ID
_M.Protocols[_LAIXIA_PACKET_CS_ExtensionBindingID] = import(".protocol.CSExtensionBinding")
_M.Protocols[_LAIXIA_PACKET_SC_ExtensionBindingRetID] = import(".protocol.SCExtensionBindingRet")

--推广活动领取金币
_M.Protocols[_LAIXIA_PACKET_CS_ReceiveExtensionID] = import(".protocol.CSReceiveExtension")
_M.Protocols[_LAIXIA_PACKET_SC_ReceiveExtensionRetID] = import(".protocol.SCReceiveExtensionRet")

--赠送道具
_M.Protocols[_LAIXIA_PACKET_CS_PresentID] = import(".protocol.CSPresent")
_M.Protocols[_LAIXIA_PACKET_SC_PresentRetID] = import(".protocol.SCPresentRet")

--推广活动规则
_M.Protocols[_LAIXIA_PACKET_CS_ExtensionRuleID] = import(".protocol.CSExtensionRule")
_M.Protocols[_LAIXIA_PACKET_SC_ExtensionRuleRetID] = import(".protocol.SCExtensionRuleRet")

--触发是否有周卡月卡礼包
_M.Protocols[_LAIXIA_PACKET_CS_WeekOrMonthCardID] = import(".protocol.CSWeekOrMonthCard")
_M.Protocols[_LAIXIA_PACKET_SC_WeekOrMonthCardRetID] = import(".protocol.SCWeekOrMonthCardRet")

--活动请求
_M.Protocols[_LAIXIA_PACKET_CS_ActivityID] = import(".protocol.CSActivity")
_M.Protocols[_LAIXIA_PACKET_SC_ActivityID] = import(".protocol.SCActivity")

--活动请求
_M.Protocols[_LAIXIA_PACKET_CS_GETVERSION] = import(".protocol.CSGetVersion")
_M.Protocols[_LAIXIA_PACKET_SC_GETVERSION] = import(".protocol.SCGetVersion")

--通知下线
_M.Protocols[_LAIXIA_PACKET_SC_UserOfflineID] = import(".protocol.SCUserOffline")

--推送道具（充值推送金）
_M.Protocols[_LAIXIA_PACKET_SC_SynPropsChangeID] = import(".protocol.SCSynPropsChange")


_M.Protocols[_LAIXIA_PACKET_CS_UsePackPropID]=import(".protocol.CSUsePackProp")--使用道具
_M.Protocols[_LAIXIA_PACKET_SC_UsePackPropID]=import(".protocol.SCUsePackProp")

_M.Protocols[_LAIXIA_PACKET_CS_VersionOpenID] =import(".protocol.CSVersionOpen")--功能开关信息
_M.Protocols[_LAIXIA_PACKET_SC_VersionOpenID] =import(".protocol.SCVersionOpen")



_M.Protocols[_LAIXIA_PACKET_CS_SuperGiftID]=import(".protocol.CSSuperGift")--超级礼包
_M.Protocols[_LAIXIA_PACKET_SC_SuperGiftID]=import(".protocol.SCSuperGift")

_M.Protocols[_LAIXIA_PACKET_CS_ServiceNoticeID]=import(".protocol.CSServiceNotice")--游戏公告
_M.Protocols[_LAIXIA_PACKET_SC_ServiceNoticeID]=import(".protocol.SCServiceNotice")

_M.Protocols[_LAIXIA_PACKET_CS_RequestOrderID] = import(".protocol.CSRequestOrder") --商城购买请求订单
_M.Protocols[_LAIXIA_PACKET_SC_RequestOrderID] = import(".protocol.SCRequestOrder")

_M.Protocols[_LAIXIA_PACKET_CS_ModifySexNickSignID] = import(".protocol.CSModifySexNickSign")  --修改性别&昵称&签名
_M.Protocols[_LAIXIA_PACKET_SC_ModifySexNickSignID] =import(".protocol.SCModifySexNickSign")



_M.Protocols[_LAIXIA_PACKET_SC_RechargeToClientID] = import(".protocol.SCRechargeToClient")

_M.Protocols[_LAIXIA_PACKET_CS_RechargeToIOS] = import(".protocol.CSRechargeToIOS")
_M.Protocols[_LAIXIA_PACKET_SC_RechargeToIOSRet] = import(".protocol.SCRechargeToIOSRet")

-- 斗地主消息相关
-- 房间列表
_M.Protocols[_LAIXIA_PACKET_CS_ListRoomID]= import(".protocol.landlords.CSRoomList")
_M.Protocols[_LAIXIA_PACKET_SC_ListRoomID] = import(".protocol.landlords.SCRoomList")

-- 进入房间
_M.Protocols[_LAIXIA_PACKET_CS_EnterRoomID]= import(".protocol.landlords.CSEnterRoom")
_M.Protocols[_LAIXIA_PACKET_SC_EnterRoomID] = import(".protocol.landlords.SCEnterRoom")

--快速开始
_M.Protocols[_LAIXIA_PACKET_CS_QuickOpenID ]= import(".protocol.landlords.CSQuickOpen")
_M.Protocols[_LAIXIA_PACKET_SC_QuickOpenID ]= import(".protocol.landlords.SCQuickOpen")

--退出房间
_M.Protocols[_LAIXIA_PACKET_CS_ExitRoomID ]= import(".protocol.landlords.CSExitRoom")
_M.Protocols[_LAIXIA_PACKET_SC_ExitRoomID ]= import(".protocol.landlords.SCExitRoom")

--继续游戏
_M.Protocols[_LAIXIA_PACKET_CS_ContinueGameID]= import(".protocol.landlords.CSContinueGame")
_M.Protocols[_LAIXIA_PACKET_SC_ContinueGameID]= import(".protocol.landlords.SCContinueGame")

--自建桌奖励推送
_M.Protocols[_LAIXIA_PACKET_SC_SelfBuildRewardRetID]= import(".protocol.selfbuild.SCSelfBuildRewardRet")

--站内玩家信息查看
_M.Protocols[_LAIXIA_PACKET_CS_TablePlayerID]= import(".protocol.landlords.CSTablePlayer")
_M.Protocols[_LAIXIA_PACKET_SC_TablePlayerID]= import(".protocol.landlords.SCTablePlayer")

--断网时再牌桌内
_M.Protocols[_LAIXIA_PACKET_CS_OnlineRoomID]= import(".protocol.landlords.CSOnlineRoom")
_M.Protocols[_LAIXIA_PACKET_SC_OnlineRoomID]= import(".protocol.landlords.SCOnlineRoom")

--发底牌
_M.Protocols[_LAIXIA_PACKET_SC_DealHandID] =import(".protocol.landlords.SCDealHand")

--叫地主抢地主
_M.Protocols[_LAIXIA_PACKET_CS_CallBidID] =import(".protocol.landlords.CSCallBid")
_M.Protocols[_LAIXIA_PACKET_SC_CallBidID] =import(".protocol.landlords.SCCallBid")

--出手牌
_M.Protocols[_LAIXIA_PACKET_CS_PlayCardsID] =import(".protocol.landlords.CSPlayCards")
_M.Protocols[_LAIXIA_PACKET_SC_PlayCardsID] =import(".protocol.landlords.SCPlayCards")

--结算
_M.Protocols[_LAIXIA_PACKET_SC_BalanceID] =import(".protocol.landlords.SCBalance")

--属性变化
_M.Protocols[_LAIXIA_PACKET_SC_AttriChangeID] =import(".protocol.landlords.SCAttriChange")

--明牌
_M.Protocols[_LAIXIA_PACKET_CS_ShowCardID] =import(".protocol.landlords.CSShowCard")
_M.Protocols[_LAIXIA_PACKET_SC_ShowCardID] =import(".protocol.landlords.SCShowCard")

--牌桌阶段
_M.Protocols[_LAIXIA_PACKET_SC_TableSyncStageRetID] =import(".protocol.landlords.SCTableSyncStage")

--牌桌同步
_M.Protocols[_LAIXIA_PACKET_SC_TableSyncID] =import(".protocol.landlords.SCTableSync")

--取消托管
_M.Protocols[_LAIXIA_PACKET_CS_CancelMandateID] =import(".protocol.landlords.CSCancelMandate")
_M.Protocols[_LAIXIA_PACKET_SC_CancelMandateID] =import(".protocol.landlords.SCCancelMandate")

--聊天
_M.Protocols[_LAIXIA_PACKET_CS_TableTalkingID]=import(".protocol.landlords.CSTableTalking")
_M.Protocols[_LAIXIA_PACKET_SC_TableTalkingID]=import(".protocol.landlords.SCTableTalking")

--结算亮牌推送
_M.Protocols[_LAIXIA_PACKET_SC_EndShowCardsID]=import(".protocol.landlords.SCEndShowCards")

_M.Protocols[_LAIXIA_PACKET_SC_LeaveRoomID] = import(".protocol.landlords.SCLeaveRoom")

--创建桌超时删除
_M.Protocols[_LAIXIA_PACKET_SC_CreateOverTimeRetID] =import(".protocol.selfbuild.SCCreateOverTimeRet")

--创建牌桌大结算
_M.Protocols[_LAIXIA_PACKET_SC_CreateEndResultRetID] =import(".protocol.selfbuild.SCCreateEndResultRet")

---------------------------------------------------------------------------------------------------
--自建房
--创建房间
_M.Protocols[_LAIXIA_PACKET_CS_CreateTableID] =import(".protocol.selfbuild.CSCreateTable")
_M.Protocols[_LAIXIA_PACKET_SC_CreateTableRetID] =import(".protocol.selfbuild.SCCreateTableRet")

--加入已有房间
_M.Protocols[_LAIXIA_PACKET_CS_JoinTableID] =import(".protocol.selfbuild.CSJoinTable")
_M.Protocols[_LAIXIA_PACKET_SC_JoinTableRetID] =import(".protocol.selfbuild.SCJoinTableRet")

--解散自建桌
_M.Protocols[_LAIXIA_PACKET_CS_CreateDelID] =import(".protocol.selfbuild.CSCreateDel")
_M.Protocols[_LAIXIA_PACKET_SC_CreateDelRetID] =import(".protocol.selfbuild.SCCreateDelRet")

--进入房间--推送同步消息

_M.Protocols[_LAIXIA_PACKET_SC_JoinSyncRetID] =import(".protocol.selfbuild.SCJoinSyncRet")

--创建房间有人退出
_M.Protocols[_LAIXIA_PACKET_SC_CreateExitRetID] =import(".protocol.selfbuild.SCCreateExitRet")

--创建房间列表
_M.Protocols[_LAIXIA_PACKET_CS_CreateListID] =import(".protocol.selfbuild.CSCreateList")
_M.Protocols[_LAIXIA_PACKET_SC_CreateListRetID] =import(".protocol.selfbuild.SCCreateListRet")

--申请解散房间
_M.Protocols[_LAIXIA_PACKET_CS_AppleDismissID] =import(".protocol.selfbuild.CSAppleDismiss")
_M.Protocols[_LAIXIA_PACKET_SC_AppleDismissID] =import(".protocol.selfbuild.SCAppleDismiss")

--闯将房间继续开始
_M.Protocols[_LAIXIA_PACKET_CS_CreateGoonID] =import(".protocol.selfbuild.CSCreateGoon")
_M.Protocols[_LAIXIA_PACKET_SC_CreateGoonRetID] =import(".protocol.selfbuild.SCCreateGoonRet")
---------------------------------------------------------------------------------------------------
-- 比赛相关
_M.Protocols[_LAIXIA_PACKET_CS_MatchRegisterID] = import(".protocol.match.CSMatchRegister") --报名 +1
_M.Protocols[_LAIXIA_PACKET_SC_MatchRegisterID] =import(".protocol.match.SCMatchRegister")

_M.Protocols[_LAIXIA_PACKET_CS_MatchGameID] = import(".protocol.match.CSMatchGame") --比赛列表   +2
_M.Protocols[_LAIXIA_PACKET_SC_MatchGameID] = import(".protocol.match.SCMatchGame")

_M.Protocols[_LAIXIA_PACKET_CS_ExitMatchGameID] = import(".protocol.match.CSExitMatchGame") --比赛退出报名 + 3
_M.Protocols[_LAIXIA_PACKET_SC_ExitMatchGameID]=import(".protocol.match.SCExitMatchGame")

_M.Protocols[_LAIXIA_PACKET_SC_FailExitMatchID] = import(".protocol.match.SCFailExitMatch")--比赛失败退出 +4

_M.Protocols[_LAIXIA_PACKET_SC_ExitTipsMatchID] = import(".protocol.match.SCExitTipsMatch") --返还报名费 + 5

_M.Protocols[_LAIXIA_PACKET_CS_MatchQuitDeskID] = import(".protocol.match.CSMatchQuitDesk") --比赛退出牌桌  +6
_M.Protocols[_LAIXIA_PACKET_SC_MatchQuitDeskID] =import(".protocol.match.SCMatchQuitDesk")

_M.Protocols[_LAIXIA_PACKET_CS_IsMatchID] = import(".protocol.match.CSIsMatch") --短线重连时，是否进入比赛  +7
_M.Protocols[_LAIXIA_PACKET_SC_IsMatchID] =import(".protocol.match.SCIsMatch")

_M.Protocols[_LAIXIA_PACKET_CS_MatchJoinInID] = import(".protocol.match.CSMatchJoinIn") --确认参加比赛 +8
_M.Protocols[_LAIXIA_PACKET_SC_MatchJoinInID] = import(".protocol.match.SCMatchJoinIn")

_M.Protocols[_LAIXIA_PACKET_SC_MatchWaitQueueID]=import(".protocol.match.SCMatchWaitQueue") --玩家进入等待队列  +9

_M.Protocols[_LAIXIA_PACKET_SC_MatchStageUpID] = import(".protocol.match.SCMatchStageUp") --比赛阶段变化同步 +10

_M.Protocols[_LAIXIA_PACKET_SC_MatchRenManUpID] =import(".protocol.match.SCMatchRenManUp") --人满开赛数据更新  +11

_M.Protocols[_LAIXIA_PACKET_CS_MatchDetailsID] = import(".protocol.match.CSMatchDetails") --比赛详情页  +12
_M.Protocols[_LAIXIA_PACKET_SC_MatchDetailsID] = import(".protocol.match.SCMatchDetails")

_M.Protocols[_LAIXIA_PACKET_CS_MatchIntegralRankID] = import(".protocol.match.CSMatchIntergralRank")  --获取积分榜  +14
_M.Protocols[_LAIXIA_PACKET_SC_MatchIntegralRankID]  = import(".protocol.match.SCMatchIntergralRank")

_M.Protocols[_LAIXIA_PACKET_SC_MatchRankID] = import(".protocol.match.SCMatchRank")  --获取当前排名和积分+15

_M.Protocols[_LAIXIA_PACKET_SC_MatchResultID] = import(".protocol.match.SCMatchResult")  --比赛奖励+16

_M.Protocols[_LAIXIA_PACKET_SC_MatchTimingID] =import(".protocol.match.SCMatchTiming")  --定时开赛中间等待界面+17

_M.Protocols[_LAIXIA_PACKET_SC_MatchStopMaintainID] = import(".protocol.match.SCMatchStopMaintain") -- 比赛服务器维护 +18

_M.Protocols[_LAIXIA_PACKET_SC_MatchResurrectionBackID] = import(".protocol.match.SCMatchResurrectionBack") --可复活退出 +19

_M.Protocols[_LAIXIA_PACKET_CS_MatchResurrectionID] = import(".protocol.match.CSMatchResurrection") --确认复活 +20
_M.Protocols[_LAIXIA_PACKET_SC_MatchResurrectionID] = import(".protocol.match.SCMatchResurrection") --复活

_M.Protocols[_LAIXIA_PACKET_SC_MatchStopCompensationID] = import(".protocol.match.SCMatchStopCompensation") --服务器维护补偿 +21

_M.Protocols[_LAIXIA_PACKET_SC_MatchFloatwordID] = import(".protocol.match.SCMatchFloatword") -- 比赛飘字提示+22

_M.Protocols[_LAIXIA_PACKET_CS_MatchOpenRecentTimeID] = import(".protocol.match.CSMatchOpenRecentTime") -- 获取最近的定时开赛的比赛+23
_M.Protocols[_LAIXIA_PACKET_SC_MatchOpenRecentTimeID] = import(".protocol.match.SCMatchOpenRecentTime")

_M.Protocols[_LAIXIA_PACKET_SC_MatchPhaseChangeID] = import(".protocol.match.SCMatchPhaseChange")-- 阶段改变等待消息

--龙虎斗
_M.Protocols[_LAIXIA_PACKET_CS_DragonTigerEnterID] = import('.protocol.dragon.CSDragonTigerEnter')
_M.Protocols[_LAIXIA_PACKET_SC_DragonTigerEnterID] = import('.protocol.dragon.SCDragonTigerEnter')
_M.Protocols[_LAIXIA_PACKET_SC_DragonTigerSyncStageID] = import('.protocol.dragon.SCDragonTigerSyncStage')
_M.Protocols[_LAIXIA_PACKET_CS_DragonTigerBetID] = import('.protocol.dragon.CSDragonTigerBet')
_M.Protocols[_LAIXIA_PACKET_SC_DragonTigerBetID] = import('.protocol.dragon.SCDragonTigerBet')
_M.Protocols[_LAIXIA_PACKET_SC_DragonTigerTableSyncID] = import('.protocol.dragon.SCDragonTigerTableSync')
_M.Protocols[_LAIXIA_PACKET_SC_DragonTigerResultID] = import('.protocol.dragon.SCDragonTigerResult')
_M.Protocols[_LAIXIA_PACKET_SC_DragonTigerRewardID] = import('.protocol.dragon.SCDragonTigerReward')
_M.Protocols[_LAIXIA_PACKET_CS_DragonHistoryRecordID] = import('.protocol.dragon.CSDragonHistoryRecord')
_M.Protocols[_LAIXIA_PACKET_SC_DragonHistoryRecordID] = import('.protocol.dragon.SCDragonHistoryRecord')
_M.Protocols[_LAIXIA_PACKET_CS_DragonQuitID] = import('.protocol.dragon.CSDragonQuit')
_M.Protocols[_LAIXIA_PACKET_SC_DragonQuitID] = import('.protocol.dragon.SCDragonQuit')
_M.Protocols[_LAIXIA_PACKET_CS_DragonPresentID] = import('.protocol.dragon.CSDragonPresent')
_M.Protocols[_LAIXIA_PACKET_SC_DragonPresentRetID] = import('.protocol.dragon.SCDragonPresentRet')
--------------------------------------------------------------------------------------------
--大转盘
_M.Protocols[_LAIXIA_PACKET_CS_TurnTableEnterID] = import('.protocol.truntable.CSTurnTableEnter')
_M.Protocols[_LAIXIA_PACKET_SC_TurnTableEnterRetID] = import('.protocol.truntable.SCTurnTableEnterRet')
_M.Protocols[_LAIXIA_PACKET_CS_TurnTableLotteryID] = import('.protocol.truntable.CSTurnTableLottery')
_M.Protocols[_LAIXIA_PACKET_SC_TurnTableLotteryRetID] = import('.protocol.truntable.SCTurnTableLotteryRet')
_M.Protocols[_LAIXIA_PACKET_CS_TurnTableResultID] = import('.protocol.truntable.CSTurnTableResult')
_M.Protocols[_LAIXIA_PACKET_SC_TurnTableResultRetID] = import('.protocol.truntable.SCTurnTableResultRet')
----------------------------------------------------------------------------------------------
--万人牛牛
_M.Protocols[_LAIXIA_PACKET_CS_EnterTenThousandID] = import('.protocol.tenthousand.CSEnterTenThousand')
_M.Protocols[_LAIXIA_PACKET_SC_EnterTenThousandRetID] = import('.protocol.tenthousand.SCEnterTenThousandRet')
_M.Protocols[_LAIXIA_PACKET_CS_TenThousandBetID] = import('.protocol.tenthousand.CSTenThousandBet')
_M.Protocols[_LAIXIA_PACKET_SC_TenThousandBetRetID] = import('.protocol.tenthousand.SCTenThousandBetRet')
_M.Protocols[_LAIXIA_PACKET_SC_TenThousandResultRetID] = import('.protocol.tenthousand.SCTenThousandResultRet')
_M.Protocols[_LAIXIA_PACKET_SC_TenThousandSynRetID] = import('.protocol.tenthousand.SCTenThousandSynRet')
_M.Protocols[_LAIXIA_PACKET_CS_TenThousandHistoryID] = import('.protocol.tenthousand.CSTenThousandHistory')
_M.Protocols[_LAIXIA_PACKET_SC_TenThousandHistoryRetID] = import('.protocol.tenthousand.SCTenThousandHistoryRet')
_M.Protocols[_LAIXIA_PACKET_CS_TenThousandQuitID] = import('.protocol.tenthousand.CSTenThousandQuit')
_M.Protocols[_LAIXIA_PACKET_SC_TenThousandQuitRetID] = import('.protocol.tenthousand.SCTenThousandQuitRet')

--万人牛牛翻牌界面
--界面初始化
_M.Protocols[_LAIXIA_PACKET_CS_FlopInitID] = import('.protocol.tenthousand.CSFlopInit')
_M.Protocols[_LAIXIA_PACKET_SC_FlopInitRetID] = import('.protocol.tenthousand.SCFlopInitRet')
_M.Protocols[_LAIXIA_PACKET_CS_FlopOpenID] = import('.protocol.tenthousand.CSFlopOpen')
_M.Protocols[_LAIXIA_PACKET_SC_FlopOpenRetID] = import('.protocol.tenthousand.SCFlopOpenRet')
_M.Protocols[_LAIXIA_PACKET_CS_FlopHalfGoldID] = import('.protocol.tenthousand.CSFlopHalfGold')
_M.Protocols[_LAIXIA_PACKET_SC_FlopHalfGoldRetID] = import('.protocol.tenthousand.SCFlopHalfGoldRet')
_M.Protocols[_LAIXIA_PACKET_CS_FlopEndID] = import('.protocol.tenthousand.CSFlopEnd')
_M.Protocols[_LAIXIA_PACKET_SC_FlopEndRetID] = import('.protocol.tenthousand.SCFlopEndRet')

--水果机界面
_M.Protocols[_LAIXIA_PACKET_CS_FruitInitGameID]      = import('.protocol.fruit.CSFruitInit')
_M.Protocols[_LAIXIA_PACKET_SC_FruitInitGameRetID]   = import('.protocol.fruit.SCFruitInitRet')

_M.Protocols[_LAIXIA_PACKET_SC_FruitGameStartRetID]   = import('.protocol.fruit.SCFruitGameStartRet')
_M.Protocols[_LAIXIA_PACKET_CS_FruitAddBetID]      = import('.protocol.fruit.CSFruitAddBet')
_M.Protocols[_LAIXIA_PACKET_SC_FruitAddBetRetID]   = import('.protocol.fruit.SCFruitAddBetRet')
_M.Protocols[_LAIXIA_PACKET_CS_FruitRebetID]      = import('.protocol.fruit.CSFruitRebet')
_M.Protocols[_LAIXIA_PACKET_SC_FruitRebetRetID]   = import('.protocol.fruit.SCFruitRebetRet')
_M.Protocols[_LAIXIA_PACKET_SC_FruitrefreshBetsRetID]   = import('.protocol.fruit.SCFruitrefreshBetsRet')
_M.Protocols[_LAIXIA_PACKET_SC_FruitRollRetID]   = import('.protocol.fruit.SCFruitRollRet')
_M.Protocols[_LAIXIA_PACKET_SC_FruitLotteryRetID]   = import('.protocol.fruit.SCFruitLotteryRet')
_M.Protocols[_LAIXIA_PACKET_CS_FruitExitID]      = import('.protocol.fruit.CSFruitExit')
--_M.Protocols[_LAIXIA_PACKET_SC_FruitExitRetID]   = import('.protocol.fruit.SCFruitExitRet')

_M.Protocols[_T_PACKET_SC_FruitSYNRetID]      = import('.protocol.fruit.SCFruitSYNRet')

-------------------------------------------------------------------------------------------
-- 多人三张牌相关 --
-- 进入游戏
_M.Protocols[_LAIXIA_PACKET_CS_MckitEnterGameID] = import(".protocol.threecards.CSMckitEnterGame")
_M.Protocols[_LAIXIA_PACKET_SC_MckitEnterGameID] = import(".protocol.threecards.SCMckitEnterGame")
-- 坐下
_M.Protocols[_LAIXIA_PACKET_CS_MckitSitDownID] = import(".protocol.threecards.CSMckitSitDown")
_M.Protocols[_LAIXIA_PACKET_SC_MckitSitDownID] = import(".protocol.threecards.SCMckitSitDown")
-- 站起
_M.Protocols[_LAIXIA_PACKET_CS_MckitStandUpID] = import(".protocol.threecards.CSMckitStandUp")
_M.Protocols[_LAIXIA_PACKET_SC_MckitStandUpID] = import(".protocol.threecards.SCMckitStandUp")
-- 换桌
_M.Protocols[_LAIXIA_PACKET_CS_MckitChangeID] = import(".protocol.threecards.CSMckitChange")
_M.Protocols[_LAIXIA_PACKET_SC_MckitChangeID] = import(".protocol.threecards.SCMckitChange")
-- 离桌
_M.Protocols[_LAIXIA_PACKET_CS_MckitExitID] = import(".protocol.threecards.CSMckitExit")
_M.Protocols[_LAIXIA_PACKET_SC_MckitExitID] = import(".protocol.threecards.SCMckitExit")
-- 游戏开始
_M.Protocols[_LAIXIA_PACKET_SC_MckitStartID] = import(".protocol.threecards.SCMckitStart")
-- 游戏结算
_M.Protocols[_LAIXIA_PACKET_SC_MckitRoundResultID] = import(".protocol.threecards.SCMckitRoundResult")
-- 游戏结束
_M.Protocols[_LAIXIA_PACKET_SC_MckitOverID] = import(".protocol.threecards.SCMckitOver")
-- 操作开始
_M.Protocols[_LAIXIA_PACKET_SC_MckitPlayerOptionID] = import(".protocol.threecards.SCMckitPlayerOption")
-- 下注
_M.Protocols[_LAIXIA_PACKET_CS_MckitBetID] = import(".protocol.threecards.CSMckitBet")
_M.Protocols[_LAIXIA_PACKET_SC_MckitBetID] = import(".protocol.threecards.SCMckitBet")
-- 跟注
_M.Protocols[_LAIXIA_PACKET_CS_MckitFollowID] = import(".protocol.threecards.CSMckitFollow")
_M.Protocols[_LAIXIA_PACKET_SC_MckitFollowID] = import(".protocol.threecards.SCMckitFollow")
-- 看牌
_M.Protocols[_LAIXIA_PACKET_CS_MckitSeeCardsID] = import(".protocol.threecards.CSMckitSeeCards")
_M.Protocols[_LAIXIA_PACKET_SC_MckitSeeCardsID] = import(".protocol.threecards.SCMckitSeeCards")
-- 比牌
_M.Protocols[_LAIXIA_PACKET_CS_MckitCompareCardID] = import(".protocol.threecards.CSMckitCmpCard")
_M.Protocols[_LAIXIA_PACKET_SC_MckitCompareCardID] = import(".protocol.threecards.SCMckitCmpCard")
-- 弃牌
_M.Protocols[_LAIXIA_PACKET_CS_MckitThrowCardsID] = import(".protocol.threecards.CSMckitThrowCards")
_M.Protocols[_LAIXIA_PACKET_SC_MckitThrowCardsID] = import(".protocol.threecards.SCMckitThrowCards")
-- 秀牌
_M.Protocols[_LAIXIA_PACKET_CS_MckitShowCardsID] = import(".protocol.threecards.CSMckitShowCards")
_M.Protocols[_LAIXIA_PACKET_SC_MckitShowCardsID] = import(".protocol.threecards.SCMckitShowCards")
-- led
_M.Protocols[_LAIXIA_PACKET_SC_MckitNotifyID] = import(".protocol.threecards.SCMckitNotify")
--个人账单
-- 秀牌
_M.Protocols[_LAIXIA_PACKET_CS_PERSONBILL] = import(".protocol.CSPersonBill")
_M.Protocols[_LAIXIA_PACKET_SC_PERSONBILL] = import(".protocol.SCPersonBill")

--活动请求
_M.Protocols[_LAIXIA_PACKET_CS_GETTASKLIST] = import(".protocol.CSSendGetTaskList")
_M.Protocols[_LAIXIA_PACKET_SC_GETTASKLIST] = import(".protocol.SCSendGetTaskList")

--请求比赛列表的标签
_M.Protocols[_LAIXIA_PACKET_CS_MatchSignID] = import(".protocol.match.CSMatchSign")
_M.Protocols[_LAIXIA_PACKET_SC_MatchSignID] = import(".protocol.match.SCMatchSign")


function _M.getProtocol(ID)
    return  _M.Protocols[ID];
end

return Protocols

















   



