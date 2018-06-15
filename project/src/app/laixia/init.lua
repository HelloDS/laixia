
local utils  = import("framework.cc.utils.init")

cc.utils = cc.utils or {}

xzmj = xzmj or { }

local winSize = cc.Director:getInstance():getWinSize()

xzmj.winSize = winSize

-- 事件派发
ObjectEventDispatch = import(".public.MonitorSystem")

xzmj.Layout = import(".tools.Layout")     --调取csb工具方法

xzmj.soundTools = import(".tools.SoundTools") --声音工具

xzmj.status = 'ddz'; -- > 默认状态

xzmj.Loader = import(".tools.IBaseLoader")


xzmj.ani = import(".animation.init")

xzmj.json = import(".tools.dkjson")

xzmj.evt = import(".public.MonitorID")

xzmj.MainCommand = import(".ui.MainCommand")

xzmj.http = import(".net.Http");

xzmj.subApps = {};

xzmj.logPacketID = logPacket

--音效管理 add by feng
xzmj.soundManager   = require("app.laixia.Manager.Sound.SoundManager")

xzmj.soundEnum      = require("app.laixia.Manager.Sound.SoundEnum")

xzmj.UserManager    = require("app.laixia.Model.UserManager").new()
   
xzmj.Animg = require "app.laixia.animation.CocosAnimManager"

xzmj.Animg:load()






