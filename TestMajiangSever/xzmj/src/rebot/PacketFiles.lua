require("rebot/PacketID")

local PacketFiles = {}
PacketFiles.Protocols = {}

PacketFiles.Protocols[_LAIXIA_PACKET_CS_Login_ID] = require("rebot.protocol.CSLogin")
PacketFiles.Protocols[_LAIXIA_PACKET_SC_Login_ID] = require("rebot.protocol.SCLoginRet")

PacketFiles.Protocols[_LAIXIA_PACKET_CS_EnterGameID]= require("rebot.protocol.CSEnterGame")
PacketFiles.Protocols[_LAIXIA_PACKET_SC_EnterGameID]= require("rebot.protocol.SCEnterGame")

----进入个人信息
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_PersonalCenterID] = require("rebot.protocol.CSPersonalCenter");
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_PersonalCenterID] = require("rebot.protocol.SCPersonalCenter");

----排行榜
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_RankID] = require("rebot.protocol.CSRank")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_RankID] = require("rebot.protocol.SCRank")

----点击某个玩家
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_PlayerRankInfoID] = require("rebot.protocol.CSPlayerRankInfo")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_PlayerRankInfoID] = require("rebot.protocol.SCPlayerRankInfo")

----是否有站内信
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_HasMailID] = require("rebot.protocol.CSHasMail")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_HasMailID] = require("rebot.protocol.SCHasMail")

----请求站内信
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_SmsListID] = require("rebot.protocol.CSSmsList")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_SmsListID] = require("rebot.protocol.SCSmsList")

----签到表（连续登陆）
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_SignLandingID] = require("rebot.protocol.CSSignLanding")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_SignLandingID] = require("rebot.protocol.SCSignLanding")

----签到
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_SignID] = require("rebot.protocol.CSSign")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_SignID] = require("rebot.protocol.SCSign")

----快充礼包
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_QuickSuperBagID] = require("rebot.protocol.CSQuickSuperBag")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_QuickSuperBagID] = require("rebot.protocol.SCQuickSuperBag")

----破产礼包
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_BankruptBagID] = require("rebot.protocol.CSBankruptBag")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_BankruptBagID] = require("rebot.protocol.SCBankruptBag")

----首充礼包
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_FirstSuperBagID] = require("rebot.protocol.CSFirstSuperBag")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_FirstSuperBagID] = require("rebot.protocol.SCFirstSuperBag")

----商城
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_ShopID] = require("rebot.protocol.CSShop")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_ShopID] = require("rebot.protocol.SCShop")

----修改密码
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_RevisePwdID] = require("rebot.protocol.CSRevisePwd")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_RevisePwdID] = require("rebot.protocol.SCRevisePwd")

----找回密码
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_FindPwdID] = require("rebot.protocol.CSFindPwd")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_FindPwdID] = require("rebot.protocol.SCFindPwd")

----获取包裹
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_PackItemsID] = require("rebot.protocol.CSPackItems")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_PackItemsID] = require("rebot.protocol.SCPackItems")

----使用道具
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_UsePacksID] = require("rebot.protocol.CSUsePacks")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_UsePacksID] = require("rebot.protocol.SCUsePacksRet")

----绑定手机获取验证码
--PacketFiles.Protocols[_LAIXIA_PACKET_CSCodeBindingID] = require("rebot.protocol.CSCodeBinding")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_SCCodeBindingID] = require("rebot.protocol.SCCodeBinding")

----绑定玩家手机
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_BoundPhoneID] = require("rebot.protocol.CSBoundPhone")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_BoundPhoneID] = require("rebot.protocol.SCBoundPhone")

----获取兑换列表
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_ExchangeDataID] = require("rebot.protocol.CSExchangeData")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_ExchangeDataID] = require("rebot.protocol.SCExchangeData")

----兑换
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_ExchangeID] = require("rebot.protocol.CSExchange")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_ExchangeID] = require("rebot.protocol.SCExchange")

