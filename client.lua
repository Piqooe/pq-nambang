local ESX = exports["es_extended"]:getSharedObject()

-- Function Notif
local function ShowNotification(message, type)
    lib.notify({
        title = 'Notification',
        description = message,
        type = type
    })
end

-- Function MiniGames
local function StartMiningGame(difficulty, successCallback)
    exports['boii_minigames']:button_mash({
        style = 'default',
        difficulty = difficulty
    }, function(success)
        if success then
            successCallback()
        else
            lib.notify({
                title = 'Notification',
                description = 'Gagal',
                type = 'error'
            })
        end
    end)
end

-- Function GetMiningDuration
local function GetMiningDuration(pickaxeType)
    local baseTime = 10000
    local pickaxe = Config.Mining.Pickaxes[pickaxeType]
    if pickaxe then
        return baseTime * pickaxe.miningSpeed
    end
    return baseTime
end

-- Function OpenBlacksmithMenu
local function OpenBlacksmithMenu()
    local options = {}
    
    for pickaxeType, data in pairs(Config.Mining.Pickaxes) do
        if data.craftingMaterials then
            local option = {
                title = 'Craft ' .. data.label,
                description = 'Buat ' .. data.label,
                onSelect = function()
                    local hasMaterials = true
                    local materialsText = ''
                    
                    for material, amount in pairs(data.craftingMaterials) do
                        local count = exports.ox_inventory:GetItemCount(material)
                        if count < amount then
                            hasMaterials = false
                        end
                        materialsText = materialsText .. material .. ': ' .. amount .. '\n'
                    end
                    
                    if hasMaterials then
                        if lib.progressBar({
                            duration = 5000,
                            label = 'Membuat ' .. data.label,
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                move = true,
                                car = true,
                                combat = true
                            },
                            anim = {
                                dict = 'mini@repair',
                                clip = 'fixing_a_ped'
                            },
                        }) then
                            TriggerServerEvent('pq-job:craftPickaxe', pickaxeType)
                        end
                    else
                        ShowNotification('Bahan tidak cukup!\nDibutuhkan:\n' .. materialsText, 'error')
                    end
                end
            }
            table.insert(options, option)
        end
    end
    
    lib.registerContext({
        id = 'blacksmith_menu',
        title = 'Tukang Besi',
        options = options
    })
    
    lib.showContext('blacksmith_menu')
end

-- Create Blacksmith Zone
CreateThread(function()
    exports.ox_target:addSphereZone({
        coords = Config.Mining.Blacksmith.location,
        radius = Config.Mining.Blacksmith.radius,
        options = {{
            label = Config.Mining.Blacksmith.label,
            icon = Config.Mining.Blacksmith.icon,
            distance = Config.Mining.Blacksmith.distance,
            onSelect = function()
                OpenBlacksmithMenu()
            end
        }}
    })
end)

-- Mining Zone
local function createMiningZone(zone)
    exports.ox_target:addSphereZone({
        coords = zone.coords,
        radius = Config.Mining.radius,
        options = {{
            label = Config.Mining.label,
            name = 'menambangbatu',
            icon = Config.Mining.icon,
            distance = Config.Mining.distance,
            -- items = {'pickaxe', 'iron_pickaxe', 'gold_pickaxe', 'diamond_pickaxe'},
            onSelect = function()
                local bestPickaxe = 'pickaxe'
                for pickaxeType, _ in pairs(Config.Mining.Pickaxes) do
                    if exports.ox_inventory:GetItemCount(pickaxeType) > 0 then
                        bestPickaxe = pickaxeType
                    end
                end
                
                ExecuteCommand('e mechanic')           
                StartMiningGame(Config.Mining.miningDifficulty, function()
                    if lib.progressBar({
                        duration = GetMiningDuration(bestPickaxe),
                        label = 'Menambang Batu',
                        useWhileDead = false,
                        canCancel = true,
                        disable = { move = true, combat = true, car = true },
                        anim = {
                            dict = 'amb@world_human_hammering@male@base', 
                            clip = 'base',
                        },
                        prop = {
                            bone = 57005, 
                            model = 'prop_tool_pickaxe', 
                            pos = vec3(0.09, -0.53, -0.22), 
                            rot = vec3(252.0, 180.0, 0.0)
                        },
                    }) then
                        TriggerServerEvent('pq-job:nambangbatu', bestPickaxe)
                    else
                        ShowNotification('Penambangan dibatalkan', 'error')
                    end
                    ExecuteCommand('e c')
                end)
            end
        }}
    })
