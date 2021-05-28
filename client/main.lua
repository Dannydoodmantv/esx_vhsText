local showJob = nil

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  Citizen.Wait(2000)
  TriggerServerEvent('esx_vhsText:joined')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
  Citizen.Wait(2000)
  TriggerServerEvent('esx_vhsText:joined')
end)

function formatTime(data)
	for i=1, #data do
		local v = data[i]
		if v <= 9 then
			data[i] = "0"..v
		end
	end
	return data
end

local axonOn = true

RegisterNetEvent('esx_vhsText:controls')
AddEventHandler('esx_vhsText:controls', function(name)
	if PlayerData.job and PlayerData.job.name == 'police' or PlayerData.job.name == 'sheriff' and axonOn then
		showJob = 'none'
			rank = Config.Ranks[PlayerData.job.grade_name]
			if rank then
				showJob = rank..' '..name
			end
			SendNUIMessage({
				action  = 'changeJob',
				data = showJob
			})
		else
			SendNUIMessage({
			action  = 'changeJob',
			data = 'none'
		})
	end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    if (PlayerData ~= nil) and (PlayerData.job.name == 'police' or PlayerData.job.name == 'sheriff') and axonOn then
      hour = GetClockHours()
      minute = GetClockMinutes()
      month = GetClockMonth()
	  dayOfMonth = GetClockDayOfMonth()

      local type = ' AM'
      if hour == 0 or hour == 24 then
        hour = 12
        type = ' AM'
      elseif hour >= 13 then
        hour = hour - 12
        type = ' PM'
      end

			minute, month, dayOfMonth, hour = table.unpack(formatTime({minute, month, dayOfMonth, hour}))
      local formatted = dayOfMonth..'/'..month..'/2021'..' '..hour..':'..minute..type
      SendNUIMessage({
        action  = 'changeTime',
        data = formatted
      })
    end
    Citizen.Wait(1000)
  end
end)