----头像上传
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_HeadUploadID] = require("rebot.protocol.CSHeadUpload")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_HeadUploadID] = require("rebot.protocol.SCHeadUpload")

----心跳
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_HeartBeatID] = require("rebot.protocol.CSHeartBeat")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_HeartBeatID] = require("rebot.protocol.SCHeartBeat")

----兑换码兑换
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_RedeemCodeID] = require("rebot.protocol.CSRedeemCode")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_RedeemCodeID] = require("rebot.protocol.SCRedeemCode")

----请求救济金
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_ReliefFundID] = require("rebot.protocol.CSReliefFund")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_ReliefFundID] = require("rebot.protocol.SCReliefFund")

----请求救济金剩余次数
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_ReliefFundInfoID] = require("rebot.protocol.CSReliefFundInfo")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_ReliefFundInfoID] = require("rebot.protocol.SCReliefFundInfo")

----进入大厅获取个人数据
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_HallLobbyID] = require("rebot.protocol.CSHallLobby")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_HallLobbyID] = require("rebot.protocol.SCHallLobby")



----广播推送  走马灯
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_RotateNoticeID] = require("rebot.protocol.SCRotateNotice")

----服务器维护踢人下线
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_CutLineID] = require("rebot.protocol.SCCutLine")


----推广活动绑定ID
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_ExtensionBindingID] = require("rebot.protocol.CSExtensionBinding")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_ExtensionBindingRetID] = require("rebot.protocol.SCExtensionBindingRet")

----推广活动领取金币
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_ReceiveExtensionID] = require("rebot.protocol.CSReceiveExtension")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_ReceiveExtensionRetID] = require("rebot.protocol.SCReceiveExtensionRet")

----赠送道具
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_PresentID] = require("rebot.protocol.CSPresent")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_PresentRetID] = require("rebot.protocol.SCPresentRet")

----推广活动规则
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_ExtensionRuleID] = require("rebot.protocol.CSExtensionRule")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_ExtensionRuleRetID] = require("rebot.protocol.SCExtensionRuleRet")

----触发是否有周卡月卡礼包
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_WeekOrMonthCardID] = require("rebot.protocol.CSWeekOrMonthCard")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_WeekOrMonthCardRetID] = require("rebot.protocol.SCWeekOrMonthCardRet")

----活动请求
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_ActivityID] = require("rebot.protocol.CSActivity")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_ActivityID] = require("rebot.protocol.SCActivity")

----活动请求
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_GETVERSION] = require("rebot.protocol.CSGetVersion")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_GETVERSION] = require("rebot.protocol.SCGetVersion")

----通知下线
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_UserOfflineID] = require("rebot.protocol.SCUserOffline")

----推送道具（充值推送金）
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_SynPropsChangeID] = require("rebot.protocol.SCSynPropsChange")


--PacketFiles.Protocols[_LAIXIA_PACKET_CS_UsePackPropID]=require("rebot.protocol.CSUsePackProp")--使用道具
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_UsePackPropID]=require("rebot.protocol.SCUsePackProp")

--PacketFiles.Protocols[_LAIXIA_PACKET_CS_VersionOpenID] =require("rebot.protocol.CSVersionOpen")--功能开关信息
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_VersionOpenID] =require("rebot.protocol.SCVersionOpen")



--PacketFiles.Protocols[_LAIXIA_PACKET_CS_SuperGiftID]=require("rebot.protocol.CSSuperGift")--超级礼包
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_SuperGiftID]=require("rebot.protocol.SCSuperGift")

--PacketFiles.Protocols[_LAIXIA_PACKET_CS_ServiceNoticeID]=require("rebot.protocol.CSServiceNotice")--游戏公告
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_ServiceNoticeID]=require("rebot.protocol.SCServiceNotice")

