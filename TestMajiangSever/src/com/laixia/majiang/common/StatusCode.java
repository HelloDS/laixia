package com.laixia.majiang.common;

public class StatusCode {

	public static final short SUCCESS = 0;
    public static final String SUCCESS_MSG = "操作成功";

	public static final short FAILURE = 1;
	public static final String FAILURE_MSG = "操作失败";
	/**
	 * 没有响应
	 */
	public static final short NO_RETURN = 2;
	/**
	 * 参数错误
	 */
	public static final short CLIENT_PARAM_ERROR = 3;
	/**
	 * 无效操作
	 */
	public static final short INVALID_OPERATION = 4;
	/**
	 * 未登录
	 */
	public static final short UN_LOGIN = 5;
	/**
	 * 登陆异常
	 */
	public static final short LOGIN_ERROR = 6;
	/**
	 * 未知操作
	 */
	public static final short UNKNOW_ARGUMENT = 7;
	/**
	 * 非法操作
	 */
	public static final short ILLEGAL_OPER = 8;
	/**
	 * 校验码或默认参数错误
	 */
	public static final short ERROR_NEED_RELOAD = 9;
	/**
	 * 验证码已失效
	 */
	public static final short CHECK_CODE_LOSE_EFFECT = 10;
	/**
	 * 没有发现网关
	 */
	public static final short GATE_NOT_FIND = 11;
	/**
	 * 帐号不存在
	 */
	public static final short ACCOUNT_NOT_EXIST = 12;
	/**
	 * 玩家不存在
	 */
	public static final short PLAYER_NOT_EXIST = 13;
	/**
	 * 金币不足
	 */
	public static final short NO_ENOUGH_COIN_FAILURE = 14;
	/**
	 * 元宝不足
	 */
	public static final short NO_ENOUGH_SYCEE_FAILURE = 15;
	/**
	 * 兑换券不足
	 */
	public static final short NOT_ENOUGTH_GIFT_CARD = 16;
	/**
	 * 帐号或密码错误
	 */
	public static final short ACCOUNT_OR_PASSWD_ERROR = 17;
	/**
	 * 同时多次请求
	 */
	public static final short REQ_MANY = 18;
	/**
	 * 帐号随机失败
	 */
	public static final short ACCOUNT_RAND_FAILED = 19;
	/**
	 * 角色创建失败
	 */
	public static final short PLAYER_CREATE_FAILED = 20;
	/**
	 * 头像图片不存在
	 */
	public static final short PIC_NOT_FOUND = 21;
	/**
	 * 手机格式错误
	 */
	public static final short TEL_FORMAT_ERROR = 22;
	/**
	 * 发送手机消息失败
	 */
	public static final short MOBILE_MSG_FAILED = 23;
	/**
	 * 帐号已经被绑定
	 */
	public static final short ACCOUNT_HAS_BIND = 24;
	/**
	 * 验证码已发送
	 */
	public static final short CODE_HAS_SEND = 25;
	/**
	 * 密码格式错误
	 */
	public static final short PWD_FORMAT_ERROR = 26;
	/**
	 * 无效兑换码
	 */
	public static final short GIFT_CODE_NOT_EFF = 27;
	/**
	 * 地址错误
	 */
	public static final short REC_ADDR_ERROR = 28;
	/**
	 * 包含敏感字
	 */
	public static final short KEY_WORD_FILTER = 29;
	/**
	 * 需要绑定手机号
	 */
	public static final short NEED_BIND_ACCOUNT = 30;
	/**
	 * QQ格式不对
	 */
	public static final short QQ_FORMAT_ERROR = 31;
	/**
	 * 不能给自己赠送
	 */
	public static final short NOT_SEND_SEIF = 32;
	/**
	 * 商品不能购买
	 */
	public static final short NOT_BUY_ITEM = 33;
	/**
	 * 座位不存在
	 */
	public static final short SEAT_NONE_EXIST = 34;
	/**
	 * 经验值不足
	 */
	public static final short EXP_NOT_ENOUGH = 35;
	/**
	 * 等级不足
	 */
	public static final short LEVEL_NOT_ENOUGH = 36;
	/**
	 * 比赛消耗不足
	 */
	public static final short MATCH_COST_NOT_ENOUGH = 38;
	/**
	 * 牌桌不存在
	 */
	public static final short TABLE_NOT_EXIST = 39;
	/**
	 * 当前座位有人
	 */
	public static final short SEAT_NOT_NULL = 40;
	/**
	 * 道具不足
	 */
	public static final short ITEM_NOT_ENOUGH = 41;
	/**
	 * 重复登入踢下线
	 */
	public static final short REPEAT_LOGIN = 42;
	/**
	 * 服务器维护登入关闭
	 */
	public static final short LOGIN_OFF = 43;
	/**
	 * 服务器维护被踢下线
	 */
	public static final short CUT_LINE = 44;
	/**
	 * 服务器维护关闭进入房间和快速开始
	 */
	public static final short ENTER_ROOM_OFF = 45;
	/**
	 * 当前房间人数达到上线
	 */
	public static final short NO_ENOUGH_ROOM_PALYNUM = 46;
	/**
	 * 金币超出房间要求的最大上限
	 */
	public static final short COIN_OVER_ROOM = 49;
	/**
	 * 金币超过上限
	 */
	public static final short ENTER_COIN_EXCEED = 50;
	/**
	 * 当前房间牌桌达到上线
	 */
	public static final short NO_ENOUGH_ROOM_TABLENUM = 51;
	/**
	 * 奖励已经领取
	 */
	public static final short REWARD_ALREADY_RECEIVE = 52;
	/**
	 * 该批次礼品码已经兑换
	 */
	public static final short GIFT_CODE_BATCH_HAS_GET = 53;
	/**
	 * 礼品码已经领取
	 */
	public static final short GIFT_CODE_HAS_GAIN = 54;
	/**
	 * 刷新当前比赛列表
	 */
	public static final short REFLUSH_CUR_MATCH_LIST = 55;
	/**
	 * 人数足够了
	 */
	public static final short MATCH_JOIN_NUM_ENOUGH = 56;
	/**
	 * 无操作托管站起
	 */
	public static final short NO_OPER_STANDUP = 57;
	/**
	 * 换桌太频繁
	 */
	public static final short CHANGE_TABLE_MANY = 58;
	/**
	 * 当前有未完成牌局
	 */
	public static final short HAVE_NOT_OVER_TABLE = 59;
	/**
	 * 比赛已晋级不可复活
	 */
	public static final short MATCH_UPDATE_NOT_RESUR = 60;
	/**
	 * 比赛不支持记牌器购买
	 */
	public static final short MATCH_NOT_NOAD = 61;
	/**
	 * 记牌器存在,不需要购买
	 */
	public static final short TABLE_NOAD_OPEN = 62;
	/**
	 * 客户端版本不满足最新协议支持
	 */
	public static final short CLIENT_VERSION_LOWER = 63;
	/**
	 * 模块暂未开启
	 */
	public static final short NO_OPEN = 64;
	/**
	 * 在游戏中
	 */
	public static final short ALREADY_IN_FRUIT = 65;
	/**
	 * 超过最大下注额
	 */
	public static final short EXCEED_MAX_BET = 66;
	/**
	 * 库存不足
	 */
	public static final short STOCK_SHORTAGE = 67;
	/**
	 * 帐号被封号
	 */
	public static final short ACCOUNT_CLOSURE = 68;
	/**
	 * 桃李卡未开启
	 */
	public static final short GIVE_COIN_SWITCH_OFF = 69;
	/**
	 * 有未发完的小喇叭
	 */
	public static final short UNFINISHED_SMALL_BROAD = 70;
	/**
	 * 您的帐号尚未绑定来下棋牌公众号,清先前往绑定
	 */
	public static final short NOT_BIND_WEIXIN = 71;
	/**
	 * 微信红包发放成功，请前往微信查看
	 */
	public static final int GIVE_REDPACKAGE_SUCCESS = 72;
	/**
	 * 配置文件错误
	 */
	public static final short XML_ERROR = 73;
	/**
	 * 等待中已存在
	 */
	public static final short HAVE_WITE_ROOM = 74;
	/**
	 * 微博授权错误用户无效
	 */
	public static final short ACCOUNT_WEIBO_USER_ERROR = 75;
	/**
	 * 微博授权过期
	 */
	public static final short ACCOUNT_WEIBO_TOKEN_ERROR = 76;
	/**
	 * 微信授权错误用户无效
	 */
	public static final short ACCOUNT_WEICHAT_USER_ERROR = 77;
	/**
	 * 该物品不允许赠送
	 */
	public static final short PROP_NO_GIVE_ERROR = 78;
	/**
	 * 加入创建房间-房间已满
	 */
	public static final short TABLE_PLAYER_MAX = 79;
	/**
	 * 加入创建房间-房间已满
	 */
	public static final short TABLE_PLAYER_NULL = 80;
	/**
	 * 只有房主能解散牌桌
	 */
	public static final short TABLE_DELETE_ERROR = 81;
	/**
	 * 牌局中 不允许解散牌桌
	 */
	public static final short CREATE_TABLE_DISSOLVE_ERROR = 82;
	/**
	 * 牌桌已不存在请再次确认
	 */
	public static final short CREATE_TABLE_ERROR = 83;
	/**
	 * 需要微信绑定才能领取红包哦
	 */
	public static final short WECHAT_OFFICIAL_NO_BIND_ACCOUNT = 84;
	/**
	 * 该牌桌不支持消耗道具创建
	 */
	public static final short CREATE_TABLE_NO_ITEM = 85;
	/**
	 * 创建牌桌退出..已经开局 不能退出
	 */
	public static final short CREATE_TABLE_EXIT_ERROR = 86;
	/**
	 * 翻牌达到次数上线
	 */
	public static final short FLOP_MAX_COUNT = 87;
	/**
	 * 牛牛下注玩家下注超过最大上限
	 */
	public static final short NIUNIU_PLAYER_BET_MAX = 88;
	/**
	 * 牛牛进入翻牌错误，没有可带入金币
	 */
	public static final short NIUNIU_FLOP_ERROR = 89;
	
	
	
	/**
	 * 发放失败，此请求可能存在风险，已被微信拦截
	 * 请提醒用户检查自身帐号是否异常。使用常用的活跃的微信号可避免这种情况。
	 */
	public static final short NO_AUTH = 100;
	/**
	 * 该用户今日领取红包个数超过限制
	 */
	public static final short SENDNUM_LIMIT = 101;
	/**
	 * 红包发放失败,请更换单号再重试
	 */
	public static final short SEND_FAILED = 102;
	/**
	 * 超过频率限制,请稍后再试
	 */
	public static final short FREQ_LIMIT = 103;
	/**
	 * 帐号余额不足，请到商户平台充值后再重试
	 */
	public static final short NOTENOUGH = 104;
	/**
	 * 红包超出上线
	 */
	public static final short CHAOXIAN = 105;
	
	/**
	 * 龙虎低限下注代码
	 */
	public static final short BET_DRAG_LIMIT = 106;

	//当前版本错误
	public static final short ERROR_VERSION = 107;

	public static final short REAL_NAME = 108;

}