local ShowNotification = function(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end

local ShowHelpText = function(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

Citizen.CreateThread(function()
    while true do
        local playerWait = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local vehicle = GetClosestVehicle(playerCoords, 10.0, 0, 391551)

        if DoesEntityExist(vehicle) and not IsEntityDead(playerPed) and IsEntityInWater(vehicle) then
            playerWait = 5
            local vehicleModel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))

            if Config.Boats[vehicleModel] then

                local offset = Config.Boats[vehicleModel]
                local offsetCoords = GetOffsetFromEntityInWorldCoords(vehicle, offset.x, offset.y, offset.z)
                local distance = GetDistanceBetweenCoords(playerCoords, offsetCoords)

                if Config.DrawMarker then
                    DrawMarker(1, offsetCoords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.size.x, Config.Marker.size.y, Config.Marker.size.z, Config.Marker.color.r, Config.Marker.color.g, Config.Marker.color.b, Config.Marker.color.a, false, true, 2, false, false, false, false)
                end

                if distance < 1.0 then
                    local isBoatAnchored = IsBoatAnchoredAndFrozen(vehicle)

                    if isBoatAnchored then
                        ShowHelpText("Appuyez sur ~INPUT_PICKUP~ pour remonter l'ancre du bateau.")
                        if IsControlJustReleased(0, 38) then
                            SetBoatAnchor(vehicle, false)
                            ShowNotification("Vous remontez l'ancre du bateau.")
                        end
                    elseif not isBoatAnchored then
                        ShowHelpText("Appuyez sur ~INPUT_PICKUP~ pour descendre l'ancre du bateau.")
                        if IsControlJustReleased(0, 38) then
                            local vehicleSpeed = GetEntitySpeed(vehicle)

                            if GetEntitySpeed(vehicle) < 3.0 then
                                SetBoatAnchor(vehicle, true)
                                ShowNotification("Vous descendez l'ancre du bateau.")
                            else
                                ShowNotification("Reduisez la vitesse du bateau pour descendre l'ancre.")
                            end
                        end
                    end
                end
            end
        end

        Citizen.Wait(playerWait)
    end
end)