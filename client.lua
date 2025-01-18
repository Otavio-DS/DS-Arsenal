Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vSERVER = Tunnel.getInterface("DS_arsenal")
DS = {}
Tunnel.bindInterface("DS_arsenal", DS)

function openArsenal(items)
    SetNuiFocus(true,true)
    SendNUIMessage({ action = "open", items = items })
end

CreateThread(function()
    while true do
        local idle = 1000
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)

        for k, v in pairs(configArsenal['arsenalCoords']) do
            local distance = #(pedCoords - v.coords)
            if distance <= 20 then
                idle = 1
                
                DrawText3D(v['coords']['x'],v['coords']['y'],v['coords']['z']+0.45,'Pressione ~r~[E]~w~ para abrir o arsenal')
                local marker = configArsenal['markerConfig']
                DrawMarker(marker["id"],v['coords']['x'],v['coords']['y'],v['coords']['z']-0.6, 0,0,0,
                    marker["rotacao"]["x"],marker["rotacao"]["y"],marker["rotacao"]["z"],
                    marker["scale"]["x"],marker["scale"]["y"],marker["scale"]["z"],
                    marker["color"][1],marker["color"][2],marker["color"][3],marker["color"][4],
                    marker["bobUpAndDown"], marker["faceCamera"], 2, marker["rotation"], nil, nil, false)

                if distance <= 2 then
                    if IsControlJustPressed(0, 38) then
                        local hasPermission, items = vSERVER.checkPermission(v.coords.x, v.coords.y, v.coords.z)
                        if hasPermission then
                            openArsenal(items)
                        end
                    end
                end
            end
        end
        Wait(idle)
    end
end)


RegisterNUICallback('closeMenu',function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "close"
    })
end)
local timerBuyItem = 0
RegisterNUICallback('buyItem', function(data, cb)
    if GetGameTimer() >= timerBuyItem then
        vSERVER.buyItem(data.item)
        timerBuyItem = GetGameTimer() + 1000
    else
        TriggerEvent('Notify','negado','Aguarde para pegar outro item do arsenal',5000)
    end
end)

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.40, 0.40)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end