-- 简单的http请求获取数据的类 

local tempJson = require("cjson")

local tempHttpConnect = { }

tempHttpConnect.Message = {
    -- 请求获得服务器url,头像uir　　有测试66，69，外网等很多IP，每次通过热更修改比较麻烦，直接从后台获取比较容易
    -- cmd消息号 platformId设备 ver = 版本号 gameType游戏类型
    AmendServer = "?content={cmd:1001,platformId:%d,ver:%s,gameType:%d,time:%s}",
    -- 收集信息url
    -- state 成功，失败 成功时，默认地址和收到的地址。失败时，返回原因
    GatherInfoServer = "?content={state:%s,info:%s}",
    GatherInfoServerUrl = "",
    -- 连接状态 是否成功，失败则为断网
    requestCompleted = "completed",
    -- 连接code 200是成功
    requestCode = 200,
    -- 返回码 -1  参数错误
    requestCmdParameter = - 1,
    -- 返回码 -2  URL不能存在
    requestCmdURL = - 2,
    -- 返回码 2001 连接修改服务url成功
    requestCmdAmendServerSuccess = 2001,
    -- 连接重试次数 默认3次，超过3次没有请求到url就走默认地址
    requestTimes = 3,

    --新增加的请求方式
    downLoad = nil,
    downLoadUrl =  "http://10.235.65.38/json/",
    downLoadFile =  ".json",

}


 

-- 修改服务器url 头像url 游戏名称 
function tempHttpConnect:AmendServerURL()
    -- 平台类型
    -- window = 0,
    -- android = 3,
    -- iphone = 4,
    -- ipad = 5,
    if laixia == nil or laixia.config == nil then 
        logError("tempHttpConnect:AmendServerURL__________________error_______laixiaconfig__not___exist_")
        self:InfoFeedback(false, "___error_______laixiaconfig__not___exist_")
        self:AmendServerURLNetStar()
        return
    end
    if laixia.config.LAIXIA_AMEND_SERVER_URL == false then
        self:InfoFeedback(false, "___error_____Don't need to jump__")
        self:AmendServerURLNetStar()
        return
    end
    -- 配置
    local tempConfig = laixia.config
    -- 得到设备类型
    local tempPlatformId = cc.Application:getInstance():getTargetPlatform()
    -- 版本号
    local tempVersionCode = '"' .. getAppVersion() .. '"'
    -- 游戏类型
    local tempGameType = tempConfig.GameType
    -- 组装消息
    local tempMessageURL = tempConfig.LAIXIA_AMEND_SERVER .. string.format(tempHttpConnect.Message.AmendServer, tempPlatformId, tempVersionCode, tempGameType, os.time())
       
    -- 下载相关
    local tempDownLoad = tempHttpConnect.downLoad
    if tempDownLoad then
        --
        local tempFileName = string.format( "gurl_%s_%s_%d",tempPlatformId,getAppVersion() ,tempGameType ) .. tempHttpConnect.Message.downLoadFile

        --重新切换了请求方式了
        tempDownLoad:Init(getAppVersion(), tempHttpConnect.Message.downLoadUrl , tempFileName)
        local tempSuccess = function() 
            self:DownLoadCallBack(true)
        end
        local tempError = function()
            self:DownLoadCallBack(false)
        end
        tempDownLoad:StartDownLoad( tempSuccess,tempError );
    else
        -- 代替
        local tempCallBack = function(event, data, sender)
            self:AmendServerURLCallBack(event)
        end
        local temphttPReuest = cc.HTTPRequest:createWithUrl(tempCallBack, tempMessageURL, cc.kCCHTTPRequestMethodGET)
        temphttPReuest:start()
    end

end  



