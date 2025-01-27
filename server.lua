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
    local source = source
    local stoneQuantity = math.random(Config.Mining.minQuantity, Config.Mining.maxQuantity)
    
    if exports.ox_inventory:CanCarryItem(source, Config.Mining.itemToAdd, stoneQuantity) then
        exports.ox_inventory:AddItem(source, Config.Mining.itemToAdd, stoneQuantity)
        NotifyPlayer(source, 'Kamu mendapatkan ' .. stoneQuantity .. ' batu')
    else
        NotifyPlayer(source, 'KANTONG MU PENUH!')
    end
end)

-- Stone Washing Event
RegisterNetEvent('pq-job:cucibatu', function()
    local source = source
    if exports.ox_inventory:CanCarryItem(source, Config.Washing.outputItem, Config.Washing.requiredQuantity) then
        exports.ox_inventory:RemoveItem(source, Config.Washing.inputItem, Config.Washing.requiredQuantity)
        exports.ox_inventory:AddItem(source, Config.Washing.outputItem, Config.Washing.requiredQuantity)
    else
        NotifyPlayer(source, 'KANTONG MU PENUH!')
    end
end)

-- Smelting Event
RegisterNetEvent('pq-job:leburbatu', function()
    local source = source
    
    if not exports.ox_inventory:RemoveItem(source, Config.Smelting.inputItem, Config.Smelting.requiredStones) then
        NotifyPlayer(source, 'Kamu tidak memiliki cukup batu cuci!', 'error')
        return
    end
    
    local minerals = {
        {
            item = 'copper',
            chance = Config.Smelting.chances.copper,
            min = Config.Smelting.quantities.copper.min,
            max = Config.Smelting.quantities.copper.max
        },
        {
            item = 'iron',
            chance = Config.Smelting.chances.iron,
            min = Config.Smelting.quantities.iron.min,
            max = Config.Smelting.quantities.iron.max
        },
        {
            item = 'gold',
            chance = Config.Smelting.chances.gold,
            min = Config.Smelting.quantities.gold.min,
            max = Config.Smelting.quantities.gold.max
        },
        {
            item = 'diamond',
            chance = Config.Smelting.chances.diamond,
            min = Config.Smelting.quantities.diamond.min,
            max = Config.Smelting.quantities.diamond.max
        }
    }
    
    local itemsReceived = {}
    
    for _, mineral in ipairs(minerals) do
        if math.random() <= mineral.chance then
            local quantity = math.random(mineral.min, mineral.max)
            if quantity > 0 then
                if exports.ox_inventory:CanCarryItem(source, mineral.item, quantity) then
                    exports.ox_inventory:AddItem(source, mineral.item, quantity)
                    table.insert(itemsReceived, quantity .. 'x ' .. mineral.item)
                else
                    NotifyPlayer(source, 'KANTONG MU PENUH!', 'error')
                    return
                end
            end
        end
    end
    
    if #itemsReceived > 0 then
        NotifyPlayer(source, 'Kamu mendapatkan: ' .. table.concat(itemsReceived, ', '), 'success')
    else
        NotifyPlayer(source, 'Kamu tidak mendapatkan apa-apa dari peleburan', 'info')
    end
end)