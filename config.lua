Config = {}
Core = exports.vorp_core:GetCore()
Config.DefaultLifeStyle = "civilian" -- What is returned when lifestyle is null. 
Config.StarterItemsOnlyFirstTime = true -- If true, players can only get starter items once when they first create chararacter. Prevent Exploit.
Config.ChooseLifeStyleOnce = true -- If true, players can only choose lifestyle once. This will automatically turn on Config.StarterItemsOnlyFirstTime

Config.LifeSyles = {
    outlaw = {
        name= "The Outlaw", -- Armadillo
        description=  "A life of crime and rebellion. Rob, smuggle, and live by your own rules, always evading the law.",
        spawnLocation = vector3(-3710.08, -2607.86, -13.41), -- Set to spawn location to spawn at
        spawnHeading = 143.75, -- Set to heading to spawn at
        starterItems = {
            {
                label = "Cattleman Revolver",
                quantity = 1,
                name = 'WEAPON_REVOLVER_CATTLEMAN',
                type = 'weapon'
            },
            {
                label = "Lockpick",
                quantity = 5,
                name = 'lockpick'
            },
            {
                label = "Whiskey Bottle",
                quantity = 5,
                name = 'whisky'
            },
            {
                label = "Cash",
                quantity = 250,
                type = 'money'
            }
        }
    },
    farmer = {
        name= "The Farmer", -- strawberry
        description=  "A person that enjoys farming and planting crops.",
        spawnLocation = vector3(-1783.02, -441.37, 155.23), -- Strawberry
        spawnHeading = 340.68,
        starterItems = {
            {
                label = "Garden Hoe",
                quantity = 1,
                name = 'hoe',
            },
            {
                label = "Campfire",
                quantity = 1,
                name = 'campfire',
            },
            {
                label = "Buckets of Water",
                quantity = 2,
                name = 'wateringcan_cleanwater'
            },
            {
                label = "Cash",
                quantity= 350,
                type = 'money'
            }

        }
    },
    hunter = {
        name= "The Hunter", -- Valentine
        description=  "A self-reliant wanderer who hunts for food, trade, and survival in the wilderness.",
        spawnLocation = vector3(-167.84, 633.53, 114.03),
        spawnHeading = 230.16,
        starterItems = {
            {
                label = "Bow",
                quantity = 1,
                name = 'WEAPON_BOW',
                type = 'weapon'
            },
            {
                label = "Arrows",
                quantity = 3,
                name = 'ammoarrownormal'
            },
            {
                label = "Hunting Knife",
                quantity = 1,
                name = 'WEAPON_MELEE_KNIFE',
                type = 'weapon'
            },
            {
                label = "Cash",
                quantity= 200,
                type = 'money'
            }
        }
    },
    civilian = {
        name= "The Civilian", -- Blackwater
        description=  "An honest worker focused on stability, making a living through trade or craft.",
        spawnLocation = vector3(-868.61, -1329.47, 43.95),
        spawnHeading = 279.09,
        starterItems = {
            {
                label = "Lantern",
                quantity = 1,
                name = 'WEAPON_MELEE_LANTERN',
                type = 'weapon'
            },
            {
                label = "Pocket Watch",
                quantity = 1,
                name = 'pocket_watch'
            },
            {
                label = "Food",
                quantity = 10,
                name = 'consumable_peach'
            },
            {
                label = "Water",
                quantity = 15,
                name = 'consumable_water'
            },
            {
                label = "Cash",
                quantity= 400,
                type = 'money'
            }
        }
    },
}

Config.GiveStarterItems = function(source, id)
    local VORPInv = exports.vorp_inventory
    local user = Core.getUser(source)
    if not user then
        return
    end
    local character = user.getUsedCharacter
    if not Config.LifeSyles[id] or not Config.LifeSyles[id].starterItems then
        return
    end

    for k, v in pairs(Config.LifeSyles[id].starterItems) do
        if v.type == "weapon" then
            local canCarry = VORPInv:canCarryWeapons(source, v.quantity, nil, v.name)
            if not canCarry then
                goto continue
            end

            local result = VORPInv:createWeapon(source, v.name, {})
            if not result then
                goto continue
            end
        elseif v.type == "money" then
            character.addCurrency(0, v.quantity)
        elseif v.type == "gold" then
            character.addCurrency(1, v.quantity)
        elseif v.type == "rol" then
            character.addCurrency(2, v.quantity)
        else
            local itemCheck = VORPInv:getItemDB(v.name)
            local canCarry = VORPInv:canCarryItems(source, v.quantity)
            local canCarry2 = VORPInv:canCarryItem(source, v.name, v.quantity)

            if not itemCheck or not canCarry or not canCarry2 then
                goto continue
            end

            VORPInv:addItem(source, v.name, v.quantity)
        end
        ::continue::
    end
    return true
end


Config.GetUniqueIdentifierForCharacter = function(source)
    local Core = exports.vorp_core:GetCore()
    local user = Core.getUser(source)
    if not user then return end
    local character = user.getUsedCharacter
    return character.charIdentifier
end