--PacketFiles.Protocols[_LAIXIA_PACKET_CS_RequestOrderID] = require("rebot.protocol.CSRequestOrder") --商城购买请求订单
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_RequestOrderID] = require("rebot.protocol.SCRequestOrder")

--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesodifySexNickSignID] = require("rebot.protocol.CSModifySexNickSign")  --修改性别&昵称&签名
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesodifySexNickSignID] =require("rebot.protocol.SCModifySexNickSign")



--PacketFiles.Protocols[_LAIXIA_PACKET_SC_RechargeToClientID] = require("rebot.protocol.SCRechargeToClient")

--PacketFiles.Protocols[_LAIXIA_PACKET_CS_RechargeToIOS] = require("rebot.protocol.CSRechargeToIOS")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_RechargeToIOSRet] = require("rebot.protocol.SCRechargeToIOSRet")

---- 斗地主消息相关
---- 房间列表
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_ListRoomID]= require("rebot.protocol.landlords.CSRoomList")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_ListRoomID] = require("rebot.protocol.landlords.SCRoomList")

---- 进入房间
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_EnterRoomID]= require("rebot.protocol.landlords.CSEnterRoom")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_EnterRoomID] = require("rebot.protocol.landlords.SCEnterRoom")

----快速开始
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_QuickOpenID ]= require("rebot.protocol.landlords.CSQuickOpen")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_QuickOpenID ]= require("rebot.protocol.landlords.SCQuickOpen")

----退出房间
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_ExitRoomID ]= require("rebot.protocol.landlords.CSExitRoom")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_ExitRoomID ]= require("rebot.protocol.landlords.SCExitRoom")

----继续游戏
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_ContinueGameID]= require("rebot.protocol.landlords.CSContinueGame")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_ContinueGameID]= require("rebot.protocol.landlords.SCContinueGame")

----自建桌奖励推送
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_SelfBuildRewardRetID]= require("rebot.protocol.selfbuild.SCSelfBuildRewardRet")

----站内玩家信息查看
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_TablePlayerID]= require("rebot.protocol.landlords.CSTablePlayer")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_TablePlayerID]= require("rebot.protocol.landlords.SCTablePlayer")

----断网时再牌桌内
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_OnlineRoomID]= require("rebot.protocol.landlords.CSOnlineRoom")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_OnlineRoomID]= require("rebot.protocol.landlords.SCOnlineRoom")

----发底牌
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_DealHandID] =require("rebot.protocol.landlords.SCDealHand")

----叫地主抢地主
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_CallBidID] =require("rebot.protocol.landlords.CSCallBid")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_CallBidID] =require("rebot.protocol.landlords.SCCallBid")

----出手牌
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_PlayCardsID] =require("rebot.protocol.landlords.CSPlayCards")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_PlayCardsID] =require("rebot.protocol.landlords.SCPlayCards")

----结算
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_BalanceID] =require("rebot.protocol.landlords.SCBalance")

----属性变化
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_AttriChangeID] =require("rebot.protocol.landlords.SCAttriChange")

----明牌
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_ShowCardID] =require("rebot.protocol.landlords.CSShowCard")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_ShowCardID] =require("rebot.protocol.landlords.SCShowCard")

----牌桌阶段
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_TableSyncStageRetID] =require("rebot.protocol.landlords.SCTableSyncStage")

----牌桌同步
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_TableSyncID] =require("rebot.protocol.landlords.SCTableSync")

----取消托管
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_CancelMandateID] =require("rebot.protocol.landlords.CSCancelMandate")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_CancelMandateID] =require("rebot.protocol.landlords.SCCancelMandate")

----聊天
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_TableTalkingID]=require("rebot.protocol.landlords.CSTableTalking")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_TableTalkingID]=require("rebot.protocol.landlords.SCTableTalking")

----结算亮牌推送
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_EndShowCardsID]=require("rebot.protocol.landlords.SCEndShowCards")

