local gunSafetyEnabled = true

--put your melee weapons here
local meleeWeapons = {
    GetHashKey("weapon_unarmed"),
    GetHashKey("weapon_knife"),
    GetHashKey("weapon_nightstick"),
    GetHashKey("weapon_hammer"),
    GetHashKey("weapon_bat"),
    GetHashKey("weapon_golfclub"),
    GetHashKey("weapon_crowbar"),
    GetHashKey("weapon_bottle"),
    GetHashKey("weapon_dagger"),
    GetHashKey("weapon_hatchet"),
    GetHashKey("weapon_knuckle"),
    GetHashKey("weapon_machete"),
    GetHashKey("weapon_switchblade"),
    GetHashKey("weapon_poolcue")
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        local currentWeapon = GetSelectedPedWeapon(playerPed)

        if currentWeapon ~= nil and currentWeapon ~= 0 then
            local weaponType = GetWeapontypeGroup(currentWeapon)
            local isMelee = false

            for _, meleeHash in ipairs(meleeWeapons) do
                if currentWeapon == meleeHash then
                    isMelee = true
                    break
                end
            end

            if gunSafetyEnabled and not isMelee and weaponType ~= -1569615261 then
                DisablePlayerFiring(playerPed, true)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        local currentWeapon = GetSelectedPedWeapon(playerPed)
        local weaponType = GetWeapontypeGroup(currentWeapon)
        local isMelee = false

        for _, meleeHash in ipairs(meleeWeapons) do
            if currentWeapon == meleeHash then
                isMelee = true
                break
            end
        end

        if IsControlJustReleased(0, 311) then
            gunSafetyEnabled = not gunSafetyEnabled
            if gunSafetyEnabled then
                if not isMelee and weaponType ~= -1569615261 then
                    TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Safety on' }) 
                end
            else
                TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Safety off' })
            end
        end
    end
end)