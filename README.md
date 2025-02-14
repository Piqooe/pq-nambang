# SCRIPT JOB MENAMBANG FIVEM [ESX]
Simple script mining job for Fivem

## Fitur yang di dapatkan (akan update terus jika banyak peminat)
- Mining Zone
    - Batu Langka
    - Batu Runtuh
    - Bonus Loot
- Pickaxe Bisa di Upgrade
    - Blacksmith
- Washing Zone
- Smelting Zone
- Ez Config (Semoga)

## Dependencies
- [Ox Lib](https://github.com/overextended/ox_lib) - Untuk Lib Menu
- [Ox Inventory](https://github.com/overextended/ox_inventory) - Untuk Akses Inventory
- [Ox Target](https://github.com/overextended/ox_target) - Untuk Akses Target (otot mata)
- [BOII MINIGAMES](https://github.com/boiidevelopment/boii_minigames) - Untuk minigames

## Cara Install
1. Import ```pq-nambang``` ke folder resources server kalian
2. Tambahkan code di bawah ini ke ```ox_inventory > data > items.lua```
```lua
    ['pickaxe'] = {
        label = 'Pickaxe',
        weight = 5000,
        stack = false,
        close = true,
        description = 'Alat untuk menambang batu (paling lemah)',
    },
    ['iron_pickaxe'] = {
        label = 'Pickaxe Besi',
        weight = 5000,
        stack = false,
        close = true,
        description = 'Alat untuk menambang batu (menengah)',
    },
    ['gold_pickaxe'] = {
        label = 'Pickaxe Emas',
        weight = 5000,
        stack = false,
        close = true,
        description = 'Alat untuk menambang batu (tinggi)',
    },
    ['diamond_pickaxe'] = {
        label = 'Pickaxe Berlian',
        weight = 5000,
        stack = false,
        close = true,
        description = 'Alat untuk menambang batu (paling gacor)',
    }
```
3. Sesuaikan/Konfigurasi kan script di ```config.lua``` sesuai dengan kebutuhan kalian
4. Enjoy the script!

## Preview
Cooming Soon
