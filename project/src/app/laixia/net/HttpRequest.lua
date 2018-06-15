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
    if type(array) ~= "table" then
        print("Error in json decode")
        return
    end
    for _,v in pairs(array) do
        http.ServerUrl[v.key] = v.url
    end
end
 
--[[
    HTTP请求
        @parme string key       请求网址的key
        @parme table  content   请求数据和类型
                        content.data   table      请求传递的参数
                        content.type   string     请求类型 get post
        @parme fun    cb        回调函数   
]]
http.request = function(key, content, cb)
    if type(key) ~= "string" or type(content) ~= "table" or type(cb) ~= "function"  then
        print("http请求参数错误")
        local data = {}
        data.dm_error = 501
        data.error_msg = "http请求参数错误"
        cb(data)
        return
    end
    local url = ""
    if device.platform == "android" then
        dump(APP_ACTIVITY, "APP_ACTIVITY")
        dump(key, "key")
        local ok, result = luaj.callStaticMethod(APP_ACTIVITY, "getUrl", {key}, "(Ljava/lang/String;)Ljava/lang/String;")
        if ok then url = result end
        dump(url, "返回的URL")
    elseif device.platform == "ios" then
        local ok, result = luaoc.callStaticMethod("IKCRLXBridgeManager", "getUrl", {key=key})
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
        print(content.type .. "url格式错误")
        local data = {}
        data.dm_error = 501
        data.error_msg = "url格式错误"
        cb(data)
        return
    end
    local xhr = cc.XMLHttpRequest:new()
    xhr:registerScriptHandler(function() 
        local res = xhr.response
        if type(res) ~= "string" then
            print(content.type .. "请求返回参数错误")
            local data = {}
            data.dm_error = 501
            data.error_msg = "请求返回参数错误"
            cb(data)
            return
        end
        local data = json.decode(res)
        dump(data, "HTTP返回")
        if data then
            if data.dm_error == 604 then
                --账号相同
                print("账号异常,请检查账号!")
                local scene = cc.Director:getInstance():getRunningScene()
                if type(scene.popUpTips) == "function" then
                    scene:popUpTips("账号异常,请检查账号!")
                    app:exit()
                end
            else
                cb(data)
            end
        end
    end)
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    if not content.type or not content.data then
        print("参数类型或数据错误")
        local data = {}
        data.dm_error = 501
        data.error_msg = "参数类型或数据错误"
        cb(data)
        return
    end
    if content.type == "get" then
        local params = ""
        for k,v in pairs(content.data) do
            params = params ..k .. "=" .. v .."&"
        end
       -- params = params .. laixia.LocalPlayercfg.LaixiaTokenID
        params = params .. "11"
        -- params = string.sub(params,0,string.len(params)-1)
        local xhrURL = url .. "?" .. params
        xhr:open("GET", xhrURL, true)
        xhr:send()
    elseif content.type == "post" then
        local data = {}
        for k,v in pairs(content.data) do
            data[k] = v
        end
        if type(content.postData) == "table" then
            local urlStr = "?"
            local url_index = 1
            local url_total = table.nums(content.postData)
            for k,v in pairs(content.postData) do
                urlStr =  urlStr .. k .. "=" .. v
                url_index = url_index + 1
                if url_index <= url_total then
                    urlStr = urlStr .. "&"
                end
            end
            url  = url ..urlStr
        end
        url = url .. "&"..laixia.LocalPlayercfg.LaixiaTokenID
        local jsonStr = json.encode(data)
        xhr:open("POST", url, true)
        xhr:send(jsonStr)
    end
    dump(url)
end

--[[
    send请求
        @parme name 请求的key名称
        @parme data 请求的json表
        @parme string name       请求网址的key
        @parme table  content   请求数据和类型
                        content.data   table      请求传递的参数
]]
http.send = function(name, content)
    dump(content,"send--content")
    
    if type(name) ~= "string" or type(content) ~= "table" or type(content.data) ~= "table" then
        return
    end
    if device.platform == "android" then
        -- 测试用例 name = "call_point"  data = {type = "0", chip = 1, table_id = "1234556", pid = 16678751, room_id = 123}
        local jsonStr = json.encode(content.data)
        
        luaj.callStaticMethod(APP_ACTIVITY, "send", 
            {
                name,
                jsonStr
            }
        , "(Ljava/lang/String;Ljava/lang/String;)V")
    elseif device.platform == "ios" then
        -- 测试用例 name = "call_point"  data = {type = "0", chip = 1, table_id = "1234556", pid = 16678751, room_id = 123}
        local jsonStr = json.encode(content.data)
        luaoc.callStaticMethod("IKCRLXBridgeManager", "send", 
            {
                key = name,
                params = jsonStr   
            }
        )
    elseif device.platform == "windows" then

    end
end

return http