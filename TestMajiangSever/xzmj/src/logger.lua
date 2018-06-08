

--因为打印一开始的消息，这个在启动 cocos 和quick 框架之前就需要调用哪个log，所以这个需要拿出来

local Env = APP_ENV;
local targetPlatform = Env.platform;
local fileUtils = Env.fileUtils;

-- redirect Print Func

function babe_tostring(...)
    local num = select("#", ...);
    local args = { ...};
    local outs = { };
    for i = 1, num do
        if i > 1 then
            outs[#outs + 1] = "\t";
        end
        outs[#outs + 1] = tostring(args[i]);
    end
    return table.concat(outs);
end


local babe_print = print;
local babe_output = function(...)
    babe_print(...);
    if decoda_output ~= nil then
        local str = babe_tostring(...);
        decoda_output(str);
    end
end

local sys_print = babe_output



LL_PRINT = 0;
LL_VERBOSE = 1;
LL_Game = 2;
LL_WARNNING  = 3;
LL_ERROR = 4;

LL_PACKETID =7;


local logFile = nil;

function logFilePrint(var)
    if(logFile == nil) then
       local path = fileUtils:getWritablePath()
       local logFileName = path.."Laixia_log_"..tostring(os.date("%y-%m-%d-%H-%M-%S"))..".log";
       logFile= io.open(logFileName,"w");
       logFile:setvbuf("no") -- 输出
    end 
    logFile:write(var.."\n");
end 

function CloseLogFile()
    if(nil ~= logFile) then
        io.close(logFile)
        logFile = nil;
    end 
end 

local socket = require("socket");

function baseLog(args,contentfix)    
    contentfix = contentfix or"unknown";
    
    local t = socket:gettime();
    local t2 = os.time();
    local str = string.sub(tostring(t-t2),3,5);

    local prefix = "[Log]"..contentfix.."["..os.date()..":"..str.."]";   
    local val = prefix
    if(type(args) =='table') then
        for _,v in ipairs(args) do
            val = val ..tostring(v);
        end
    else 
        val = val..args    
        --var = val.."unimplement parse"..type(args);
    end 
    sys_print(val);
    if targetPlatform == 3 then -- android
        CPPLog:info(tostring(val))       
    end   
    if(targetPlatform == 0) then-- windows
        logFilePrint(val);
    end 
end 

function logDump(...)
   if(DUMP_ENABLED) then
        local args = {...};
        baseLog(args,"[Dump]")
    end 
end 
local key = ""
function PrintTable(table , level)
  level = level or 1
  local indent = ""
  for i = 1, level do
    indent = indent.."  "
  end

  if key ~= "" then
    print(indent..key.." ".."=".." ".."{")
  else
    print(indent .. "{")
  end

  key = ""
  for k,v in pairs(table) do
     if type(v) == "table" then
        key = k
        PrintTable(v, level + 1)
     else
        local content = string.format("%s%s = %s", indent .. "  ",tostring(k), tostring(v))
      print(content)  
      end
  end
  print(indent .. "}")

end
function logPrint(...)
   if(LOG_LEVEL<= LL_PRINT) then
        local args = {...};
        baseLog(args,"[LogPrint]")
    end 
end 

function logVerbose(...)
    if(LOG_LEVEL<= LL_VERBOSE) then
        local args = {...};
        baseLog(args,"[Verb]")
    end 
end 

function logGame(...)
    if(LOG_LEVEL<= LL_Game) then
        local args = {...};
        baseLog(args,"[Game]")
    end         
end 



function logWarning(...)
    if(LOG_LEVEL<=LL_WARNNING) then
        local args = {...};
        baseLog(args,"[Warning]")
    end         
end 

function logError(...)
    if(LOG_LEVEL<= LL_ERROR) then
        local args = {...};
        baseLog(args,"[Error]")
    end         
end 

function logPacket(...)
    if(LOG_LEVEL<= LL_PACKETID) then
        local args = {...};
        baseLog(args,"[packet]")
    end         
end 
print = logGame;
print = release_print

--endregion
