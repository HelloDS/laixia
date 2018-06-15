--[[
    资源更新管理
]]
local AssetsManager = class("AssetsManager",function ()
    return cc.LayerColor:create(cc.c4b(20, 20, 20, 220))
end)

function AssetsManager:ctor()
--    self:onNodeEvent("exit", handler(self, self.onExitCallback))
    self:initUI()
    self:setAssetsManage()
end

function AssetsManager:onExitCallback()
    self.assetsManagerEx:release()
end

function AssetsManager:initUI()

    local hintLabel = cc.Label:create()
        :addTo(self)
    hintLabel:setPosition(cc.p(600, 80))
    hintLabel:setSystemFontSize(20)
    hintLabel:setString("正在更新...")

    local progressBg = display.newSprite("images/ic_morenhead0.png")    
        :addTo(self)
    progressBg:setPosition(cc.p(600, 40))

    self.progress = cc.ProgressTimer:create(display.newSprite("images/ic_morenhead1.png"))
        :addTo(progressBg)
    self.progress:setPosition(cc.p(380, 19))
    self.progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.progress:setBarChangeRate(cc.p(1, 0))
    self.progress:setMidpoint(cc.p(0.0, 0.5))
    self.progress:setPercentage(0) 

    --触摸吞噬
    self.listener = cc.EventListenerTouchOneByOne:create()
    self.listener:setSwallowTouches(true)
    local onTouchBegan = function (touch, event)
        return true
    end

    self.listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.listener, self)   
end

function AssetsManager:setAssetsManage()
    --创建可写目录与设置搜索路径
    local storagePath = cc.FileUtils:getInstance():getWritablePath() .. "upd/" 
    local resPath = storagePath.. "/res"
    local srcPath = storagePath.. "/src"
    if not (cc.FileUtils:getInstance():isDirectoryExist(storagePath)) then         
        cc.FileUtils:getInstance():createDirectory(storagePath)
        cc.FileUtils:getInstance():createDirectory(resPath)
        cc.FileUtils:getInstance():createDirectory(srcPath)
    end
    local searchPaths = cc.FileUtils:getInstance():getSearchPaths() 
    table.insert(searchPaths, 1, storagePath)  
    table.insert(searchPaths, 2, resPath)
    table.insert(searchPaths, 3, srcPath)
    cc.FileUtils:getInstance():setSearchPaths(searchPaths)

    cc.FileUtils:getInstance():removeFile(storagePath .. "/project.manifest.temp")
    cc.FileUtils:getInstance():removeFile(storagePath .. "/version.manifest")

    self.assetsManagerEx = cc.AssetsManagerEx:create("upd/version.manifest", storagePath)    
    self.assetsManagerEx:retain()

    local eventListenerAssetsManagerEx = cc.EventListenerAssetsManagerEx:create(self.assetsManagerEx, handler(self, self.handleAssetsManagerEvent))

    local dispatcher = cc.Director:getInstance():getEventDispatcher()
    dispatcher:addEventListenerWithFixedPriority(eventListenerAssetsManagerEx, 1)

    --检查版本并升级
    self.assetsManagerEx:update()
end

function AssetsManager:handleAssetsManagerEvent(event)    
    local eventCodeList = cc.EventAssetsManagerEx.EventCode    
--    local percent = event:getPercent()
    local eventCodeHand = {

        [eventCodeList.ERROR_NO_LOCAL_MANIFEST] = function ()
            print("发生错误:本地资源清单文件未找到")
        end,

        [eventCodeList.ERROR_DOWNLOAD_MANIFEST] = function ()
            print("发生错误:远程资源清单文件下载失败")  --资源服务器没有打开，
            self:downloadManifestError()
        end,

        [eventCodeList.ERROR_PARSE_MANIFEST] = function ()
             print("发生错误:资源清单文件解析失败")
        end,

        [eventCodeList.NEW_VERSION_FOUND] = function ()
            print("发现找到新版本")
        end,

        [eventCodeList.ALREADY_UP_TO_DATE] = function ()
            print("已经更新到服务器最新版本")            
--            self:updateFinished()
        end,

        [eventCodeList.UPDATE_PROGRESSION]= function ()
            print("更新过程的进度事件" .. event:getPercentByFile())
--            self.progress:setPercentage(event:getPercentByFile())
        end,

        [eventCodeList.ASSET_UPDATED] = function ()
            print("单个资源被更新事件")
        end,

        [eventCodeList.ERROR_UPDATING] = function ()
            print("发生错误:更新过程中遇到错误")
        end,

        [eventCodeList.UPDATE_FINISHED] = function ()
            print("更新成功事件")
--            self:updateFinished()
        end,

--        [eventCodeList.UPDATE_FAILED] = function ()
--            print("更新失败事件")
--        end,

--        [eventCodeList.ERROR_DECOMPRESS] = function ()
--            print("解压缩失败")
--        end
    }
    local eventCode = event:getEventCode()    
    if eventCodeHand[eventCode] ~= nil then
        eventCodeHand[eventCode]()
    else
        print("eventCodeHand not find eventCode == " .. eventCode) 
    end  
end

function AssetsManager:updateFinished()
    self:setVisible(false)
    self.listener:setEnabled(false)
end

function AssetsManager:downloadManifestError()
    self:setVisible(false)
    self.listener:setEnabled(false)
end

return AssetsManager