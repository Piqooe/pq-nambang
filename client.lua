local ESX = exports["es_extended"]:getSharedObject()
local spawnedProps = {}
local maxProps = 25
local spawnedStones = 0

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
            items = Config.Mining.requiredItem,
            onSelect = function()
                ExecuteCommand('e mechanic')           
                StartMiningGame(Config.Mining.miningDifficulty, function()
                    if lib.progressBar({
                        duration = 10000,
                        label = 'Menambang Batu',
                        useWhileDead = false,
                        canCancel = true,
                        disable = { move = true, combat = true, car = true },
                        anim = {
                            dict = 'amb@world_human_hammering@male@base', 
                            clip = 'base',
                        },
                        prop = {
                            bone = 57005, model = 'prop_tool_pickaxe', 
                            pos = vec3(0.09, -0.53, -0.22), 
                            rot = vec3(252.0, 180.0, 0.0)
                        },
                    }) then
                        TriggerServerEvent('pq-job:nambangbatu')
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