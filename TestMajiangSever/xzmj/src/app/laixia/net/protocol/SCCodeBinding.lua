--获取绑定手机验证码 接受服务器消息

local Type = import("..DataType")
local StatusCode = import("..StatusCode")

local function onSCCodeBindingPacket(packet)
    local statusID = packet:getValue("StatusID")
    if StatusCode.new(statusID):isOK() then
        laixia.LocalPlayercfg.LaixiaMatchVerification = true
    else
        laixia.LocalPlayercfg.LaixiaMatchVerification = false
    end
end

local  SCCodeBinding =
    {
        ID = _LAIXIA_PACKET_SC_SCCodeBindingID,
        name = "SCCodeBinding",
        data_array =
        {
            {"StatusID",Type.Short},
        },
        HandlerFunction =  onSCCodeBindingPacket,
    }

return SCCodeBinding