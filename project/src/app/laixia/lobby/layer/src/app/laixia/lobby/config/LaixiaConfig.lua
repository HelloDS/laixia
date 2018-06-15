
local Laixia_Config = 
{
    GameAppID = 1,
    GameType = 1,-- 1表示是新浪斗地主，2表示新浪二打一（小米包）
    --[[    
        1 游客
        2 手机号登录
       4 微博
        5 微信
    --]]
    isAutoLogin = false,    
    isOpenUpdate = true,
    isAudit = false,
    
    GamePlatformID = 1, -- 默认值 laixia.config.GamePlatformID   
    MobileInfo = "huawei", --手机设备
    GameMsgVersion = 4,     --协议版本号
    ClientVersion = 4,   --客户端版本号
    
    --ServerURL = "http://192.168.2.125/laixia-hall/hall.do",
--   ServerURL = "http://192.168.2.199/laixia-hall/hall.do",  
     ServerURL = "http://39.106.111.17:11121/laixia-hall/hall.do",
--    ServerURL = "http://laixia.f3322.net:11121/laixia-hall/hall.do",


    LAIXIA_WAITING_OUT = 15, --等待秒数  --等待时间修改为15秒了
    LAIXIA_WAITINT_WINDOW_INTERVAL = 1, --等待1秒出现 等待界面
    LAIXIA_MAX_LOST_BEAT_HEART_PACKET_NUM = 2, --丢失心跳包
    USING_CPP_HTTP = true, -- HTTP_用C++
    LAIXIA_DEBUG_ACCOUNT = false,      -- 是否随机账号    
    LAIXIA_HEARTBEAT_SWITCH = true,     -- 心跳开关
    LAIXIA_HEARTBEAT_INTERVAL = 15000,  -- 心跳时间间隔（毫秒）  
    LAIXIA_SHOW_STATINMASSAGE = 7 , -- 用于控制站内信显示的有效时间，过来此时间就不会显示了

    Laixia_SoundOn = true, -- --音乐打开

    LAIXIA_AMEND_SERVER_URL = false,        -- 是否获取url，false不获取，true会去固定请求获取 正式上线需要打开
    LAIXIA_AMEND_SERVER = "http://172.16.225.78/gameUrl/gameUrl.do",        -- 是否获取url，false不获取，true会去固定请求获取 正式上线需要打开

    UPDATE_HOTUPDATE_DOWNLOADURL = "http://39.106.120.67/upload/zipfiles/",
    --TCP 服务器
    LAIXIA_TCP_SERVER_ADDRESS ="",
    --头像URL    
    
	HEAD_URL = "",--"http://images.qp.games.weibo.com/", 
       
    AGREEMENT_URL = "http://wx.laixia.com/templates/terms.html", --游戏协议地址
    
    ZHISHI_AGREEMENT_URL = "http://service.h7tuho5mf.cn/privacy.html", -- 芝士服务协议  agreement
    
    ERVYI_URL = "http://2v1.games.laixia.com.cn/h5game?from=ddz",
    --ERVYI_URL = "http://115.182.15.89:8089/innerapp/index.html??channel_id=0&uid=1505656092&avatar=http%3A%2F%2Ftvax1.sinaimg.cn%2Fcrop.0.0.750.750.50%2F59be7d1cly8fdgpgg5ixwj20ku0kuwhk.jpg&nick=%25E6%2588%2591%25E6%2598%25AF%25E5%258C%2597%25E6%25BC%2582%25E5%25AE%25B6%25E6%2597%258F&token=6685832fa20004cb6de32009c992b8a1",

    --小游戏的下载地址
    --二打一下载地址
    APK2VS1_URL = "http://mg.games.laixia.com.cn/97973/2v1/Landlord2v1_1.1.0_20161013_sina2.apk",
    --牛牛下载地址 
    APKDOUNIUNIU_URL = "http://update.qp.games.weibo.com/sinaddz/apk/bailin/combailinkillbullssina_175.apk",
    --德州扑克下载地址
    APKTEXAS_URL = "http://update.qp.games.weibo.com/sinaddz/apk/bailin/dzpk_sina_20170516.apk",
    --麻将的下载地址
    APKMAJIANG_URL = "http://update.qp.games.weibo.com/sinaddz/apk/bailin/blmj_laixia.apk",
    --捕鱼的下载地址
    APKFISH_URL = "http://update.qp.games.weibo.com/sinaddz/apk/sina/mobile_fish.apk",
    ------------------------业务常量配置-----------------------------------------
    LAIXIA_SUPERROOM_ID = 246,   
    
    LAIXIA_MAX_AWAKE_MSG_LENGTH_POKERDESK = 20,     --睡眠唤醒后同时处理的包数量（牌桌页面），超出会重新登录
    LAIXIA_MAX_AWAKE_MSG_LENGTH_NOPOKERDESK = 60    --睡眠唤醒后同时处理的包数量（非牌桌页面），超出会重新登录

   
}


return Laixia_Config

 