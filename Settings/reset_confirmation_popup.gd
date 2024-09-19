extends Control


@onready var color_rect: ColorRect = $ColorRect
@onready var panel: Panel = $Panel


var exit = false

func _ready() -> void:
	
	#If animations are true, set start positions.
	if Global.animations == true:
		color_rect.modulate.a = 0.0
		panel.position.y = -550
	
	#Otherwise, just put them at their final positions.
	else:
		color_rect.modulate.a = 1
		panel.position.y =300

func _process(delta: float) -> void:
#If animations are enabled:
	if Global.animations == true:
		
		#If not currently exiting:
		if exit == false:
			
			#Fade the backdrop in, and slide the panel down.
			if color_rect.modulate.a < 1:
				color_rect.modulate.a += 4 * delta
			panel.position.y = lerp(panel.position.y, 300.0, 8 * delta)
		
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

func _on_no_pressed() -> void:
	#If animations enabled, set exit to true, otherwise just delete the whole instance.
	if Global.animations == true:
		exit = true
	else:
		queue_free()

func _on_yes_pressed() -> void:
	
	#Deletes the save file and reloads the main scene.
	DirAccess.remove_absolute("user://savegame.data")
	get_tree().reload_current_scene()
	
	Global.cod_info = {}
	Global.upgrade_info = {}