end

-- Washing Zone
local function createWashingZone(zone)
    lib.points.new({
        coords = zone.coords,
        distance = Config.Washing.distance,
        onEnter = function()
            lib.showTextUI('[E] - ' .. Config.Washing.label, {
                position = "right-center", 
                icon = Config.Washing.icon, 
            })
        end,
        onExit = function()
            lib.hideTextUI()
        end,
        nearby = function()
            if IsControlJustPressed(0, 38) then
                local stoneCount = exports.ox_inventory:GetItemCount('stone')
                if stoneCount < Config.Washing.requiredStones then
                    ShowNotification('Kamu membutuhkan minimal ' .. Config.Washing.requiredStones .. ' batu', 'error')
                else
                    ExecuteCommand('e mechanic')    
                    StartMiningGame(Config.Washing.washingDifficulty, function()
                        if lib.progressBar({
                            duration = 10000,
                            label = 'Mencuci Batu',
                            useWhileDead = false,
                            canCancel = true,
                            disable = { move = true, combat = true, car = true },
                        }) then
                            TriggerServerEvent('pq-job:cucibatu')
                        else
                            ShowNotification('Pencucian dibatalkan', 'error')
                        end
                        ExecuteCommand('e c')
                    end)
                end
            end
        end
    })
end

-- Smelting Zone
local function createSmeltingZone(zone)
    lib.points.new({
        coords = zone.coords,
        distance = Config.Smelting.distance,
        onEnter = function()
            lib.showTextUI('[E] - ' .. Config.Smelting.label, {
                position = "right-center",
                icon = Config.Smelting.icon,
            })
        end,
        onExit = function()
            lib.hideTextUI()
        end,
        nearby = function()
            if IsControlJustPressed(0, 38) then
                local washedStoneCount = exports.ox_inventory:GetItemCount('washed_stone')
                if washedStoneCount < Config.Smelting.requiredStones then
                    ShowNotification('Kamu membutuhkan minimal ' .. Config.Smelting.requiredStones .. ' batu cuci', 'error')
                else
                    ExecuteCommand('e mechanic')    
                    StartMiningGame(Config.Smelting.smeltingDifficulty, function()
                        if lib.progressBar({
                            duration = 15000,
                            label = 'Melebur Batu',
                            useWhileDead = false,
                            canCancel = true,
                            disable = { move = true, combat = true, car = true },
                        }) then
                            TriggerServerEvent('pq-job:leburbatu')
                        else
                            ShowNotification('Peleburan dibatalkan', 'error')
                        end
                        ExecuteCommand('e c')
                    end)
                end
            end
        end
    })
end

-- RockSlide Event
RegisterNetEvent('pq-job:rockslideEffect')
AddEventHandler('pq-job:rockslideEffect', function(damage)
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    
    SetPedToRagdoll(ped, 2000, 2000, 0, true, true, false)
    
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.8)
    
    local coords = GetEntityCoords(ped)
    UseParticleFxAssetNextCall('core')
    StartParticleFxNonLoopedAtCoord('ent_sht_rockdust', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false)
    
    Wait(1000)
    SetEntityHealth(ped, health - damage)
    
    StartScreenEffect("DeathFailOut", 0, false)
    Wait(1500)
    StopScreenEffect("DeathFailOut")
end)

CreateThread(function()
    for _, zone in ipairs(Config.Mining.zones) do
        createMiningZone(zone)
    end
    
    for _, zone in ipairs(Config.Washing.zones) do
        createWashingZone(zone)
    end

    for _, zone in ipairs(Config.Smelting.zones) do
        createSmeltingZone(zone)
    end
end)