-- 对应的回调
function tempHttpConnect:AmendServerURLCallBack(event)
    local request = event.request
    -- 当为completed表示正常结束此事件
    if event.name ~= tempHttpConnect.Message.requestCompleted then
        -- 断网
        -- logError("__not_completed____net___________error___")
        -- self:AmendServerError( "__not_completed____net___________error___" )
        -- return
    end
    if nil == request then
        -- 断网
        logError("___and__request__is__nil___________error___")
        self:AmendServerError("___and__request__is__nil___________error___")
        return
    end
    -- 看下是否成功
    local code = request:getResponseStatusCode()
    if (code ~= tempHttpConnect.Message.requestCode) then
        -- 是不是端口错了
        local tempInfo = string.format("__errorCode_is:%d_____port_error__LAIXIA_AMEND_SERVER__is_%s", code, laixia.config.LAIXIA_AMEND_SERVER)
        logError(tempInfo)
        self:AmendServerError(tempInfo)
        return
    end
    -- 拿到下载数据
    local tempString = request:getResponseString()
    local state, tempData = pcall(tempJson.decode, tempString)
    if false == state then
        local tempInfo = "__error_______json___format__"
        logError(tempInfo)
        self:AmendServerError(tempInfo)
        return
    end
    if tempData.cmd == tempHttpConnect.Message.requestCmdParameter then
        -- 参数错误
        local tempInfo = "__error____parameter__"
        logError(tempInfo)
        self:AmendServerError(tempInfo)
        return
    elseif tempData.cmd == tempHttpConnect.Message.requestCmdURL then
        -- url错误或者不存在
        local tempInfo = "_error____url__not___exist_"
        logError(tempInfo)
        self:AmendServerError(tempInfo)
        return
    elseif tempData.cmd == tempHttpConnect.Message.requestCmdAmendServerSuccess then
        -- 连接成功

    else
        -- 错误返回值
        local tempInfo = string.format("__error___back_state_%d", tempData.cmd)
        logError(tempInfo)
        self:AmendServerError(tempInfo)
        return
    end

    local tempLogInfo = "defalut__" .. laixia.config.ServerURL

    -- 修改url
    laixia.config.ServerURL = tempData.gameUrl
    laixia.config.HEAD_URL = tempData.gameUrlImage

    -- 可以确定是得到了服务器给的url，还是需要输出下具体请求到的url是什么
    self:InfoFeedback(true, tempLogInfo)
    self:AmendServerURLNetStar()
end

-- 请求失败
function tempHttpConnect:AmendServerError(logInfo)

    tempHttpConnect.Message.requestTimes = tempHttpConnect.Message.requestTimes - 1
    if tempHttpConnect.Message.requestTimes < 0 then
        -- 走默认的地址
        logError("tempHttpConnect:AmendServerError__________________error____default____")
        -- 发送日志，3次了都，确定是失败的，如果是成功的，直接在上一个函数已经输出了。得出来只是错误信息，没有反馈url。
        self:InfoFeedback(false, logInfo)
        self:AmendServerURLNetStar()
        return
    end
    -- 继续请求
    logError(string.format("tempHttpConnect:AmendServerError__________________error_____try__reuest_%d_", tempHttpConnect.Message.requestTimes))
    self:AmendServerURL()
end


-- 请求成功
function tempHttpConnect:AmendServerURLNetStar()
    self._isLoad = self._isLoad or false
    if self._isLoad == true then
        return
    end
    self._isLoad = true


end


-- 消息状态反馈
function tempHttpConnect:InfoFeedback(isSuccess, value)

    local tempSuccess = "success"
    if isSuccess ~= true then
        tempSuccess = "error"
    end
    -- 配置
    local tempConfig = laixia.config
    if value == nil or type(value) ~= "string" then
        value = ""
    end
    value = value .. "___current_Ip_is" .. tempConfig.ServerURL


    -- 组装消息
    local tempMessageURL = tempHttpConnect.Message.GatherInfoServerUrl .. string.format(tempHttpConnect.Message.GatherInfoServer, tempSuccess, value, os.time())
    -- 给一个回调
    local tempCallBack = function(event, data, sender) 
    end
    local temphttPReuest = cc.HTTPRequest:createWithUrl(tempCallBack, tempMessageURL, cc.kCCHTTPRequestMethodGET)
    temphttPReuest:start()
end 

