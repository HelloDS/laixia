local Type = import("..DataType")
local DownloadActivity = import("...ui.layer.DownloadActivity")
local function onSCActivityPacket(packet)
    dumpGameData(packet)
    
    laixia.LocalPlayercfg.LaixiaActivityItems = packet:getValue("ActivityItems")
    local activityItems = packet:getValue("ActivityItems")
    for k,v in pairs(activityItems) do
        if tonumber(os.time()) >= v.beginTime and tonumber(os.time()) <= v.endTime then
            local localActivityName = DownloadActivity:SplitLastStr(v.image_url, "/")
            local localLunBoName = DownloadActivity:SplitLastStr(v.turn_url, "/")
            local activityPath = cc.FileUtils:getInstance():getWritablePath() .. localActivityName
            local lunBoPath = cc.FileUtils:getInstance():getWritablePath() .. localLunBoName
            local fileExist1 = cc.FileUtils:getInstance():isFileExist(activityPath)
            local fileExist2 = cc.FileUtils:getInstance():isFileExist(lunBoPath)
            local index = tonumber(k)
            if (fileExist2) then
                if  laixia.LocalPlayercfg.LaixiaLunBoPath[index] == nil then  
                    laixia.LocalPlayercfg.LaixiaLunBoPath[index] = {}
                end
                laixia.LocalPlayercfg.LaixiaLunBoPath[index] = lunBoPath
                if (fileExist1) then
                    if  laixia.LocalPlayercfg.LaixiaActivityPath[index] == nil then  
                        laixia.LocalPlayercfg.LaixiaActivityPath[index] = {}
                    end
                    laixia.LocalPlayercfg.LaixiaActivityPath[index] = activityPath
                else
                    DownloadActivity:pushTask(v.activityName,v.image_url,index,1)
                end
            else
                DownloadActivity:pushTask(v.activityName,v.turn_url,index,2)
                if (fileExist1) then
                        if  laixia.LocalPlayercfg.LaixiaActivityPath[index] == nil then   
                            laixia.LocalPlayercfg.LaixiaActivityPath[index] = {}
                        end
                        laixia.LocalPlayercfg.LaixiaActivityPath[index] = activityPath
                else
                    local index = tonumber(k)
                    DownloadActivity:pushTask(v.activityName,v.image_url,index,1)
                end
            end
        end
    end
    if laixia.LocalPlayercfg.LaixiaisActivity == true then
        laixia.LocalPlayercfg.LaixiaisActivity = false
    else
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_ACTIVITY_WINDOW,packet.data)
    end
end

local SCActivity =
    {
        ID = _LAIXIA_PACKET_SC_ActivityID,
        name = "SCActivity",
        data_array =
        {
            {"StatusID", Type.Short},-- 状态码
            {"ActivityItems" , Type.Array, Type.TypeArray.ActivityItems}
        },
        HandlerFunction = onSCActivityPacket,
    }

return SCActivity