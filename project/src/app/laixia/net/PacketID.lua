
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

--登陆
_LAIXIA_PACKET_CS_Login_ID =   BASIC_ID+1
_LAIXIA_PACKET_SC_Login_ID = (bit.bor(flag,_LAIXIA_PACKET_CS_Login_ID))

--进入游戏
_LAIXIA_PACKET_CS_EnterGameID = BASIC_ID+ 3
_LAIXIA_PACKET_SC_EnterGameID = (bit.bor(flag,_LAIXIA_PACKET_CS_EnterGameID))

--下线通知
_LAIXIA_PACKET_SC_UserOfflineID = (bit.bor(flag,BASIC_ID+4))

--心跳
_LAIXIA_PACKET_CS_HeartBeatID = BASIC_ID+5
_LAIXIA_PACKET_SC_HeartBeatID = (bit.bor(flag,_LAIXIA_PACKET_CS_HeartBeatID))

--获取玩家绑定手机验证码
_LAIXIA_PACKET_CSCodeBindingID = BASIC_ID+7
_LAIXIA_PACKET_SC_SCCodeBindingID = (bit.bor(flag,_LAIXIA_PACKET_CSCodeBindingID))

--修改密码
_LAIXIA_PACKET_CS_RevisePwdID = BASIC_ID+8
_LAIXIA_PACKET_SC_RevisePwdID = (bit.bor(flag,_LAIXIA_PACKET_CS_RevisePwdID))

-- 找回密码
_LAIXIA_PACKET_CS_FindPwdID = BASIC_ID + 9
_LAIXIA_PACKET_SC_FindPwdID = (bit.bor(flag,_LAIXIA_PACKET_CS_FindPwdID))

--绑定玩家手机
_LAIXIA_PACKET_CS_BoundPhoneID = BASIC_ID+10
_LAIXIA_PACKET_SC_BoundPhoneID = (bit.bor(flag,_LAIXIA_PACKET_CS_BoundPhoneID))

--头像上传
_LAIXIA_PACKET_CS_HeadUploadID = BASIC_ID+12
_LAIXIA_PACKET_SC_HeadUploadID = (bit.bor(flag,_LAIXIA_PACKET_CS_HeadUploadID))

--修改个人详情
_LAIXIA_PACKET_CS_ModifySexNickSignID =BASIC_ID+14
_LAIXIA_PACKET_SC_ModifySexNickSignID = (bit.bor(flag,_LAIXIA_PACKET_CS_ModifySexNickSignID))

--进入个人中心
_LAIXIA_PACKET_CS_PersonalCenterID = BASIC_ID+16
_LAIXIA_PACKET_SC_PersonalCenterID = (bit.bor(flag,_LAIXIA_PACKET_CS_PersonalCenterID))

--进入大厅获取个人数据消息
_LAIXIA_PACKET_CS_HallLobbyID = BASIC_ID+17
_LAIXIA_PACKET_SC_HallLobbyID = (bit.bor(flag,_LAIXIA_PACKET_CS_HallLobbyID))

--点击某个玩家的信息
_LAIXIA_PACKET_CS_PlayerRankInfoID =BASIC_ID+18
_LAIXIA_PACKET_SC_PlayerRankInfoID = (bit.bor(flag,_LAIXIA_PACKET_CS_PlayerRankInfoID))

--兑换码兑换
_LAIXIA_PACKET_CS_RedeemCodeID = BASIC_ID+20
_LAIXIA_PACKET_SC_RedeemCodeID = (bit.bor(flag,_LAIXIA_PACKET_CS_RedeemCodeID))

--兑换道具
_LAIXIA_PACKET_CS_ExchangeID = BASIC_ID+21
_LAIXIA_PACKET_SC_ExchangeID = (bit.bor(flag,_LAIXIA_PACKET_CS_ExchangeID))

--获取商城
_LAIXIA_PACKET_CS_ShopID = BASIC_ID+22
_LAIXIA_PACKET_SC_ShopID = (bit.bor(flag,_LAIXIA_PACKET_CS_ShopID))

--是否有站内信
_LAIXIA_PACKET_CS_HasMailID = BASIC_ID+23
_LAIXIA_PACKET_SC_HasMailID = (bit.bor(flag,_LAIXIA_PACKET_CS_HasMailID))

--请求站内信
_LAIXIA_PACKET_CS_SmsListID = BASIC_ID+24
_LAIXIA_PACKET_SC_SmsListID = (bit.bor(flag,_LAIXIA_PACKET_CS_SmsListID))


--排行榜列表
_LAIXIA_PACKET_CS_RankID = BASIC_ID+26
_LAIXIA_PACKET_SC_RankID = (bit.bor(flag,_LAIXIA_PACKET_CS_RankID))

