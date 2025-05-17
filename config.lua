local Config = {}

-- Webhook URL
Config.Webhook = "WEBHOOK_HERE" -- Discord webhook for logging, set to Config.Webhook = false if you dont want to use
Config.CooldownTime = 15 * 60 -- 15 minutes
Config.MaxRequests = 10       -- max allowed requests per timeout period (Logged as cheat detection)
Config.RequestTimeout = 10    -- seconds to reset count

Config.Injurysystem = {
    enabled = true,
    protectiveItem = "gloves",          -- Item that protects from injury (ox_inventory)
    chance = 35,                        -- Percent chance to get cut
    damage = {
        min = 5,                        -- Min HP to lose
        max = 15                        -- Max HP to lose
    }
}


Config.Blip = {
    title = 'Bin Diving',                    -- Title For Blip
    colour = 2,                              -- Colour for blip
    id = 677,                                -- Blip Sprite
    location = vec3(-447.27, -1720.9, 18.64) -- Blip location
}

Config.Interaction = {
    text = "[E] - Search threw rubble", -- Text show on TextUI
    radius = 2.0,                       -- Radius of the TextUI
    duration = 5000,                    -- Time it takes to search in milliseconds
}

-- Dive locations
Config.DiveSpots = {
    [1] = { coords = vec3(-422.29, -1702.27, 21.98) }, -- These are defualt locations, change acordingly.
    [2] = { coords = vec3(-439.33, -1723.96, 19.88) },
    [3] = { coords = vec3(-422.11, -1721.33, 20.26) },
    [4] = { coords = vec3(-476.19, -1690.89, 21.19) },
    [5] = { coords = vec3(-476.19, -1690.89, 21.19) },
    [6] = { coords = vec3(-474.01, -1677.62, 19.08) },
    [7] = { coords = vec3(-443.88, -1676.64, 20.02) },
    [8] = { coords = vec3(-454.89, -1678.54, 20.06) },
    [9] = { coords = vec3(-473.31, -1728.48, 19.06) },
    [10] = { coords = vec3(-481.4, -1748.02, 18.7) },
    [11] = { coords = vec3(-488.73, -1749.14, 18.72) },
    [12] = { coords = vec3(-509.46, -1745.1, 19.8) },
    [13] = { coords = vec3(-498.73, -1723.75, 20.31) },
    [14] = { coords = vec3(-503.3, -1703.83, 19.48) },
    [15] = { coords = vec3(-511.86, -1694.23, 19.56) },
    [16] = { coords = vec3(-522.51, -1673.03, 22.44) },
    [17] = { coords = vec3(-515.68, -1677.72, 19.48) },
    [18] = { coords = vec3(-529.0, -1704.88, 20.73) },
    [19] = { coords = vec3(-532.89, -1702.52, 20.48) },
    [20] = { coords = vec3(-536.8, -1705.81, 19.64) },
    [21] = { coords = vec3(-555.45, -1711.72, 20.24) },
    [22] = { coords = vec3(-556.86, -1714.66, 21.56) },
    [23] = { coords = vec3(-571.46, -1697.11, 20.15) },
    [24] = { coords = vec3(-576.74, -1687.75, 21.42) },
    [25] = { coords = vec3(-574.93, -1682.35, 19.57) },
    [26] = { coords = vec3(-570.42, -1674.39, 20.53) },
    [27] = { coords = vec3(-566.99, -1674.92, 21.48) },
    [28] = { coords = vec3(-558.29, -1669.34, 21.57) },
    [29] = { coords = vec3(-554.83, -1671.76, 20.36) },
    [30] = { coords = vec3(-552.98, -1673.75, 21.61) },
    [31] = { coords = vec3(-563.86, -1655.26, 19.36) },
    [32] = { coords = vec3(-559.77, -1646.22, 22.14) },
    [33] = { coords = vec3(-566.34, -1634.39, 20.71) },
    [34] = { coords = vec3(-536.64, -1632.78, 22.08) },
    [35] = { coords = vec3(-527.15, -1620.67, 17.96) },
    [36] = { coords = vec3(-524.54, -1622.57, 17.96) },
    [37] = { coords = vec3(-519.78, -1622.6, 17.96) },
    [38] = { coords = vec3(-519.71, -1637.36, 20.16) },
    [39] = { coords = vec3(-507.67, -1633.41, 20.11) },
    [40] = { coords = vec3(-505.35, -1636.19, 19.14) },
    [41] = { coords = vec3(-495.71, -1641.59, 17.96) },
    [42] = { coords = vec3(-486.43, -1642.36, 19.17) },
    [43] = { coords = vec3(-476.81, -1654.79, 18.83) },
    [44] = { coords = vec3(-585.81, -1670.94, 19.52) },
    [45] = { coords = vec3(-599.67, -1667.3, 19.83) },
    [46] = { coords = vec3(-586.78, -1654.55, 20.47) },
    [47] = { coords = vec3(-589.2, -1652.13, 21.72) },
    [48] = { coords = vec3(-599.73, -1667.27, 19.83) },
    [49] = { coords = vec3(-601.21, -1677.1, 19.64) },
    [50] = { coords = vec3(-603.91, -1679.0, 19.71) },
    [51] = { coords = vec3(-609.33, -1689.64, 21.82) },
}

Config.Rewards = {
    -- { item = "CHANGE_ME", chance = 100, min = 1, max = 3 },
    { item = "tyre", chance = 25, min = 1, max = 3 }, --  These are defualt items, change acordingly.
    { item = "car_radio", chance = 25, min = 1, max = 3 },
    { item = "car_engine", chance = 25, min = 1, max = 5 },
    { item = "spoiler", chance = 25, min = 1, max = 4 },
    { item = "car_grill", chance = 25, min = 1, max = 3 },
    { item = "car_rim", chance = 25, min = 1, max = 4 },
    { item = "spark_plugs", chance = 25, min = 1, max = 12 },
    { item = "car_door", chance = 25, min = 1, max = 1 },
    { item = "fuel_cap", chance = 25, min = 1, max = 1 },
    { item = "car_hood", chance = 25, min = 1, max = 1 },
    { item = "rubber", chance = 25, min = 1, max = 5 },
}

Config.RareChance = 10 -- %5 chance
Config.RareAmount = 2 -- quantity if successful
Config.RareItems = {
    'bullet_casings',
    'blueprint_fragment',
    'metalscrap',
}


return Config
