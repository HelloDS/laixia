function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")

     local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    errorMessage = string.gsub(errorMessage,'\\','/')
    local msg = debug.traceback("", 2) 
    msg=string.gsub(msg,'\\','\\\\')
    msg=string.gsub(msg,' ','_')
    xhr:open("POST", "http://zgame.laixia.com/uploaderror")
    xhr:registerScriptHandler(function() 
        local test = 1
    end)  
    xhr:send("key="..tostring(errorMessage).."&msg="..tostring(msg)) 
end


cc.FileUtils:getInstance():addSearchPath("src_landlord")
cc.FileUtils:getInstance():addSearchPath("res_landlord")
cc.FileUtils:getInstance():addSearchPath("res_landlord/new_ui")
cc.FileUtils:getInstance():addSearchPath("res_landlord/new_animation")
cc.FileUtils:getInstance():addSearchPath("src/app/laixia")
cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("res")
cc.FileUtils:getInstance():addSearchPath("res/new_ui")
cc.FileUtils:getInstance():addSearchPath("res/new_animation")
cc.FileUtils:getInstance():addSearchPath("res/lobby/animation")

--添加更新目录到searchpath
local pathToSave = cc.FileUtils:getInstance():getWritablePath() .. "update"
cc.FileUtils:getInstance():addSearchPath(pathToSave .. "/src",true)
cc.FileUtils:getInstance():addSearchPath(pathToSave .. "/src/app/laixia",true)
cc.FileUtils:getInstance():addSearchPath(pathToSave .. "/res", true)
cc.FileUtils:getInstance():addSearchPath(pathToSave .. "/res/new_ui",true)
cc.FileUtils:getInstance():addSearchPath(pathToSave .. "/res/new_animation",true)
cc.FileUtils:getInstance():addSearchPath(pathToSave .. "res/lobby/animation",true)

package.path = package.path .. ";"..pathToSave.."/src/?.lua".. ";src_landlord"..";src/"
cc.FileUtils:getInstance():setPopupNotify(false)

cc.LuaLoadChunksFromZIP("res/libs/cocos.zip");
cc.LuaLoadChunksFromZIP("res/libs/framework.zip");
            
require "config"
require("cocos.init")
require("framework.init")


APP_ENV = {};
local Env = APP_ENV;

Env.platform  = cc.Application:getInstance():getTargetPlatform()
Env.director  = cc.Director:getInstance()
Env.fileUtils = cc.FileUtils:getInstance()
Env.userDefault = cc.UserDefault:getInstance() --




function gotoLogin()


local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    
    if(targetPlatform == 3 ) then -- android
            --cc.LuaLoadChunksFromZIP("res/libs/cocos.zip");

            Env.luaj = require "cocos.cocos2d.luaj"

            --cc.LuaLoadChunksFromZIP("res/libs/cocos.zip");
            
            cc.LuaLoadChunksFromZIP("res/libs/socket.zip");
            
            --cc.LuaLoadChunksFromZIP("res/libs/framework.zip");
            
            cc.LuaLoadChunksFromZIP("res/libs/app.zip");
      
           
          print("LuaLoadChunksFromZIP")
    end
    if(4 == cc.Application:getInstance():getTargetPlatform() or 5 == cc.Application:getInstance():getTargetPlatform()) then

            --cc.LuaLoadChunksFromZIP(localResPath.."res/libs/cocos.zip");

            cc.LuaLoadChunksFromZIP(localResPath.."res/libs/socket.zip");

            --cc.LuaLoadChunksFromZIP(localResPath.."res/libs/framework.zip");

            cc.LuaLoadChunksFromZIP(localResPath.."res/libs/app.zip");

    end
    if(targetPlatform == 0 ) then -- window

            --cc.LuaLoadChunksFromZIP(localResPath.."res/libs/cocos.zip");

            cc.LuaLoadChunksFromZIP(localResPath.."res/libs/socket.zip");

            --cc.LuaLoadChunksFromZIP(localResPath.."res/libs/framework.zip");

            cc.LuaLoadChunksFromZIP(localResPath.."res/libs/app.zip");

    end
        require("pluginManager");
        require("app.MyApp").new():run()
        print("main ending")
end


local fileUtils = Env.fileUtils;


require "logger"
require "download"

-- local localResPath =  fileUtils:getWritablePath() .. "update/"--"download/"..getHotUpdateRelativePath() 
-- fileUtils:addSearchPath(localResPath  ,true); 

--DownLoadManager.registerStaticRelativePath(getHotUpdateRelativePath());

addSearchPath2 = function(path)    
    fileUtils:addSearchPath(localResPath .. path,true);       
    fileUtils:addSearchPath(path,true); 
end
--强制更新
-- local HAS_NEW_UMENG_VERSION =  chkIsUpdate();

local function EnterLogin(...) 
    print("main begin")
    -- addSearchPath2("src")
    -- addSearchPath2("res")
    -- addSearchPath2("res/libs")
    -- addSearchPath2("res/new_ui") 
    -- addSearchPath2("res/new_animation") 

local path = fileUtils:getSearchPaths();
for i=1,#path   do
print("path***"..path[i])
end

     -- if(HAS_NEW_UMENG_VERSION) then 
     --     forceUpdate()
     -- elseif USE_UPDATE then  
     --     post_zip()
     -- else
         gotoLogin()
     -- end

--     if USE_UPDATE then  
--         post_zip()
--     else
--         gotoLogin()
--         --forceUpdate()
--     end
end


EnterLogin()
--xpcall(EnterLogin(), function() print(debug.traceback()) end, 33)
