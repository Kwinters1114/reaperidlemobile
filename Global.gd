extends Node

@export var souls = 0
@export var highest_souls = 0

#Holds info about each COD.
@export var cod_info = {}

#Holds the bought status of each upgrade.
@export var upgrade_info = {}

#If false, animations will be disabled.
@export var animations = true

func _process(delta: float) -> void:
	if souls > highest_souls:
		highest_souls = souls
