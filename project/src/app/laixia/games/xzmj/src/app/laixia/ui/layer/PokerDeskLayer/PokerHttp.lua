

local PokerHttp = {}


function PokerHttp:SendOperation( val,operation )
    if val == nil or operation == nil then
        print("SendOperation==error==nil")
        return
    end
    local tb = {
            ["msgid"] = 1002,
            ["uid"] = xzmj.Model.GameLayerModel:GetUid(),
            ["card"]  = {val},
            ["operation"] = operation,
            ["room_id"] = "0",
            ["table_id"] = "0",
    }
    xzmj.net.CloudSocket:Send( xzmj.json.encode(tb) )
    
end 



--[[ valtb = {} ]]
function PokerHttp:SendHsz( valtb )
    if valtb == nil then
        return
    end
    local tb = {
            ["msgid"] = 1002,
            ["uid"] = xzmj.Model.GameLayerModel:GetUid(),
            ["card"]  = valtb,
            ["operation"] = 11,
            ["room_id"] = "0",
            ["table_id"] = "0",
    }
    xzmj.net.CloudSocket:Send( xzmj.json.encode(tb)  )
end 



--[[
    ev 事件名字      string
    mctb 附带参数    table数组格式非键值对格式   {["gid"] = "gid",["gid"] = "gid" }
]]--
function PokerHttp:Send( ev, mctb, fun )

    local URL = string.format("http://127.0.0.1:9401")
    local tb = {
        ["b"] = {["ev"] = ev },
        ["liveid"] = "1501748382962273",
        ["gid"] = "gid",
        ["mc"] = { mctb },
        ["userid"] = 16678751,
        ["server_ip"] =  "10.111.7.213",
    }
    local tb1 = xzmj.json.encode(tb)
    xzmj.net.http.SetCode( xzmj.net.http.new( URL,tb1 )):sendPost(function ( code,data )
        if d1 == 200 then
           if fun then
            fun( data )
           end
        end            
    end)

end


return PokerHttp

