local QBCore = exports['qb-core']:GetCoreObject()
local Config = require("config")

local requestCounts = {}
local locationTimers = {}
local requestTimeout = Config.RequestTimeout
local maxRequests = Config.MaxRequests
local cooldownSeconds = Config.CooldownTime

-- Main drop generator
local function GetMultipleRewards()
    local results = {}
    local maxRewards = math.random(1, 1)

    for i = 1, maxRewards do
        for _, reward in ipairs(Config.Rewards) do
            local roll = math.random(1, 100)
            if roll <= reward.chance then
                local amount = math.random(reward.min, reward.max)
                table.insert(results, { item = reward.item, amount = amount, rare = false })
                break
            end
        end
    end

    local rareRoll = math.random(1, 100)
    if rareRoll <= Config.RareChance then
        local rareItem = Config.RareItems[math.random(#Config.RareItems)]
        table.insert(results, {
            item = rareItem,
            amount = Config.RareAmount,
            rare = true
        })
    end

    return results
end

-- Discord logging
local function SendWebhookLog(player, rewards, wasTriggered, locId)
    if not Config.Webhook or Config.Webhook == "" then return end

    local identifiers = player.PlayerData.citizenid or "Unknown"
    local discord = "N/A"
    for _, id in pairs(GetPlayerIdentifiers(player.PlayerData.source)) do
        if string.find(id, "discord:") then
            discord = string.gsub(id, "discord:", "")
            break
        end
    end

    local description = wasTriggered and (
        ("**%s** may be abusing the bindiving trigger (Location ID: %s)!"):format(player.PlayerData.name, tostring(locId))
    ) or (
        ("**%s** has completed a dive search at location ID %s!"):format(player.PlayerData.name, tostring(locId))
    )

    local fields = {
        { name = "Player Name", value = player.PlayerData.name, inline = true },
        { name = "Citizen ID", value = identifiers, inline = true },
        { name = "Discord ID", value = discord, inline = true },
        { name = "Location ID", value = tostring(locId), inline = true }
    }

    if not wasTriggered and rewards then
        for _, reward in ipairs(rewards) do
            local label = QBCore.Shared.Items[reward.item] and QBCore.Shared.Items[reward.item].label or reward.item
            table.insert(fields, {
                name = reward.rare and ("🗑️Rare: " .. label) or label,
                value = tostring(reward.amount),
                inline = true
            })
        end
    else
        table.insert(fields, { name = "Item", value = "None", inline = true })
        table.insert(fields, { name = "Amount", value = "0", inline = true })
    end

    local embed = {
        {
            title = wasTriggered and ":warning: Trigger Abuse Detected" or ":wastebasket: Bindiving Reward Log",
            color = wasTriggered and 16711680 or 1752220,
            description = description,
            fields = fields,
            footer = { text = os.date("%Y-%m-%d %H:%M:%S") },
        }
    }

    PerformHttpRequest(Config.Webhook, function() end, "POST", json.encode({ embeds = embed }), {
        ["Content-Type"] = "application/json"
    })
end

-- Main event
RegisterNetEvent("lips_bindiving:giveItem", function(locationId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player or not locationId then
        print("Exploit attempt: Invalid player or location!")
        return
    end

    local now = os.time()
    if locationTimers[locationId] and now < locationTimers[locationId] then
        SendWebhookLog(Player, nil, true, locationId)
        return
    end

    requestCounts[src] = requestCounts[src] or { count = 2, last = now }
    local info = requestCounts[src]

    if now - info.last > requestTimeout then
        info.count = 5
        info.last = now
    else
        info.count = info.count + 2
    end

    if info.count > maxRequests then
        SendWebhookLog(Player, nil, true, locationId)
        return
    end

    locationTimers[locationId] = now + cooldownSeconds

    local rewards = GetMultipleRewards()
    if #rewards > 0 then
        for _, reward in ipairs(rewards) do
            Player.Functions.AddItem(reward.item, reward.amount)

            local label = QBCore.Shared.Items[reward.item] and QBCore.Shared.Items[reward.item].label or reward.item

            TriggerClientEvent("ox_lib:notify", src, {
                title = reward.rare and "Rare Find!" or "You found something!",
                description = ('You found %sx %s'):format(reward.amount, label),
                type = reward.rare and "inform" or "success"
            })
        end
        SendWebhookLog(Player, rewards, false, locationId)
    else
        TriggerClientEvent("ox_lib:notify", src, {
            title = "Nothing Found",
            description = "You didn't find anything this time.",
            type = "error"
        })
    end
end)

-- Injury item check using ox_inventory
lib.callback.register('lips_bindiving:checkForGloves', function(source)
    local item = exports.ox_inventory:Search(source, 'count', Config.Injurysystem.protectiveItem)
    return item > 0
end)

-- Spot cooldown
lib.callback.register('lips_bindiving:canSearch', function(source, locationId)
    local now = os.time()
    if not locationTimers[locationId] or now >= locationTimers[locationId] then
        return true
    end
    return false
end)
