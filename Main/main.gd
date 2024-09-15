extends Control


@onready var soul_counter: Label = $SoulCounter
@onready var reap_button: Button = $ReapButton

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	soul_counter.text = "Souls: " + str(Global.souls)
	
	if Global.animations == true:
		reap_button.rotation_degrees = lerp(reap_button.rotation_degrees, 0.0, 0.2)



func _on_reap_button_pressed() -> void:
	
	Global.souls += 1
	reap_button.rotation_degrees = 45
	
	if Global.animations == false:
		await get_tree().create_timer(0.05).timeout
		reap_button.rotation_degrees = 0


func _on_settings_button_pressed() -> void:
	var instance = preload("res://Settings/settings_popup.tscn").instantiate()
	get_tree().root.add_child(instance)