--PacketFiles.Protocols[_LAIXIA_PACKET_SC_LeaveRoomID] = require("rebot.protocol.landlords.SCLeaveRoom")

----创建桌超时删除
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_CreateOverTimeRetID] =require("rebot.protocol.selfbuild.SCCreateOverTimeRet")

----创建牌桌大结算
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_CreateEndResultRetID] =require("rebot.protocol.selfbuild.SCCreateEndResultRet")

-----------------------------------------------------------------------------------------------------
----自建房
----创建房间
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_CreateTableID] =require("rebot.protocol.selfbuild.CSCreateTable")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_CreateTableRetID] =require("rebot.protocol.selfbuild.SCCreateTableRet")

----加入已有房间
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_JoinTableID] =require("rebot.protocol.selfbuild.CSJoinTable")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_JoinTableRetID] =require("rebot.protocol.selfbuild.SCJoinTableRet")

----解散自建桌
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_CreateDelID] =require("rebot.protocol.selfbuild.CSCreateDel")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_CreateDelRetID] =require("rebot.protocol.selfbuild.SCCreateDelRet")

----进入房间--推送同步消息

--PacketFiles.Protocols[_LAIXIA_PACKET_SC_JoinSyncRetID] =require("rebot.protocol.selfbuild.SCJoinSyncRet")

----创建房间有人退出
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_CreateExitRetID] =require("rebot.protocol.selfbuild.SCCreateExitRet")

----创建房间列表
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_CreateListID] =require("rebot.protocol.selfbuild.CSCreateList")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_CreateListRetID] =require("rebot.protocol.selfbuild.SCCreateListRet")

----申请解散房间
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_AppleDismissID] =require("rebot.protocol.selfbuild.CSAppleDismiss")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_AppleDismissID] =require("rebot.protocol.selfbuild.SCAppleDismiss")

----闯将房间继续开始
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_CreateGoonID] =require("rebot.protocol.selfbuild.CSCreateGoon")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_CreateGoonRetID] =require("rebot.protocol.selfbuild.SCCreateGoonRet")
-----------------------------------------------------------------------------------------------------
---- 比赛相关
PacketFiles.Protocols[_LAIXIA_PACKET_CS_MatchRegisterID] = require("rebot.protocol.CSMatchRegister") --报名 +1
PacketFiles.Protocols[_LAIXIA_PACKET_SC_MatchRegisterID] = require("rebot.protocol.SCMatchRegister")

--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesatchGameID] = require("rebot.protocol.match.CSMatchGame") --比赛列表   +2
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchGameID] = require("rebot.protocol.match.SCMatchGame")

--PacketFiles.Protocols[_LAIXIA_PACKET_CS_ExitMatchGameID] = require("rebot.protocol.match.CSExitMatchGame") --比赛退出报名 + 3
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_ExitMatchGameID]=require("rebot.protocol.match.SCExitMatchGame")

--PacketFiles.Protocols[_LAIXIA_PACKET_SC_FailExitMatchID] = require("rebot.protocol.match.SCFailExitMatch")--比赛失败退出 +4

--PacketFiles.Protocols[_LAIXIA_PACKET_SC_ExitTipsMatchID] = require("rebot.protocol.match.SCExitTipsMatch") --返还报名费 + 5

--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesatchQuitDeskID] = require("rebot.protocol.match.CSMatchQuitDesk") --比赛退出牌桌  +6
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchQuitDeskID] =require("rebot.protocol.match.SCMatchQuitDesk")

--PacketFiles.Protocols[_LAIXIA_PACKET_CS_IsMatchID] = require("rebot.protocol.match.CSIsMatch") --短线重连时，是否进入比赛  +7
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_IsMatchID] =require("rebot.protocol.match.SCIsMatch")

--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesatchJoinInID] = require("rebot.protocol.match.CSMatchJoinIn") --确认参加比赛 +8
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchJoinInID] = require("rebot.protocol.match.SCMatchJoinIn")

