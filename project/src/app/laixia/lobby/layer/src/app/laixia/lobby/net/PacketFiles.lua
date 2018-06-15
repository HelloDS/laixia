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

--------------------------------------------------------------------------------------------
--大转盘
_M.Protocols[_LAIXIA_PACKET_CS_TurnTableEnterID] = import('.protocol.truntable.CSTurnTableEnter')
_M.Protocols[_LAIXIA_PACKET_SC_TurnTableEnterRetID] = import('.protocol.truntable.SCTurnTableEnterRet')
_M.Protocols[_LAIXIA_PACKET_CS_TurnTableLotteryID] = import('.protocol.truntable.CSTurnTableLottery')
_M.Protocols[_LAIXIA_PACKET_SC_TurnTableLotteryRetID] = import('.protocol.truntable.SCTurnTableLotteryRet')
_M.Protocols[_LAIXIA_PACKET_CS_TurnTableResultID] = import('.protocol.truntable.CSTurnTableResult')
_M.Protocols[_LAIXIA_PACKET_SC_TurnTableResultRetID] = import('.protocol.truntable.SCTurnTableResultRet')
----------------------------------------------------------------------------------------------
--个人账单
-- 秀牌
_M.Protocols[_LAIXIA_PACKET_CS_PERSONBILL] = import(".protocol.CSPersonBill")
_M.Protocols[_LAIXIA_PACKET_SC_PERSONBILL] = import(".protocol.SCPersonBill")

--活动请求
_M.Protocols[_LAIXIA_PACKET_CS_GETTASKLIST] = import(".protocol.CSSendGetTaskList")
_M.Protocols[_LAIXIA_PACKET_SC_GETTASKLIST] = import(".protocol.SCSendGetTaskList")
----比赛拉回
_M.Protocols[_LAIXIA_PACKET_CS_IsMatchID] = import(".protocol.match.CSIsMatch") --短线重连时，是否进入比赛  +7
_M.Protocols[_LAIXIA_PACKET_SC_IsMatchID] =import(".protocol.match.SCIsMatch")

--断网时再牌桌内
_M.Protocols[_LAIXIA_PACKET_CS_OnlineRoomID]= import(".protocol.landlords.CSOnlineRoom")
_M.Protocols[_LAIXIA_PACKET_SC_OnlineRoomID]= import(".protocol.landlords.SCOnlineRoom")
function _M.getProtocol(ID)
    return  _M.Protocols[ID];
end

return Protocols

















   



