extends Control


@onready var soul_counter: Label = $MarginContainer/VBoxContainer/SoulCounter
@onready var souls_per_second: Label = $MarginContainer/VBoxContainer/SoulsPerSecond

@onready var reap_button: Button = $ReapButton

func _ready() -> void:
	load_game()

func _process(delta: float) -> void:
	
	#Updates the souls and sps text.
	soul_counter.text = "Souls: " + BigNumbers.array_to_display(BigNumbers.truncate_array(Global.souls_info["souls"], 0))
	souls_per_second.text = "Per Second: " + BigNumbers.array_to_display(Global.souls_info["global_souls_per_second"])
	
	#If animations are on, smoothly return the scythe's rotation to 0.
	if Global.animations == true:
		reap_button.rotation_degrees = lerp(reap_button.rotation_degrees, 0.0, 0.2)

func _on_reap_button_pressed() -> void:
	
	#Add 1 to the souls counter and all-time souls counter.
	Global.souls_info["souls"] = BigNumbers.add_arrays(Global.souls_info["souls"], Global.souls_info["souls_per_click"])
	Global.souls_info["all_time_souls"] = BigNumbers.add_arrays(Global.souls_info["all_time_souls"], Global.souls_info["souls_per_click"])
	
	#Spawn in the floating text.
	var instance = load("res://Main/floating_souls_text.tscn").instantiate()
	instance.position = Vector2(500, 450)
	instance.display_amount = BigNumbers.array_to_display(Global.souls_info["souls_per_click"])
	get_tree().root.add_child(instance)
	
	#Set the scythe rotation to 45 degrees.
	if Global.animations == true:
		reap_button.rotation_degrees = 45
	else:
		reap_button.rotation_degrees = 30
	
	#If animations are disabled, wait 0.05 seconds, then return the scythe's rotation to 0.
	if Global.animations == false:
		await get_tree().create_timer(0.05).timeout
		reap_button.rotation_degrees = 0
	
	#Plays sound.
	var sfx = preload("res://Main/sfx_player.tscn").instantiate()
	sfx.volume = 0
	sfx.pitch = randf_range(1.5, 2)
	sfx.stream = load("res://Assets/Sounds/Slash" + str(randi_range(1 , 3)) + ".ogg")
	self.add_child(sfx)

func _on_settings_button_pressed() -> void:
	
	#Opens the setting menu.
	var instance = preload("res://Settings/settings_popup.tscn").instantiate()
	get_tree().root.add_child(instance)

func _on_save_timer_timeout() -> void:
	save_game()

func save_game(): 
	
	#Creates a dictionary to store save data.
	var saved_data = {}
	
	#Creates entries in the dictionary for each variable/dictionary that needs to be saved.
	saved_data["cod_info"] = Global.cod_info
	saved_data["upgrade_info"] = Global.upgrade_info
	saved_data["souls_info"] = Global.souls_info
	saved_data["animations"] = Global.animations
	saved_data["last_saved_time"] = Time.get_unix_time_from_system()
	
	#Opens or creates the save file, and stores the dictionary.
	var file = FileAccess.open("user://savegame.data", FileAccess.WRITE)
	file.store_var(saved_data)
	file.close()

func load_game():
	
	#If the save file exists, it opens it.
	if FileAccess.file_exists("user://savegame.data"):
		var file = FileAccess.open("user://savegame.data", FileAccess.READ)
		
		#The dictionary is taken from the save file and assigned to this new variable.
		var saved_data = file.get_var()
		
		#Each entry in the dictionary is reassigned to its proper place.
		Global.cod_info = saved_data["cod_info"]
		Global.upgrade_info = saved_data["upgrade_info"]
		Global.souls_info = saved_data["souls_info"]
		Global.animations = saved_data["animations"]
		Global.last_saved_time = saved_data["last_saved_time"]
		
		#Closes the file because we're done with it.
		file.close()
		
		offline_progression()
		
	#If the file doesn't exist, initialize the variables.
	else:
		Global.souls_info = {
			
			"souls" : [0],
			"highest_souls" : [0],
			"all_time_souls" : [0],
			"global_souls_per_second" : [0],
			"souls_per_click" : [1]
			
		}
		

		#If false, animations will be disabled.
		Global.animations = true

func offline_progression():
		
		#Calculates how long its been since the game was closed.
		var time_elapsed = Time.get_unix_time_from_system() - Global.last_saved_time
		
		#Converts that time into an array.
		var time_elapsed_array = BigNumbers.string_to_array(str(time_elapsed))
		
		#Multiplies that time by the global sps (rounded to one soul).
		var offline_souls = BigNumbers.multiply_arrays(time_elapsed_array, Global.souls_info["global_souls_per_second"])
		
		#Adds this value to the global soul counter and all-time souls.
		Global.souls_info["souls"] = BigNumbers.add_arrays(Global.souls_info["souls"], offline_souls)
		Global.souls_info["all_time_souls"] = BigNumbers.add_arrays(Global.souls_info["all_time_souls"], offline_souls)
		
		#Instantiates offline progression popup.
		var instance = preload("res://Main/offline_progression_popup.tscn").instantiate()
		instance.time_elapsed = snapped(time_elapsed, 1)
		instance.offline_souls = offline_souls
		self.add_child(instance)

func _on_upgrade_button_pressed() -> void:
	var instance = load("res://Main/Scythe/scythe_upgrades.tscn").instantiate()
	get_tree().root.add_child(instance)

func _on_info_button_pressed() -> void:
	var instance = load("res://Main/Info/info_panel.tscn").instantiate()
	get_tree().root.add_child(instance)
