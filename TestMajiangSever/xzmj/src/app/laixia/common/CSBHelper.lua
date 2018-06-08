--[[
********************************************************
    @date:      2018-3-1
    @author:    zl
    @version:   1.0
    @explain:   用于处理csb加载
        使用方法:
            UI基类:
                local CSBHelper = require("common.src.CSBHelper")
                在ctor构造函数中CSBHelper.load(self)加载即可
            UI派生类:
                XXX.CSB_NAME = "xxx.csb"
                XXX.CSB_CHILD = 
                {
                    ["panel_root"] = {varname = "panel_bottom"},
                    ...
                }
********************************************************
]]

local CSBHelper = class("CSBHelper")

function CSBHelper.load(root)
    local csb = rawget(root.class, "CSB_NAME")
    if csb then
        CSBHelper.createCSB(root,csb)
    end

    local child = rawget(root.class, "CSB_CHILD")
    if csb and child then
        CSBHelper.addChild(root,child)
    end
end

function CSBHelper.createCSB(root,filename)
    if root.csb then
        root.csb:removeSelf() 
        root.csb = nil
    end
    root.csb = cc.CSLoader:createNode(filename)
    root:addChild(root.csb)
end

function CSBHelper.addChild(root,child)
    for nodeName, nodeChild in pairs(child) do
        local node = root.csb
        for name in string.gmatch(nodeName, "[%w_]+") do
            if node then
                node = node:getChildByName(name)
            else
                break
            end
        end
        
        if nodeChild.varname then
            root[nodeChild.varname] = node
        end
        for _, event in ipairs(nodeChild.events or {}) do
            if (root[event.method]) and "function" == type(root[event.method]) then
                if event.event == "touch" then
                    node:addTouchEventListener(handler(root, root[event.method]))
                end
            end
        end
    end
end

return CSBHelper