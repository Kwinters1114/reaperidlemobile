extends Control

@onready var container: Control = $Container
@onready var button: Button = $Container/Button

var minimized = true

func _process(delta: float) -> void:
	
	#If animations are enabled:
	if Global.animations == true:
		
		#If minimized, smoothly move to bottom of screen, if not minimized, smoothly move to center.
		if minimized == true:
			container.position.y = lerp(container.position.y, 1200.0, 8 * delta)
		else:
			container.position.y = lerp(container.position.y, 250.0, 8 * delta)
	
	#If animations are disabled:
	else:
		
		#If minimized, move to bottom of screen, if not minimized, move to center.
		if minimized == true:
			container.position.y = 1200
		else:
			container.position.y = 250

func _on_cod_button_pressed() -> void:
	
	var sfx = preload("res://Main/sfx_player.tscn").instantiate()
	sfx.volume = -4
	sfx.pitch = randf_range(1.5, 2)
	sfx.stream = load("res://Assets/Sounds/StoneSliding1.ogg")
	self.add_child(sfx)

	
	#Switches the minimized variable to the opposite of its current value.
	minimized = !minimized
