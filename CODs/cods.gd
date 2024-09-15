extends Control

@onready var container: Control = $Container
@onready var button: Button = $Container/Button

var minimized = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	
	if Global.animations == true:
		if minimized == true:
			container.position.y = lerp(container.position.y, 1200.0, 8 * delta)
		else:
			container.position.y = lerp(container.position.y, 200.0, 8 * delta)
	else:
		if minimized == true:
			container.position.y = 1200
		else:
			container.position.y = 200


func _on_cod_button_pressed() -> void:
	minimized = !minimized
