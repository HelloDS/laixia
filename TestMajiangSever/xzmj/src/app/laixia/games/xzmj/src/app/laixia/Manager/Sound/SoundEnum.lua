--
-- Author: Feng
-- Date: 2018-04-19 11:35:36
--

--[[
	--音效/音乐 枚举模块

	--修改音效管理模块中的音效路径来改变音乐/音效
	BUTTON_COMMON = laixia.soundManagbasePath..
  ]]

module(...,package.seeall)

--通用按钮音效
BUTTON_COMMON = xzmj.soundManager.baseEffectPath .. "feiji.mp3"
BUTTON_CHUPAI = xzmj.soundManager.baseEffectPath .. "chupai.mp3"
BUTTON_BACKGROUND_1 = xzmj.soundManager.baseMusicPath .. "game_hall.mp3"
BUTTON_BACKGROUND_2 = xzmj.soundManager.baseMusicPath .. "lucky_wheel.mp3"


OpenMusic_NONE = nil
OpenMusic_WINDOW = nil
OpenMusic_TIP = nil


CloseMusic_NONE = nil
CloseMusic_CLOSE = nil
CloseMusic_BACK = nil
