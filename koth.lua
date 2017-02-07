local function teleportToSpawn(player, force, surface)
	local spawn = force.get_spawn_position(surface)
	local destination = surface.find_non_colliding_position("player", spawn, 10, 1)
	player.teleport(destination, surface)
end

Event.register(defines.events.on_gui_click, function()
	if not event.element then return end
	local player = game.players[event.player_index]
	local force = player.force
	if event.element.name == "teleport" then
		if game.tick - global.cooldowns[player.name] < global.config.cooldown then
			player.print("Your teleport button is on cooldown!")
			return
		end
		if player.surface.name == force.name then
			--Teleport player to battle surface
			teleportToSpawn(player, force, game.surfaces["battle-surface"])
		else if surface.name == "battle-surface" then
			--Teleport player back to home surface
			teleportToSpawn(player, force, game.surfaces[force.name])
		else
			--Player is on unknown surface, error and/or teleport to some other surface
		end
	end
	if not player.admin then return end
	--Admin access only, allows admins to teleport to any force's surface.
end)

Event.register(defines.events.on_tick, function()
	--Handle transportation of supplies to battle surface and point collection for claimed hills
end)

Event.register(defines.events.on_player_respawned, function()
	--Teleport player to their force's surface on respawn
	local player = game.players[event.player_index]
	teleportToSpawn(player, player.force, game.surfaces[player.force.name]) 
end)

Event.register(defines.events.on_built_entity, function()
	--Handle the claiming of a hill as well as spawn area protection
end)

Event.register(-1, function()
	--Handle the initial setup of required tables
end)