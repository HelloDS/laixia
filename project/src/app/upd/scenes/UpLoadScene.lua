--[[
    加载场景界面
        此处用于处理热更新和硬更新
    流程：    
        加载界面->判定更新-> 
                        true    ->1.热更新  2.硬更新   
                        false   ->进入主场景界面     
                        
    AssetsManagerEx 会检测本地和服务器的版本号，并且添加搜索路径
    如果是一致的添加 "upd/" 路径搜索到第一位
    如果不是一致的添加 "src/"路径到第一位 然后添加 "upd/" 路径搜索到第一位初始化
]]
local UpLoadScene = class("UpLoadScene", function()
    return display.newScene("UpLoadScene")
end)

UpLoadScene.STATE = {
    CheckError      = 0, -- 检测失败，更新失败
    CheckVersion    = 1, -- 检测版本
    CheckOver       = 2, -- 检测版本结束
    LoginApp        = 3, -- 登录平台
    LoginAppSucess  = 4, -- 登录平台成功
}

--[[
    构造函数
]]
function UpLoadScene:ctor()
    print("UpLoadScene ctor")
    self.m_updateState = nil
    self.m_projectJson = nil
    self.m_totalUpdSize = 0
    if not cc.UserDefault:getInstance():getBoolForKey("isUpdateSuccessful", false) then
        --只走一次 下次硬更新修复此问题
        local storagePath = cc.FileUtils:getInstance():getWritablePath() .. "upd/" 
        local function removeUpdFile(fileName)
            if (cc.FileUtils:getInstance():isFileExist(storagePath .. fileName)) then 
                cc.FileUtils:getInstance():removeFile(storagePath .. fileName)
            end
        end
        removeUpdFile("version.manifest")
        removeUpdFile("project.manifest")
        removeUpdFile("project.manifest.temp")
    end
    self:init()
end

--[[
    初始化
]]
function UpLoadScene:init()
    -- self:registerScriptHandler(handler(self, self.onNodeEvent))
    self:onNodeEvent("enter")

    local bg = ccui.ImageView:create("new_ui/LobbyScene/beijing.jpg")
    bg:setAnchorPoint(cc.p(0,0))
    bg:setTextureRect(cc.rect(0, 0, display.width, display.height))
    bg:setPosition(cc.p(0,(display.height - 1280) / 2))
    self:addChild(bg)

    self.txt_update = cc.Label:create()
    self.txt_update:setString("检测游戏更新")
    self.txt_update:setColor(cc.c3b(255, 255, 255))
    self.txt_update:setSystemFontSize(40)
    self.txt_update:setPosition(cc.p(display.cx, display.cy))
    self:addChild(self.txt_update)
end

function UpLoadScene:copyfile(source, destination)
    local data = cc.FileUtils:getInstance():getStringFromFile(source)
    if not data then 
        print("copyfile|data is null.")
        return false 
    end
    destFile = io.writefile(destination, data, "w+b")
    if destFile == nil then 
        print("copyfile|open destFile failed.")
        return false 
    end
    return true
end

function UpLoadScene:onNodeEvent(eventName)
	if "enter" == eventName then
        local storagePath = cc.FileUtils:getInstance():getWritablePath() .. "upd/" 
        local resPath = storagePath.. "/res"
        local srcPath = storagePath.. "/src"
        if not (cc.FileUtils:getInstance():isDirectoryExist(storagePath)) then         
            cc.FileUtils:getInstance():createDirectory(storagePath)
            cc.FileUtils:getInstance():createDirectory(resPath)
            cc.FileUtils:getInstance():createDirectory(srcPath)
        end
        local projectPath = storagePath .. "project.manifest"
            if not (cc.FileUtils:getInstance():isFileExist(projectPath)) then 
                if cc.FileUtils:getInstance():isFileExist("app/upd/project.manifest") then
                    self:copyfile("app/upd/project.manifest", projectPath)
                end
            end
        local searchPaths = cc.FileUtils:getInstance():getSearchPaths() 
        table.insert(searchPaths, 1, storagePath)  
        table.insert(searchPaths, 2, resPath)
        table.insert(searchPaths, 3, srcPath)
        cc.FileUtils:getInstance():setSearchPaths(searchPaths)

        cc.FileUtils:getInstance():removeFile(storagePath .. "/project.manifest.temp")

		self.assetsMgr = cc.AssetsManagerEx:create("upd/version.manifest", storagePath)
		self.assetsMgr:retain()
		if not self.assetsMgr:getLocalManifest():isLoaded() then
			print("检查更新失败...")
			self:updateFinish()
		else
			self.listener = cc.EventListenerAssetsManagerEx:create(self.assetsMgr, handler(self, self.handleAssetsManagerEvent))
			cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self.listener, 1)
			self.assetsMgr:update()
		end
	elseif "exit" == eventName then
        if self and self.assetsMgr then
		    self.assetsMgr:release()
        end
	end
end

