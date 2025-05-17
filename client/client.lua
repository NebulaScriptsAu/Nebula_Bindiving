local QBCore = exports["qb-core"]:GetCoreObject()
local searching = false
local Config = require("config")

local function IsPlayerNearSpot()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    for i, spot in pairs(Config.DiveSpots) do
        if #(coords - spot.coords) < Config.Interaction.radius then
            return true, i
        end
    end
    return false, nil
end

local function TryInjury()
    if not Config.Injurysystem.enabled then return end

    lib.callback("lips_bindiving:checkForGloves", false, function(hasProtection)
        if hasProtection then return end

        local roll = math.random(1, 100)
        if roll <= Config.Injurysystem.chance then
            local damage = math.random(Config.Injurysystem.damage.min, Config.Injurysystem.damage.max)
            ApplyDamageToPed(PlayerPedId(), damage, false)

            lib.notify({
                title = "Ouch!",
                description = "You cut yourself on some rusty metal!",
                type = "error"
            })
        end
    end)
end

CreateThread(function()
    while true do
        Wait(0)
        local nearby, spotIndex = IsPlayerNearSpot()
        if nearby and not searching then
            lib.showTextUI(Config.Interaction.text)
            if IsControlJustReleased(0, 38) then -- E key
                lib.callback("lips_bindiving:canSearch", false, function(canSearch)
                    if not canSearch then
                        lib.notify({
                            title = "Nothing Here",
                            description = "Looks like this has already been searched recently...",
                            type = "error"
                        })
                        return
                    end

                    searching = true
                    lib.hideTextUI()
                    FreezeEntityPosition(PlayerPedId(), true)
                    TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)

                    SetTimeout(5000, function()
                        ClearPedTasksImmediately(PlayerPedId())
                        FreezeEntityPosition(PlayerPedId(), false)
                    end)

                    local success = lib.progressBar({
                        duration = Config.Interaction.duration,
                        label = "Searching...",
                        useWhileDead = false,
                        allowRagdoll = false,
                        allowCuffed = false,
                        allowFalling = false,
                        canCancel = true,
                        disable = { move = true, car = true, combat = true },
                    })

                    FreezeEntityPosition(PlayerPedId(), false)
                    ClearPedTasks(PlayerPedId())

                    if success then
                        TriggerServerEvent("lips_bindiving:giveItem", spotIndex)
                        TryInjury()
                    end

                    searching = false
                end, spotIndex)
            end
        else
            lib.hideTextUI()
        end
    end
end)

Citizen.CreateThread(function()
    local info = Config.Blip
    local blip = AddBlipForCoord(info.location.x, info.location.y, info.location.z)

    SetBlipSprite(blip, info.id)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, info.colour)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(info.title)
    EndTextCommandSetBlipName(blip)
end)
