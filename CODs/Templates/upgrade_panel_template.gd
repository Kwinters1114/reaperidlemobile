extends Control

@export var cod_name = "insert_name"

@onready var container: Control = $Container
@onready var title: Label = $Container/Panel/MarginContainer/VBoxContainer/Title

var shown = true


func _ready() -> void:
	
	#Sets the panel's position to be to the right of the screen.
	container.position = Vector2(720, 100)
	
	#Initializes the title text.
	title.text = str(cod_name) + "\nUpgrades"
	
	var sfx = preload("res://Main/sfx_player.tscn").instantiate()
	sfx.volume = -4
	sfx.pitch = 1
	sfx.stream = load("res://Assets/Sounds/StoneSliding1.ogg")
	self.add_child(sfx)

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
		await get_tree().create_timer(1).timeout
		queue_free()

func _on_exit_pressed() -> void:
	
	#Set the shown variable to false, essentially starting the exit animation.
	shown = false
	
	var sfx = preload("res://Main/sfx_player.tscn").instantiate()
	sfx.volume = -4
	sfx.pitch = randf_range(1.5, 2)
	sfx.stream = load("res://Assets/Sounds/StoneSliding1.ogg")
	self.add_child(sfx)