-- 下载回调
function tempHttpConnect:DownLoadCallBack(isSuccess)
    if isSuccess ~= true then
        local tempInfo = "_download___error____url_file__is"..tempHttpConnect.downLoad.downloadConfig.down_url .. tempHttpConnect.downLoad.downloadConfig.downFile.."__version:_"..getAppVersion()
        logError(tempInfo)
        self:AmendServerError(tempInfo)
        return
    end

    local tempPath = cc.FileUtils:getInstance():getWritablePath() .. "download/" .. getHotUpdateRelativePath() .. tempHttpConnect.downLoad.downloadConfig.downFile .. '.temp'
    local fileExist = cc.FileUtils:getInstance():isFileExist( tempPath)
    if (fileExist == true) then
        local tempString = cc.FileUtils:getInstance():getStringFromFile(tempPath) 
        -- 拿到下载数据
        local state, tempData = pcall(tempJson.decode, tempString)
        if false == state then
            local tempInfo = "_download_error_______json___format__"
            logError(tempInfo)
            self:AmendServerError(tempInfo)
            return
        end
        if nil == tempData or nil == tempData.gameUrl or  nil == tempData.gameUrlImage then
            local tempInfo = "_download_error____json__error___"
            logError(tempInfo)
            self:AmendServerError(tempInfo)
            return
        end
        local tempLogInfo = "___download__defalut__" .. laixia.config.ServerURL
        -- 修改url
        laixia.config.ServerURL = tempData.gameUrl
        laixia.config.HEAD_URL = tempData.gameUrlImage

        -- 可以确定是得到了服务器给的url，还是需要输出下具体请求到的url是什么
        self:InfoFeedback(true, tempLogInfo)
        self:AmendServerURLNetStar()
    else
        tempHttpConnect:InfoFeedback(false, "download_file_not_exist______path__" .. tempPath)
        self:AmendServerError(tempInfo)
    end

end

tempDownLoad = {}
tempDownLoad.downloadConfig = {
    verision_code = "1.0.0",
    -- 下载使用的线程数
    DOWN_THREADNUM = 1,
    -- 是否开启幽灵下载
    DOWN_GHOST = false,
    -- 下载url
    down_url = "",
    -- 下载base url
    down_url_base = "", 
    -- 下载文件
    downFile = ""
}

tempDownLoad.downloadType = {
    Check = "check",
    Complete = "complete",
    Error = "error",
}


-- 输出日志
local downLogInfo = function(...)
    XLCCLog:info(...)
end
local downLogError = function(...)
    XLCCLog:error(...)
end 




-- 开始下载  downloadTable.ddz.value   1.完成 2失败 3正在进行
function tempDownLoad:StartDownLoad(CompleteCb, ErrorCb, LoadingCb)
    if self.isDownFinish == false then
        -- 正在下载中，请等待其他游戏下载完成
        return false
    end
    local tempValue = nil
    self.down_state = nil 
    self._completeCb = CompleteCb
    self._errorCb = ErrorCb
    self._loadingCb = LoadingCb
    local tempIsLoadRes = self:downLoadRes()
    return tempIsLoadRes
end 


-- 结束下载 内部调用
function tempDownLoad:EndDownLoad()
    -- 关闭更新
    if self.entryId ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.entryId)
        self.entryId = nil
    end
    -- 清理管理器
    if self.pDownLoadManager ~= nil then
        self.pDownLoadManager:unregisterLuaListener()
        self.pDownLoadManager:destroy()
        self.pDownLoadManager = nil
    end
    -- 可以算是下载完成了
    self.isDownFinish = true
end


-- 初始化
function tempDownLoad:Init(appVersion, url ,file)
    -- 是否下载完成
    self.isDownFinish = true
    -- 记录回调函数
    self.entryId = nil
    -- 下载状态
    self.down_state = nil
    -- 修改版本号
    tempDownLoad.downloadConfig.verision_code = appVersion
    -- 设置下载地址
    tempDownLoad.downloadConfig.down_url = url
    tempDownLoad.downloadConfig.down_url_base = url
    tempDownLoad.downloadConfig.downFile = file
end