--签到表
_LAIXIA_PACKET_CS_SignLandingID = BASIC_ID+27
_LAIXIA_PACKET_SC_SignLandingID = (bit.bor(flag,_LAIXIA_PACKET_CS_SignLandingID))

--签到
_LAIXIA_PACKET_CS_SignID = BASIC_ID+28
_LAIXIA_PACKET_SC_SignID = (bit.bor(flag,_LAIXIA_PACKET_CS_SignID))

--获取兑换列表
_LAIXIA_PACKET_CS_ExchangeDataID = BASIC_ID+31
_LAIXIA_PACKET_SC_ExchangeDataID = (bit.bor(flag,_LAIXIA_PACKET_CS_ExchangeDataID))

--请求救济金次数
_LAIXIA_PACKET_CS_ReliefFundInfoID =  BASIC_ID+33
_LAIXIA_PACKET_SC_ReliefFundInfoID = (bit.bor(flag,_LAIXIA_PACKET_CS_ReliefFundInfoID))

--请求救济金
_LAIXIA_PACKET_CS_ReliefFundID =  BASIC_ID+34
_LAIXIA_PACKET_SC_ReliefFundID = (bit.bor(flag,_LAIXIA_PACKET_CS_ReliefFundID))

--获取包裹--道具箱 -- 礼品盒
_LAIXIA_PACKET_CS_PackItemsID = BASIC_ID+35
_LAIXIA_PACKET_SC_PackItemsID = (bit.bor(flag,_LAIXIA_PACKET_CS_PackItemsID))

--物品使用
_LAIXIA_PACKET_CS_UsePacksID = BASIC_ID+36
_LAIXIA_PACKET_SC_UsePacksID = (bit.bor(flag,_LAIXIA_PACKET_CS_UsePacksID))

--兑换使用请求
_LAIXIA_PACKET_CS_UsePackPropID = BASIC_ID+38
_LAIXIA_PACKET_SC_UsePackPropID = (bit.bor(flag,_LAIXIA_PACKET_CS_UsePackPropID))

--道具变化推送（现阶段主要为充值推送金）
_LAIXIA_PACKET_SC_SynPropsChangeID = (bit.bor(flag,BASIC_ID+39))

--请求订单
_LAIXIA_PACKET_CS_RequestOrderID = BASIC_ID + 44
_LAIXIA_PACKET_SC_RequestOrderID = (bit.bor(flag,_LAIXIA_PACKET_CS_RequestOrderID))

--充值消息回调
_LAIXIA_PACKET_SC_RechargeToClientID =  (bit.bor(flag,BASIC_ID + 46))

--ios充值回调
_LAIXIA_PACKET_CS_RechargeToIOS =  BASIC_ID + 47
_LAIXIA_PACKET_SC_RechargeToIOSRet =  (bit.bor(flag,_LAIXIA_PACKET_CS_RechargeToIOS))

--游戏公告
_LAIXIA_PACKET_CS_ServiceNoticeID = BASIC_ID+49
_LAIXIA_PACKET_SC_ServiceNoticeID = (bit.bor(flag,_LAIXIA_PACKET_CS_ServiceNoticeID))

--广播推送  走马灯
_LAIXIA_PACKET_CS_RotateNoticeID =  BASIC_ID+51
_LAIXIA_PACKET_SC_RotateNoticeID = (bit.bor(flag,_LAIXIA_PACKET_CS_RotateNoticeID))

--请求版本的模块开启
_LAIXIA_PACKET_CS_VersionOpenID = BASIC_ID+52
_LAIXIA_PACKET_SC_VersionOpenID = (bit.bor(flag,_LAIXIA_PACKET_CS_VersionOpenID))

--超级礼包
_LAIXIA_PACKET_CS_SuperGiftID = BASIC_ID+53
_LAIXIA_PACKET_SC_SuperGiftID = (bit.bor(flag,_LAIXIA_PACKET_CS_SuperGiftID))

--快充礼包
_LAIXIA_PACKET_CS_QuickSuperBagID = BASIC_ID+54
_LAIXIA_PACKET_SC_QuickSuperBagID = (bit.bor(flag,_LAIXIA_PACKET_CS_QuickSuperBagID))

--破产礼包
_LAIXIA_PACKET_CS_BankruptBagID = BASIC_ID+56
_LAIXIA_PACKET_SC_BankruptBagID = (bit.bor(flag,_LAIXIA_PACKET_CS_BankruptBagID))

--首充礼包
_LAIXIA_PACKET_CS_FirstSuperBagID = BASIC_ID+57
_LAIXIA_PACKET_SC_FirstSuperBagID = (bit.bor(flag,_LAIXIA_PACKET_CS_FirstSuperBagID))

