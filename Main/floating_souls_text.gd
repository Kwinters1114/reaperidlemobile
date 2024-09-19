extends Control

@onready var label: Label = $Label

var display_amount : String

func _ready() -> void:
	label.text = "+" + display_amount
	
	if Global.animations == false:
		position.y -= 100
		await get_tree().create_timer(1).timeout
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Global.animations == true:
		position.y -= 5
		label.modulate.a -= 0.025
		
		if label.modulate.a <= 0:
			queue_free()
