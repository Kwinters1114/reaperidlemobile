extends Control

@export var cod_name = "insert_name"

@onready var container: Control = $Container
@onready var title: Label = $Container/Panel/MarginContainer/VBoxContainer/Title

var shown = true


func _ready() -> void:
	
	#Sets the panel's position to be to the right of the screen.
	container.position = Vector2(720, 50)
	
	#Initializes the title text.
	title.text = str(cod_name) + "\nUpgrades"

func _process(delta: float) -> void:
	
	#If animations are enabled:
	if Global.animations == true:
		
		#If shown is true, smoothly move the panel into the center of the screen.
		if shown == true:
			container.position.x = lerp(container.position.x, 0.0, 8 * delta)
		
		#If shown is false, smoothy move the panel off to the right of the screen.
		else:
			container.position.x = lerp(container.position.x, 721.0, 8 * delta)
	
	#If animations are disabled:
	else:
		
		#If shown is true, move the panel to the center of the screen.
		if shown == true:
			container.position.x = 0
		
		#If shown is false, move the panel off to the right of the screen.
		else:
			container.position.x = 721
	
	#If the container is off to the right of the screen, delete the entire instance.
	if container.position.x > 720:
		queue_free()

func _on_exit_pressed() -> void:
	
	#Set the shown variable to false, essentially starting the exit animation.
	shown = false
