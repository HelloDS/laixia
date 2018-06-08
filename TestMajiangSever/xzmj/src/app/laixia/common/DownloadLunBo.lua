

local laixiaUITools = import("...tools.UITools")        
local Queue = import("...net.Queue")
local DownloadLunBo = class ("DownloadLunBo")
function DownloadLunBo:ctor(...)           
    self:reset()
end 

function DownloadLunBo:reset()
    self.mTaskQueue = Queue:new()
    self.mDownloading = false
    self.mImgSaveTick = 0 
end

--线程中的轮询
function DownloadLunBo:tick()           
    --正在下载中
    -- print("99999999999999999999999999999999999999999999999999999")
    if(self.mDownloading == true)then 
        return
    end
    --队列中没有了
    if(self.mTaskQueue:IsEmpty()) then
        return
    end
    --下载第一个任务
    local task = self.mTaskQueue:Front()
    self:download(task)
    self:execDownLoad()
end 

--开始下载一个任务
function DownloadLunBo:download(task)
    local url = task.url

    local request = network.createHTTPRequest(function(event)
        event.task = task
        self:onResponsePost(event)
    end, url, "GET")

    request:setTimeout(5)
    request:start()
    self.mDownloading = true
end

function DownloadLunBo:execDownLoad() 
    local task = self.mTaskQueue:Front()
    --如果已经下载过了，则不进行下载
    local imgName = self:SplitLastStr(task.url, "/")
    local isPath = cc.FileUtils:getInstance():getWritablePath() .. imgName
    local fileExist = cc.FileUtils:getInstance():isFileExist(isPath)
    if(fileExist) then
        self.mTaskQueue:Pop()
        self.mDownloading = false
    else
        self:download(task)
    end
end 



--向下载队列中加入一个下载人物
function DownloadLunBo:pushTask(lunBoName, url)
    if (lunBoName == nil) then
        return
    end
    if(url == nil) then
        return
    end 
    if(url == "") then
        return
    end
 
    local task = {}
    task.lunBoName = lunBoName
    task.url = url
    self.mTaskQueue:Push(task)

end


function DownloadLunBo:Split(szFullString, szSeparator)  
    return  laixia.UItools.Split(szFullString, szSeparator)   
end  
 
--切出最后一个
function DownloadLunBo:SplitLastStr(szFullString, szSeparator)  
    local nFindStartIndex = 1  
    local nSplitIndex = 1  
    local nSplitArray = {}  
    local ret = nil
    while true do  
       local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
       if not nFindLastIndex then  
            ret = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
            nSplitArray[nSplitIndex] = ret
            break  
       end
       
       nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
       nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
       nSplitIndex = nSplitIndex + 1  
    end  
    return ret  
end

--下载事件回调
function DownloadLunBo:onResponsePost(event)
    local request = event.request
    
    if event.name == "failed" then
        self.mTaskQueue:Pop()
        self.mDownloading = false
        return
    end
    if event.name ~= "completed" then 
        return 
    end

    self.mDownloading = false
    local task = event.task

    -- 看下是否成功
    local code = request:getResponseStatusCode()

    if (code ~= 200) then 
        return 
    end
    
    if task == nil then
        return
    end
    print("lunBo url ---")
    print(task.url)

    --拿到下载数据
    local data = request:getResponseData()
    local size = #data

    local imgName
    imgName = self:SplitLastStr(task.url, "/")
    local savePath = cc.FileUtils:getInstance():getWritablePath() .. imgName

    
    io.writefile(savePath, data)

    --通知UI更新图片
    local event={}
    event.LunBoName = task.lunBoName
    event.savePath = savePath
    self.mImgSaveTick = self.mImgSaveTick + 1
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DOWNLOAD_LUNBO_WINDOW, event);
    print("onResponsePost end88888888888888888888888888888888888888888888888888888888888888888888")
end

return DownloadLunBo.new()  

