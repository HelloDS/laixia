--[[
    平台常量
]]
APP_PACKAGE_NAME = "com/laixia/game/ddz/" 

ACTIVITY_NAME = "AppActivity"
APP_ACTIVITY  = APP_PACKAGE_NAME..ACTIVITY_NAME 

--资源更新版本号
Upd_Version = "0.0.1"





laixia = laixia or {}

--是否更新 此开关可以控制更新 方便Debug模式下不进行更新从而调试代码
laixia.m_isUpdate = false
laixia.lobby_liveid = "0"
--laixia.resVersion = "2.0.21"
laixia.LocalPlayercfg = {}
laixia.LocalPlayercfg.LaixiaPlayerID = 10004
laixia.LocalPlayercfg.LaixiaGoldCoin = 1000
laixia.LocalPlayercfg.LaixiaZsCoin = 500 
laixia.LocalPlayercfg.LaixiaLdCoin = 0
laixia.LocalPlayercfg.PhoneNumber = ""
laixia.LocalPlayercfg.LaixiaPlayerGender = 1
laixia.LocalPlayercfg.LaixiaPlayerNickname = "浪漫风暴"
laixia.LocalPlayercfg.LaixiaTokenID = "balabala"
laixia.LocalPlayercfg.LaixiaLunBoPath={}
-- laixia.LocalPlayercfg.LaixiaLunBoPath[1] = {}
-- laixia.LocalPlayercfg.LaixiaLunBoPath[1][1] = "res/new_ui/test/1.png"
-- laixia.LocalPlayercfg.LaixiaLunBoPath[1][2] = "res/new_ui/test/2.png"
-- laixia.LocalPlayercfg.LaixiaLunBoPath[1][3] = "res/new_ui/test/1.png"
-- laixia.LocalPlayercfg.LaixiaLunBoPath[2] = {}
-- laixia.LocalPlayercfg.LaixiaLunBoPath[2][1] = "res/new_ui/test/1.png"
-- laixia.LocalPlayercfg.LaixiaLunBoPath[2][2] = "res/new_ui/test/2.png"
-- laixia.LocalPlayercfg.LaixiaLunBoPath[2][3] = "res/new_ui/test/2.png"
-- laixia.LocalPlayercfg.LaixiaLunBoPath[3] = {}
-- laixia.LocalPlayercfg.LaixiaLunBoPath[3][1] = "res/new_ui/test/guanggaotu.png"
-- laixia.LocalPlayercfg.LaixiaLunBoPath[3][2] = "res/new_ui/test/4.png"
-- laixia.LocalPlayercfg.LaixiaLunBoPath[3][3] = "res/new_ui/test/5.png"


laixia.LocalPlayercfg.AdvermentIndex = 1
laixia.LocalPlayercfg.HEAD_URL = "http://39.106.111.17:11121/examples/ic_morenhead13.png"


--游戏总场次
laixia.LocalPlayercfg.LaixiaGameTotal = 0
--参赛总场次
laixia.LocalPlayercfg.LaixiaBisaiNum = 0
--胜利总场次
laixia.LocalPlayercfg.LaixiaPlayerVictoryTimes = 0
--冠军总次数
laixia.LocalPlayercfg.LaixiaPlayerMaxWintimes = 0
--游戏总胜率
laixia.LocalPlayercfg.LaixiaPlayerRate = 0
--亚军总次数
laixia.LocalPlayercfg.LaixiaBisaiSecond =  0

laixia.LocalPlayercfg.LaixiaHeartBeatTime = 10000

--背包
laixia.LocalPlayercfg.LaixiaPropsData = {}

--轮播图的当前索引
laixia.LocalPlayercfg.LunBoindex = 1
--轮播标题的表
laixia.LocalPlayercfg.LunBoTitle = {"res/new_ui/test/OPPO.png","res/new_ui/test/huodong.png","res/new_ui/test/youjian.png"}



---游戏场相关
laixia.LocalPlayercfg.laixiaddzOutCardsCount =0
laixia.LocalPlayercfg.laixiaddzisConnectCardTable = false      --是否连上牌桌
laixia.LocalPlayercfg.LaixiaSelfInning =  0
laixia.LocalPlayercfg.LaixiaSelfTotalInning = 0 -- 自建桌总局数

laixia.LocalPlayercfg.LaixiaWechatServiceNum = "laixia"   -- 微信分享需要用到的
laixia.LocalPlayercfg.LaixiaBroadCastInInHall = {}
