function onSay(player, words, param)
	print(string.format("NewID param: %s",param))
	if (param == '') then
		doPlayerSendTextMessage(player, MESSAGE_STATUS_CONSOLE_BLUE, "Command requires param.")
		return true
	end

	local numberParam = tonumber(param)
	if (not numberParam) then
		doPlayerSendTextMessage(player, MESSAGE_STATUS_CONSOLE_BLUE, "Command requires numeric param.")
		return true
	end
	if (numberParam >= 10544) then
		doPlayerSendTextMessage(player, MESSAGE_STATUS_CONSOLE_BLUE, "Such item does not exist.")
		return true
	end
	doPlayerSendTextMessage(player, MESSAGE_INFO_DESCR,string.format("Your outfit has been turned into a %s.",getItemNameById(numberParam)))
	doSendMagicEffect(getCreaturePosition(player), CONST_ME_SLEEP)
	doSetItemOutfit(player, numberParam, -1)
	return true
end
