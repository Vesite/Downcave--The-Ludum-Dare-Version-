/// @desc


if P exit


if instance_exists(player) {
	
	var _chunk_height = (32*CHUNK_HEIGHT)
	
	if player.y >= (_chunk_height*depth_var - 32) {
		
		chunks_until_weapon = max(chunks_until_weapon - 1, 0)
		chunks_until_biome_change = max(chunks_until_biome_change - 1, 0)
		
		//Choose a new different biome!
		if chunks_until_biome_change == 0 {
			chunks_until_biome_change = choose(6, 7, 7, 8, 8, 9)
			
			biome = RANDOM_BIOME
			while biome == previous_biome {
				biome = RANDOM_BIOME
			}
		}
		previous_biome = biome
		
		#region Decide stuff based on biome
			
			switch (biome) {
			    case BIOME.ROCK:
			       var _chunk_list = chunk_list_rock 
			    break;
			    case BIOME.SAND:
			        var _chunk_list = chunk_list_sand
			    break;
				case BIOME.CRYSTAL:
			        var _chunk_list = chunk_list_crystal
			    break;
				case BIOME.FLESH:
			        var _chunk_list = chunk_list_flesh
			    break;
			}
		
		#endregion
		
		var _indx = irandom_range(0, ds_list_size(_chunk_list) - 1)
		var _new_chunk = ds_list_find_value(_chunk_list, _indx)
		while _new_chunk == previous_chunk {
			var _indx = irandom_range(0, ds_list_size(_chunk_list) - 1)
			_new_chunk = ds_list_find_value(_chunk_list, _indx)
		}
		previous_chunk = _new_chunk
		
		var _have_weapon = false
		if chunks_until_weapon == 0 {
			var _have_weapon = true
			chunks_until_weapon = choose(3, 4, 4, 5)
		}
		
		generate_chunk(depth_var, _chunk_height*(depth_var + 1), _new_chunk, _have_weapon, biome)
		//show_message("Generate a chunk starting at y=360*(depth_var + 1)")
		depth_var += 1
		
		//Clean up blocks that are far away
		event_user(0)
		
	}
	
	
	#region Spawn Constant enemies
	
		if depth_var > 3 {
			
			//Spawn Ghosts
			if player.player_biome_in_currently == BIOME.ROCK {
		
				//Spawn enemies
				var _chance = (0.02 + depth_var/700)
				_chance = min(_chance, 0.2)
				if random(1) < _chance {
		
					//show_debug_message("Chance to spawn: " + string(_chance))
		
					//Create an enemy on left or right
					var _x = choose(random_range(-50, -16), random_range(GAME_WIDTH + 16, GAME_WIDTH + 50))
					var _y = random_range(player.y + 800, player.y - 128)
					instance_create_layer(_x, _y, "Enemies", ghast_1)
	
				}
			}
			
			//Spawn Clouds
			if player.player_biome_in_currently == BIOME.CRYSTAL {
			
				//Spawn enemies
				var _chance = (0.008 + depth_var/2500)
				_chance = min(_chance, 0.25)
				if random(1) < _chance {
		
					//show_debug_message("Chance to spawn: " + string(_chance))
		
					//Create an enemy on left or right
					var _x = random_range(-40, GAME_WIDTH + 40)
					var _y = random_range(player.y - GAME_HEIGHT*0.8, player.y - GAME_HEIGHT*1.2)
					instance_create_layer(_x, _y, "Enemies", cloud)
		
				}
			
			}
			
		
		}
	
	#endregion
	

}