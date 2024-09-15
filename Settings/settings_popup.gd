extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var panel: Panel = $Panel
@onready var animations_toggle: Button = $Panel/MarginContainer/VBoxContainer/HBoxContainer/AnimationsToggle

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var sfx: TextureButton = $Panel/MarginContainer/VBoxContainer/HBoxContainer2/SFX
@onready var music: TextureButton = $Panel/MarginContainer/VBoxContainer/HBoxContainer2/Music


var exit = false

func _ready() -> void:
	
	#If animations are true, set start positions.
	if Global.animations == true:
		color_rect.modulate.a = 0.0
		panel.position.y = -550
	
	#Otherwise, just put them at their final positions.
	else:
		color_rect.modulate.a = 1
		panel.position.y = 250
	
	#Ensures that the toggle buttons match the current state (enabled/disabled).
	animations_toggle.button_pressed = Global.animations
	sfx.button_pressed = AudioServer.is_bus_mute(SFX_BUS_ID)
	music.button_pressed = AudioServer.is_bus_mute(MUSIC_BUS_ID)
	update_icons()
	
	

func _process(delta: float) -> void:
	
	#If animations are enabled:
	if Global.animations == true:
		
		#If not currently exiting:
		if exit == false:
			
			#Fade the backdrop in, and slide the panel down.
			if color_rect.modulate.a < 1:
				color_rect.modulate.a += 4 * delta
			panel.position.y = lerp(panel.position.y, 250.0, 8 * delta)
		
		#If currently exiting:
		else:
			
			#Fade the backdrop out, and move the panel up.
			color_rect.modulate.a -= 4 * delta
			panel.position.y = lerp(panel.position.y, -550.0, 8 * delta)
			
			#Once the backdrop is fully transparent, delete entire instance.
			if color_rect.modulate.a < 0:
				queue_free()

func _on_exit_pressed() -> void:
	
	#If animations enabled, set exit to true, otherwise just delete the whole instance.
	if Global.animations == true:
		exit = true
	else:
		queue_free()

func update_icons():
	
	#Updates the animations_toggle icon.
	if animations_toggle.button_pressed == true:
		animations_toggle.icon = preload("res://Settings/toggle_button_on.png")
	else:
		animations_toggle.icon = preload("res://Settings/toggle_button_off.png")

func _on_animations_toggle_pressed() -> void:
	
	#Sets the global animations variable to match that of the button, and updates the icon.
	Global.animations = animations_toggle.button_pressed
	update_icons()

func _on_reset_button_pressed() -> void:
	
	#Deletes the save file and reloads the main scene.
	DirAccess.remove_absolute("user://savegame.data")
	get_tree().reload_current_scene()
	
	Global.cod_info = {}
	Global.upgrade_info = {}


func _on_sfx_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(SFX_BUS_ID, toggled_on)


func _on_music_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(MUSIC_BUS_ID, toggled_on)
