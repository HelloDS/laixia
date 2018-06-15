
local soundConfig = xzmj.soundcfg
local soundTools = {}

--记录最后播放的声音
local _currentMusic = nil
soundTools.mDelay = 0
soundTools.musicPlayed = false


--获取音效和背景音乐开关 
function soundTools.loadValue(key)
    return cc.UserDefault:getInstance():getBoolForKey(key)
end
--设置音效和背景音乐开关
function soundTools.saveValue(key, value)
    cc.UserDefault:getInstance():setBoolForKey(key, value)
end


--设置背景音乐状态
function soundTools.openMusic(play)
    -- soundTools.saveValue("MusicValue",play)

        if soundTools.musicPlayed then
        if play then
            audio.resumeMusic() -- 恢复暂停
        else
            audio.pauseMusic() -- 暂停音乐
        end

    else
        if play then
            soundTools.playMusic(_currentMusic,true)
        end
    end

end

--设置音效状态
function soundTools.openSound(play)
    --soundTools.saveValue("SoundValue",play)
    if not play then
        audio.stopAllSounds() -- 关闭所有音效
    end
end


--设置声音开启
function soundTools.soundOn()
      xzmj.LocalPlayercfg.LaixiaSoundOn = true
     -- --恢复背景音的播放
     soundTools.playMusic(_currentMusic)
end


--设置声音关闭
function soundTools.soundOff()
    xzmj.LocalPlayercfg.LaixiaSoundOn = false

    --关闭所有声音
    audio.stopAllSounds()
end

function soundTools.setPercent(aiPercent)
end
function soundTools.getPercent(aiPercent)
    
end
function soundTools.setBGPercent(aiPercent)
    audio.setMusicVolume(aiPercent)
end
function soundTools.getBGPercent(aiPercent)
    audio.getMusicVolume()
end
function soundTools.setEffectPercent(aiPercent)
    audio.setSoundsVolume(aiPercent)
end
function soundTools.getEffectPercent(aiPercent)
    audio.getSoundsVolume()
end



--播放背景音
function soundTools.playMusic(music, loop)
    if(music == nil) then
        return
    end
    --记录最后播放的声音，用于设置开启声音后可以恢复播放
    _currentMusic = music

    --查看声音是否开启
    if(xzmj.LocalPlayercfg.LaixiaSoundOn == false) then 
        return
    end

    if(xzmj.LocalPlayercfg.LaixiaMusicValue == 2) then 
        return
    end

--    if _currentMusic == music and audio.isMusicPlaying() then
--        return
--    end 

    soundTools.musicPlayed = true

    --播放背景音
    audio.playMusic(music, loop)
end

--播放音效
function soundTools.playSound(sound, delay)
    if (soundTools.mDelay > 0) then
        return
    end

    --查看声音是否开启
    if(xzmj.LocalPlayercfg.LaixiaSoundOn == false) then 
        return
    end
    --查看声音是否开启
    if(xzmj.LocalPlayercfg.LaixiaSoundValue == 2) then 
        return
    end
    
    --播放音效
    print("sound"..sound)
    audio.playSound(sound)

    if(delay ~= nil) then 
        soundTools.mDelay = delay
    end
end
--停止背景音乐
function soundTools.stopMusic()
    audio.stopMusic()
    _currentMusic = nil
end
--暂停背景音乐
function soundTools.pauseMusic()
    audio.pauseMusic()
end 
--回复背景音效
function soundTools.resumeMusic()
    audio.resumeMusic()
end 
--暂定所有音效
function soundTools.pauseAllSounds()
    audio.pauseAllSounds()
end
--回复所有音效
function soundTools.resumeAllSounds()
    audio.resumeAllSounds()
end
--卸载音效
function soundTools.unloadSound(filename)
    audio.unloadSound(filename)
end

function soundTools.resumeAllSounds()
    audio.resumeAllSounds()
end

function soundTools.stopAllSounds()
    audio.stopAllSounds()
end
function soundTools.playEffect(aiType,aiSound,aiSex,aiLoop)
    if aiSex == 0 then
        soundTools.playManEffect(aiType,aiLoop)
    else
         soundTools.playWomanEffect(aiType,aiLoop)
    end
end

return soundTools