
 laixiaddz = laixiaddz or { }

 laixia.config = import(".config.LaixiaddzConfig")  -- 配置
 laixiaddz.kconfig = import(".config.KeepConfig")  --
 laixiaddz.soundcfg = import(".config.LaixiaddzSoundConfig")

 laixiaddz.LocalPlayercfg = laixia.LocalPlayercfg----import(".public.LocalPlayer") -- 本地数据

 laixiaddz.utilscfg = import(".common.tools.init")
 laixiaddz.UItools = import(".common.tools.UITools")     --公共的工具方法


 laixiaddz.Layout = import(".common.tools.Layout")     --调取csb工具方法

 laixiaddz.soundTools = import(".common.tools.SoundTools") --声音工具
 laixiaddz.EffectAni = import(".ui.EffectAni.EffectAni")
 laixiaddz.EffectDict = import(".ui.EffectAni.EffectDict")
 laixiaddz.status = 'ddz'; -- > 默认状态

import(".public.MonitorID")

 laixiaddz.logVerbose =  logVerbose   -- 打印详单
 laixiaddz.logGame =     logGame      --laixiaddz.logGame
 laixiaddz.loggame =     logGame      --laixiaddz.logGame

 laixiaddz.logWarnning = logWarning   --src.logger.logWarnning
 laixiaddz.logError =    logError     --src.logger.logError
 laixiaddz.log =         logVerbose
 laixiaddz.logPacketID = logPacket

 local laixiaddzDump = function (value, desciption, nesting)
     if type(nesting) ~= "number" then nesting = 5 end

     local lookupTable = {}
     local result = {}

     local function _v(v)
         if type(v) == "string" then
             v = "\"" .. v .. "\""
         end
         return tostring(v)
     end

     local traceback = string.split(debug.traceback("", 2), "\n")
     logDump("dump from: " .. string.trim(traceback[3]));

     local function _dump(value, desciption, indent, nest, keylen)
         desciption = desciption or "<var>"
         spc = ""
         if type(keylen) == "number" then
             spc = string.rep(" ", keylen - string.len(_v(desciption)))
         end
         if type(value) ~= "table" then
             result[#result +1 ] = string.format("%s%s%s = %s", indent, _v(desciption), spc, _v(value))
         elseif lookupTable[value] then
             result[#result +1 ] = string.format("%s%s%s = *REF*", indent, desciption, spc)
         else
             lookupTable[value] = true
             if nest > nesting then
                 result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, desciption)
             else
                 result[#result +1 ] = string.format("%s%s = {", indent, _v(desciption))
                 local indent2 = indent.."    "
                 local keys = {}
                 local keylen = 0
                 local values = {}
                 for k, v in pairs(value) do
                     keys[#keys + 1] = k
                     local vk = _v(k)
                     local vkl = string.len(vk)
                     if vkl > keylen then keylen = vkl end
                     values[k] = v
                 end
                 table.sort(keys, function(a, b)
                     if type(a) == "number" and type(b) == "number" then
                         return a < b
                     else
                         return tostring(a) < tostring(b)
                     end
                 end)
                 for i, k in ipairs(keys) do
                     _dump(values[k], k, indent2, nest + 1, keylen)
                 end
                 result[#result +1] = string.format("%s}", indent)
             end
         end
     end
     _dump(value, desciption, "- ", 1)

     for i, line in ipairs(result) do
         logDump(line);
     end
 end

 if LOG_LEVEL <= 2 then
     dumpGameData = laixiaddzDump
 else
     dumpGameData = function(...) end
 end

 if LOG_LEVEL <= 0 then
 --    dump = laixiaddzDump
 else
     dump = function(...) end
 end


 if (DUMP_ENABLED) then
     laixiaddz.dump = dump
 else
     laixiaddz.dump = function(...) end
 end

 laixiaddz.Loader = import(".common.tools.IBaseLoader")


laixiaddz.JsonTxtData = import(".data.init");
laixiaddz.net = import(".net.Laixia_Net")--require("lobby.net.LaixiaNet")--import(".net.init")
laixiaddz.Packet = import(".net.Packet")
laixiaddz.Queue = import(".net.Queue");
laixiaddz.ui = import(".ui.Init")
laixiaddz.ani = import(".animation.init")

laixiaddz.subApps = {};

function laixiaddz.init()

end


function laixiaddz:addSubApp(subApp)
    if(subApp ~= nil ) then
        self.subApps[subApp.app_name] = subApp;
    end
    return subApp;
end


function laixiaddz:removeSubApp(arg)
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

