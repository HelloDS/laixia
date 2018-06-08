
local utils  = import("framework.cc.utils.init")

cc.utils = cc.utils or {}
cc.utils.ByteArray = utils.ByteArray
cc.utils.ByteArrayVarint = utils.ByteArrayVarint
cc.utils.Gettext = utils.Gettext

ObjectEventDispatch = import(".public.MonitorSystem")

-- laixia = laixia or { }

-- laixia.config = import(".config.LaixiaConfig")  -- 配置
-- laixia.kconfig = import(".config.KeepConfig")  --
-- laixiaddz.soundcfg = import(".config.LaixiaSoundConfig")

-- laixia.LocalPlayercfg = import(".public.LocalPlayer") -- 本地数据

-- laixia.utilscfg = import("..common.tools.init")
-- laixia.UItools = import("..common.tools.UITools")     --公共的工具方法


-- laixiaddz.Layout = import("..common.tools.Layout")     --调取csb工具方法

-- laixiaddz.soundTools = import("..common.tools.SoundTools") --声音工具
-- laixia.EffectAni = import(".ui.EffectAni.EffectAni")
-- laixia.EffectDict = import(".ui.EffectAni.EffectDict")
-- laixia.status = 'ddz'; -- > 默认状态


-- laixia.logVerbose =  logVerbose   -- 打印详单
-- laixiaddz.loggame =     logGame      --laixiaddz.loggame

-- laixia.logWarnning = logWarning   --src.logger.logWarnning
-- laixia.logError =    logError     --src.logger.logError
-- laixia.log =         logVerbose
-- laixia.logPacketID = logPacket


-- local laixiaDump = function (value, desciption, nesting)
--     if type(nesting) ~= "number" then nesting = 5 end

--     local lookupTable = {}
--     local result = {}

--     local function _v(v)
--         if type(v) == "string" then
--             v = "\"" .. v .. "\""
--         end
--         return tostring(v)
--     end

--     local traceback = string.split(debug.traceback("", 2), "\n")
--     logDump("dump from: " .. string.trim(traceback[3]));

--     local function _dump(value, desciption, indent, nest, keylen)
--         desciption = desciption or "<var>"
--         spc = ""
--         if type(keylen) == "number" then
--             spc = string.rep(" ", keylen - string.len(_v(desciption)))
--         end
--         if type(value) ~= "table" then
--             result[#result +1 ] = string.format("%s%s%s = %s", indent, _v(desciption), spc, _v(value))
--         elseif lookupTable[value] then
--             result[#result +1 ] = string.format("%s%s%s = *REF*", indent, desciption, spc)
--         else
--             lookupTable[value] = true
--             if nest > nesting then
--                 result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, desciption)
--             else
--                 result[#result +1 ] = string.format("%s%s = {", indent, _v(desciption))
--                 local indent2 = indent.."    "
--                 local keys = {}
--                 local keylen = 0
--                 local values = {}
--                 for k, v in pairs(value) do
--                     keys[#keys + 1] = k
--                     local vk = _v(k)
--                     local vkl = string.len(vk)
--                     if vkl > keylen then keylen = vkl end
--                     values[k] = v
--                 end
--                 table.sort(keys, function(a, b)
--                     if type(a) == "number" and type(b) == "number" then
--                         return a < b
--                     else
--                         return tostring(a) < tostring(b)
--                     end
--                 end)
--                 for i, k in ipairs(keys) do
--                     _dump(values[k], k, indent2, nest + 1, keylen)
--                 end
--                 result[#result +1] = string.format("%s}", indent)
--             end
--         end
--     end
--     _dump(value, desciption, "- ", 1)

--     for i, line in ipairs(result) do
--         logDump(line);
--     end
-- end

-- if LOG_LEVEL <= 2 then
--     dumpGameData = laixiaDump
-- else
--     dumpGameData = function(...) end
-- end

-- if LOG_LEVEL <= 0 then
-- --    dump = laixiaDump
-- else
--     dump = function(...) end
-- end


-- if (DUMP_ENABLED) then
--     laixia.dump = dump
-- else
--     laixia.dump = function(...) end
-- end

-- laixia.Loader = import("..common.tools.IBaseLoader")


laixiaddz.JsonTxtData = import(".data.init");
laixia.net = import(".net.init")
laixia.Queue = import(".net.Queue");
-- laixiaddz.ui = import(".ui.Init")
-- laixiaddz.ani = import(".animation.init")

laixia.subApps = {};

function laixia.init()

end


function laixia:addSubApp(subApp)
    if(subApp ~= nil ) then
        self.subApps[subApp.app_name] = subApp;
    end
    return subApp;
end


function laixia:removeSubApp(arg)
    if(type(arg) == 'table') then
        self.subApps[arg['app_name']] = nil;
    elseif(type(arg) == 'string')then
        self.subApps[arg] = nil;
    end
end

function table.removeItem(list, item, removeAll)
    local rmCount = 0
    for i = 1, #list do
        if list[i - rmCount] == item then
            table.remove(list, i - rmCount)
            if removeAll then
                rmCount = rmCount + 1
            else
                break
            end
        end
    end
end

