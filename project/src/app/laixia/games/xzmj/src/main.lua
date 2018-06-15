



function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")


    print("errorMessage============="..errorMessage)
    -- 游戏报错弹出提示
    if xzmj and xzmj.debuger then
        local message = debug.traceback(errorMessage, 3)
        xzmj.debuger:showBugMesg("lua error:\n\t" .. message)
    end


    --- 游戏错误日志上传
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

package.path = package.path .. ";src/"
cc.FileUtils:getInstance():setPopupNotify(false)
            
require "config"
require("cocos.init")
require("framework.init")
math.randomseed(os.time())


local fileUtils = cc.FileUtils:getInstance()
local addSearchPath2 = function(path)    
    fileUtils:addSearchPath(path,true)
end

local sharedDirector         = cc.Director:getInstance()
local glview = sharedDirector:getOpenGLView()
glview:setDesignResolutionSize(CONFIG_SCREEN_WIDTH, CONFIG_SCREEN_HEIGHT, cc.ResolutionPolicy.SHOW_ALL)

addSearchPath2("src")
addSearchPath2("res")
addSearchPath2("res/libs")
addSearchPath2("res/new_ui") 
addSearchPath2("res/new_animation") 

require("app.scenes.MainScene")
