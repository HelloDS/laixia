require "model.GlobalVars"
require "utils.Util"
require "model.game.anysdkConst"
local Share = class("Share")
local CallBack = nil
local share_plugin = nil

function Share:onShareResult(code, msg)
    print("on share result listener.")
    print("code:"..code..",msg:"..msg)
    if code == ShareResultCode.kShareSuccess then
        CallBack(true)
    elseif code == ShareResultCode.kShareFail then
        CallBack(false)
    elseif code == ShareResultCode.kShareCancel then
        CallBack(false)
    elseif code == ShareResultCode.kShareNetworkError then
        CallBack(false)
    end
end
function Share:setEndCallBack(callback)
    CallBack=callback
end
function Share:ctor()
	share_plugin = AgentManager:getInstance():getSharePlugin()

     local data ={}
    local function callBack(resp,isSuccess) 
        require("common/KindlyReminderLayer"):show("游戏出错了！请联系客服妹妹！")
        if isSuccess~=true then
            
        end
    end
    if not VERSION then VERSION=0 end
    data["version"]=VERSION
    data["error"]="1111"
    data["user_id"]=USER_ID --玩家id 唯一标识
    data["detail_err"]=share_plugin--详细报错堆栈信息
    data["app_platform"]=CHANNELID -- 之后改为渠道名，从global中取
    data["section_name"]="测试一区" --区服务器id --本次上线默认1
    gameServerRequest(data,"log.SaveClientError",callBack)



	if share_plugin ~= nil then
	    share_plugin:setResultListener(self.onShareResult)
	end
end
function Share.create()
    local model = Share.new()
    return model
end

function Share:share(type,towhere,imgPath)




	if share_plugin ~= nil then
        local info 
        if imgPath == nil then
            info = {
                title = "ShareSDK是一个神奇的SDK",
                titleUrl = "http://sharesdk.cn",
                site = "ShareSDK",
                siteUrl = "http://sharesdk.cn",
                text = "ShareSDK集成了简单、支持如微信、新浪微博、腾讯微博等社交平台",
                comment = "无",
                mediaType = tostring(type),--0文字 1图片 2网址
                shareTo = tostring(towhere),--0 聊天 1 朋友圈 2 收藏
            }
        else
             info = {
                title = "ShareSDK是一个神奇的SDK",
                titleUrl = "http://sharesdk.cn",
                site = "ShareSDK",
                siteUrl = "http://sharesdk.cn",
                text = "ShareSDK集成了简单、支持如微信、新浪微博、腾讯微博等社交平台",
                comment = "无",
                imageUrl = imgPath,
                mediaType = tostring(type),--0文字 1图片 2网址
                shareTo = tostring(towhere),--0 聊天 1 朋友圈 2 收藏
            }
        end
        share_plugin:share(info)
	end
end
return Share