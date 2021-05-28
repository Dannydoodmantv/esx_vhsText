ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_vhsText:joined')
AddEventHandler('esx_vhsText:joined', function()
	local xPlayer = ESX.GetPlayerFromId(source)
    local name = xPlayer.getName()

    TriggerClientEvent('esx_vhsText:controls', source, name)
end)