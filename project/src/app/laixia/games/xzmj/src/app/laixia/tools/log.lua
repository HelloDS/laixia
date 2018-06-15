--[[--
打印UserData & table
]]
print_r = function(o, ret, indent)
    local r = ""
    local t = type(o)

    if t == "table" then
        if not indent then indent = 0 end
        r = "{"
        local first = true

        for k, v in pairs(o) do
            r = r .. (first and "" or ", ") .. print_r(k, true, indent + 1).. "=" .. print_r(v, true, indent + 1)
            if first then first = false end
        end
        r = r .. "}\n"
    elseif t == "function" then r = "funciton"
    elseif t == "string" then   r = o
    elseif t == "boolean" then  r = o and "true" or "false"
    elseif t == "nil" then      r = t
    elseif t == "userdata" then
        t = tolua.type(o)
        if t == "CCPoint" then r = "{x="..o.x..",y="..o.y.."}"
        elseif t == "CCSize" then r = "{width="..o.width..",height="..o.height.."}"
        elseif t == "CCRect" then r = "{origin="..print_r(o.origin, true)..",size="..print_r(o.size, true).."}"
        else r = t
        end
    else r = r .. o
    end

    if ret then return r else 
        print("------------------ [print_r] Start---------------------")
        print(r) 
        print("------------------ [print_r] End  ---------------------")
    end
end


--[[--
特殊打印语句，私人订制
clog("....")
]]
function clog(...)
    print("[MonCoder]", ...)
end

--[[--
Lua 格式化打印 table 函数
use: http://www.laoxieit.com/coding/59.html
]]
function print_lua_table (lua_table)
    indent = indent or 0
    for k, v in pairs(lua_table) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        local szSuffix = ""
        if type(v) == "table" then
            szSuffix = "{"
        end
        local szPrefix = string.rep("    ", indent)
        formatting = szPrefix.."["..k.."]".." = "..szSuffix
        if type(v) == "table" then
            print(formatting)
            print_lua_table(v, indent + 1)
            print(szPrefix.."},")
        else
            local szValue = ""
            if type(v) == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end
            print(formatting..szValue..",")
        end
    end
end


--[[
    何强增加打印table数据
]]--
function printTb( ... )
  print("------------开始打印table数据-------------")
  print_lua_table(...)
  print("------------结束打印table数据-------------")

end





---
-- @function: 打印table的内容，递归
-- @param: tbl 要打印的table
-- @param: level 递归的层数，默认不用传值进来
-- @param: filteDefault 是否过滤打印构造函数，默认为是
-- @return: return
function PrintTable( tbl , level, filteDefault)
  local msg = ""
  filteDefault = filteDefault or true --默认过滤关键字（DeleteMe, _class_type）
  level = level or 1
  local indent_str = ""
  for i = 1, level do
    indent_str = indent_str.."  "
  end

  print(indent_str .. "{")
  for k,v in pairs(tbl) do
    if filteDefault then
      if k ~= "_class_type" and k ~= "DeleteMe" then
        local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
        print(item_str)
        if type(v) == "table" then
          PrintTable(v, level + 1)
        end
      end
    else
      local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
      print(item_str)
      if type(v) == "table" then
        PrintTable(v, level + 1)
      end
    end
  end
  print(indent_str .. "}")

end

local x = {a = 20,20,60,{a = {a = 1,2323},2323}}
PrintTable(x)