--服务器维护踢人下线
_LAIXIA_PACKET_SC_CutLineID = (bit.bor(flag,BASIC_ID + 63))

--推广活动绑定ID
_LAIXIA_PACKET_CS_ExtensionBindingID =  BASIC_ID + 71
_LAIXIA_PACKET_SC_ExtensionBindingRetID =  (bit.bor(flag,_LAIXIA_PACKET_CS_ExtensionBindingID))

--推广活动绑定奖励
_LAIXIA_PACKET_CS_ReceiveExtensionID =  BASIC_ID + 72
_LAIXIA_PACKET_SC_ReceiveExtensionRetID =  (bit.bor(flag,_LAIXIA_PACKET_CS_ReceiveExtensionID))

--赠送道具
_LAIXIA_PACKET_CS_PresentID =  BASIC_ID + 73
_LAIXIA_PACKET_SC_PresentRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_PresentID))

--推广活动规则
_LAIXIA_PACKET_CS_ExtensionRuleID =  BASIC_ID + 74
_LAIXIA_PACKET_SC_ExtensionRuleRetID =  (bit.bor(flag,_LAIXIA_PACKET_CS_ExtensionRuleID))

--触发是否有周卡月卡礼包
_LAIXIA_PACKET_CS_WeekOrMonthCardID = BASIC_ID + 75
_LAIXIA_PACKET_SC_WeekOrMonthCardRetID =  (bit.bor(flag,_LAIXIA_PACKET_CS_WeekOrMonthCardID))

--活动请求
_LAIXIA_PACKET_CS_ActivityID = BASIC_ID+76
_LAIXIA_PACKET_SC_ActivityID = (bit.bor(flag,_LAIXIA_PACKET_CS_ActivityID))

_LAIXIA_PACKET_CS_PERSONBILL = BASIC_ID+77
_LAIXIA_PACKET_SC_PERSONBILL = (bit.bor(flag,_LAIXIA_PACKET_CS_PERSONBILL))

_LAIXIA_PACKET_CS_GETVERSION = BASIC_ID+78
_LAIXIA_PACKET_SC_GETVERSION = (bit.bor(flag,_LAIXIA_PACKET_CS_GETVERSION))

_LAIXIA_PACKET_CS_GETTASKLIST = BASIC_ID+79
_LAIXIA_PACKET_SC_GETTASKLIST = (bit.bor(flag,_LAIXIA_PACKET_CS_GETTASKLIST))

--实名认证
_LAIXIA_PACKET_CS_REALNAMEAUTH = BASIC_ID+91
_LAIXIA_PACKET_SC_REALNAMEAUTH = (bit.bor(flag,_LAIXIA_PACKET_CS_REALNAMEAUTH))
------------------------------------------------------------------------------------------------
-- 房间列表
_LAIXIA_PACKET_CS_ListRoomID = LANDLORDS_ROOM_ID+1
_LAIXIA_PACKET_SC_ListRoomID = (bit.bor(flag,_LAIXIA_PACKET_CS_ListRoomID))

-- 进入房间
_LAIXIA_PACKET_CS_EnterRoomID = LANDLORDS_ROOM_ID+2
_LAIXIA_PACKET_SC_EnterRoomID = (bit.bor(flag,_LAIXIA_PACKET_CS_EnterRoomID))

--快速开始
_LAIXIA_PACKET_CS_QuickOpenID = LANDLORDS_ROOM_ID+3
_LAIXIA_PACKET_SC_QuickOpenID = (bit.bor(flag,_LAIXIA_PACKET_CS_QuickOpenID))

--退出房间
_LAIXIA_PACKET_CS_ExitRoomID = LANDLORDS_ROOM_ID+4
_LAIXIA_PACKET_SC_ExitRoomID = (bit.bor(flag,_LAIXIA_PACKET_CS_ExitRoomID))

--继续游戏
_LAIXIA_PACKET_CS_ContinueGameID = LANDLORDS_ROOM_ID+5
_LAIXIA_PACKET_SC_ContinueGameID = (bit.bor(flag,_LAIXIA_PACKET_CS_ContinueGameID))

--自建牌桌奖励推送
_LAIXIA_PACKET_CS_SelfBuildRewardID = LANDLORDS_ROOM_ID+6
_LAIXIA_PACKET_SC_SelfBuildRewardRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_SelfBuildRewardID))

--站内玩家信息查看
_LAIXIA_PACKET_CS_TablePlayerID = LANDLORDS_ROOM_ID+7
_LAIXIA_PACKET_SC_TablePlayerID = (bit.bor(flag,_LAIXIA_PACKET_CS_TablePlayerID))

