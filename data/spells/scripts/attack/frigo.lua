
--I tried lots of other ways to replicate de effect of the video, like create a new effect using ObjectBuilder but
--this i will take ages to replicate and i will only show my art skills on AsePrite and not coding skills,
--but going this way make me learn how the client load assets, another way i tried was 
--creating combat areas randonly for every time the player cast, and took some time to me to realise,
--combat areas are only loadded in the start of the server and you can not change inside onCastSpell().
--So the code below is the closiest i can get to replicate the spell.

--To make that spell i started duplicating the Ethernal_Winter and adding the spell to spells.xml
--Another change i have to make is, add some code to lib/core/combat.lua so i can call onGetFormulaValues multiple times
--follwing that solution https://otland.net/threads/tfs-1-x-combat-setcallbackfunction-event-function.283490/

--Creating matrices with combatAreas
--I prefer create the new combatArear here because is only used to this spell
local combatAreas = {
	{
		{ 0, 0, 0, 0, 1, 0, 0, 0, 0 },
		{ 0, 0, 0, 1, 1, 1, 0, 0, 0 },
		{ 0, 0, 1, 1, 1, 1, 1, 0, 0 },
		{ 0, 1, 1, 0, 0, 0, 1, 1, 0 },
		{ 1, 1, 1, 0, 2, 0, 1, 0, 0 },
		{ 0, 1, 1, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 1, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 1, 1, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 1, 0, 0, 0, 0 }
	},
	{
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 1, 1, 1, 0, 0, 0 },
		{ 0, 0, 0, 1, 2, 1, 0, 1, 0 },
		{ 0, 0, 0, 1, 1, 1, 0, 0, 0 },
		{ 0, 0, 1, 0, 1, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	},
	{
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 1, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 1, 1, 0, 0 },
		{ 0, 0, 0, 1, 1, 1, 1, 1, 0 },
		{ 0, 0, 0, 1, 2, 1, 1, 1, 1 },
		{ 0, 0, 0, 1, 1, 1, 1, 1, 0 },
		{ 0, 0, 0, 0, 0, 1, 1, 0, 0 },
		{ 0, 0, 0, 0, 0, 1, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	}
}

--Creating the damage formula
function onGetFormulaValues(player, level, magicLevel)
	local min = (level / 5) + (magicLevel * 5.5) + 25
	local max = (level / 5) + (magicLevel * 11) + 50
	return -min, -max
end

--Creating a combat array to cast multiple waves with diferent combatAreas
--I made this way because i want to make easier to change the number of waves, 
--you just have to add or remove a new matrix to combatAreas

local combats = {}
for i = 1, #combatAreas, 1 do
	combats[i] = Combat()
	combats[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
	combats[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
	combats[i]:setCallbackFunction(CALLBACK_PARAM_LEVELMAGICVALUE, onGetFormulaValues)
	combats[i]:setArea(createCombatArea(combatAreas[i]))
end

--Execute every combat created
function onCastSpell(creature, variant)
	combats[1]:execute(creature, variant)
	for i = 2, #combats, 1 do
		addEvent(function() combats[i]:execute(creature, variant) end, 300 * i)
	end
	return true
end
