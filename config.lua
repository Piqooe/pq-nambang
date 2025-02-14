Config = {
    Mining = {
        zones = {
            {coords = vector3(2979.4795, 2748.2756, 43.5842)},
            {coords = vector3(3003.1985, 2759.9211, 43.0463)},
            {coords = vector3(3003.9536, 2785.5212, 44.5251)}
        },
        Events = {
            -- Rare Stone
            rareStonechance = 0.1, -- 10% chance (ganti sesuai kebutuhan)
            rareStoneItem = 'rare_stone', -- Janlup di tambahin di items.lua
            
            -- Rockslide
            rockslideChance = 0.05, -- 5% chance (ganti sesuai kebutuhan)
            rockslideDamage = 25, -- Damage ke player
            
            -- Bonus Loot
            bonusLootChance = 0.15, -- 15% chance (ganti sesuai kebutuhan)
            bonusMin = 3,
            bonusMax = 8
        },
        Pickaxes = {
            ['pickaxe'] = {
            label = 'Pickaxe Biasa',
            miningSpeed = 1.0, -- Kecepatan dasar
            bonusChance = 0.0, -- Ga dapet bonus
            craftingMaterials = nil -- Gabisa dibuat, pickaxe dasar
            },
            ['iron_pickaxe'] = {
            label = 'Pickaxe Besi',
            miningSpeed = 0.8, -- 20% lebih kenceng
            bonusChance = 0.2, -- 20% kesempatan dapet bonus
            craftingMaterials = {
                iron = 15,
                wood = 5
            }
            },
            ['gold_pickaxe'] = {
            label = 'Pickaxe Emas',
            miningSpeed = 0.6, -- 40% lebih kenceng
            bonusChance = 0.4, -- 40% kesempatan dapet bonus
            craftingMaterials = {
                gold = 12,
                iron = 5,
                wood = 5
            }
            },
            ['diamond_pickaxe'] = {
            label = 'Pickaxe Berlian',
            miningSpeed = 0.4, -- 60% lebih kenceng
            bonusChance = 0.6, -- 60% kesempatan dapet bonus
            craftingMaterials = {
                diamond = 8,
                gold = 5,
                iron = 5,
                wood = 5
            }
            }
        },
        Blacksmith = {
            location = vector3(2952.5969, 2742.9216, 43.5854), -- Sesuaikan koordinat sesuai kebutuhan
            radius = 2,
            label = 'Tukang Besi',
            icon = 'fa-solid fa-hammer',
            distance = 3
        },
        radius = 2,
        label = 'Menambang Batu',
        icon = 'fa-solid fa-hammer',
        distance = 5,
        requiredItem = 'pickaxe',
        miningDifficulty = 0.8,
        itemToAdd = 'stone',
        minQuantity = 5,
        maxQuantity = 10
    },
    Washing = {
        zones = {
            {coords = vector3(1816.1515, 440.6039, 161.0974)},
            {coords = vector3(1820.3456, 435.7890, 160.5621)},
            {coords = vector3(1811.9876, 445.2345, 161.5432)}
        },
        radius = 2,
        label = 'Mencuci Batu',
        icon = 'fa-solid fa-hammer',
        distance = 5,
        requiredStones = 3,
        washingDifficulty = 0.5,
        inputItem = 'stone',
        outputItem = 'washed_stone',
        requiredQuantity = 3
    },
    Smelting = {
        zones = {
            {coords = vector3(1087.9994, -2002.1027, 30.8810)},
            {coords = vector3(1110.8243, -2007.8617, 31.0387)}
        },
        label = 'Melebur Batu',
        icon = 'fa-solid fa-fire',
        distance = 5,
        requiredStones = 5,
        smeltingDifficulty = 0.6,
        inputItem = 'washed_stone',
        
        chances = {
            copper = 0.8,    -- 80% chance
            iron = 0.6,      -- 60% chance
            gold = 0.3,      -- 30% chance
            diamond = 0.1    -- 10% chance
        },
        
        quantities = {
            copper = {min = 10, max = 20},
            iron = {min = 5, max = 12},
            gold = {min = 2, max = 6},
            diamond = {min = 1, max = 2}
        }
    }
}