--断网时在牌桌内
_LAIXIA_PACKET_CS_OnlineRoomID = LANDLORDS_ROOM_ID+9
_LAIXIA_PACKET_SC_OnlineRoomID = (bit.bor(flag,_LAIXIA_PACKET_CS_OnlineRoomID))

----------------------------------------------------------------------------
--自建房
--斗地主创建牌桌
_LAIXIA_PACKET_CS_CreateTableID = LANDLORDS_ROOM_ID + 15
_LAIXIA_PACKET_SC_CreateTableRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_CreateTableID))

--加入已有牌桌
_LAIXIA_PACKET_CS_JoinTableID = LANDLORDS_ROOM_ID + 16
_LAIXIA_PACKET_SC_JoinTableRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_JoinTableID))

--解散自建桌
_LAIXIA_PACKET_CS_CreateDelID = LANDLORDS_ROOM_ID + 17
_LAIXIA_PACKET_SC_CreateDelRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_CreateDelID))

--进入房间--推送同步消息
_LAIXIA_PACKET_CS_JoinSyncID = LANDLORDS_ROOM_ID + 18
_LAIXIA_PACKET_SC_JoinSyncRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_JoinSyncID))

--创建房间有人退出
_LAIXIA_PACKET_CS_CreateExitID = LANDLORDS_ROOM_ID + 19
_LAIXIA_PACKET_SC_CreateExitRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_CreateExitID))

--创建房间列表（用于显示自建列表）
_LAIXIA_PACKET_CS_CreateListID = LANDLORDS_ROOM_ID + 20
_LAIXIA_PACKET_SC_CreateListRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_CreateListID))

--申请解散房间(自建房)
_LAIXIA_PACKET_CS_AppleDismissID = LANDLORDS_ROOM_ID + 21
_LAIXIA_PACKET_SC_AppleDismissID = (bit.bor(flag,_LAIXIA_PACKET_CS_AppleDismissID))

------------------------------牌桌消息--------------------------------------

_LAIXIA_PACKET_CS_DealHandID=LANDLORDS_TABLE_ID+1                  --底牌
_LAIXIA_PACKET_SC_DealHandID=(bit.bor(flag,_LAIXIA_PACKET_CS_DealHandID))

_LAIXIA_PACKET_CS_CallBidID=LANDLORDS_TABLE_ID+2                  --叫地主、抢地主
_LAIXIA_PACKET_SC_CallBidID=(bit.bor(flag,_LAIXIA_PACKET_CS_CallBidID))

_LAIXIA_PACKET_CS_PlayCardsID=LANDLORDS_TABLE_ID+3                      --出手牌
_LAIXIA_PACKET_SC_PlayCardsID=(bit.bor(flag,_LAIXIA_PACKET_CS_PlayCardsID))

_LAIXIA_PACKET_CS_BalanceID=LANDLORDS_TABLE_ID+4                     --结算
_LAIXIA_PACKET_SC_BalanceID=(bit.bor(flag,_LAIXIA_PACKET_CS_BalanceID))

_LAIXIA_PACKET_CS_AttriChangeID=LANDLORDS_TABLE_ID+5                     --属性变化
_LAIXIA_PACKET_SC_AttriChangeID=(bit.bor(flag,_LAIXIA_PACKET_CS_AttriChangeID))

_LAIXIA_PACKET_CS_ShowCardID=LANDLORDS_TABLE_ID+6                     --明牌
_LAIXIA_PACKET_SC_ShowCardID=(bit.bor(flag,_LAIXIA_PACKET_CS_ShowCardID))

_LAIXIA_PACKET_CS_TableSyncStageID=LANDLORDS_TABLE_ID+7                    --牌桌阶段
_LAIXIA_PACKET_SC_TableSyncStageRetID=(bit.bor(flag,_LAIXIA_PACKET_CS_TableSyncStageID))

_LAIXIA_PACKET_CS_TableSyncID=LANDLORDS_TABLE_ID+8                    --牌桌同步
_LAIXIA_PACKET_SC_TableSyncID=(bit.bor(flag,_LAIXIA_PACKET_CS_TableSyncID))

_LAIXIA_PACKET_CS_CancelMandateID=LANDLORDS_TABLE_ID+9                    --取消托管
_LAIXIA_PACKET_SC_CancelMandateID=(bit.bor(flag,_LAIXIA_PACKET_CS_CancelMandateID))

_LAIXIA_PACKET_CS_TableTalkingID = LANDLORDS_TABLE_ID+10                    --聊天
_LAIXIA_PACKET_SC_TableTalkingID = (bit.bor(flag,_LAIXIA_PACKET_CS_TableTalkingID))

