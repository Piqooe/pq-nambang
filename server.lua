local ESX = exports["es_extended"]:getSharedObject()

-- Function Notif
local function NotifyPlayer(source, message, type)
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Notification',
        description = message,
        type = type
    })
end

-- Mining Event
RegisterNetEvent('pq-job:nambangbatu', function()
    local player = source
    local config = Config.Mining
    
    local item = exports.ox_inventory:GetItem(player, config.requiredItem)
    if not item or item.count <= 0 then
        NotifyPlayer(player, 'Kamu butuh Pickaxe buat nambang!', 'error')
        return
    end
    
    local stoneQuantity = math.random(config.minQuantity, config.maxQuantity)
    
    if exports.ox_inventory:CanCarryItem(player, config.itemToAdd, stoneQuantity) then
        exports.ox_inventory:AddItem(player, config.itemToAdd, stoneQuantity)
        NotifyPlayer(player, 'Kamu mendapatkan ' .. stoneQuantity .. ' batu', 'success')
    else
        NotifyPlayer(player, 'KANTONG MU PENUH!', 'error')
    end
end)


-- Stone Washing Event
RegisterNetEvent('pq-job:cucibatu', function()
    local source = source
    if exports.ox_inventory:GetItem(source, Config.Washing.inputItem)?.count >= Config.Washing.requiredQuantity then
        if exports.ox_inventory:CanCarryItem(source, Config.Washing.outputItem, Config.Washing.requiredQuantity) then
            exports.ox_inventory:RemoveItem(source, Config.Washing.inputItem, Config.Washing.requiredQuantity)
            exports.ox_inventory:AddItem(source, Config.Washing.outputItem, Config.Washing.requiredQuantity)
        else
            NotifyPlayer(source, 'KANTONG MU PENUH!')
        end
    else
        NotifyPlayer(source, 'BATU KAMU KURANG!')
    end
end)


-- Smelting Event
RegisterNetEvent('pq-job:leburbatu', function()
    local player = source
    local config = Config.Smelting
    
    if not exports.ox_inventory:RemoveItem(player, config.inputItem, config.requiredStones) then
        NotifyPlayer(player, 'Kamu tidak memiliki cukup batu cuci!', 'error')
        return
    end
    
    local mineralTypes = {'copper', 'iron', 'gold', 'diamond'}
    local itemsReceived = {}
    
    for _, mineralType in ipairs(mineralTypes) do
        local chance = config.chances[mineralType]
        local quantity = config.quantities[mineralType]
        
        if math.random() <= chance then
            local amount = math.random(quantity.min, quantity.max)
            
            if amount > 0 then
                if not exports.ox_inventory:CanCarryItem(player, mineralType, amount) then
                    NotifyPlayer(player, 'KANTONG MU PENUH!', 'error')
                    return
                end
                
                exports.ox_inventory:AddItem(player, mineralType, amount)
                table.insert(itemsReceived, amount .. 'x ' .. mineralType)
            end
        end
    end
    
    if #itemsReceived > 0 then
        NotifyPlayer(player, 'Kamu mendapatkan: ' .. table.concat(itemsReceived, ', '), 'success')
    else
        NotifyPlayer(player, 'Kamu tidak mendapatkan apa-apa dari peleburan', 'info')
    end
end)