extends Control

#Exported variables.
@export var cod_name = "insert_name"
@export var cod_icon : Texture2D
@export var base_time = 5.0
@export var base_value = 1.0
@export var base_price = 1
@export var price_increase = 1.15
@export var previous_cod_name = "insert_name"
@export var upgrades_scene : PackedScene

#References to children nodes.
@onready var name_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/Name
@onready var icon: TextureRect = $Panel/MarginContainer/HBoxContainer/VBoxContainer2/Icon
@onready var progress_bar: ProgressBar = $Panel/MarginContainer/HBoxContainer/VBoxContainer/ProgressBar
@onready var sps: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/SPS
@onready var buy: Button = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Buy
@onready var upgrades: Button = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Upgrades
@onready var owned_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer2/Owned
@onready var margin_container: MarginContainer = $Panel/MarginContainer
@onready var panel: PanelContainer = $Panel
@onready var lock_icon: TextureRect = $Panel/LockIcon

var locked = true


func _ready():
	
	#Creates global dictionary of cod info.
	Global.cod_info[str(cod_name)] = {
		
		"price" : base_price,
		"owned" : 0,
		"value" : base_value,
		"time" : base_time,
		"level" : 0,
		"level_multiplier" : 1,
		"souls_per_second" : 0
		
	}
	
	#Initializes label, icon, and progress bar.
	name_label.text = cod_name
	icon.texture = cod_icon
	progress_bar.max_value = base_time
	progress_bar.value = 0

func _process(delta: float) -> void:
	
	#Updates souls per second
	Global.cod_info[str(cod_name)]["souls_per_second"] = str(snapped((Global.cod_info[str(cod_name)]["value"] * Global.cod_info[str(cod_name)]["owned"])/ (Global.cod_info[str(cod_name)]["time"] / Global.cod_info[str(cod_name)]["level_multiplier"]), 0.1))
	
	#Updates all text values.
	sps.text = "Souls Per Second: " + Global.format_number(int(Global.cod_info[str(cod_name)]["souls_per_second"]))
	buy.text = "Buy\n(" + Global.format_number(Global.cod_info[str(cod_name)]["price"]) + ")"
	owned_label.text = str(Global.cod_info[str(cod_name)]["owned"])
	
	#Updates the progress bar's max value.
	progress_bar.max_value = Global.cod_info[str(cod_name)]["time"] / Global.cod_info[str(cod_name)]["level_multiplier"]
	
	#Moves the progress bar forward, if some are owned.
	if Global.cod_info[str(cod_name)]["owned"] > 0:
		progress_bar.value += delta
	
	#Adds souls and resets progress bar once full.
	if progress_bar.value >= progress_bar.max_value:
		Global.souls_info["souls"] += Global.cod_info[str(cod_name)]["value"] * Global.cod_info[str(cod_name)]["owned"]
		Global.souls_info["all_time_souls"] += Global.cod_info[str(cod_name)]["value"] * Global.cod_info[str(cod_name)]["owned"]
		progress_bar.value = 0
	
	#Disables the buy button if it can't be afforded.
	if Global.souls_info["souls"] < Global.cod_info[str(cod_name)]["price"]:
		buy.disabled = true
	else:
		buy.disabled = false
	
	#Determines if COD has been unlocked yet.
	if cod_name == "Gas Station Sushi":
		locked = false
	elif Global.cod_info[previous_cod_name]["owned"] > 0:
		locked = false
	
	#Reveals COD if unlocked.
	if locked == true:
		margin_container.hide()
		panel.modulate = Color(0.4, 0.4, 0.4)
		lock_icon.show()
	else:
		margin_container.show()
		panel.modulate = Color(1, 1, 1)
		lock_icon.hide()
	
	#Handles leveling up.
	if Global.cod_info[cod_name]["owned"] >= 100:
		Global.cod_info[cod_name]["level"] = 3
		Global.cod_info[cod_name]["level_multiplier"] = 4
		panel.self_modulate = Color(1.0, 0.8, 0.25) #Gold
	
	elif Global.cod_info[cod_name]["owned"] >= 50:
		Global.cod_info[cod_name]["level"] = 2
		Global.cod_info[cod_name]["level_multiplier"] = 3
		panel.self_modulate = Color(0.75, 0.95, 0.95) #Silver
	
	elif Global.cod_info[cod_name]["owned"] >= 10:
		Global.cod_info[cod_name]["level"] = 1
		Global.cod_info[cod_name]["level_multiplier"] = 2
		panel.self_modulate = Color(1.0, 0.66, 0.33) #Bronce

func _on_buy_pressed() -> void:
	
	#Subtracts price from souls, adds one to owned, and updates the price.
	Global.souls_info["souls"] -= Global.cod_info[str(cod_name)]["price"]
	Global.cod_info[str(cod_name)]["owned"] += 1
	Global.cod_info[str(cod_name)]["price"] = snapped(base_price * (price_increase ** Global.cod_info[str(cod_name)]["owned"]) , 1)
	
	#Plays sound.
	var sfx = preload("res://Main/sfx_player.tscn").instantiate()
	sfx.volume = -12
	sfx.pitch = 1
	sfx.stream = load("res://Assets/Sounds/Angelic.ogg")
	self.add_child(sfx)


func _on_upgrades_pressed() -> void:
	
	#Instances the matching upgrade panel.
	var instance = upgrades_scene.instantiate()
	get_tree().root.add_child(instance)