_LAIXIA_PACKET_CS_EndShowCardsID = LANDLORDS_TABLE_ID+11                    --结算亮牌推送
_LAIXIA_PACKET_SC_EndShowCardsID = (bit.bor(flag,_LAIXIA_PACKET_CS_EndShowCardsID))

_LAIXIA_PACKET_CS_LeaveRoomID = LANDLORDS_TABLE_ID+14
_LAIXIA_PACKET_SC_LeaveRoomID = (bit.bor(flag,_LAIXIA_PACKET_CS_LeaveRoomID))

--创建桌继续开始
_LAIXIA_PACKET_CS_CreateGoonID = LANDLORDS_TABLE_ID+15
_LAIXIA_PACKET_SC_CreateGoonRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_CreateGoonID))

_LAIXIA_PACKET_CS_CreateOverTimeID = LANDLORDS_TABLE_ID+16                    --创建桌超时删除
_LAIXIA_PACKET_SC_CreateOverTimeRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_CreateOverTimeID))

_LAIXIA_PACKET_CS_CreateEndResultID = LANDLORDS_TABLE_ID+17                    --创建桌大结算
_LAIXIA_PACKET_SC_CreateEndResultRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_CreateEndResultID))


-------------------------------------------------------------------------------------------
-- 比赛相关
_LAIXIA_PACKET_CS_MatchRegisterID = MATCH_ID +1  --参加比赛
_LAIXIA_PACKET_SC_MatchRegisterID =(bit.bor(flag,_LAIXIA_PACKET_CS_MatchRegisterID))

_LAIXIA_PACKET_CS_MatchGameID=MATCH_ID+2  --比赛列表
_LAIXIA_PACKET_SC_MatchGameID=(bit.bor(flag,_LAIXIA_PACKET_CS_MatchGameID))

_LAIXIA_PACKET_CS_ExitMatchGameID = MATCH_ID +3  --比赛退出报名
_LAIXIA_PACKET_SC_ExitMatchGameID =(bit.bor(flag,_LAIXIA_PACKET_CS_ExitMatchGameID))

_LAIXIA_PACKET_SC_FailExitMatchID =(bit.bor(flag,MATCH_ID +4))  --比赛失败退出

_LAIXIA_PACKET_SC_ExitTipsMatchID =(bit.bor(flag,MATCH_ID +5)) --返还报名费

_LAIXIA_PACKET_CS_MatchQuitDeskID =MATCH_ID+6  --比赛退出牌桌
_LAIXIA_PACKET_SC_MatchQuitDeskID =(bit.bor(flag,_LAIXIA_PACKET_CS_MatchQuitDeskID))

_LAIXIA_PACKET_CS_IsMatchID = MATCH_ID +7  --断线重连时，是否进入比赛
_LAIXIA_PACKET_SC_IsMatchID =(bit.bor(flag,_LAIXIA_PACKET_CS_IsMatchID))

_LAIXIA_PACKET_CS_MatchJoinInID = MATCH_ID+8  --确认参加比赛
_LAIXIA_PACKET_SC_MatchJoinInID =(bit.bor(flag,_LAIXIA_PACKET_CS_MatchJoinInID))

_LAIXIA_PACKET_SC_MatchWaitQueueID = (bit.bor(flag,MATCH_ID +9)) --玩家进入等待队列消,牌桌匹配不足的时候会有这个界面

_LAIXIA_PACKET_SC_MatchStageUpID = (bit.bor(flag,MATCH_ID +10)) --比赛阶段同步变化

_LAIXIA_PACKET_SC_MatchRenManUpID = (bit.bor(flag,MATCH_ID +11))  --人满开赛数据更新

_LAIXIA_PACKET_CS_MatchDetailsID = MATCH_ID +12  --比赛详情
_LAIXIA_PACKET_SC_MatchDetailsID =(bit.bor(flag,_LAIXIA_PACKET_CS_MatchDetailsID))

_LAIXIA_PACKET_CS_MatchIntegralRankID= MATCH_ID +14  --获取积分榜
_LAIXIA_PACKET_SC_MatchIntegralRankID=(bit.bor(flag,_LAIXIA_PACKET_CS_MatchIntegralRankID))

_LAIXIA_PACKET_CS_MatchRankID =MATCH_ID + 15  --同步当前排名和积分
_LAIXIA_PACKET_SC_MatchRankID =(bit.bor(flag,_LAIXIA_PACKET_CS_MatchRankID))

_LAIXIA_PACKET_CS_MatchResultID = MATCH_ID +16  --比赛奖励
_LAIXIA_PACKET_SC_MatchResultID =(bit.bor(flag,_LAIXIA_PACKET_CS_MatchResultID))

_LAIXIA_PACKET_CS_MatchTimingID = MATCH_ID +17  --定时开赛中间等待界面
_LAIXIA_PACKET_SC_MatchTimingID =(bit.bor(flag,_LAIXIA_PACKET_CS_MatchTimingID))

