extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var panel: Panel = $Panel

@onready var current_souls: Label = $Panel/MarginContainer/VBoxContainer/CurrentSouls
@onready var highest_souls: Label = $Panel/MarginContainer/VBoxContainer/HighestSouls
@onready var all_time_souls: Label = $Panel/MarginContainer/VBoxContainer/AllTimeSouls
@onready var souls_per_second: Label = $Panel/MarginContainer/VBoxContainer/SoulsPerSecond
@onready var souls_per_click: Label = $Panel/MarginContainer/VBoxContainer/SoulsPerClick

var exit = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#If animations are true, set start positions.
	if Global.animations == true:
		color_rect.modulate.a = 0.0
		panel.position.y = -550
	
	#Otherwise, just put them at their final positions.
	else:
		color_rect.modulate.a = 1
		panel.position.y = 250
	
	#Initialize text values.
	current_souls.text = "Current Souls: " + BigNumbers.array_to_display(Global.souls_info["souls"])
	highest_souls.text = "Most Souls Held: " + BigNumbers.array_to_display(Global.souls_info["highest_souls"])
	all_time_souls.text = "All Time Souls: " + BigNumbers.array_to_display(Global.souls_info["all_time_souls"])
	souls_per_second.text = "Souls Per Second: " + BigNumbers.array_to_display(Global.souls_info["global_souls_per_second"])
	souls_per_click.text = "Souls Per Click: " + BigNumbers.array_to_display(Global.souls_info["souls_per_click"])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
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
