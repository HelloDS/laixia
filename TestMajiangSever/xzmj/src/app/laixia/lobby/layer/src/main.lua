
--[[
    此接口是c++调用的lua启动接口
            1.此处处理文件路径加载
            2.报错异常处理
]]

--添加本地目录
cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("src/app")
cc.FileUtils:getInstance():addSearchPath("src/app/laixia")
cc.FileUtils:getInstance():addSearchPath("res")
cc.FileUtils:getInstance():addSearchPath("res/new_ui")

--添加更新目录到searchpath
local pathToSave = cc.FileUtils:getInstance():getWritablePath() .. "upd"
cc.FileUtils:getInstance():addSearchPath(pathToSave .. "/src",true)
cc.FileUtils:getInstance():addSearchPath(pathToSave .. "/src/app",true)
cc.FileUtils:getInstance():addSearchPath(pathToSave .. "/src/app/laixia",true)
cc.FileUtils:getInstance():addSearchPath(pathToSave .. "/res", true)


package.path = package.path .. "/src;" .. "/src/app"
print = release_print

--屏蔽c++多余的日志
cc.FileUtils:getInstance():setPopupNotify(false)

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
local function main()
    require("app.MyApp").new():run()
end

local status,msg = xpcall(main,__G__TRACKBACK__)
if not status then
    print(msg)
end