_LAIXIA_PACKET_CS_MatchStopMaintainID = MATCH_ID +18 --服务器维护中
_LAIXIA_PACKET_SC_MatchStopMaintainID =(bit.bor(flag,_LAIXIA_PACKET_CS_MatchStopMaintainID))

_LAIXIA_PACKET_CS_MatchResurrectionBackID = MATCH_ID +19 --复活确认消息
_LAIXIA_PACKET_SC_MatchResurrectionBackID =(bit.bor(flag,_LAIXIA_PACKET_CS_MatchResurrectionBackID))

_LAIXIA_PACKET_CS_MatchResurrectionID = MATCH_ID +20 --复活成功
_LAIXIA_PACKET_SC_MatchResurrectionID =(bit.bor(flag,_LAIXIA_PACKET_CS_MatchResurrectionID))

_LAIXIA_PACKET_CS_MatchStopCompensationID = MATCH_ID +21 --服务器维护补偿
_LAIXIA_PACKET_SC_MatchStopCompensationID =(bit.bor(flag,_LAIXIA_PACKET_CS_MatchStopCompensationID))

_LAIXIA_PACKET_CS_MatchFloatwordID = MATCH_ID +22 -- 飘字提示
_LAIXIA_PACKET_SC_MatchFloatwordID =(bit.bor(flag,_LAIXIA_PACKET_CS_MatchFloatwordID))

_LAIXIA_PACKET_CS_MatchOpenRecentTimeID = MATCH_ID +23 --获取最近的定时开赛的比赛
_LAIXIA_PACKET_SC_MatchOpenRecentTimeID =(bit.bor(flag,_LAIXIA_PACKET_CS_MatchOpenRecentTimeID))

_LAIXIA_PACKET_SC_MatchPhaseChangeID =(bit.bor(flag,MATCH_ID +24)) -- 阶段改变等待消息

_LAIXIA_PACKET_CS_MatchSignID = MATCH_ID +27 --获取比赛列表标签页
_LAIXIA_PACKET_SC_MatchSignID =(bit.bor(flag,_LAIXIA_PACKET_CS_MatchSignID))

-- 龙虎斗
--进入游戏
_LAIXIA_PACKET_CS_DragonTigerEnterID = DRAGON_TIGER_ID + 1
_LAIXIA_PACKET_SC_DragonTigerEnterID =(bit.bor(flag,_LAIXIA_PACKET_CS_DragonTigerEnterID))
--进入游戏返回
_LAIXIA_PACKET_SC_DragonTigerSyncStageID =  (bit.bor(flag,DRAGON_TIGER_ID +2))
--玩家压注
_LAIXIA_PACKET_CS_DragonTigerBetID = DRAGON_TIGER_ID + 3
_LAIXIA_PACKET_SC_DragonTigerBetID = (bit.bor(flag,_LAIXIA_PACKET_CS_DragonTigerBetID))
--刷新棋牌桌面上的信息
_LAIXIA_PACKET_SC_DragonTigerTableSyncID = (bit.bor(flag,DRAGON_TIGER_ID+4))
--开牌结果
_LAIXIA_PACKET_SC_DragonTigerResultID = (bit.bor(flag,DRAGON_TIGER_ID + 5))
--结算
_LAIXIA_PACKET_SC_DragonTigerRewardID = (bit.bor(flag,DRAGON_TIGER_ID + 6))
--走势申请
_LAIXIA_PACKET_CS_DragonHistoryRecordID  =  DRAGON_TIGER_ID + 7
_LAIXIA_PACKET_SC_DragonHistoryRecordID  =  (bit.bor(flag,_LAIXIA_PACKET_CS_DragonHistoryRecordID))
--申请退出
_LAIXIA_PACKET_CS_DragonQuitID = DRAGON_TIGER_ID + 8
_LAIXIA_PACKET_SC_DragonQuitID =(bit.bor(flag,_LAIXIA_PACKET_CS_DragonQuitID))
--龙虎斗赠送金币 --桃李卡
_LAIXIA_PACKET_CS_DragonPresentID = DRAGON_TIGER_ID + 10
_LAIXIA_PACKET_SC_DragonPresentRetID =(bit.bor(flag,_LAIXIA_PACKET_CS_DragonPresentID))

