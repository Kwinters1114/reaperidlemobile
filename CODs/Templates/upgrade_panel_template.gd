extends Control

@export var cod_name = "insert_name"

@onready var container: Control = $Container
@onready var title: Label = $Container/Panel/MarginContainer/VBoxContainer/Title

var shown = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	container.position = Vector2(720, 50)
	
	title.text = str(cod_name) + "\nUpgrades"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Global.animations == true:
		if shown == true:
			container.position.x = lerp(container.position.x, 0.0, 8 * delta)
		else:
			container.position.x = lerp(container.position.x, 721.0, 8 * delta)
	else:
		if shown == true:
			container.position.x = 0
		else:
			container.position.x = 721
	
	if container.position.x > 720:
		queue_free()


func _on_exit_pressed() -> void:
	shown = false
