local ESX = exports["es_extended"]:getSharedObject()

-- Function Notif
local function NotifyPlayer(source, message, type)
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Notification',
        description = message,
        type = type
    })
end

-- Random Events Handler
local function HandleRandomEvents(player)
    local eventChance = math.random()
    
    if eventChance <= Config.Mining.Events.rareStonechance then
        if exports.ox_inventory:CanCarryItem(player, Config.Mining.Events.rareStoneItem, 1) then
            exports.ox_inventory:AddItem(player, Config.Mining.Events.rareStoneItem, 1)
            NotifyPlayer(player, 'Kamu menemukan batu langka!', 'success')
        end
    elseif eventChance <= Config.Mining.Events.rockslideChance then
        TriggerClientEvent('pq-job:rockslideEffect', player, Config.Mining.Events.rockslideDamage)
        NotifyPlayer(player, 'Batu runtuh! Kamu terluka dan butuh pertolongan medis!', 'error')
    elseif eventChance <= Config.Mining.Events.bonusLootChance then
        local bonusAmount = math.random(Config.Mining.Events.bonusMin, Config.Mining.Events.bonusMax)
        if exports.ox_inventory:CanCarryItem(player, Config.Mining.itemToAdd, bonusAmount) then
            exports.ox_inventory:AddItem(player, Config.Mining.itemToAdd, bonusAmount)
            NotifyPlayer(player, 'Beruntung! Kamu mendapat ' .. bonusAmount .. ' batu tambahan!', 'success')
        end
    end
end

-- Crafting Event
RegisterNetEvent('pq-job:craftPickaxe', function(pickaxeType)
    local source = source
    local pickaxeData = Config.Mining.Pickaxes[pickaxeType]
    
    if not pickaxeData or not pickaxeData.craftingMaterials then
        return
    end
    
    for material, amount in pairs(pickaxeData.craftingMaterials) do
        if exports.ox_inventory:GetItemCount(source, material) < amount then
            NotifyPlayer(source, 'Bahan tidak cukup!', 'error')
            return
        end
    end
    
    for material, amount in pairs(pickaxeData.craftingMaterials) do
        exports.ox_inventory:RemoveItem(source, material, amount)
    end
    
    if exports.ox_inventory:CanCarryItem(source, pickaxeType, 1) then
        exports.ox_inventory:AddItem(source, pickaxeType, 1)
        NotifyPlayer(source, 'Berhasil membuat ' .. pickaxeData.label, 'success')
    else
        NotifyPlayer(source, 'Inventory penuh!', 'error')
        for material, amount in pairs(pickaxeData.craftingMaterials) do
            exports.ox_inventory:AddItem(source, material, amount)
        end
    end
end)

-- Mining Event
RegisterNetEvent('pq-job:nambangbatu', function(pickaxeType)
    local player = source
    local config = Config.Mining
    local pickaxe = config.Pickaxes[pickaxeType]
    
    if not pickaxe then
        NotifyPlayer(player, 'Pickaxe tidak valid!', 'error')
        return
    end
    
    local item = exports.ox_inventory:GetItem(player, pickaxeType)
    if not item or item.count <= 0 then
        NotifyPlayer(player, 'Kamu butuh ' .. pickaxe.label .. ' buat nambang!', 'error')
        return
    end
    
    local stoneQuantity = math.random(config.minQuantity, config.maxQuantity)
    
    if math.random() <= pickaxe.bonusChance then
        stoneQuantity = stoneQuantity + math.random(1, 3)
    end
    
    if exports.ox_inventory:CanCarryItem(player, config.itemToAdd, stoneQuantity) then
        exports.ox_inventory:AddItem(player, config.itemToAdd, stoneQuantity)
        NotifyPlayer(player, 'Kamu mendapatkan ' .. stoneQuantity .. ' batu', 'success')
        
        HandleRandomEvents(player)
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