--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchWaitQueueID]=require("rebot.protocol.match.SCMatchWaitQueue") --玩家进入等待队列  +9

--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchStageUpID] = require("rebot.protocol.match.SCMatchStageUp") --比赛阶段变化同步 +10

--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchRenManUpID] =require("rebot.protocol.match.SCMatchRenManUp") --人满开赛数据更新  +11

--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesatchDetailsID] = require("rebot.protocol.match.CSMatchDetails") --比赛详情页  +12
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchDetailsID] = require("rebot.protocol.match.SCMatchDetails")

--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesatchIntegralRankID] = require("rebot.protocol.match.CSMatchIntergralRank")  --获取积分榜  +14
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchIntegralRankID]  = require("rebot.protocol.match.SCMatchIntergralRank")

--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchRankID] = require("rebot.protocol.match.SCMatchRank")  --获取当前排名和积分+15

--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchResultID] = require("rebot.protocol.match.SCMatchResult")  --比赛奖励+16

--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchTimingID] =require("rebot.protocol.match.SCMatchTiming")  --定时开赛中间等待界面+17

--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchStopMaintainID] = require("rebot.protocol.match.SCMatchStopMaintain") -- 比赛服务器维护 +18

--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchResurrectionBackID] = require("rebot.protocol.match.SCMatchResurrectionBack") --可复活退出 +19

--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesatchResurrectionID] = require("rebot.protocol.match.CSMatchResurrection") --确认复活 +20
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchResurrectionID] = require("rebot.protocol.match.SCMatchResurrection") --复活

--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchStopCompensationID] = require("rebot.protocol.match.SCMatchStopCompensation") --服务器维护补偿 +21

--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchFloatwordID] = require("rebot.protocol.match.SCMatchFloatword") -- 比赛飘字提示+22

--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesatchOpenRecentTimeID] = require("rebot.protocol.match.CSMatchOpenRecentTime") -- 获取最近的定时开赛的比赛+23
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchOpenRecentTimeID] = require("rebot.protocol.match.SCMatchOpenRecentTime")

--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesatchPhaseChangeID] = require("rebot.protocol.match.SCMatchPhaseChange")-- 阶段改变等待消息

----龙虎斗
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_DragonTigerEnterID] = _G.inport('.protocol.dragon.CSDragonTigerEnter')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_DragonTigerEnterID] = _G.inport('.protocol.dragon.SCDragonTigerEnter')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_DragonTigerSyncStageID] = _G.inport('.protocol.dragon.SCDragonTigerSyncStage')
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_DragonTigerBetID] = _G.inport('.protocol.dragon.CSDragonTigerBet')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_DragonTigerBetID] = _G.inport('.protocol.dragon.SCDragonTigerBet')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_DragonTigerTableSyncID] = _G.inport('.protocol.dragon.SCDragonTigerTableSync')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_DragonTigerResultID] = _G.inport('.protocol.dragon.SCDragonTigerResult')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_DragonTigerRewardID] = _G.inport('.protocol.dragon.SCDragonTigerReward')
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_DragonHistoryRecordID] = _G.inport('.protocol.dragon.CSDragonHistoryRecord')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_DragonHistoryRecordID] = _G.inport('.protocol.dragon.SCDragonHistoryRecord')
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_DragonQuitID] = _G.inport('.protocol.dragon.CSDragonQuit')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_DragonQuitID] = _G.inport('.protocol.dragon.SCDragonQuit')
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_DragonPresentID] = _G.inport('.protocol.dragon.CSDragonPresent')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_DragonPresentRetID] = _G.inport('.protocol.dragon.SCDragonPresentRet')
----------------------------------------------------------------------------------------------
----大转盘
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_TurnTableEnterID] = _G.inport('.protocol.truntable.CSTurnTableEnter')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_TurnTableEnterRetID] = _G.inport('.protocol.truntable.SCTurnTableEnterRet')
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_TurnTableLotteryID] = _G.inport('.protocol.truntable.CSTurnTableLottery')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_TurnTableLotteryRetID] = _G.inport('.protocol.truntable.SCTurnTableLotteryRet')
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_TurnTableResultID] = _G.inport('.protocol.truntable.CSTurnTableResult')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_TurnTableResultRetID] = _G.inport('.protocol.truntable.SCTurnTableResultRet')
------------------------------------------------------------------------------------------------
----万人牛牛
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_EnterTenThousandID] = _G.inport('.protocol.tenthousand.CSEnterTenThousand')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_EnterTenThousandRetID] = _G.inport('.protocol.tenthousand.SCEnterTenThousandRet')
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_TenThousandBetID] = _G.inport('.protocol.tenthousand.CSTenThousandBet')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_TenThousandBetRetID] = _G.inport('.protocol.tenthousand.SCTenThousandBetRet')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_TenThousandResultRetID] = _G.inport('.protocol.tenthousand.SCTenThousandResultRet')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_TenThousandSynRetID] = _G.inport('.protocol.tenthousand.SCTenThousandSynRet')
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_TenThousandHistoryID] = _G.inport('.protocol.tenthousand.CSTenThousandHistory')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_TenThousandHistoryRetID] = _G.inport('.protocol.tenthousand.SCTenThousandHistoryRet')
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_TenThousandQuitID] = _G.inport('.protocol.tenthousand.CSTenThousandQuit')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_TenThousandQuitRetID] = _G.inport('.protocol.tenthousand.SCTenThousandQuitRet')

