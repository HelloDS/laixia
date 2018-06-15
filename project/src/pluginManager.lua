local cur_mod = ...;


local function isZipFile(fileName)
    pos1 , pos2 = string.find(fileName,"._zip")
    if pos1 == pos2 then
        return false
    else
        return true
    end
end


local pluginManager = {

      plugins = {
		["lhd"]             = "lobby.ui.LHD.lhd_launch",
        ["niuniu"]          = "lobby.ui.WRNN.wrnn_launch",
        ["fruit"]           = "lobby.ui.Fruit.fruit_lauch",
        ["threecards"]      = "lobby.ui.ThreeCards.tc_launch",
      },

      plugin_file_sets = {        
		["lhd"]             = "cdf/lhd.xml",
        ["niuniu"]              = "cdf/niuniu.xml",
        ["fruit"]              = "cdf/fruit.xml",
        ["threecards"]      = "cdf/threecard.xml",
      },

      plugin_update_status = {

        ["lhd"]             = true,
        ["niuniu"]          = true,
        ["fruit"]          = true,
        ["threecards"]      = true,
      },


      is_loading_plugin = false,
      isSuspend = false;
      is_updateing_idx = nil,
      
    ['_dm'] = nil,
    ['_downloadPath'] = DOWN_URL,
    ['_downloadPath_base'] = DOWN_URL_BASE


}

-- @ pluginID   :string

function pluginManager:loadPlugin(pluginID, descriptorArg)    
    --取得入口的lua文件
    print("pluginManager:loadPlugin ".. pluginID);

    if(self.is_loading_plugin) then
        return false;
    end 
    self.is_loading_plugin = true;
    self.isSuspend = false;
    self.descriptor = descriptorArg;

    local  entryLua =  self:getPluginEntry(pluginID);  --获取入口文件
   
    local  entry_update_statuse = self.plugin_update_status[pluginID];

    local  entry_filesets = self.plugin_file_sets[pluginID];
 
    local function onEnterGame()        
        self.is_updateing_idx = nil;
        self.is_loading_plugin = false;
        local entry = import(entryLua,cur_mod);
        if(entry ~= nil) then
            entry:run()  -- 需要自己实现的接口 
        end 
    end      

    local function onDownload()        
        local descriptor = self.descriptor --显示下载进度
        if(descriptor ~= nil) then
            if(descriptor["loadingbarBg"] ~= nil) then    
                descriptor["loadingbarBg"]:show();
            end       
        end 
                        
        local function onProcess(download_byte,all_byte)      --更新进度 
        
            local descriptor = self.descriptor 
            local percentage = download_byte/all_byte
            print("onProcess "..percentage);     
                        
            local str = string.format("%02.1f",percentage * 100);
            if(descriptor ~= nil) then 
 
                    if(descriptor["loadingbarBg"] ~= nil) then    
                        descriptor["loadingbarBg"]:show();
                    end
                    if(descriptor["loadingbar"] ~= nil) then    
                        descriptor["loadingbar"]:show():setPercentage(percentage*100);
                    end
                    if(descriptor["LoadingNum"] ~= nil) then  
                        local num  = math.modf(tonumber(percentage*100)/1)  
                        descriptor["LoadingNum"]:show():setString(num ..'%');
                    end

            end 
        end

        local function onError()     
            local descriptor = self.descriptor                         

            if self._dm ~= nil then
                self._dm:unregisterLuaListener()
                self._dm:destroy()
                self._dm = nil
            end

            self.is_loading_plugin = false
            self.is_updateing_idx  = nil
        end

        local function onSuccess()
            print("onProcess onSuccess");
            local descriptor = self.descriptor 
            if(descriptor ~= nil) then

                if(descriptor["loadingbarBg"] ~= nil) then    
                    descriptor["loadingbarBg"]:hide();
                end
                if(descriptor["loadingbar"] ~= nil) then    
                    descriptor["loadingbar"]:hide();
                end

            end
            self.is_loading_plugin = false  
            self.is_updateing_idx = nil;
            if(not self.isSuspend) then
                onEnterGame();
            end 
        end

        if(not self.is_updateing_idx) then
            self:registerFunc(onProcess, onSuccess, onError);
            local downloads = { }    
            downloads[entry_filesets] = entry_filesets;
            self:startDownload(downloads, self._onSuccess)
        end
    end

    if(entry_update_statuse) then
         if USE_UPDATE then   
           onDownload() 
         else
            onEnterGame()
         end

    else
        onEnterGame();
    end
       
    return true                
