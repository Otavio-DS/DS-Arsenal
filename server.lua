Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
DS = {}
Tunnel.bindInterface("DS_arsenal", DS)
vCLIENT = Tunnel.getInterface("DS_arsenal")

function SendWebhookMessage(webhook,message) 
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

function DS.checkPermission(x,y,z)
    local source = source
    local user_id = getUserId(source)
    for k,v in pairs(configArsenal['arsenalCoords']) do
        if hasPermission(user_id,v.permission) then
            if vec3(x,y,z) == v['coords'] then
                return true, v['arsenalItems']
            end
        end
    end
end

function clearArsenalItems(user_id)
    local source = getUserSource(user_id)
    for _,get in pairs(configArsenal['arsenalCoords']) do
        for _,v in pairs(get['arsenalItems']) do
            if tryGetInventoryItem(user_id,v['item'], getInventoryItemAmount(user_id,v['item'])) then
                if source then
                    TriggerClientEvent('Notify',source, 'sucesso','Items de serviço removidos',5000)
                end
            end
            Wait(1000)
        end
    end
end
exports('clearArsenalItems',clearArsenalItems)

function DS.buyItem(item)
    local source = source
    local user_id = getUserId(source)
    local identity = getUserIdentity(user_id)
    for _,get in pairs(configArsenal['arsenalCoords']) do
        for _,v in pairs(get['arsenalItems']) do
            if v['item'] == item then
                if hasPermission(user_id, v['permission']) then
                    if v['typeItem'] == 'item' then
                        giveInventoryItem(user_id,item,v['quantity'],true)
                        SendWebhookMessage(configArsenal['logs']['getItem'],"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[PEGOU ITEM NO ARSENAL]: "..v['nameItem'].." \n[PERMISSÃO]: "..v['permission'].." \n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."```")
                        return
                    elseif v['typeItem'] == 'weaponHand' then
                        giveInventoryItem(user_id,'wbody|'..item,1,true)
                        SendWebhookMessage(configArsenal['logs']['getWeapon'],"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[PEGOU ARMA NO ARSENAL]: "..v['nameItem'].." \n[PERMISSÃO]: "..v['permission'].." \n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."```")
                        return
                    elseif v['typeItem'] == 'weapon' then
                        giveInventoryItem(user_id,'wbody|'..item,1,true)
                        giveInventoryItem(user_id,'wammo|'..item,250,true)
                        SendWebhookMessage(configArsenal['logs']['getWeapon'],"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[PEGOU ARMA NO ARSENAL]: "..v['nameItem'].." \n[PERMISSÃO]: "..v['permission'].." \n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."```")
                        return  
                    end
                else
                    TriggerClientEvent('Notify',source,'negado','Você não tem permissão para pegar este item!',5000)
                end
            end
        end
    end
end