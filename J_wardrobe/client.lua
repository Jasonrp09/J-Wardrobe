ESX = exports['es_extended']:getSharedObject()
Config = Config or {}


CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local sleep = 1500
        for _,v in pairs(Config.OutfitPoints) do
            if v.job == nil or ESX.GetPlayerData().job.name == v.job then
                local dist = #(playerCoords - v.coords)
                if dist < 10.0 then
                    sleep = 1
                    DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 200, 255, 150, false, false, 2, false, nil, nil, false)
                    if dist < 1.5 then
                        ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ für das Outfit-Menü")
                        if IsControlJustReleased(0, 38) then
                            OpenMainOutfitMenu()
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)


function OpenMainOutfitMenu()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'main_outfit_menu', {
        css = 'skin_menu',
        title = 'Kleiderschrank',
        align = 'top-left',
        elements = {
            {label = '🧥 Outfits ansehen', value = 'view'},
            {label = '💾 Outfit speichern', value = 'save'},
            {label = '🗑️ Outfit löschen', value = 'delete'}
        }
    }, function(data, menu)
        if data.current.value == 'view' then
            OpenOutfitView()
        elseif data.current.value == 'save' then
            SaveCurrentOutfit()
        elseif data.current.value == 'delete' then
            OpenOutfitDelete()
        end
    end, function(data, menu)
        menu.close()
    end)
end


function OpenOutfitView()
    ESX.TriggerServerCallback('j_wardrobe:getOutfits', function(outfits)
        local elements = {}

        for i=1, #outfits, 1 do
            table.insert(elements, {
                label = outfits[i].label,
                value = outfits[i]
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'outfit_view', {
            css = 'skin_menu',
            title = 'Outfits',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            LoadOutfit(data.current.value.skin)
        end, function(data, menu)
            menu.close()
        end)
    end)
end


function OpenOutfitDelete()
    ESX.TriggerServerCallback('j_wardrobe:getOutfits', function(outfits)
        local elements = {}

        for i=1, #outfits, 1 do
            table.insert(elements, {
                label = outfits[i].label,
                value = outfits[i].id
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'outfit_delete', {
            css = 'skin_menu',
            title = 'Outfit löschen',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            DeleteOutfit(data.current.value)
            menu.close()
            Wait(250)
            OpenOutfitDelete()
        end, function(data, menu)
            menu.close()
        end)
    end)
end


function SaveCurrentOutfit()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_label', {
            title = 'Name des Outfits'
        }, function(data, menu)
            local name = tostring(data.value)
            if name and name ~= '' then
                TriggerServerEvent('j_wardrobe:saveOutfit', name, skin)
                ESX.ShowNotification('Outfit ~b~' .. name .. '~s~ gespeichert.')
                menu.close()
            else
                ESX.ShowNotification('~r~Ungültiger Name.')
            end
        end, function(data, menu)
            menu.close()
        end)
    end)
end


function LoadOutfit(skin)
    TriggerEvent('skinchanger:loadSkin', skin)
end


function DeleteOutfit(id)
    TriggerServerEvent('j_wardrobe:deleteOutfit', id)
    ESX.ShowNotification('Outfit gelöscht.')
end
