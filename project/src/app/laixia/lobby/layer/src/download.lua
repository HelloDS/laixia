--下载使用的线程数
DOWN_THREADNUM = 5
    --是否开启幽灵下载
DOWN_GHOST = false

local mGameType = 1
    --强更地址
local   LAIXIA_STRONG_UPDATE = "http://forward.qp.games.weibo.com/server_"

local targetPlatform = cc.Application:getInstance():getTargetPlatform()


	BASE_UPDATE_URL = 'http://update.qp.games.weibo.com/sinaddz/'    --正式环境-cdn 
	BASE_UPDATE_URL_BASE = 'http://update.qp.games.weibo.com/sinaddz/' 

--	BASE_UPDATE_URL = 'http://10.235.66.59/sinaddz/'    --测试环境 
--	BASE_UPDATE_URL_BASE = 'http://10.235.66.59/sinaddz/' 


local APP_VERSION = "1.0.0"
local _progressbarloading
local _progressBarNum
function getAppVersion()
    print("getAppVersion  start");        
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if targetPlatform ==  3 then  
        cc.LuaLoadChunksFromZIP("res/libs/cocos.zip");
        local luaj = require "cocos.cocos2d.luaj"                  
	    local javaClassName = APP_ACTIVITY
	    local javaMethodName = "getAppVersion"
	    local javaParams = { }
	    local javaMethodSig = "()Ljava/lang/String;"	    
        local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
         print("getAppVersion  end");      
        return value;
    elseif (targetPlatform == 4 or targetPlatform == 5) then --ios获取app版本
        local luaoc = require("cocos.cocos2d.luaoc")
        local ok,ret = luaoc.callStaticMethod("GetGeneralInfo", "getAppVersionCode");
    	if ret ~= 0 or ret~= nil then
    	    APP_VERSION = ret
    	end
    	return APP_VERSION;
    else 
        return APP_VERSION;
    end 
    return APP_VERSION;
end 


function getHotUpdateRelativePath()  --获取热更的地址      
    print('hotUpdateRelativePath '..getAppVersion() .."/");
    return  getAppVersion().."/";
end


DownLoadManager.registerStaticRelativePath(getHotUpdateRelativePath());

DOWN_URL = BASE_UPDATE_URL..getHotUpdateRelativePath()
DOWN_URL_BASE = BASE_UPDATE_URL_BASE..getHotUpdateRelativePath()

localResPath = cc.FileUtils:getInstance():getWritablePath() .. "download/"..getHotUpdateRelativePath();

local _state = nil

local downloadTable = {}
local callback = nil
local trackBack = nil

local curError_no = 0

local isDownFinish = nil
local current_download_byte = 0
local all_download_byte = 0

 


pDownLoadManager = nil

local entryId = 0


local function isZipFile(fileName)
    pos1 , pos2 = string.find(fileName,"._zip")
    if pos1 == pos2 then
        return false
    else
        return true
    end
end 
 

local function finishDownLoadCallBack()
    CPPLog:info("***********************   finishDownLoadCallBack   ************************"); 
    if callback ~= nil and trackBack ~= nil then
        xpcall(callback, trackBack)
    elseif callback ~= nil then
        _progressbarloading:setPercent(100)
        _progressBarNum:setString("100%")
        callback() 
    end
end


local function finishDownLoad()
     CPPLog:info("***********************   finishDownLoad   ************************");
    if entryId ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(entryId)
        entryId = nil
    end

    if pDownLoadManager ~= nil then
        pDownLoadManager:unregisterLuaListener()
        pDownLoadManager:destroy()
        pDownLoadManager = nil

        finishDownLoadCallBack()
    end
end


local function updata(dt)
    if isDownFinish == true then
        finishDownLoad()
    end
end

local function handlerError(  )
    -- body
     CPPLog:info("*********              handlerError           *********************")
end


local function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

--下载处理函数 #1工作状态，#2类型
local function on_finish(work_state, type, name, error_no, download_byte, all_byte)    
    logGame("onFinish.... "..name.." download/all:"..download_byte.."/"..all_byte);
     if error_no ~= 0 then

        for k,v in pairs(downloadTable) do
            if isZipFile(v["name"])  == false then
                cc.FileUtils:getInstance():removeFile(localResPath .. v["name"])
                cc.FileUtils:getInstance():removeFile(localResPath .. v["name"] .. '.temp') 
                cc.FileUtils:getInstance():removeFile(localResPath .. v["name"] .. '.hash.real')            
            end 
        end      
        curError_no = error_no
        CPPLog:info("**Observer::on_finish: name="..name.."; type="..type.."; error="..error_no..";\n" )
    
