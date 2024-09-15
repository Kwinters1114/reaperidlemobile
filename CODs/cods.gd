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
			container.position.y = lerp(container.position.y, 200.0, 8 * delta)
	
	#If animations are disabled:
	else:
		
		#If minimized, move to bottom of screen, if not minimized, move to center.
		if minimized == true:
			container.position.y = 1200
		else:
			container.position.y = 200

func _on_cod_button_pressed() -> void:
	
	#Switches the minimized variable to the opposite of its current value.
	minimized = !minimized