end


function pluginManager:getPluginEntry(pluginID)
    print("pluginManager:getPluginEntry "..tostring(pluginID));
  
    return self.plugins[pluginID] ;
end



function pluginManager:registerFunc(onProcess, onSuccess, onError)
    self._onProcess = onProcess
    self._onSuccess = onSuccess
    self._onError = onError
end

--开始下载
function pluginManager:startDownload(downloads,onDownFinish)
    if self._dm == nil then
        self._dm = DownLoadManager:new()
        local url = self._downloadPath        
        local urlbase = self._downloadPath_base;

        local urls = {}
        table.insert(urls, url)
        table.insert(urls, url)        
        table.insert(urls, urlbase) 
        table.insert(urls, urlbase) 
        self._dm:initWithData(urls,1,false)
    end

    self._onDownloads =  downloads
    self._onDownFinish = onDownFinish

    local function onFinish(work_state, type, name, error_no, download_byte, all_byte)
        self:onFinish(work_state, type, name, error_no, download_byte, all_byte)
    end
    self._dm:unregisterLuaListener()
    self._dm:registerLuaListener(onFinish)

    for k,v in pairs(downloads) do

        if isZipFile(v) then
            self._dm:post_desire_pkg(v, e_priority_exclusive, "", nil, nil)
        else
            self._dm:post_desire_cdf(v, e_priority_exclusive, "", e_cdf_loadtype_load_cascade, e_zip_none, nil, nil)
        end
    end

    self._isDownFail = false
    self._isDownFinish = false

    self._entryId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()self:update()end, 0, false)

end


function pluginManager:onFinish(work_state, type, name, error_no, download_byte, all_byte)
    print("*****************************name = "..name .." error_no " ..error_no.."*******************************\n");
    if error_no ~= 0 then
        for k,v in pairs(self._onDownloads) do
          if isZipFile(v)  == false then
                cc.FileUtils:getInstance():removeFile(localResPath .. v)
                cc.FileUtils:getInstance():removeFile(localResPath .. v .. '.temp') 
                cc.FileUtils:getInstance():removeFile(localResPath .. v .. '.hash.real')            
            end 
        end
        print("_isDownFail error = "..error_no.."*******************************\n");
        self._isDownFail = true        
        return
    end

    if e_work_state_checking == work_state then
        print("*****************************work_state = e_work_state_checking*******************************\n");

    elseif e_work_state_downloading == work_state then
        print("*****************************work_state = e_work_state_downloading*******************************\n");

        print( "download_byte:  "..download_byte.." / "..all_byte)

        if 0 ~= all_byte then
            self._onProcess(download_byte,all_byte)
        end


        if type == e_state_file_pkg then
             print("*****************************pkg task done*******************************\n");
        end

        if type == e_state_event_alldone then
            print("*****************************all task done*******************************\n"); 
            self._isDownFinish = true
        end 
    end
end


pluginUpdaterstep = 1
function pluginManager:update(dt)

    if self._isDownFail == true then
        self._onError()
        pluginUpdaterstep = pluginUpdaterstep + 1
        if pluginUpdaterstep > 60 then 
            --app:exit()() 
        end

    elseif self._isDownFinish == true and self._isDownFail == false then
        self:finishDownLoad()
    end
end

function pluginManager:finishDownLoad()
    self._isDownFinish = false

    if self._entryId ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._entryId)
        self._entryId = nil
    end

    if self._dm ~= nil then
        self._dm:unregisterLuaListener()
        self._dm:destroy()
        self._dm = nil

        self._onDownFinish()
    end
end

function pluginManager:PauseFun()
    self.descriptor = nil;
    self.isSuspend = true;
    --self.is_updateing_idx = nil;
    --self.is_loading_plugin = false;
    --self.descriptor = nil;
end 

function pluginManager:updateLoadingIndex(name,idx)
    if(self.plugin_update_status[name]) then
        self.is_updateing_idx = idx;
    end 
end 
--usage:
--@ lua  files
--@ desc 
_G['pluginManager'] = pluginManager;
--endregion
