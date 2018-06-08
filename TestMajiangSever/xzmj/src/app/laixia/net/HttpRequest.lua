--[[
    Http请求接口
]]
local http = {}

--[[
    windows通用测试参数
]]
http.ServerUrl = {}
http.ServerUrl["user_info"] = "http://47.93.102.58:9202/api/lxg/bagpack/use_user_bagpack"
http.ServerUrl["test_get"] = "http://47.93.102.58:9203/shop/get_shop_item?cv=1.3.20_Android"
http.ServerUrl["test_post"] = "http://47.93.102.58:9203/shop/use_shop_item"
local testUrl = cc.FileUtils:getInstance():getStringFromFile("res/testUrl.json")
if type(testUrl) == "string" then
    local array = json.decode(testUrl)
    for _,v in pairs(array) do
        http.ServerUrl[v.key] = v.url
    end
end
 
--[[
    HTTP请求
        @parme string key       请求网址的key
        @parme string uid       用户ID
        @parme string reqType   请求类型 get post
        @parme fun    cb        回调函数   
]]
http.request = function(key, uid, reqType, cb)
    if type(key) ~= "string" or type(uid) ~= "string" or type(cb) ~= "function"  then
        print("http请求参数错误")
        return
    end
    local url = ""
    if device.platform == "android" then
        local ok, result = luaj.callStaticMethod("AppActivity", "getUrl", http.ServerUrl[1], "(Ljava/lang/String;)Ljava/lang/String;")
        if ok then url = result end
    elseif device.platform == "ios" then
        local ok, result = luaoc.callStaticMethod("IKCRBridgeManager", "getUrl", http.ServerUrl[1])
        if ok then url = result end
    elseif device.platform == "windows" then
        for k,v in pairs(http.ServerUrl) do
            if key == k then
                url = v
                break
            end 
        end
    end
    if type(url) ~= "string" or string.sub(url, 1, 4) ~= "http" then
        print("url格式错误")
        return
    end
    local xhr = cc.XMLHttpRequest:new()
    xhr:registerScriptHandler(function() 
        local res = xhr.response
        if type(res) ~= "string" then
            print("请求返回参数错误")
            return
        end
        local data = json.decode(res)
        cb(data)
    end)
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    if reqType == "get" then
        local xhrURL = string.format("%s?uid=%s", url, uid)
        xhr:open("GET", xhrURL, true)
        xhr:send()
    elseif reqType == "post" then
        xhr:open("POST", url, true)
        xhr:send(uid)
    end
end

--[[
    send请求
        @parme name 请求的key名称
        @parme data 请求的json表
]]
http.send = function(name, data)
    if type(name) ~= "string" or type(data) ~= "table" then
        return
    end
    if device.platform == "android" then
        -- 测试用例 name = "call_point"  data = {type = "0", chip = 1, table_id = "1234556", pid = 16678751, room_id = 123}
        local jsonStr = json.encode(data)
        luaj.callStaticMethod(APP_ACTIVITY, "send", 
            {
                name,
                jsonStr
            }
        , "(Ljava/lang/String;Ljava/lang/String;)V")
    elseif device.platform == "ios" then
        -- 测试用例 name = "call_point"  data = {type = "0", chip = 1, table_id = "1234556", pid = 16678751, room_id = 123}
        local jsonStr = json.encode(data)
        luaoc.callStaticMethod("IKCRBridgeManager", "send", 
            {
                key = name,
                params = jsonStr   
            }
        )
    elseif device.platform == "windows" then

    end
end

--[[
    接收广播消息
]]
function received(event)
    print("444444444-----------")
    dump(event, "Received")
end

--[[
    用户连接"ua"连接成功
]]
function socketDidConnected()
    print("用户连接\"ua\"连接成功")
end

--[[
    用户连接"ua"连接断开或者失败
]]
function socketDidDisconnect()
    print("用户连接\"ua\"连接断开或者失败")
end
--fix me android的java调lua函数命名需改成以上 同步ios

return http