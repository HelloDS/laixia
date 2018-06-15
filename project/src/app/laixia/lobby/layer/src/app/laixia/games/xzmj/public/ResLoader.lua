local CURRENT_MODULE_NAME = ...;
print("import ResLoader")
local laixia = laixia;

local ResLoader = class("ResLoader");

local display = display;




local function addImageAsync(res1,res2,callback)    
        return display.addImageAsync(res1, callback)
end

local function addSpriteFramesAsync (res1,res2,callback)    
        return display.addSpriteFrames(res1, res2,callback);
end
local preloader = {
    
    _res_t = {
------------------------------------------------------------------------------------------------
--新界面资源

    -- {'new_ui/common/activity.plist','new_ui/common/activity.png',addSpriteFramesAsync},
    {'new_ui/common/all_button.plist','new_ui/common/all_button.png',addSpriteFramesAsync},
    {'new_ui/common/layer01.plist','new_ui/common/layer01.png',addSpriteFramesAsync},
    -- {'new_ui/common/layer02.plist','new_ui/common/layer02.png',addSpriteFramesAsync},
    -- {'new_ui/common/picture.plist','new_ui/common/picture.png',addSpriteFramesAsync},
    --{'new_ui/common/poker.plist','new_ui/common/poker.png',addSpriteFramesAsync},
    -- {'new_ui/common/role.plist','new_ui/common/role.png',addSpriteFramesAsync},
    {'new_ui/common/word.plist','new_ui/common/word.png',addSpriteFramesAsync},
    {'new_ui/common/icon.plist','new_ui/common/icon.png',addSpriteFramesAsync},
    -- {'new_ui/common/activity01.plist','new_ui/common/activity01.png',addSpriteFramesAsync},
    -- {'new_ui/common/libao.plist','new_ui/common/libao.png',addSpriteFramesAsync},
    {'new_ui/common/red_packet.plist','new_ui/common/red_packet.png',addSpriteFramesAsync},
    -- {'new_ui/common/chips.plist','new_ui/common/chips.png',addSpriteFramesAsync},

--------------------------------------------------------------------------------------------
    --新动画
    -- {'new_animation/baoxiang0.plist','new_animation/baoxiang0.png',addSpriteFramesAsync},
    -- {'new_animation/jigndeng0.plist','new_animation/jigndeng0.png',addSpriteFramesAsync},
    -- {'new_animation/shouchong0.plist','new_animation/shouchong0.png',addSpriteFramesAsync},
    -- {'new_animation/naozhogn0.plist','new_animation/naozhogn0.png',addSpriteFramesAsync},
    -- {'new_animation/ddz0.plist','new_animation/ddz0.png',addSpriteFramesAsync},
    -- {'new_animation/jinbidiaoluo.plist','new_animation/jinbidiaoluo.png',addSpriteFramesAsync},
    -- {'new_animation/zhengzaijiazai.plist','new_animation/zhengzaijiazai.png',addSpriteFramesAsync},
    -- {'new_animation/rain.plist','new_animation/rain.png',addSpriteFramesAsync},
    -- {'new_animation/gain.plist','new_animation/gain.png',addSpriteFramesAsync},
    -- {'new_animation/tablelose.plist','new_animation/tablelose.png',addSpriteFramesAsync},
    -- -- {'new_animation/everyday0.plist','new_animation/everyday0.png',addSpriteFramesAsync},
    -- {'new_animation/table_zjz.plist','new_animation/table_zjz.png',addSpriteFramesAsync},
    --
------------------------------------------------------------------------------------------------
    -- {'new_animation/bsc0.plist','new_animation/bsc0.png',addSpriteFramesAsync},
    -- {'new_animation/szp0.plist','new_animation/szp0.png',addSpriteFramesAsync},
    -- {'new_animation/dzpk0.plist','new_animation/dzpk0.png',addSpriteFramesAsync},
    -- {'new_animation/lhd0.plist','new_animation/lhd0.png',addSpriteFramesAsync},
    -- {'new_animation/guang0.plist','new_animation/guang0.png',addSpriteFramesAsync},
    -- {'new_animation/famerwin.plist','new_animation/famerwin.png',addSpriteFramesAsync},
    -- {'new_animation/landlordwin.plist','new_animation/landlordwin.png',addSpriteFramesAsync},
    -- {'new_animation/roomlight.plist','new_animation/roomlight.png',addSpriteFramesAsync},
    -- {'new_animation/roomkaishi.plist','new_animation/roomkaishi.png',addSpriteFramesAsync},
    -- {'new_animation/famerlost001.plist','new_animation/famerlost001.png',addSpriteFramesAsync},
    -- {'new_animation/ming.plist','new_animation/ming.png',addSpriteFramesAsync},
    -- {'new_animation/laizi.plist','new_animation/laizi.png',addSpriteFramesAsync},
    -- {'new_animation/discount.plist','new_animation/discount.png',addSpriteFramesAsync},
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
    },


    getItemCount = function(self)
        return #self._res_t;
    end,

    doLoad = function(self,callback)     
         local len = #self._res_t
         for i = 1,len do
            local funIndex = #self._res_t[i]
            local func =self._res_t[i][funIndex];
            func(self._res_t[i][1],self._res_t[i][2],self.callback);                        
        end
    end,
    registerLoadingCallback = function(self,func)
        self.callback = func;
        return self;       
    end 
}

function ResLoader:ctor()    
    self._resArrays = {}; -- table
    self._preLoadCallback = nil;
    self._loadingCallback = nil; --
    self._resCount = 0;    
end


function ResLoader:registerPreLoadEndCallBack(cb)    
    self._preLoadCallback = cb;
    return self;        
end
 

-- 预先读取的资源
function ResLoader:init()    
    laixiaddz.JsonTxtData:init();
    laixia.net.init();
    laixiaddz.ui:init();
    laixiaddz.ani:init();

    return self      
end




function ResLoader:addDefault()

    self._resArrays = {        
     
        {"texture",preloader},
            
    };

    return self;    
end 



function ResLoader:addResource(resName,resType,loadFunc)
    return self;
end
 


function ResLoader:getTotalCount()
    --返回加载资源的数量   
    return self._resCount;        
end


function ResLoader:prepareForLoad()

    self:addDefault()
    
    self._resCount = 0;
    for _,v in pairs(self._resArrays) do
        self._resCount = self._resCount + v[2]:getItemCount();
    end 
    return self;
end 


function ResLoader:doLoad()            
    print("ResLoader:doLoad");
    for i,v in ipairs(self._resArrays) do

        v[2]:registerLoadingCallback(function(...)             
            self._loadingCallback(...)
        end)
        :doLoad();             
    end      
end


function ResLoader:registerLoadingCallback(callback)
    self._loadingCallback  = callback or function(...) end ;
    return self;
end  

  
return ResLoader.new();


