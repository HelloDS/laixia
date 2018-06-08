

--[[
    管理器里面用到
]]--


local Layout = {}

function Layout.loadScene(path)
    local ret = cc.CSLoader:createNode(path)
    ret:setContentSize(display.size)
    ccui.Helper:doLayout(ret)
    ret:setTag(-1)
    return ret
end

function Layout.loadLayer(path)
    local ret = cc.CSLoader:createNode(path)
    ret:setContentSize(display.size)
    ccui.Helper:doLayout(ret)
    ret:setTag(-1)
    if path == "new_ui\BroadcastWindow.csb" then
        ret:setGlobalZOrder(100000)
    end
    return ret
end

function Layout.loadNode(path)
    local ret = cc.CSLoader:createNode(path)
    ret:setTag(-1)
    return ret
end

function Layout.CreateItemNode( delete )
    local n = require "app.laixia.ui.layer.GameTips.ItemNode"
    local node = n.CreateItemNode( delete )
    return node
end


return Layout