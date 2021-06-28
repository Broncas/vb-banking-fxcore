FX = nil

TriggerEvent('fx:get', function(core) FX = core end)

FX.RegisterCallback('vb-banking:server:GetPlayerName', function(source, cb)
	local _char = FX.GetPlayerById(source)
	local _charname = _char:Player().getName()
	cb(_charname)
end)

RegisterServerEvent('vb-banking:server:depositvb')
AddEventHandler('vb-banking:server:depositvb', function(amount, inMenu)
	local _src = source
	local _char = FX.GetPlayerById(_src)
	amount = tonumber(amount)
	Citizen.Wait(50)
	if amount == nil or amount <= 0 or amount > _char:Cash().get() then
		TriggerClientEvent('chatMessage', _src, "Cantidad Inválida.")
	else
		_char.Cash().removeCash(amount)
		_char.Bank().addBank(tonumber(amount))
		_char.Notification("Has ingresado $"..amount)
	end
end)

RegisterServerEvent('vb-banking:server:withdrawvb')
AddEventHandler('vb-banking:server:withdrawvb', function(amount, inMenu)
	local _src = source
	local _char = FX.GetPlayerById(_src)
	local _base = 0
	amount = tonumber(amount)
	_base = _char.Bank().get()
	Citizen.Wait(100)
	if amount == nil or amount <= 0 or amount > _base then
		TriggerClientEvent('chatMessage', _src, "Cantidad Inválida")
	else
		_char.Bank().removeBank(amount, cb)
		_char.Cash().addCash(amount)
		_char.Notification("Has retirado $"..amount)
	end
end)

RegisterServerEvent('vb-banking:server:balance')
AddEventHandler('vb-banking:server:balance', function(inMenu)
	local _src = source
	local _char = FX.GetPlayerById(_src)
	local balance = _char.Bank().get()
	TriggerClientEvent('vb-banking:client:refreshbalance', _src, balance)
end)

RegisterServerEvent('vb-banking:server:transfervb')
AddEventHandler('vb-banking:server:transfervb', function(to, amountt, inMenu)
	local _source = source
	local xPlayer = FX.GetPlayerById(_src)
	local zPlayer = FX.GetPlayerById(to)
	local balance = 0
	if zPlayer ~= nil then
		balance = xPlayer:Bank().get()
		if tonumber(_source) == tonumber(to) then
			TriggerClientEvent('chatMessage', _source, "No te puedes transferir dinero a ti mismo")	
		else
			if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <= 0 then
				TriggerClientEvent('chatMessage', _source, "No tienes suficiente dinero en el banco.")
			else
				xPlayer:Bank().removeBank(tonumber(amountt))
				zPlayer:Bank().addBank(tonumber(amountt))
				zPlayer.Notification("Te han enviado una transferencia de "..amountt.."€ por parte de la ID: ".._source)
				xPlayer.Notification("Has enviado una transferencia de "..amountt.."€ a la ID: "..to)
			end
		end
	else
		TriggerClientEvent('chatMessage', _source, "That Wallet ID is invalid or doesn't exist")
	end
end)
