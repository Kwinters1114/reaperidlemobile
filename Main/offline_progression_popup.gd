extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var panel: Panel = $Panel

@onready var gone_for: Label = $Panel/MarginContainer/VBoxContainer/GoneFor
@onready var made: Label = $Panel/MarginContainer/VBoxContainer/Made

var exit = false

var time_elapsed
var offline_souls

func _ready() -> void:
	
	#Set panel and bg at final state.
	color_rect.modulate.a = 1
	panel.position.y = 250
	
	var formatted_time_elapsed = format_time(time_elapsed)
	
	#Initialize text values.
	gone_for.text = "You were gone for\n" + str(formatted_time_elapsed) + ","
	made.text = "and made\n" + Global.format_number(offline_souls) + " souls."
	

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

func format_time(time_elapsed):
	
	var formatted_time_elapsed
	
	if time_elapsed >= 60:
		formatted_time_elapsed = str(snapped(time_elapsed / 60, 1)) + " minutes"
	else:
		formatted_time_elapsed = str(snapped(time_elapsed, 1)) + " seconds"
	
	return formatted_time_elapsed
	
