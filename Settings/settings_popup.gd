extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var panel: Panel = $Panel
@onready var animations_toggle: Button = $Panel/MarginContainer/VBoxContainer/HBoxContainer/AnimationsToggle


var exit = false

func _ready() -> void:
	
	if Global.animations == true:
		color_rect.modulate.a = 0.0
		panel.position.y = -550
	else:
		color_rect.modulate.a = 1
		panel.position.y = 250
	
	animations_toggle.button_pressed = Global.animations
	update_icons()



func _process(delta: float) -> void:
	
	if Global.animations == true:
		
		if exit == false:
			
			if color_rect.modulate.a < 1:
				color_rect.modulate.a += 4 * delta
			panel.position.y = lerp(panel.position.y, 250.0, 8 * delta)
			
		else:
			
			color_rect.modulate.a -= 4 * delta
			panel.position.y = lerp(panel.position.y, -550.0, 8 * delta)
			
			if color_rect.modulate.a < 0:
				queue_free()
				


func _on_exit_pressed() -> void:
	
	if Global.animations == true:
		exit = true
	else:
		queue_free()


func update_icons():
	if animations_toggle.button_pressed == true:
		animations_toggle.icon = preload("res://Settings/toggle_button_on.png")
	else:
		animations_toggle.icon = preload("res://Settings/toggle_button_off.png")

func _on_animations_toggle_pressed() -> void:
	Global.animations = animations_toggle.button_pressed
	update_icons()
