extends Control


@export var upgrade_name = "insert_name"
@export var upgrade_icon : Texture2D
@export var upgrade_description = "insert_description"
@export var upgrade_price = 100

@export var affected_cod = "insert_cod_name"
@export var multiplicative = false
@export var affect_time = false
@export var effect_amount = 1.0

@onready var name_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/Name
@onready var description_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/Description
@onready var effect_label: Label = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/EffectLabel
@onready var buy: Button = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Buy
@onready var icon: TextureRect = $Panel/MarginContainer/HBoxContainer/Icon
@onready var margin_container: MarginContainer = $Panel/MarginContainer
@onready var lock_icon: TextureRect = $Panel/LockIcon
@onready var panel: PanelContainer = $Panel


func _ready() -> void:
	
	#If there isn't already an entry in the global dictionary, make one.
	if !Global.upgrade_info.has(upgrade_name):
		Global.upgrade_info[upgrade_name] = {
		
			"bought" : false,
			"locked" : true
		
		}
	
	#If the upgrade has been bought already, delete.
	if Global.upgrade_info[upgrade_name]["bought"] == true:
		queue_free()
	
	#Initialize labels and icons.
	name_label.text = upgrade_name
	description_label.text = upgrade_description
	buy.text = "Buy\n(" + Global.format_number(upgrade_price) + ")"
	icon.texture = upgrade_icon
	
	#Creates different effect descriptions based on how it affects the target COD.
	var effect_text : String
	if affect_time == true:
		effect_text = "x" + str(effect_amount) + " " + str(affected_cod) + " Speed"
	else:
		if multiplicative == true:
			effect_text = "x" + str(effect_amount) + " " + str(affected_cod) + " souls"
		elif multiplicative == false:
			effect_text = "+" + str(effect_amount) + " souls per " + str(affected_cod) 
	effect_label.text = effect_text

func _process(delta: float) -> void:
	
	#Disables button if upgrade can't be afforded.
	if Global.souls_info["souls"] < upgrade_price:
		buy.disabled = true
	else:
		buy.disabled = false
	
	#Unlock the upgrade once player has hit at least 75% of the price.
	if Global.souls_info["highest_souls"] >= upgrade_price * 0.75:
		Global.upgrade_info[upgrade_name]["locked"] = false
	
	#Reveals upgrade if unlocked.
	if Global.upgrade_info[upgrade_name]["locked"] == true:
		margin_container.hide()
		panel.modulate = Color(0.4, 0.4, 0.4)
		lock_icon.show()
	else:
		margin_container.show()
		panel.modulate = Color(1, 1, 1)
		lock_icon.hide()

func _on_buy_pressed() -> void:
	
	#Subtracts the price of the upgrade from the global souls value.
	Global.souls_info["souls"] -= upgrade_price
	
	#Carries out the effect of the upgrade based on the effect_amount and the toggles.
	if affect_time == true:
		Global.cod_info[affected_cod]["time"] /= effect_amount
	else:
		if multiplicative == true:
			Global.cod_info[affected_cod]["value"] *= effect_amount
		elif multiplicative == false:
			Global.cod_info[affected_cod]["value"] += effect_amount
	
	#Sets this upgrade's bought variable to true, so that it will get hidden in the future.
	Global.upgrade_info[upgrade_name]["bought"] = true
	
	#Plays sound.
	var sfx = preload("res://Main/sfx_player.tscn").instantiate()
	sfx.volume = -12
	sfx.pitch = 1
	sfx.stream = load("res://Assets/Sounds/Angelic.ogg")
	self.add_child(sfx)
	
	self.hide()
	
	await get_tree().create_timer(1).timeout
	
	#Deletes this instance.
	queue_free()
