local StatusCode = class("StatusCode")
local laixia = laixia;
local db2 = laixia.JsonTxtData;

function StatusCode:ctor(aiStatus,info)
	aiStatus = aiStatus or "nil";
	local function  handleError()
		if aiStatus == 0 then       --请求成功
			self.mOK = true
		elseif aiStatus == 1 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "请求失败！")
		elseif aiStatus == 2 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "没有响应！")
		elseif aiStatus == 3 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "参数错误")
		elseif aiStatus == 4 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "无效操作")
		elseif aiStatus == 5 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "未登录！")
		elseif aiStatus == 6 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "登陆异常！")
		elseif aiStatus == 7 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "未知操作！")
		elseif aiStatus == 8 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "非法操作！")
		elseif aiStatus == 9 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "校验码或默认参数错误！")
		elseif aiStatus == 10 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "验证码错误！")
		elseif aiStatus == 11 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "没有发现网关")
		elseif aiStatus == 12 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "帐号不存在！")
		elseif aiStatus == 13 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "玩家不存在！")
		elseif aiStatus == 14 then
			--ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "金不足请充费！")
			self:status2()
		elseif aiStatus == 15 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "元宝不足！")
		elseif aiStatus == 16 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "兑换券不足！")
		elseif aiStatus == 17 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "帐号或密码错误！")
		elseif aiStatus == 18 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "同时多次请求！")
		elseif aiStatus == 19 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "帐号随机失败！")
		elseif aiStatus == 20 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "角色创建失败！")
		elseif aiStatus == 21 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "头像图片不存在！")
		elseif aiStatus == 22 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "手机格式错误！")
		elseif aiStatus == 23 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "发送手机消息失败！")
		elseif aiStatus == 24 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "此手机号已绑定其它账号！")
		elseif aiStatus == 25 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "验证码已发送！")
		elseif aiStatus == 26 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "密码格式错误！")
		elseif aiStatus == 27 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "您输入的礼品码错误，请确定是否过期或确定是否输入正确！")
		elseif aiStatus == 28 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "地址错误！")
		elseif aiStatus == 29 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "包含敏感字！")
		elseif aiStatus == 30 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "需要绑定手机号！")
		elseif aiStatus == 31 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "QQ格式不对！")
		elseif aiStatus == 32 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "不能给自己赠送！")
		elseif aiStatus == 33 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "商品不能购买！")
		elseif aiStatus == 34 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "座位不存在！")
		elseif aiStatus == 35 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "经验值不足！")
		elseif aiStatus == 36 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "等级不足！")
		elseif aiStatus == 37 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "VIP不足！")
		elseif aiStatus == 38 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "比赛消耗不足！")
		elseif aiStatus == 39 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "牌桌不存在！")
		elseif aiStatus == 40 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "当前座位有人！")
		elseif aiStatus == 41 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "道具不足！")
		elseif aiStatus == 42 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "重复登入踢下线！")
		elseif aiStatus == 43 then
			if info and type(info) == "table" then
				ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_BULLETINS_WINDOW)
				ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_BULLETINS_WINDOW,info)
			else
				ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_REQUEST_BULLETINS_WINDOW)
			end

		elseif aiStatus == 44 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "服务器维护被踢下线！")
		elseif aiStatus == 45 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "服务器维护中，\n无法进入牌桌！")
		elseif aiStatus == 46 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "当前房间人数达到上线！")
		elseif aiStatus == 47 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "教学任务完成！")
		elseif aiStatus == 48 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "教学任务跳过！")
		elseif aiStatus == 49 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, laixia.utilscfg.CoinType().."超出房间要求的最大上限！")
		elseif aiStatus == 50 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, laixia.utilscfg.CoinType().."超过上限")
		elseif aiStatus == 51 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "当前房间牌桌达到上线！")
		elseif aiStatus == 52 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "奖励已经领取！")
		elseif aiStatus == 53 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "该账号已经领取过礼品码，不能重复领取！")
		elseif aiStatus == 54 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "礼品码已经领取！")
		elseif aiStatus == 55 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "比赛已开始！请等待下一场。")
		elseif aiStatus == 56 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "人数足够了！")
		elseif aiStatus == 57 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "无操作托管站起！")
		elseif aiStatus == 58 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "换桌太频繁！")
		elseif aiStatus == 59 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW,  {Text = "当前有未完成的牌局",
				OnCallFunc = function(isTry)
					if(isTry == nil) then isTry = true; end
					if(isTry) then
						ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_RECONNECTION_WINDOW,laixia.LocalPlayercfg.LaixiaRoomID)
					end
				end,
			})
		elseif aiStatus == 60 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "比赛已晋级不可复活")
		elseif aiStatus == 61 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "比赛不支持记牌器购买")
		elseif aiStatus == 62 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "记牌器存在,不需要购买")
		elseif aiStatus == 63 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW,
				{Text = "版本过低，请下载最新版本。",
					OnCallFunc = function()
						app:exit()();
					end,
				})
		elseif aiStatus == 64 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "VIP等级不足。")
		elseif aiStatus == 65 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "水果老虎机_已在游戏中。")
		elseif aiStatus == 66 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "水果老虎机_超过最大下注额。")
		elseif aiStatus == 67 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "今天已经换光啦，明天再来看看吧")
		elseif aiStatus == 68 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, {Text = "您的帐号（id:"..laixia.LocalPlayercfg.LaixiaPlayerID..")因数据异常已被系统封停",
				OnCallFunc = function()
					app:exit()();
				end,
			})
		elseif aiStatus == 69 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "桃李卡未开启")
		elseif aiStatus == 70 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "有未发完的小喇叭")
		elseif aiStatus == 71 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "今天已经换光啦，明天再来看看吧")
		elseif aiStatus == 72 then   --重复消息不做任何处理

        elseif aiStatus == 73 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "配置文件错误")
        elseif aiStatus == 74 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "等待中，已加入")
        elseif aiStatus == 75 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "微博授权错误用户无效")
        elseif aiStatus == 76 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "微博授权过期")
        elseif aiStatus == 77 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "微信授权错误用户无效")
        elseif aiStatus == 78 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "该物品不允许赠送")
        elseif aiStatus == 79 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "房间已满")
        elseif aiStatus == 80 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "房间不存在")
        elseif aiStatus == 81 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "只有房主能解散牌桌")
        elseif aiStatus == 82 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "牌局中不允许解散牌桌")
        elseif aiStatus == 83 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "房间号错误，请确认房间号再试！")
        elseif aiStatus == 84 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "需要微信绑定才能领取红包")
        elseif aiStatus == 100 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "发放失败，微信拦截了此次发放，请换个微信领取吧。")
        elseif aiStatus == 101 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "亲爱的，今日领取红包个数超过10个了，明天再兑换吧！")
		elseif aiStatus == 102 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "红包发放失败,微信拦截了此次发放，我们也无能无力了呢！")
		elseif aiStatus == 103 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "您手速太快了,缓两分钟再领您的钱吧！")
		elseif aiStatus == 104 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "哇哦，今天已经有1万人领取红包了，超过限额，明天请赶早来领！")
		elseif aiStatus == 105 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "哇哦，今天已经有1万人领取红包了，超过限额，明天请赶早来领！")
		elseif aiStatus == 107 then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "版本错误，重新下包")
		end
	end

	local network = laixia.net.Net;
	if(network.mProcessState ~= 2) then
		network:registerReadyFunc(handleError);
	else
		handleError();
	end