function UpLoadScene:handleAssetsManagerEvent(event)    
    local eventCodeList = cc.EventAssetsManagerEx.EventCode    
    local eventCodeHand = {

        [eventCodeList.ERROR_NO_LOCAL_MANIFEST] = function ()
            print("发生错误:本地资源清单文件未找到")
            self:updateFinish()
        end,

        [eventCodeList.ERROR_DOWNLOAD_MANIFEST] = function ()
            print("发生错误:远程资源清单文件下载失败")  --资源服务器没有打开，
            self:updateFinish()
        end,

        [eventCodeList.ERROR_PARSE_MANIFEST] = function ()
             print("发生错误:资源清单文件解析失败")
             self:updateFinish()
        end,

        [eventCodeList.NEW_VERSION_FOUND] = function ()
            print("发现找到新版本")
            cc.UserDefault:getInstance():setBoolForKey("isUpdateSuccessful", false)
        end,

        [eventCodeList.ALREADY_UP_TO_DATE] = function ()
            print("已经更新到服务器最新版本")            
            self:updateFinish()
        end,

        [eventCodeList.UPDATE_PROGRESSION]= function ()
            local filePath = cc.FileUtils:getInstance():getWritablePath() .. "upd/project.manifest.temp" 
            if cc.FileUtils:getInstance():isFileExist(filePath) and not self.m_projectJson then
                local projectStr = cc.FileUtils:getInstance():getStringFromFile(filePath)
                if type(projectStr) == "string" then
                    self.m_projectJson = json.decode(projectStr)
                end
            end
			local percent = event:getPercentByFile()
            if percent == 0 then
                return
            end
            local assetId = event:getAssetId()
			local strInfo = ""
			if assetId == cc.AssetsManagerExStatic.VERSION_ID then
				strInfo = string.format("Version file: %d%%", percent)
				print(strInfo)
				strInfo = "versoin"
			elseif assetId == cc.AssetsManagerExStatic.MANIFEST_ID then
				strInfo = string.format("Manifest file: %d%%", percent)
				print(strInfo)
				strInfo = "manifest"
			else
				strInfo = string.format("Resource file: %d%%", percent)
				print(strInfo)
				strInfo = "resource"
			end
            print("正在更新游戏资源 " .. strInfo .. ": " .. percent .. "...")
            self.txt_update:setString(string.format("正在更新游戏资源:%d%%", percent))
        end,

        [eventCodeList.ASSET_UPDATED] = function ()
            local fileName = event:getAssetId()
            local msg = event:getMessage()
            local size = self:getFileSize(fileName)
            self.m_totalUpdSize = self.m_totalUpdSize + size
            print("单个资源被更新事件 " .. fileName .. ", " .. msg .. ", size = " .. self:cacluSize(size))
        end,

        [eventCodeList.ERROR_UPDATING] = function ()
            print("发生错误:更新过程中遇到错误")
            print("Asset " .. event:getAssetId() .. ", " .. event:getMessage())
            self.txt_update:setString("更新文件离家出走了，请重新更新！")
			self:changeState(UpLoadScene.STATE.CheckError, "下载出错")
        end,

        [eventCodeList.UPDATE_FINISHED] = function ()
            print("更新成功事件")
            print("总共更新资源大小 = " .. self:cacluSize(self.m_totalUpdSize))
            cc.UserDefault:getInstance():setBoolForKey("isUpdateSuccessful", true)
            self.txt_update:setString("更新成功")
            self:updateFinish()
        end,

        [9] = function ()
            print("更新失败事件")
            self.txt_update:setString("更新失败")
            self:changeState(UpLoadScene.STATE.CheckError, "ERROR")
        end,

        [10] = function ()
            print("解压缩失败")
        end
    }
    local eventCode = event:getEventCode()    
    if eventCodeHand[eventCode] ~= nil then
        eventCodeHand[eventCode]()
    else
        print("找不到更新错误码 = " .. eventCode)
    end  
end

function UpLoadScene:changeState(state, msg)
    if state == UpLoadScene.STATE.CheckError then
        print("重新下载")
        self.m_updateState = state
        self:clearAssetsMng()

        local storagePath = cc.FileUtils:getInstance():getWritablePath() .. "upd/" 
        local function removeUpdFile(fileName)
            if (cc.FileUtils:getInstance():isFileExist(storagePath .. fileName)) then 
                cc.FileUtils:getInstance():removeFile(storagePath .. fileName)
            end
        end
       removeUpdFile("version.manifest")
       removeUpdFile("project.manifest")
       removeUpdFile("project.manifest.temp")

        app:exit()
    else
        self.m_updateState = state
    end
end

function UpLoadScene:getFileSize(fileName)
    if type(fileName) ~= "string" or not self.m_projectJson then
        return 0
    end
    local assets = self.m_projectJson.assets
    local file = assets[fileName]
    if not file then return 0 end
    return file.size
end

function UpLoadScene:updateFinish()
	local resVersion = self.assetsMgr:getLocalManifest():getVersion()
	print("resVersion:" .. resVersion)

	local loginScene = require("app/scenes/MainScene").new()
	cc.Director:getInstance():replaceScene(loginScene)
end

function UpLoadScene:cacluSize(size)
    if type(size) ~= "number" then
        return ""
    end
    local KB = 1024
    local MB = 1024 * KB
    local GB = 1024 * MB
    if size < KB then
        return size .. " 字节"
    elseif size < MB and size >= KB then
        return string.format("%.2f", size / KB) .. " KB"
    elseif size < GB and size >= MB then
        return string.format("%.2f", size / MB) .. " MB"
    end
    return ""
end

function UpLoadScene:clearAssetsMng()
    if self.assetsMgr ~= nil then
--        self.assetsMgr:release()
        if self.listener ~= nil then
--            cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listener)
            self.listener = nil
        end
        self.assetsMgr = nil
    end
end

return UpLoadScene