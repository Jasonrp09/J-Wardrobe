MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS user_outfits (
            id INT AUTO_INCREMENT PRIMARY KEY,
            identifier VARCHAR(60),
            label VARCHAR(50),
            skin LONGTEXT
        )
    ]])
end)

RegisterServerEvent('j_wardrobe:saveOutfit')
AddEventHandler('j_wardrobe:saveOutfit', function(label, skin)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('INSERT INTO user_outfits (identifier, label, skin) VALUES (@identifier, @label, @skin)', {
        ['@identifier'] = xPlayer.identifier,
        ['@label'] = label,
        ['@skin'] = json.encode(skin)
    })
end)

RegisterServerEvent('j_wardrobe:deleteOutfit')
AddEventHandler('j_wardrobe:deleteOutfit', function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('DELETE FROM user_outfits WHERE id = @id AND identifier = @identifier', {
        ['@id'] = id,
        ['@identifier'] = xPlayer.identifier
    })
end)

ESX.RegisterServerCallback('j_wardrobe:getOutfits', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM user_outfits WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(results)
        for i=1, #results do
            results[i].skin = json.decode(results[i].skin)
        end
        cb(results)
    end)
end)
