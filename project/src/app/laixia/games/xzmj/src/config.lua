
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 1

DEBUG_ALEX = true
                                 
LOG_LEVEL = 0

--是否热更
USE_UPDATE = false  

-- display FPS stats on screen
DEBUG_FPS = true

-- dump memory info every 10 seconds
DEBUG_MEM = false

-- load deprecated API
LOAD_DEPRECATED_API = false

-- load shortcodes API
LOAD_SHORTCODES_API = true

-- screen orientation
CONFIG_SCREEN_ORIENTATION = "landscape"

-- design resolution
-- CONFIG_SCREEN_WIDTH  = 1280
-- CONFIG_SCREEN_HEIGHT = 720


CONFIG_SCREEN_WIDTH  = 1280
CONFIG_SCREEN_HEIGHT = 720


-- auto scale mode
--CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"
LAIXIA_SDK_CONTROL = 0

APP_PACKAGE_NAME = "com/laixia/game/ddz/" 

ACTIVITY_NAME = "AppActivity"
APP_ACTIVITY  = APP_PACKAGE_NAME..ACTIVITY_NAME 

JAVA_UPLOAD_PHOTO_CLASS_PATH = APP_PACKAGE_NAME .."UploadPhoto"
JAVA_SHAKE_CLASSPATH = APP_PACKAGE_NAME .."ShakeUtil"


