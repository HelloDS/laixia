
local CURRENT_MODULE_NAME = ...

require("cocos.init")
require("framework.init")


--[[ 加载游戏配置文件  里面有全局变量 xzmj = {} ]]
require("app.laixia.init")
require("app.laixia.public.CommonInterFace")


local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    self:RegisterGameModel()
    self:registerClass()
    self:init();
    self:enterScene("MainScene")
end


--[[
    注册游戏model模块
]]--
function MyApp:RegisterGameModel( ... )
    
    xzmj.Model = xzmj.Model or {}

    xzmj.Model.GameLayerModel = require("app.laixia.Model.GameLayerModel")

    xzmj.Model.MatchEnrollModel = require("app.laixia.Model.MatchEnrollModel")

    xzmj.Model.PlayGroundModle = require("app.laixia.Model.PlayGroundModle")

    xzmj.Model.PokerDeskModel = require("app.laixia.Model.PokerDeskModel")

    xzmj.Model.talklayerModel = require("app.laixia.Model.talklayerModel")

    xzmj.Model.TaskLayerModel = require("app.laixia.Model.TaskLayerModel")

end


function MyApp:init()
    xzmj.resLoader = import(".laixia.public.ResLoader", CURRENT_MODULE_NAME)
        :init()
        :prepareForLoad()
end

--[[
    暂时没用
]]--
function MyApp:registerClass()
    local o = {}
    local recursion; function recursion(_o)
        setmetatable(_o, {
            __index = function(t, k)
                local path = rawget(t,"__path")
                local t1 = nil
                if string.byte(k,1) == string.byte(string.upper(k),1) then
                    local className
                     if path then
                        className = path.."."..k
                    else
                        className = k
                    end
                    -- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>className",className)
                    t1 = require(className)
                    rawset(t, k, t1)
                else
                    t1 = {}
                    if path then
                        t1.__path = path ..".".. k
                    else
                        t1.__path = k
                    end
                    -- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>path",t1.__path)
                    rawset(t, k, t1)
                    recursion(_o[k])
                end
                return t1
            end,

            __newindex = function(_, k, v)
                -- only read
            end,
        })
    end

    recursion(o)
    local A = {}
    A = O;
end
---- 在后台
function MyApp:onEnterBackground()
    MyApp.super.onEnterBackground(self);
end

function MyApp:onEnterForeground()
    MyApp.super.onEnterForeground(self);
end

function MyApp:resume()
    print('MyApp:resume');
end

function MyApp:restart()
end

return MyApp
