
--[[
    兼容原包流，转换json所需的数据
]]

local Packet = class("Packet")

function Packet:ctor(name, key)
    self.name           = name
    self.key            = key
    self.data           = {}
    self.type           = ""
    --post请求带有的url参数
    self.postData       = {}
end

function Packet:setReqType(param)
    if type(param) == "string" then
        self.type = param
    end
end

function Packet:setValue(key, value)
    if type(key) == "string" then
        self.data[key] = value
    end
end

function Packet:setPostData(key, value)
    if type(key) == "string" then
        self.postData[key] = value
    end
end

return Packet