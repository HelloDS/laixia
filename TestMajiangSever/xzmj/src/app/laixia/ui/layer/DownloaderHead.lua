

local laixiaUITools = import("...tools.UITools")        
local Queue = import("...net.Queue")
local DownloaderHead = class ("DownloaderHead")
function DownloaderHead:ctor(...)           
    self:reset()
end 

function DownloaderHead:reset()
    self.mTaskQueue = Queue:new()
    self.mDownloading = false
    self.mImgSaveTick = 0 
end

--线程中的轮询
function DownloaderHead:tick()           
    --print("op tick...")

    --正在下载中
    if(self.mDownloading == true)then 
        return
    end

    --队列中没有了
    if(self.mTaskQueue:IsEmpty()) then
        return
    end

    --下载第一个任务
    local task = self.mTaskQueue:Pop()--self.mTaskQueue:Front()
    self:download(task)
--    self:execDownLoad()
end 

function DownloaderHead:execDownLoad() 
    local task = self.mTaskQueue:Front()
    --如果已经下载过了，则不进行下载
--    local imgName = self:SplitLastStr(task.url, "/")
    local imgName = task.playerID
    local isPath = cc.FileUtils:getInstance():getWritablePath() .. imgName..".png"
    local fileExist = cc.FileUtils:getInstance():isFileExist(isPath)
    if(fileExist) then
        self.mTaskQueue:Pop()
        self.mDownloading = false
    else
        self:download(task)
    end
end 

--想下载队列中加入一个下载人物
function DownloaderHead:pushTask(playerID, url,mInGame)
    if(playerID == nil) then 
        return
    end

    if(url == nil) then
        return
    end 
    if(url == "") then
        return
    end

    local task = {}
    task.playerID = playerID
    task.url = url
    task.mInGame = mInGame
    self.mTaskQueue:Push(task)
end

--开始下载一个任务
function DownloaderHead:download(task)
    local url = task.url
    --"http://image.scale.inke.com/imageproxy2/dimgm/scaleImage?
    --url=http%3A%2F%2Fthirdwx.qlogo.cn%2Fmmopen%2Fvi_32%2FQ0j4TwGTfTIjcUbWq31f7NqpSSlKsTzEw0ubx4ZlH9Fhpl5s4AO7EuJaXxPmanJJmgHvJzLtRxYsBSoRvL8TVw%2F132&w=-1&s=80&h=-1&c=1&o=0&t=1",

    local array = string.split(url,"url=")
    if #array > 1 then
        local array1 = string.split(array[2],"&")
        local array2 = string.gsub(array1[1],'%%3A',':')
        local array3 = string.gsub(array2,'%%2F',"/")
        task.url = array3 
        url = task.url
    end

	local request = network.createHTTPRequest(function(event)
	    event.task = task
        self:onResponsePost(event)
	end, url, "GET")


    -- local accessTokenURL = url

    -- local xhr = cc.XMLHttpRequest:new()
    -- xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_ARRAY_BUFFER
    -- xhr:open("GET", accessTokenURL)
    -- local function onResp(event)
    --     event.task = task
    --     self:onResponsePost(event)
    --     xhr:unregisterScriptHandler()
    -- end
    -- xhr:registerScriptHandler(onResp)
    -- xhr:send()

	request:setTimeout(5)
	request:start()
    self.mDownloading = true
end

function DownloaderHead:Split(szFullString, szSeparator)  
    return  laixia.UItools.Split(szFullString, szSeparator)   
end  
 
--切出最后一个
function DownloaderHead:SplitLastStr(szFullString, szSeparator)  
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
function DownloaderHead:onResponsePost(event)
    local request = event.request
    print(event.name)
    if event.name == "failed" then
        -- self.mTaskQueue:Pop()
        self.mDownloading = false
        return
    end
    if event.name ~= "completed" then 
        -- self.mTaskQueue:Pop()
        return 
    end

    self.mDownloading = false
    --local task = self.mTaskQueue:Pop()
    local task = event.task

    -- 看下是否成功
    local code = request:getResponseStatusCode()

    if (code ~= 200) then 
        return 
    end
    
    if task == nil then
        return
    end
    print("head url ---")
    print(task.url)

    --拿到下载数据
    --local data = string.trim(request:getResponseString())

    local data = request:getResponseData()
    local size = #data

    local imgName
    if (task ~= nil and task.playerID~=nil)  then
        imgName = task.playerID..".png"
    else
       imgName = self:SplitLastStr(task.url, "/")..".png"
    end
    --local imgName = task.playerID

    
    local savePath = cc.FileUtils:getInstance():getWritablePath() .. imgName

    
    io.writefile(savePath, data)

    --通知UI更新图片
    local event={}
    event.playerID = task.playerID

    event.savePath = savePath--string.sub(imgName, 1, string.len(imgName)-4)  
    self.mImgSaveTick = self.mImgSaveTick + 1
        
    if (task.mInGame == 1) then --牌桌
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DOWNLOAD_PICTURE_WINDOW, event)
    elseif(task.mInGame==2) then --大厅
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DOWNLOADLOBBY_PICTURE_WINDOW, event)
    elseif(task.mInGame ==3) then --排行榜
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DOWNLOADRANK_PICTURE_WINDOW, event)
    elseif(task.mInGame ==4) then --个人信息
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DOWNLOADPERSONAL_PICTURE_WINDOW, event)
    elseif(task.mInGame ==6) then-- 站内个人信息 
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DOWNLOAD_SELFROOM_PERSONAL_PICTURE_WINDOW, event)
    elseif(task.mInGame ==7) then-- 结算
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DOWNLOAD_RESULT_SMALL_PICTURE_WINDOW, event) 
    elseif(task.mInGame ==8) then-- 自建桌大结算
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DOWNLOAD_RESULT_BIG_PICTURE_WINDOW, event)       
    elseif(task.mInGame == 5) then  -- 通用图片下载，小游戏可以用这个
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DOWNLOADNORMAL_PIC_WINDOW, event);
    elseif(task.mInGame == 9) then --解散
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DOWNLOAD_APPLEDISMISS_WINDOW, event);
    end

    print("onResponsePost end")
end

return DownloaderHead.new()  