--        if (_pecentageLabel ~= nil) then
--            _pecentageLabel:setString("下载更新错误, 请退出重试")
--        end
         local params = {
                            ["name"] = name, 
                            ["error_no"] = error_no, 
                        }  


        if (_retryButton ~= nil) then
            _retryButton:setVisible(true)
        end
       -- end
        handlerError()

        return
    end
    if curError_no > 0 then
        return
    end 

    if e_work_state_checking == work_state then

        -- print("*** e_work_state_checking   "..name.." ***");
        if "check" ~= _state then
            _state = "check" 
        end 
    elseif e_work_state_downloading == work_state then
        -- print("*** e_work_state_downloading   "..name.." ***");
        current_download_byte = download_byte
        all_download_byte = all_byte

         CPPLog:info( "download_byte:  "..current_download_byte.." / "..all_download_byte) ;

        if 0 ~= all_download_byte then
            --_pecentageLabel:setString(round(current_download_byte/1024/1024, 2).."M/".. round(all_download_byte/1024/1024,2 ).."M")
            local p = 100*current_download_byte/all_download_byte
            _progressbarloading:setPercent(p)
            p = math.modf(p/1)
            _progressBarNum:setString(p.."%")
            print(current_download_byte/all_download_byte) ; 
        end


        if "download" ~= _state then
            _state = "download" 
            if 0 ~= all_download_byte then 
            end
        end

        if type == e_state_file_pkg then
             CPPLog:info("*****************************pkg task done*******************************\n");
        end

        if type == e_state_event_alldone then
             CPPLog:info("*****************************all task done*******************************\n"); 
            isDownFinish = true
        end 
    end

end


--下载资源
local function downLoadRes()

    print("***************   downLoadRes  start  **************")

    if downloadTable ~= nil then
        curError_no = 0

        if pDownLoadManager == nil then
            pDownLoadManager = DownLoadManager:new()
            
            CPPLog:info("***************   DownLoadManager:new()   **************")
            CPPLog:info(" DOWN_URL =  "..DOWN_URL) 
            --pDownLoadManager.registerStaticRelativePath(getHotUpdateRelativePath()--[[..getDetailVersionPath()--]]);
            local urls = {}
            table.insert(urls, DOWN_URL)
            table.insert(urls, DOWN_URL) 
            table.insert(urls, DOWN_URL_BASE) 
            table.insert(urls, DOWN_URL_BASE) 
            
            --初始化数据--调用c++函数
            pDownLoadManager:initWithData(urls,DOWN_THREADNUM,DOWN_GHOST) 
        end
        --注册处理函数
        pDownLoadManager:registerLuaListener(on_finish)
        CPPLog:info("***************   pDownLoadManager:registerLuaListener(on_finish)    **************")

        for k,v in pairs(downloadTable) do
            if isZipFile(v["name"]) then
                pDownLoadManager:post_desire_pkg(v["name"], e_priority_exclusive, v["hash"], nil, nil)
            else
                pDownLoadManager:post_desire_cdf(v["name"], e_priority_exclusive, v["hash"], e_cdf_loadtype_load_cascade, e_zip_none, nil, nil)
            end 
        end


        isDownFinish = false
        entryId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(updata, 0, false)

         CPPLog:info("***************   downLoadRes  end  **************")

    else
        finishDownLoadCallBack()
    end
end

--开始下载，#1下载列表，#2显示警报，#3回调函数，#4回溯
function start_download(_downloadTable, showAlert , cb, tb )

    CPPLog:info("***************   start_download  **************") 

    downloadTable = _downloadTable
    callback = cb --结束的回调函数
    trackBack = tb 

    downLoadRes()
end 


function restart_download( )
    if isDownFinish == false then
        cleanDownLoad()
        pDownLoadManager:unregisterLuaListener()
        pDownLoadManager:destroy()
        pDownLoadManager = nil
        download.start(downloadFilesAll, false, callback,trackBack)
    end
end


function post_cells_cdf_allfiles()

    file_name = "/cdf/ddz.xml"
    file_hash = "" 

    local downloadTable = { }
    downloadTable["cdf/ddz.xml"] = { name = file_name, hash = file_hash }
    start_download(downloadTable, true, gotoLogin , __G__TRACKBACK__)

end



 function post_zip()

--   CPPLog:info("post_zip" );

     --开始下载
     local function startdown() 

        local downloadTable = { }
        downloadTable["cdf/_cdf._zip"] = { name = "/cdf/_cdf._zip", hash = "" } 
        start_download(downloadTable, true, post_cells_cdf_allfiles, __G__TRACKBACK__  )

    end
    
     --开始下载版本文件
    local function startdown_versionfiles()
        
        local downloadTable = { }
        downloadTable["index.jsp"] = { name = "/index.jsp", hash = "" } 

        local function onVersionFileDownLoaded()
            print('onVersionFileDownloaded');
            local path = cc.FileUtils:getInstance():getWritablePath() .. "download/"..getHotUpdateRelativePath().."index.jsp.temp";
            local t = cc.FileUtils:getInstance():getStringFromFile(path);
            print('onVersionFileDownloaded ' ..path);

            print("FileData: "..tostring(t));

            if(t ~= nil) then

                DOWN_URL = DOWN_URL..tostring(t).."/";
                DOWN_URL_BASE = DOWN_URL_BASE..tostring(t).."/";

                print("DOWN_URL: "..DOWN_URL)
                print("DOWN_URL_BASE: "..DOWN_URL_BASE)
                startdown();
            else
              
            end

            --startdown();
        end 
        start_download(downloadTable, true, onVersionFileDownLoaded, __G__TRACKBACK__  )
     
    end 

   createLoading(startdown_versionfiles)
