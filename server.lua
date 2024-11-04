Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
DS = {}
Tunnel.bindInterface("elite_arsenal", DS)
vCLIENT = Tunnel.getInterface("elite_arsenal")

function SendWebhookMessage(webhook,message) 
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

function DS.checkPermission(x,y,z)
    local source = source
    local user_id = vRP.getUserId(source)
    for k,v in pairs(configArsenal['arsenalCoords']) do
        if vRP.hasPermission(user_id,k) then
            if vec3(x,y,z) == v['coords'] then
                return true, v['arsenalItems']
            end
        end
    end
end

function DS.buyItem(item)
    local source = source
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    for _,get in pairs(configArsenal['arsenalCoords']) do
        for _,v in pairs(get['arsenalItems']) do
            if v['item'] == item then
                if vRP.hasPermission(user_id, v['permission']) then
                    if v['typeItem'] == 'item' then
                        vRP.giveInventoryItem(user_id,item,1,true)
                        SendWebhookMessage(configArsenal['logs']['getItem'],"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[PEGOU ITEM NO ARSENAL]: "..v['nameItem'].." \n[PERMISSÃO]: "..v['permission'].." \n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."```")
                    elseif v['typeItem'] == 'weapon' then
                        vRP.giveInventoryItem(user_id,'wbody|'..item,1,true)
                        vRP.giveInventoryItem(user_id,'wammo|'..item,250,true)
                        SendWebhookMessage(configArsenal['logs']['getWeapon'],"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[PEGOU ARMA NO ARSENAL]: "..v['nameItem'].." \n[PERMISSÃO]: "..v['permission'].." \n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."```")
                    end
                else
                    TriggerClientEvent('Notify',source,'negado','Você não tem permissão para comprar este item!',5000)
                end
            end
        end
    end
end