----万人牛牛翻牌界面
----界面初始化
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_FlopInitID] = _G.inport('.protocol.tenthousand.CSFlopInit')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_FlopInitRetID] = _G.inport('.protocol.tenthousand.SCFlopInitRet')
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_FlopOpenID] = _G.inport('.protocol.tenthousand.CSFlopOpen')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_FlopOpenRetID] = _G.inport('.protocol.tenthousand.SCFlopOpenRet')
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_FlopHalfGoldID] = _G.inport('.protocol.tenthousand.CSFlopHalfGold')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_FlopHalfGoldRetID] = _G.inport('.protocol.tenthousand.SCFlopHalfGoldRet')
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_FlopEndID] = _G.inport('.protocol.tenthousand.CSFlopEnd')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_FlopEndRetID] = _G.inport('.protocol.tenthousand.SCFlopEndRet')

----水果机界面
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_FruitInitGameID]      = _G.inport('.protocol.fruit.CSFruitInit')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_FruitInitGameRetID]   = _G.inport('.protocol.fruit.SCFruitInitRet')

--PacketFiles.Protocols[_LAIXIA_PACKET_SC_FruitGameStartRetID]   = _G.inport('.protocol.fruit.SCFruitGameStartRet')
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_FruitAddBetID]      = _G.inport('.protocol.fruit.CSFruitAddBet')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_FruitAddBetRetID]   = _G.inport('.protocol.fruit.SCFruitAddBetRet')
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_FruitRebetID]      = _G.inport('.protocol.fruit.CSFruitRebet')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_FruitRebetRetID]   = _G.inport('.protocol.fruit.SCFruitRebetRet')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_FruitrefreshBetsRetID]   = _G.inport('.protocol.fruit.SCFruitrefreshBetsRet')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_FruitRollRetID]   = _G.inport('.protocol.fruit.SCFruitRollRet')
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_FruitLotteryRetID]   = _G.inport('.protocol.fruit.SCFruitLotteryRet')
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_FruitExitID]      = _G.inport('.protocol.fruit.CSFruitExit')
----PacketFiles.Protocols[_LAIXIA_PACKET_SC_FruitExitRetID]   = _G.inport('.protocol.fruit.SCFruitExitRet')