-------------------------------------------------------------------------------------------------
--大转盘
--中奖纪录
_LAIXIA_PACKET_CS_TurnTableResultID =  BIGTURNTABLE_ID + 1
_LAIXIA_PACKET_SC_TurnTableResultRetID =(bit.bor(flag,_LAIXIA_PACKET_CS_TurnTableResultID))
--抽奖
_LAIXIA_PACKET_CS_TurnTableLotteryID =  BIGTURNTABLE_ID + 2
_LAIXIA_PACKET_SC_TurnTableLotteryRetID =(bit.bor(flag,_LAIXIA_PACKET_CS_TurnTableLotteryID))
--界面显示
_LAIXIA_PACKET_CS_TurnTableEnterID =  BIGTURNTABLE_ID + 3
_LAIXIA_PACKET_SC_TurnTableEnterRetID =(bit.bor(flag,_LAIXIA_PACKET_CS_TurnTableEnterID))

---------------------------------------------------------
--万人牛牛
--进入游戏
_LAIXIA_PACKET_CS_EnterTenThousandID =  WANRENNIUNIU_ID + 1
_LAIXIA_PACKET_SC_EnterTenThousandRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_EnterTenThousandID))
--押注
_LAIXIA_PACKET_CS_TenThousandBetID = WANRENNIUNIU_ID+2
_LAIXIA_PACKET_SC_TenThousandBetRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_TenThousandBetID))
--结算返回
_LAIXIA_PACKET_SC_TenThousandResultRetID = (bit.bor(flag,WANRENNIUNIU_ID+3))
--同步筹码
_LAIXIA_PACKET_SC_TenThousandSynRetID = (bit.bor(flag,WANRENNIUNIU_ID+4))
--走势
_LAIXIA_PACKET_CS_TenThousandHistoryID = WANRENNIUNIU_ID+5
_LAIXIA_PACKET_SC_TenThousandHistoryRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_TenThousandHistoryID )) --走势返回
--退出
_LAIXIA_PACKET_CS_TenThousandQuitID = WANRENNIUNIU_ID+6 --退出
_LAIXIA_PACKET_SC_TenThousandQuitRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_TenThousandQuitID))--退出

----------------------------------------------------------------------------------------------------------
--翻牌界面初始化
_LAIXIA_PACKET_CS_FlopInitID = WANRENNIUNIU_ID + 8
_LAIXIA_PACKET_SC_FlopInitRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_FlopInitID))
--翻牌第一张
_LAIXIA_PACKET_CS_FlopOpenID = WANRENNIUNIU_ID + 9
_LAIXIA_PACKET_SC_FlopOpenRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_FlopOpenID))
--收取一半金币
_LAIXIA_PACKET_CS_FlopHalfGoldID = WANRENNIUNIU_ID + 10
_LAIXIA_PACKET_SC_FlopHalfGoldRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_FlopHalfGoldID))
--结束翻牌
_LAIXIA_PACKET_CS_FlopEndID = WANRENNIUNIU_ID + 11
_LAIXIA_PACKET_SC_FlopEndRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_FlopEndID))

--------------------------------------------------------------------------------------------------------
-- --水果机
-- 水果机进入游戏
_LAIXIA_PACKET_CS_FruitInitGameID = FRUITS_ID + 1       --over
_LAIXIA_PACKET_SC_FruitInitGameRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_FruitInitGameID))

-- 水果机开始游戏；初始化当前游戏状态
_LAIXIA_PACKET_CS_FruitGameStartID = FRUITS_ID + 2    --over
_LAIXIA_PACKET_SC_FruitGameStartRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_FruitGameStartID))

-- 水果机下注
_LAIXIA_PACKET_CS_FruitAddBetID = FRUITS_ID + 3       --over
_LAIXIA_PACKET_SC_FruitAddBetRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_FruitAddBetID))

-- 水果机续压
_LAIXIA_PACKET_CS_FruitRebetID = FRUITS_ID + 4        --over
_LAIXIA_PACKET_SC_FruitRebetRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_FruitRebetID))

-- 水果机刷新下注情况
_LAIXIA_PACKET_CS_FruitRefreshBetsID = FRUITS_ID + 5    --over
_LAIXIA_PACKET_SC_FruitrefreshBetsRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_FruitRefreshBetsID))

-- 水果机开奖，发送中奖消息
_LAIXIA_PACKET_CS_FruitRollID = FRUITS_ID + 6           --over
_LAIXIA_PACKET_SC_FruitRollRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_FruitRollID))

-- 水果机开奖，发送开奖结果
_LAIXIA_PACKET_CS_FruitLotteryID = FRUITS_ID + 7       --over
_LAIXIA_PACKET_SC_FruitLotteryRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_FruitLotteryID))

-- 水果机退出
_LAIXIA_PACKET_CS_FruitExitID = FRUITS_ID + 8      --over
_LAIXIA_PACKET_SC_FruitExitRetID = (bit.bor(flag,_LAIXIA_PACKET_CS_FruitExitID))

