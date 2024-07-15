local displayIDs = false

-- Key controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlPressed(0, Config.Key) then
            if not displayIDs then
                displayIDs = true
            end
        else
            if displayIDs then
                displayIDs = false
            end
        end
    end
end)

-- Display IDs
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if displayIDs then
            local players = GetActivePlayers()
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            for _, playerId in ipairs(players) do
                local targetPed = GetPlayerPed(playerId)
                if targetPed ~= playerPed then
                    local targetCoords = GetEntityCoords(targetPed)
                    local distance = #(playerCoords - targetCoords)
                    if distance <= Config.Distance then
                        local playerIdText = GetPlayerServerId(playerId)
                        DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 1.0, tostring(playerIdText))
                    end
                end
            end
        end
    end
end)

-- Function to draw 3D text
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextOutline()
    SetTextColour(Config.IDColor[1], Config.IDColor[2], Config.IDColor[3], Config.IDColor[4])
    AddTextComponentString(text)
    DrawText(_x, _y)
end