end



function chkIsUpdate()
   local targetPlatform = cc.Application:getInstance():getTargetPlatform()
   print("in the fun   chkisupdate  ***********************targetPlatform =="..targetPlatform)
    
    if targetPlatform ==  3 then 
       cc.LuaLoadChunksFromZIP("res/libs/cocos.zip");
       local path = LAIXIA_STRONG_UPDATE..targetPlatform.."_"..mGameType.."_"..getAppVersion()..".json"

        local luaj = require "cocos.cocos2d.luaj"
	    local javaClassName = APP_ACTIVITY
	    local javaMethodName = "chkIsUpdate"
	    local javaParams = {path}
	    local javaMethodSig = "(Ljava/lang/String;)Z"   
        local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        print("getAppHasNewVersion value = ".. tostring(value).." state = "..tostring(state));
        return value;
    else    
        return false;
    end 
end


function createLoading(startFun)

    local frameSize = cc.Director:getInstance():getOpenGLView():getFrameSize()
    local size = display.size
    local _curView = cc.Scene:create()
    local splashLayer = cc.Layer:create()    
    _curView:addChild(splashLayer)
    local winSize = cc.Director:getInstance():getWinSize()
    local thirdLogo = nil --第三方logo
    thirdLogo = cc.Sprite:create("images/laixia_logo.png")
    thirdLogo:setPosition({x=winSize.width/2, y=winSize.height/2})
    thirdLogo:setAnchorPoint(0.5,0.5)
    splashLayer:addChild(thirdLogo)
    thirdLogo:setScale(cc.Director:getInstance():getVisibleSize().height/thirdLogo:getContentSize().height)

    local lastScene = cc.Director:getInstance():getRunningScene()  
    if (nil ~= lastScene) then
        cc.Director:getInstance():replaceScene(_curView)
    else
        cc.Director:getInstance():runWithScene(_curView)
    end
    cc.SpriteFrameCache:getInstance():removeSpriteFrameByName("images/laixia_logo.png")
    cc.Director:getInstance():getTextureCache():removeTextureForKey("images/laixia_logo.png")
    local test = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
    print(test)
    local function SwitchToDownload()
        thirdLogo:removeFromParent()
        local ret = cc.CSLoader:createNode("new_ui/Loading.csb")
	    ret:setContentSize(display.size)
	    ccui.Helper:doLayout(ret) 
        _curView:addChild(ret)
        local bg = ret:getChildByName("loadingBG")
        bg:setPosition(cc.p(display.cx,display.cy))
        bg:setScale(winSize.height/720)

        local loadingNode = ret:getChildByName("loadingNode")
--        --loadingNode:setPosition(winSize.width/2,0)
--        loadingNode:setPosition(cc.p(display.cx,display.bottom))

--        local loadAinmNode = ret:getChildByName("loadAinmNode")
--
--        loadAinmNode:setPosition(cc.p(display.cx,display.cy))
--        loadAinmNode:setPosition(cc.p(display.cx,display.cy))

        _progressbarloading = loadingNode:getChildByName("LoadingProgress")
        _progressbarloading:setPercent(0)
        _progressBarNum = loadingNode:getChildByName("progressBarNum")
        _progressBarNum:setString("0%")

        startFun()
    end
    splashLayer:runAction(cc.Sequence:create(cc.DelayTime:create(1.2),cc.CallFunc:create(SwitchToDownload)))
end


function forceUpdate()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    local function updataToProgressBar(mProgressBar)
        print("下载进度"..mProgressBar)
        _progressbarloading:setPercent(tonumber(mProgressBar))
        local num  = math.modf(tonumber(mProgressBar)/1)
        _progressBarNum:setString(num.."%")
    end

    --lua函数注册给loading
    function funToStrongUpdate()
        local targetPlatform = cc.Application:getInstance():getTargetPlatform()
        if targetPlatform == 3 then
            local luaj = require "cocos.cocos2d.luaj"
            local javaClassName = APP_PACKAGE_NAME.. "UpdateManager"
            local javaMethodName = "setLuaLoadingFun"
            local javaParams={ updataToProgressBar }
            local javaMethodSig = "(I)V"
            luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        end 
    end

    function startUpdate()
        if targetPlatform == 3 then
            funToStrongUpdate()
            local luaj = require "cocos.cocos2d.luaj"
            local javaClassName = APP_ACTIVITY
            local javaMethodName = "strongUpdate"
            local javaParams = {}
            local javaMethodSig = "()V"
            local value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            return value
        else
            return 0
        end
    end
 createLoading(startUpdate)
end

