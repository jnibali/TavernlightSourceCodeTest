local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)



function onCastSpell(creature, variant)
	for i = 10,1,-1 --for loop for amount of effects to spawn
	do
		
		local position = creature:getPosition() --get the position of the player casting the spell
		position.x = position.x + math.random(-2,2) --randomize posistion of effect around player x and y
		position.y = position.y +math.random(-2,2)
		-- Better density effect if effect is casted again in same loop iteration
		doSendMagicEffect(position, CONST_ME_ICETORNADO) 
		local position = creature:getPosition() 
		position.x = position.x + math.random(-2,2) 
		position.y = position.y +math.random(-2,2)
		doSendMagicEffect(position, CONST_ME_ICETORNADO) 
	end
	--return creature:conjureItem(0, 2543, 5, CONST_ME_MAGIC_BLUE)  --debug statement to verify spell is being called
end
