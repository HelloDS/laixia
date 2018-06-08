




--[[
    牌桌里面的配置
]]--

local PCfig = {}

PCfig.CPMAX = 10           -- 一列中出牌最大的张树 

PCfig.SCALE = 0.45         -- 牌桌上出牌的缩放

PCfig.CPJIANJU = 38        -- 玩家牌桌出牌的宽的间距

PCfig.CPJIANJU_GAO = 50		--玩家牌桌出牌的高的间距

PCfig.CPJIANJU_ZUOYOU = 28  --左右玩家的出牌的高的间距

PCfig.SPJIANJU = 83*0.95     	--玩家的手牌间距

PCfig.TIPSPSCALE = 0.44  	--上面玩家的手牌的缩放

PCfig.SEATSTY = 
{
	"xuezhan_west",   -- 左
	"xuezhan_south",  -- 下
	"xuezhan_east",   -- 右
	"xuezhan_north",  -- 上
}
PCfig.SSPJIANJU = 36 	--上玩家手牌间距
 	
PCfig.ZSPJIANJU = 25		--左玩家手牌间距

PCfig.YSPJIANJU = 25		--右玩家手牌间距
PCfig.ZYDPSCALE = 0.45 		--左右对牌的缩放

--[[
	麻将方位结构
]]--
PCfig.POSTB = 
{
	SHANG = 4,
	XIA = 2,
	ZUO = 1,
	YOU = 3,
}

PCfig.XPZACT = "xuezhan_xuanpai"
PCfig.DQZACT = "xuezhan_loading"
PCfig.PENGACT = "xuezhan_peng_a"
PCfig.GANGACT = "xuezhan_gang"
PCfig.STARACT = "xuezhan_start"
PCfig.ENDHUPACT = -- 胡牌123 动画
{
	"xuezhan_hu_a",
	"xuezhan_hu_b",
	"xuezhan_hu_c",
}
PCfig.CPJIANJU_GAO = 59		--玩家牌桌出牌的高的间距


-- 1-9 筒子
-- 10-18 条
-- 19-27 万
PCfig.TONGMIN = 1
PCfig.TONGMAX = 9

PCfig.TIAOMIN = 10
PCfig.TIAOMAX = 18

PCfig.WANMIN = 19
PCfig.WANMAX = 27

PCfig.MJSTYLE =
{
	TONG = 1,
	TIAO = 2,
	WAN = 3
} 

PCfig.TONG_HWPATH =  "games/xzmj/majianghuawen/tong/tong/"
PCfig.TIAO_HWPATH =  "games/xzmj/majianghuawen/tiao/tiao/"
PCfig.WAN_HWPATH  =  "games/xzmj/majianghuawen/wan/wan/"

PCfig.AN_GBGPATH  = "games/xzmj/Mahjong/koupai.png"
PCfig.MyDPJIANJU = 195   -- 我对牌和下一个对牌的间距 
PCfig.DJDPJIANJU = -120   -- 我的对家对牌和下一个对牌的间距 
PCfig.ZYANGANGPATH = "games/xzmj/Mahjong/heng_koupai.png"
PCfig.YOUDPJIANJU = 95   -- 左右对牌和下一个对牌的间距 

PCfig.MJONGTY = {

	NOT = -1,        -- 啥都不是
	PENG = 1,         -- 碰
	ANGANG = 2,		  -- 暗杠
	MINGGANG = 3,	  -- 明杠
	LONGQIDUI = 4,    -- 龙七对
	ANQIDUI = 5,      -- 暗七对
	QINGYISE = 6, 	  -- 清一色
	DUIZIHU = 7, 	  -- 对子胡
	TIANHU = 8, 	  -- 天胡
	DIHU = 9, 	      -- 地胡
}

PCfig.PKDESKBS = xzmj.layer.PokerDeskBasepl

--[[ 用来标记玩家到底可以操作不 ]]--
PCfig.MYSTATE = {
	NOT = 0, 		  -- 不能动
	KECAOZUO = 1,     -- 可操作(可以出牌)
	DQZ = 2,          -- 玩家在定缺
	XPZ = 3,          -- 玩家在选牌
}

PCfig.TTWICONPATH = "games/xzmj/PokerDeskLayer/"

-- 麻将换三张类型
PCfig.CHANGEACNAME = {
	"xuezhan_dingque",
	"xuezhan_dingque",
	"xuezhan_dingque",

}

--[[
	麻将的操作类型
]]--
PCfig.MJOPERATE = {
	-- 摸牌
	  mopai = 1;
	-- 出牌
	  chupai = 2;
	-- 回头刚
	  huitougang = 3;
	-- 暗杠
	  angang = 4;
	-- 明杠、点杠
	  minggang = 5;
	-- 胡
	  hu = 6;
	-- 吃
	  chi = 7;
	-- 碰
	  peng = 8;
	-- 过
	  guo = 9;
	-- 定缺
	  dingque = 10;
	-- 换三张
	  huansaizhang = 11;
}


PCfig.ENDHUPTEXT =
{
  	[1] = "平胡",
    [2] = "清一色",
    [3] = "对对胡",
    [4] = "七对",
    [5] = "幺九",
    [6] = "根",
    [7] = "全球人",
    [8] = "自摸",
    [9] = "天胡",
    [10] = "地胡",
}



PCfig.SPZHIHUI = 200

PCfig.MJSOUNDFTPATH ={
	"res/games/Sound/mjsound/boy/",
	"res/games/Sound/mjsound/girl/",

} 

PCfig.MJTYPESOUNDPATH = {
"res/games/Sound/mjsound/boy/comme/",
"res/games/Sound/mjsound/girl/comme/",
}

PCfig.MJSOUNDENDPATH = ".mp3"





return PCfig



