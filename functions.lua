function getUserId(source)
    return vRP.getUserId(source)
end

function getUserIdentity(user_id)
    return vRP.getUserIdentity(user_id)
end

function getUserSource(user_id)
    return vRP.getUserSource(user_id)
end

function hasPermission(user_id, permission)
    return vRP.hasPermission(user_id, permission)
end

function tryGetInventoryItem(user_id, item, amount)
    return exports['elite_inventory']:tryGetInventoryItem(user_id, item, amount)
end

function getInventoryItemAmount(user_id, item)
    return exports['elite_inventory']:getInventoryItemAmount(user_id, item)
end

function giveInventoryItem(user_id, item, amount, notify)
    return exports['elite_inventory']:giveInventoryItem(user_id, item, amount, notify)
end