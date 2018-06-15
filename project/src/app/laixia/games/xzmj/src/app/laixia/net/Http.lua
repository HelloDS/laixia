

--[[

cc.XMLHTTPREQUEST_RESPONSE_STRING = 0  -- 返回字符串类型
cc.XMLHTTPREQUEST_RESPONSE_ARRAY_BUFFER = 1 -- 返回字节数组类型
cc.XMLHTTPREQUEST_RESPONSE_BLOB   = 2 -- 返回二进制大对象类型
cc.XMLHTTPREQUEST_RESPONSE_DOCUMENT = 3 -- 返回文档对象类型
cc.XMLHTTPREQUEST_RESPONSE_JSON = 4 -- 返回JSON数据类型


]]
 
local Http = class("Http")

local socket = require("socket")
local json = require("framework.json")
local url = nil

-- 请求方法常量
Http.GET = "GET"
Http.POST = "POST"

Http.Request = class("HttpRequest")
Http.Response = class("HttpResponse")

local postdata = nil
local mRequest = nil

-- 提供一个重置url的方法
function Http.seturl()
    local userDefault = cc.UserDefault:getInstance()
end

function Http:ctor(URL,Postdata)
    url = URL
    postdata = Postdata
end

function Http.SetCode(  _Request )
    mRequest = _Request
    return mRequest
end


function Http:setShowLoading(bool)

end

--[[
    onSuccess 回掉函数
]]--
function Http:sendGet(onSuccess)

    local sendTime = socket.gettime()

    -- if self.showLoading then
    --     qy.Event.dispatch(qy.Event.SERVICE_LOADING_SHOW)
    -- end

    -- if qy.DEBUG then
    --     print("url: " .. url)
    --     print("params: " ..qy.json.encode(self.request.params))
    -- end

    local xhr = cc.XMLHttpRequest:new()

    local function onReadyStateChange()
        if false then
            print(self.request.params.m .. "接口请求时间：" .. socket.gettime() - sendTime .. "秒")
        end


        -- if self.showLoading then
        --     qy.Event.dispatch(qy.Event.SERVICE_LOADING_HIDE)
        -- end
        -- qy.Event.dispatch(qy.Event.SCENE_TRANSITION_HIDE)

        if false then
            print("http response: ")
            print("response code: ", xhr.status)
            -- local response = qy.json.decode(xhr.response)
            -- print(" ", qy.json.encode(response))
        end

        if xhr.status == 200 then
            local jdata = json.decode(xhr.response)

            if not jdata.error_code then
                -- 游戏数据 -- 刷新主界面数据
               -- Game:setdata(jdata, self.request.params.m)

                -- 回调数据
                if onSuccess then
                    onSuccess(xhr.status, jdata)
                end
            end
        end

        xhr:unregisterScriptHandler()
    end



    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open("GET", url,true)
    xhr:registerScriptHandler(onReadyStateChange)

    --xhr:send(self.request:getParamsStr())
    xhr:send()
end


function Http:sendPost(onSuccess)

    local sendTime = socket.gettime()
    local xhr = cc.XMLHttpRequest:new()
    local function onReadyStateChange()
        if false then
            print(self.request.params.m .. "接口请求时间：" .. socket.gettime() - sendTime .. "秒")
        end

        if false then
            print("http response: ")
            print("response code: ", xhr.status)
        end

        if xhr.status == 200 then
            local jdata = json.decode(xhr.response)
            if not jdata.error_code then
                -- 回调数据
                if onSuccess then
                    onSuccess(xhr.status,  jdata )
                end
            end
        else
            print( url.. "======请求数据失败")
        end
        xhr:unregisterScriptHandler()
    end
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open("POST", url)
    xhr:registerScriptHandler(onReadyStateChange)
    xhr:send(postdata)
end

return Http