-- 水果机下注推送
_T_PACKET_CS_FruitSYNID = FRUITS_ID + 9   --用于显示下注玩家消息
_T_PACKET_SC_FruitSYNRetID = (bit.bor(flag,_T_PACKET_CS_FruitSYNID))


------------------------------------------------------------------------------------
-- 三张牌相关
-- 三张牌进入游戏
_LAIXIA_PACKET_CS_MckitEnterGameID = THREECARDS_ID + 1
_LAIXIA_PACKET_SC_MckitEnterGameID = (bit.bor(flag,_LAIXIA_PACKET_CS_MckitEnterGameID))
-- 三张牌坐下
_LAIXIA_PACKET_CS_MckitSitDownID = THREECARDS_ID + 2
_LAIXIA_PACKET_SC_MckitSitDownID = (bit.bor(flag,_LAIXIA_PACKET_CS_MckitSitDownID))
-- 三张牌站起
_LAIXIA_PACKET_CS_MckitStandUpID = THREECARDS_ID + 3
_LAIXIA_PACKET_SC_MckitStandUpID = (bit.bor(flag,_LAIXIA_PACKET_CS_MckitStandUpID))
-- 三张牌换桌
_LAIXIA_PACKET_CS_MckitChangeID = THREECARDS_ID + 4
_LAIXIA_PACKET_SC_MckitChangeID = (bit.bor(flag,_LAIXIA_PACKET_CS_MckitChangeID))
-- 三张牌离开
_LAIXIA_PACKET_CS_MckitExitID = THREECARDS_ID + 5
_LAIXIA_PACKET_SC_MckitExitID = (bit.bor(flag,_LAIXIA_PACKET_CS_MckitExitID))
-- 三张牌游戏开始
_LAIXIA_PACKET_CS_MckitStartID = THREECARDS_ID + 9
_LAIXIA_PACKET_SC_MckitStartID = (bit.bor(flag,_LAIXIA_PACKET_CS_MckitStartID))
-- 三张牌本局游戏结束
_LAIXIA_PACKET_CS_MckitOverID = THREECARDS_ID + 10
_LAIXIA_PACKET_SC_MckitOverID = (bit.bor(flag,_LAIXIA_PACKET_CS_MckitOverID))
-- 三张牌结算
_LAIXIA_PACKET_CS_MckitRoundResultID = THREECARDS_ID + 11
_LAIXIA_PACKET_SC_MckitRoundResultID = (bit.bor(flag,_LAIXIA_PACKET_CS_MckitRoundResultID))
-- 三张牌该谁操作
_LAIXIA_PACKET_CS_MckitPlayerOptionID = THREECARDS_ID + 12
_LAIXIA_PACKET_SC_MckitPlayerOptionID = (bit.bor(flag,_LAIXIA_PACKET_CS_MckitPlayerOptionID))
-- 三张牌下注
_LAIXIA_PACKET_CS_MckitBetID = THREECARDS_ID + 13
_LAIXIA_PACKET_SC_MckitBetID = (bit.bor(flag,_LAIXIA_PACKET_CS_MckitBetID))
-- 三张牌跟注
_LAIXIA_PACKET_CS_MckitFollowID = THREECARDS_ID + 14
_LAIXIA_PACKET_SC_MckitFollowID = (bit.bor(flag,_LAIXIA_PACKET_CS_MckitFollowID))
-- 三张牌看牌
_LAIXIA_PACKET_CS_MckitSeeCardsID = THREECARDS_ID + 15
_LAIXIA_PACKET_SC_MckitSeeCardsID = (bit.bor(flag,_LAIXIA_PACKET_CS_MckitSeeCardsID))
-- 三张牌比牌
_LAIXIA_PACKET_CS_MckitCompareCardID = THREECARDS_ID + 16
_LAIXIA_PACKET_SC_MckitCompareCardID = (bit.bor(flag,_LAIXIA_PACKET_CS_MckitCompareCardID))
-- 三张牌弃牌
_LAIXIA_PACKET_CS_MckitThrowCardsID = THREECARDS_ID + 17
_LAIXIA_PACKET_SC_MckitThrowCardsID = (bit.bor(flag,_LAIXIA_PACKET_CS_MckitThrowCardsID))
-- 三张牌show牌
_LAIXIA_PACKET_CS_MckitShowCardsID = THREECARDS_ID + 18
_LAIXIA_PACKET_SC_MckitShowCardsID = (bit.bor(flag,_LAIXIA_PACKET_CS_MckitShowCardsID))
-- 三张牌led
_LAIXIA_PACKET_CS_MckitNotifyID = THREECARDS_ID + 19
_LAIXIA_PACKET_SC_MckitNotifyID = (bit.bor(flag,_LAIXIA_PACKET_CS_MckitNotifyID))



