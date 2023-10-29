local combat = Combat()
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local unwanted_tilestates = { TILESTATE_PROTECTIONZONE, TILESTATE_HOUSE, TILESTATE_FLOORCHANGE, TILESTATE_TELEPORT,
	TILESTATE_BLOCKSOLID, TILESTATE_BLOCKPATH }

function onDash(creature, steps)
	local target = creature:getTarget()
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
	--toPosition:sendMagicEffect(CONST_ME_TELEPORT)
end

function onCastSpell(creature, variant)
	local dashTimes = 3
	local dashDelay = 200
	
	for i = dashTimes, 1, -1 do
		addEvent(function()
			onDash(creature, i)
			creature:sendCancelMessage("Dash")
		end,
		dashDelay * dashTimes - (dashDelay * i))
	end

	return combat:execute(creature, variant)
end
