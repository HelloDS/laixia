local tinsert = table.insert; --
local strlen = string.len;
local strgsub = string.gsub;
local tostring = tostring;

local fileUtils = cc.FileUtils:getInstance();
local laixiaddz = laixiaddz;

local function _query(dbTbl,key,value)
    for _,v in pairs(dbTbl) do
        if(v[key] == value) then
            return v;   -- return 这个表
        end
    end
end

local data = {
    buf = {},
    defaultLoad = function(filePath)         --读取并且解析json文件
        --print(filePath);
        local rawFileData = fileUtils:getStringFromFile(filePath);
        if(strlen(rawFileData) == 0) then
            assert(false,"load file Error on loading from "..filePath);
            return nil;
        end
        local json = json or require("framework.json");
        return json.decode(rawFileData);
    end,
    --loaderFuncT = {},
    textLoader = function (filePath)

        local function rep_s_rcur(s,pat,rep)
            local s,n= strgsub(s,pat,rep);
            --print(n);
            if(n ~= 0) then
                return rep_s_rcur(s,pat,rep);
            end
            return s
        end

        local function split(str, reps)
            local resultStrsList = {};
            strgsub(str, '([^' .. reps ..']+)', function(w)table.insert(resultStrsList, w) end );
            return resultStrsList;
        end
        local rawFileData = fileUtils:getStringFromFile(filePath);
        if(strlen(rawFileData) == 0) then
            assert(false,"load file Error on loading from "..filePath);
            return nil;
        end
        local lineStr = split(rawFileData, '\n\r');


        local keys = split(lineStr[1],"\t"); -- 第一行是key
        local lines = #lineStr;
        local vdLineStart = 2; -- 第二行开始  --validDataLineStart;
        local buf = {};
        for i = vdLineStart,lines do
            local tmpStr ,num = string.gsub(lineStr[i],'\\n','\n');
            --print(tmpStr);
            local content = split(rep_s_rcur(tmpStr,'\t\t','\t \t'), "\t");

            --dump(content);
            local t = {};
            for j = 1,#keys do
                --t[keys[j]] = content[j] ~=' ' and content[j] or nil;
                local v = tonumber(content[j]) or content[j];
                t[keys[j]] = (v~=' ' and v or nil);
            end
            tinsert(buf,t)
        end
        --dump(buf,'buf');
        return buf;
    end,
--dba = {},
};


function data:init(...)
    self:onInit();

end

function data:load(dataTable,track)
    --也许用ipairs 比较好，效率更高一点吧
    for _,v in pairs(dataTable) do
        local metakey = v[1];
        local path = v[2];
        local loadFunc = v[3] or self.defaultLoad; -- or nil
        local key = self:dbmkey(metakey);     --self.prefix_tag..metakey; --;
        if(track ~= nil)   then
            track(path); -->
        end
        self.buf[key] =  loadFunc(path) ; --
    end
end

function data:dbmkey(metakey)
    --return self.prefix_tag.."&"..metakey;
    return metakey;
end

function data:loadFromLoaderT(metakey)
    print("loaderFromLoaderT "..metakey);
    for i,v in ipairs (self.resLoader_t) do
        --local rKey = v[1];
        --local rValue = v[2];
        local rloadFunc = v[3] or self.defaultLoad;
        if(v[1] == metakey) then
            self.buf[metakey] = rloadFunc(v[2]);
            return self.buf[metakey];
        end
    end
    return nil;
end

function data:queryFuncTFromLoaderT(metakey)
    for i,v in ipairs (self.resLoader_t) do

        if(v[1] == metakey) then
            return v[4];
        end
    end
    return nil;
end

function data:queryTable(metakey)
    local key   = self:dbmkey(metakey);
    local function copy_func_r (dest,src)
        for k,v in pairs(src) do
            dest[k] = v;
        end
    end
    --local tbl = self.buf[key];
    local t = {
        buf = self.buf[key] or self:loadFromLoaderT(key),
        query = function(dt,dtkey,dtv)
            assert(dtv~= nil ,"queryError");
            for _,v in pairs(dt.buf) do
                --if(tostring(v[dtkey]) == tostring(dtv)) then
                if(v[dtkey] == dtv) then
                    return v;   -- return 这个表
                end
            end
            return nil; --
        end,
    }
    local queryfunct = self:queryFuncTFromLoaderT(key)
    if(queryfunct ~= nil) then
        copy_func_r(t,queryfunct);
    end
    return t;
end


function data.query(arg1,arg2,arg3,arg4)
    --query(tbl,key,value);
    if(type(arg2) == "string") then--> using tbm:query("arg2",arg3,arg4);
        return _query(arg1,arg2,arg3);
    elseif(type(arg2) == 'table')then
        return _query(arg2,arg3,arg4);
    end
end

function data:destroy()
    print("data:destroy");
end

return data;   -- 这个不是单一类

--endregion