--PacketFiles.Protocols[_T_PACKET_SC_FruitSYNRetID]      = _G.inport('.protocol.fruit.SCFruitSYNRet')

---------------------------------------------------------------------------------------------
---- 多人三张牌相关 --
---- 进入游戏
--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesckitEnterGameID] = require("rebot.protocol.threecards.CSMckitEnterGame")
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesckitEnterGameID] = require("rebot.protocol.threecards.SCMckitEnterGame")
---- 坐下
--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesckitSitDownID] = require("rebot.protocol.threecards.CSMckitSitDown")
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesckitSitDownID] = require("rebot.protocol.threecards.SCMckitSitDown")
---- 站起
--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesckitStandUpID] = require("rebot.protocol.threecards.CSMckitStandUp")
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesckitStandUpID] = require("rebot.protocol.threecards.SCMckitStandUp")
---- 换桌
--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesckitChangeID] = require("rebot.protocol.threecards.CSMckitChange")
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesckitChangeID] = require("rebot.protocol.threecards.SCMckitChange")
---- 离桌
--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesckitExitID] = require("rebot.protocol.threecards.CSMckitExit")
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesckitExitID] = require("rebot.protocol.threecards.SCMckitExit")
---- 游戏开始
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesckitStartID] = require("rebot.protocol.threecards.SCMckitStart")
---- 游戏结算
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesckitRoundResultID] = require("rebot.protocol.threecards.SCMckitRoundResult")
---- 游戏结束
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesckitOverID] = require("rebot.protocol.threecards.SCMckitOver")
---- 操作开始
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesckitPlayerOptionID] = require("rebot.protocol.threecards.SCMckitPlayerOption")
---- 下注
--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesckitBetID] = require("rebot.protocol.threecards.CSMckitBet")
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesckitBetID] = require("rebot.protocol.threecards.SCMckitBet")
---- 跟注
--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesckitFollowID] = require("rebot.protocol.threecards.CSMckitFollow")
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesckitFollowID] = require("rebot.protocol.threecards.SCMckitFollow")
---- 看牌
--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesckitSeeCardsID] = require("rebot.protocol.threecards.CSMckitSeeCards")
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesckitSeeCardsID] = require("rebot.protocol.threecards.SCMckitSeeCards")
---- 比牌
--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesckitCompareCardID] = require("rebot.protocol.threecards.CSMckitCmpCard")
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesckitCompareCardID] = require("rebot.protocol.threecards.SCMckitCmpCard")
---- 弃牌
--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesckitThrowCardsID] = require("rebot.protocol.threecards.CSMckitThrowCards")
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesckitThrowCardsID] = require("rebot.protocol.threecards.SCMckitThrowCards")
---- 秀牌
--PacketFiles.Protocols[_LAIXIA_PACKET_CSPacketFilesckitShowCardsID] = require("rebot.protocol.threecards.CSMckitShowCards")
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesckitShowCardsID] = require("rebot.protocol.threecards.SCMckitShowCards")
---- led
--PacketFiles.Protocols[_LAIXIA_PACKET_SCPacketFilesckitNotifyID] = require("rebot.protocol.threecards.SCMckitNotify")
----个人账单
---- 秀牌
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_PERSONBILL] = require("rebot.protocol.CSPersonBill")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_PERSONBILL] = require("rebot.protocol.SCPersonBill")

----活动请求
--PacketFiles.Protocols[_LAIXIA_PACKET_CS_GETTASKLIST] = require("rebot.protocol.CSSendGetTaskList")
--PacketFiles.Protocols[_LAIXIA_PACKET_SC_GETTASKLIST] = require("rebot.protocol.SCSendGetTaskList")

--[[
    返回协议通过协议号
]]
function PacketFiles.getProtocolById(id)
    if type(id) ~= "number" then
        return nil
    end
    local ret = PacketFiles.Protocols[id] 
    return  ret and ret or nil
end

return PacketFiles

















   



