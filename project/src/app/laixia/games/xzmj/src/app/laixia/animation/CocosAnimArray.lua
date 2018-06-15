--add by wangtianye

-- 23 个
local path = "games/xzmj/"
local csb = ".csb"


local CocosAnimArray = 
{
    {
        Name = "xuezhan_hu_b",
        Name_CN = "胡牌2胡",
        AnimationFile = "games/xzmj/xuezhan_hu_b.csb",                
        isLoop = true,    
    },
    {
        Name = "xuezhan_north",
        Name_CN = "牌桌方向动画",
        AnimationFile = path.."xuezhan_north"..csb,                
        isLoop = true,    
    },
    {
        Name = "xuezhan_south",
        Name_CN = "牌桌方向动画",
        AnimationFile = path.."xuezhan_south"..csb,
        isLoop = true,    
    },
    {
        Name = "xuezhan_west",
        Name_CN = "牌桌方向动画",
        AnimationFile = path.."xuezhan_west"..csb,                
        isLoop = true,    
    },
    {
        Name = "xuezhan_east",
        Name_CN = "牌桌方向动画",
        AnimationFile = path.."xuezhan_east"..csb,                
        isLoop = true,    
    },
    {
        Name = "xuezhan_peng_a",
        Name_CN = "碰动画",
        AnimationFile = path.."xuezhan_peng_a"..csb,                
        isLoop = false,    
    },
    {
        Name = "xuezhan_xuanpai",
        Name_CN = "选牌中动画",
        AnimationFile = path.."xuezhan_xuanpai"..csb,                
        isLoop = true,    
    },
    {
        Name = "xuezhan_wind",
        Name_CN = "杠动画",
        AnimationFile = path.."xuezhan_wind"..csb,                
        isLoop = true,    
    },
    {
        Name = "xuezhan_start",
        Name_CN = "开局动画",
        AnimationFile = path.."xuezhan_start"..csb,                
        isLoop = true,    
    },
    {
        Name = "xuezhan_rain",
        Name_CN = "下雨动画",
        AnimationFile = path.."xuezhan_rain"..csb,                
        isLoop = true,    
    },
    {
        Name = "xuezhan_pointer",
        Name_CN = "那个玩家在操作箭头指向动画",
        AnimationFile = path.."xuezhan_pointer"..csb,                
        isLoop = true,    
    },
    {
        Name = "xuezhan_loading",
        Name_CN = "血战到底四个字得动画",
        AnimationFile = path.."xuezhan_loading"..csb,                
        isLoop = true,    
    },
    {
        Name = "xuezhan_hu_c",
        Name_CN = "3胡动画",
        AnimationFile = path.."xuezhan_hu_c"..csb,                
        isLoop = true,    
    },
    {
        Name = "xuezhan_hu_b",
        Name_CN = "2胡动画",
        AnimationFile = path.."xuezhan_hu_b"..csb,                
        isLoop = true,    
    },
    {
        Name = "xuezhan_hu_a",
        Name_CN = "1胡动画",
        AnimationFile = path.."xuezhan_hu_a"..csb,                
        isLoop = true,    
    },
    {
        Name = "xuezhan_hu",
        Name_CN = "自己胡得动画",
        AnimationFile = path.."xuezhan_hu"..csb,                
        isLoop = true,    
    },
    {
        Name = "xuezhan_headportrait",
        Name_CN = "围绕方框转动画",
        AnimationFile = path.."xuezhan_headportrait"..csb,                
        isLoop = true,    
    },
    {
        Name = "xuezhan_gang",
        Name_CN = "杠动画",
        AnimationFile = path.."xuezhan_gang"..csb,                
        isLoop = false,    
    },
    {
        Name = "xuezhan_dingque",
        Name_CN = "旋转动画",
        AnimationFile = path.."xuezhan_dingque"..csb,                
        isLoop = false,    
    },
    {
        Name = "xuezhan_start",
        Name_CN = "开局动画",
        AnimationFile = path.."xuezhan_start"..csb,                
        isLoop = true,    
    }
};


return CocosAnimArray;