end

function StatusCode:isOK()
	if self.mOK == true then
		return true
	else
		return false
	end
end

function  StatusCode:status2()
	ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_NOMONEY_LANDLORDTABLE_WINDOW)
	if  laixia.LocalPlayercfg.LaixiaBenefitsReceiveNum~=0 then --laixia.LocalPlayercfg.LaixiaBenefitsMaxNum -
		--获取领取救济金的阀值
		local checkCoins = laixia.JsonTxtData:queryTable("common"):query("key","limitMoney"); --laixia.db.CommonDataManager:getItemByTypeID("limitMoney")
		--检测当前金是否低于阀值
		if laixia.LocalPlayercfg.LaixiaPlayerGold < checkCoins.Num then
			ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_RELIEF_WINDOW)
		else
			 -- ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"加入失败，您的金币不足")
			--ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_INCREASEGOLD_WINDOW)

            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_TSGOSHOP_SHOPWINDOW)
			-- ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_SHOP_WINDOW,{buttonType =1}) 
   --          ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_SHOP_WINDOW)

			--ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_NOMONEY_WINDOW)
		end
	else
		 -- ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"加入失败，您的金币不足")
		--ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"加入失败，您的金币不足")
		--ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_INCREASEGOLD_WINDOW)	end
           --注
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_TSGOSHOP_SHOPWINDOW)
			-- ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_SHOP_WINDOW,{buttonType =1}) 
   --          ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_SHOP_WINDOW)

			--ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_NOMONEY_WINDOW)
	end
end

return StatusCode



--endregion
