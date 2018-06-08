--
-- Author: Feng
-- Date: 2018-04-19 11:34:56
--

--[[

  ]]--
module(...,package.seeall)

local SdMger = {}

 baseEffectPath = "sound/effect/"
 baseMusicPath = "sound/music/"

local SoundLoadTable = {}

--
local userDefault = cc.UserDefault:getInstance()
--得到本地的音乐和音效开关状态
local _isEffectOn = userDefault:getIntegerForKey("isEffectOn", 1)==1
local _isBackgroundOn = userDefault:getIntegerForKey("isBackgroundOn", 1)==1

SdMger.mIsEffectOn = _isEffectOn
SdMger.mIsBackgroundOn = _isBackgroundOn


local sharedEngine = cc.SimpleAudioEngine:getInstance()
local backgroundMusic=""
local _isShowConstConfirm = userDefault:getBoolForKey("isShowConstConfirm", true)

local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
eventDispatcher:addEventListenerWithFixedPriority(cc.EventListenerCustom:create("APP_ENTER_BACKGROUND_EVENT",function()
    if device.platform == "ios" then
        if _isEffectOn or _isBackgroundOn then

        end
    else
        if _isBackgroundOn then
            pauseBackgroundMusic()
        end
        if _isEffectOn then
            unloadAllEffect()
        end
    end
end), 1)
eventDispatcher:addEventListenerWithFixedPriority(cc.EventListenerCustom:create("APP_ENTER_FOREGROUND_EVENT",function()
    if device.platform == "ios" then
        if _isEffectOn or _isBackgroundOn then 
            sharedEngine = cc.SimpleAudioEngine:getInstance()
            if _isBackgroundOn then
                if backgroundMusic and backgroundMusic~="" then
                    
                end
            end
        end
    else
        if _isEffectOn then
            unloadAllEffect()
        end
        if _isBackgroundOn then
            resumeBackgroundMusic()
        end
    end
end), 1)


--------------------------------------------background sound-------------------------------------------------
function setBackgroundMusic(bOn)
    if bOn then
        _isBackgroundOn = bOn
        if backgroundMusic and backgroundMusic~="" then
            playBackgroundMusic(backgroundMusic,true)
        end
        userDefault:setIntegerForKey("isBackgroundOn", 1)
    else
        userDefault:setIntegerForKey("isBackgroundOn", 0)
        if backgroundMusic and backgroundMusic~="" then
            stopBackgroundMusic(backgroundMusic)
        end
    end
    _isBackgroundOn = bOn
    userDefault:flush()
end

function isBackgroundOn()
    return _isBackgroundOn --sharedEngine:isBackgroundOn()
end

--    static void end()
--function preloadBackgroundMusic(pszFilePath)
--  sharedEngine:preloadBackgroundMusic(pszFilePath)
--end

function playBackgroundMusic(pszFilePath,bLoop)
    --  if bLoop == nil then
    --      bLoop = false
    --  end
    backgroundMusic = pszFilePath
    if isBackgroundOn() and pszFilePath and pszFilePath~="" then
        sharedEngine:stopMusic(true)
        sharedEngine:playMusic(pszFilePath,bLoop)
        setBackgroundMusicVolume(0.4)
    end
end

function stopBackgroundMusic(bReleaseData)
    --  if bReleaseData == nil then
    --      bReleaseData = false
    --  end
    sharedEngine:stopMusic()

end

function pauseBackgroundMusic()
    if isBackgroundOn() then
        sharedEngine:pauseMusic()
    end
end

function resumeBackgroundMusic()
    if isBackgroundOn() then
        sharedEngine:resumeMusic()
    end
end

function rewindBackgroundMusic()
    if isBackgroundOn() then
        sharedEngine:rewindBackgroundMusic()
    end
end

function willPlayBackgroundMusic()
    return sharedEngine:willPlayBackgroundMusic()
end

function isBackgroundMusicPlaying()
    return sharedEngine:isBackgroundMusicPlaying()
end

function getBackgroundMusicVolume()
    return sharedEngine:getBackgroundMusicVolume()
end

function setBackgroundMusicVolume(volume)
    sharedEngine:setMusicVolume(volume)
end

--------------------------------------------effect sound-----------------------------------------------------
function setEffectMusic(bOn)
    if bOn then
        userDefault:setIntegerForKey("isEffectOn", 1)
    else
        userDefault:setIntegerForKey("isEffectOn", 0)
    end
    _isEffectOn = bOn
    userDefault:flush()
end

function isEffectOn()
    return _isEffectOn --sharedEngine:isEffectOn()
end

function getEffectsVolume()
    return sharedEngine:getEffectsVolume()
end

function setEffectsVolume(volume)
    sharedEngine:setEffectsVolume(volume)
end

function playEffect(pszFilePath,bLoop)
    --  if bLoop == nil then
    --      bLoop = false
    --  end
    if isEffectOn() and sharedEngine and pszFilePath and pszFilePath~=""  then
        if not SoundLoadTable[pszFilePath] then
            SoundLoadTable[pszFilePath]=true
        end
        return sharedEngine:playEffect(pszFilePath,bLoop)
    end
end

function pauseEffect(nSoundId)
    if isEffectOn() and sharedEngine  then
        sharedEngine:pauseEffect(nSoundId)
    end
end

function pauseAllEffects()
    if isEffectOn() and sharedEngine  then
        sharedEngine:pauseAllEffects()
    end
end

function resumeEffect(nSoundId)
    if isEffectOn() then
        sharedEngine:resumeEffect(nSoundId)
    end
end

function resumeAllEffects()
    if isEffectOn()  and sharedEngine  then
        sharedEngine:resumeAllEffects()
    end
end

function stopEffect(nSoundId)
    if isEffectOn()  and sharedEngine  then
        sharedEngine:stopEffect(nSoundId)
    end
end

function stopAllEffects()
    if isEffectOn() and sharedEngine then
        sharedEngine:stopAllEffects()
    end
end

function preloadEffect(pszFilePath)
    if not SoundLoadTable[pszFilePath] then
        SoundLoadTable[pszFilePath] = true
        sharedEngine:preloadEffect(pszFilePath)
    end
end

function unloadEffect(pszFilePath)
    if SoundLoadTable[pszFilePath] then
        if sharedEngine then
            sharedEngine:unloadEffect(pszFilePath)
        end
        SoundLoadTable[pszFilePath]= nil
    end
end

function unloadAllEffect()
    local l_sound = sharedEngine
    if l_sound then
        for k,v in pairs(SoundLoadTable) do
            if v then
                l_sound:unloadEffect(k)
                SoundLoadTable[v]=false
            end
        end
    end
end



