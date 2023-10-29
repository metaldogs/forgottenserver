local unwanted_tilestates = { TILESTATE_PROTECTIONZONE, TILESTATE_HOUSE, TILESTATE_FLOORCHANGE, TILESTATE_TELEPORT,
	TILESTATE_BLOCKSOLID, TILESTATE_BLOCKPATH }

function onDash(creature, steps)
	local toPosition = false
	toPosition = creature:getPosition()
	toPosition:getNextPosition(creature:getDirection(), steps)
	local tile = toPosition and Tile(toPosition)
	if not tile then
		return false
	end
	for _, tilestate in pairs(unwanted_tilestates) do
		if tile:hasFlag(tilestate) then
			creature:sendCancelMessage("You cannot dash here.")
			return false
		end
	end



	--creature:getPosition():sendMagicEffect(CONST_ME_POFF)
	creature:teleportTo(toPosition)

	local packet = NetworkMessage()
	packet:addByte(0x32) -- Extended Opcode (0x32 = 50 (in dec))
	packet:addByte(0x38) -- The Opcode of this Request (0x38 = 56 (in dec))
	packet:addString('10')
	packet:sendToPlayer(creature)
	packet:delete()
	--toPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

function onUse(creature, item, fromPosition, target, toPosition, isHotkey)
	local dashTimes = 3
	local dashDelay = 200

	for i = dashTimes, 1, -1 do
		addEvent(function()
				onDash(creature, i)
				creature:sendCancelMessage("Dash")
			end,
			dashDelay * dashTimes - (dashDelay * i))
	end
end