-- 得到管理器
function tempDownLoad:getDownLoadM()
    if self.pDownLoadManager ~= nil then
        return self.pDownLoadManager
    end
    self.pDownLoadManager = DownLoadManager:new()
    downLogInfo(" tempDownLoad.downloadConfig.down_url =  " .. tempDownLoad.downloadConfig.down_url)
    local urls = { }
    table.insert(urls, tempDownLoad.downloadConfig.down_url)
    table.insert(urls, tempDownLoad.downloadConfig.down_url)
    table.insert(urls, tempDownLoad.downloadConfig.down_url_base)
    table.insert(urls, tempDownLoad.downloadConfig.down_url_base)
    self.pDownLoadManager:initWithData(urls, tempDownLoad.downloadConfig.DOWN_THREADNUM, tempDownLoad.downloadConfig.DOWN_GHOST)

    local function tempFinish(work_state, type, name, error_no, download_byte, all_byte)
        self:onFinish(work_state, type, name, error_no, download_byte, all_byte)
    end
    self.pDownLoadManager:registerLuaListener(tempFinish)

    return self.pDownLoadManager
end

-- 内部调用 读取资源
function tempDownLoad:downLoadRes() 
    local tempDownLoadManager = self:getDownLoadM()
    if nil == tempDownLoadManager then
        downLogError("tempDownLoad:downLoadRes__tempDownLoadManager__nil____________________________error___")
        if __G__TRACKBACK__ ~= nil and self._errorCb ~= nil then
            xpcall(self._errorCb, __G__TRACKBACK__)
        end
        return false
    end 

    --下载文件
    tempDownLoadManager:post_desire_cdf( tempDownLoad.downloadConfig.downFile , 65535, "", 4, 0,nil,nil)
     
    self.isDownFinish = false
    -- 注册回调，可以检测是否完成下载，下载百分百
    if self.entryId ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.entryId)
    end
    self.entryId = cc.Director:getInstance():getScheduler():scheduleScriptFunc( function(dt) self:updata(dt) end, 0, false)

    return true
end 
   
   
-- 检测下载结果   
function tempDownLoad:updata(dt)
    if self.isDownFinish ~= true then
        return
    end
    -- 关闭
    self:EndDownLoad()
    -- 能走到这个回调一定是完成了
    if self._completeCb ~= nil and self.down_state == tempDownLoad.downloadType.Complete then
        self._completeCb()
    end
    -- 如果失败，或者卡顿时间太长，会进入失败回调
    if self._errorCb ~= nil and self.down_state == tempDownLoad.downloadType.Error then
        self._errorCb()
    end
end

-- 内部调用 完成
function tempDownLoad:onFinish(work_state, type, name, error_no, download_byte, all_byte)
    if self.isDownFinish then
        return
    end
    if error_no ~= 0 then
         
        -- 下载失败需要标记，不能直接关闭
        -- _pecentageLabel:setString("下载更新错误, 请退出重试")
        self.down_state = tempDownLoad.downloadType.Error
        self.isDownFinish = true
        downLogError("on_finish___________handlerError_____________________")
        return
    end
    if e_work_state_checking == work_state then
        -- print("*** e_work_state_checking   "..name.." ***");
        if tempDownLoad.downloadType.Check ~= self.down_state then
            self.down_state = tempDownLoad.downloadType.Check
        end
    elseif e_work_state_downloading == work_state then
        -- downLogInfo("download_byte:  " .. download_byte .. " / " .. all_byte);
        if 0 ~= all_byte then
            -- _pecentageLabel:setString(round(download_byte/1024/1024, 2).."M/".. round(all_byte/1024/1024,2 ).."M")
            -- _progressbarloading:setPercent(100 * download_byte / all_byte)
            -- 下载中
            if nil ~= self._loadingCb then
             --   self._loadingCb(download_byte, all_byte)
            end
        end
        if type == e_state_file_pkg then
            downLogInfo("*****************************pkg task done*******************************\n");
        end
        if type == e_state_event_alldone then
            downLogInfo("*****************************all task done*******************************\n");
            self.isDownFinish = true
            self.down_state = tempDownLoad.downloadType.Complete
        end
    end
end   
-- 记录表
tempHttpConnect.downLoad = tempDownLoad 

return tempHttpConnect