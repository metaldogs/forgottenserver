local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

function onGetFormulaValues(player, level, magicLevel)
	local min = (level / 5) + (magicLevel * 1.4) + 8
	local max = (level / 5) + (magicLevel * 1.8) + 11
	return min, max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(creature, variant)
	local packet = NetworkMessage()
	packet:addByte(0x32) -- Extended Opcode (0x32 = 50 (in dec))
	packet:addByte(0x38) -- The Opcode of this Request (0x38 = 56 (in dec))
	packet:addString('9')
	packet:sendToPlayer(creature)
	packet:delete()



	return combat:execute(creature, variant)
end
