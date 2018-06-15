
--字典文件，lua里的字典貌似可以直接写成lua文件。
--原则上不允许在界面文件里直接添加文字。
-- 或者可以读取json 文件, /res/data/json


--_ID_DICT_CONNECTED_TO_SERVER = 1

local DictID = import(".DictID") --

local function CoinType()
    return "金币";
end


local Dict =
    {
        [_ID_HTTP_CONNECTING] = "正在连接中，请稍候......", -- 个人认为这种说明不需要，出现旋转圈的时候谁不知道啊


        --牌型的字典

        [_ID_DICT_TYPE_TEN_THOUSAND] = "万",
        [_ID_DICT_TYPE_HUNDRED_MILLION] = "亿",


        --弹窗文字

        [_ID_DICT_TYPE_NOTIFY_OFFLINE] = "您的账号在别处登录，您被迫下线。",
        [_ID_DICT_TYPE_CONVERSIONCODE_INVALID] = "礼品码错误",
        [_ID_DICT_TYPE_CODE_CONVERSIONCODE_INVALID] = "该礼品码已经被使用。",
        [_ID_DICT_TYPE_CODE_HAVE_TO_RECEIVE] = "兑换失败，您已经使用过同类型礼品码。",
        [_ID_DICT_TYPE_CAN_MODIFY_ONE] = "您仅可修改1次昵称。",
        [_ID_DICT_TYPE_NICKNAME_LIMIT] = "新昵称长度为2-5个汉字或6-15个字符。",


        [_ID_DICT_TYPE_CONNECT_ERROR] = "无法连接到服务器，点击重试",
        [_ID_DICT_TYPE_NO_NET] =  "网络异常，请检查网络后重试。",
        [_ID_DICT_TYPE_CONNECT_TIMEOUT] = "请求超时,请重新尝试连接",

        [_ID_DICT_TYPE_NET_ERROR_LOGIN] = "登录状态异常，点击重新登录",

        [_ID_DICT_TYPE_WAITING_FOR_SWITCH] = "正在切换，请稍候…",





    }

function Dict.DICT(ID)
    return Dict[ID]
end

function Dict.CoinType()
    return CoinType();
end
return Dict
