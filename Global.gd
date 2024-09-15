extends Node

#Holds useful info about souls.
@export var souls_info = {}

#Holds info about each COD.
@export var cod_info = {}

#Holds the bought status of each upgrade.
@export var upgrade_info = {}

#If false, animations will be disabled.
@export var animations = true

@export var last_saved_time : float


func _process(delta: float) -> void:
	
	#If current souls is higher than the current highest, make it the new highest.
	if souls_info["souls"] > souls_info["highest_souls"]:
		souls_info["highest_souls"] = souls_info["souls"]
	
	update_souls_per_second()
	

func update_souls_per_second():
	
	#First set global sps to 0.
	souls_info["global_souls_per_second"] = 0
	
	#For every COD, add their sps to the global sps.
	for cod in cod_info:
		souls_info["global_souls_per_second"] += float(cod_info[cod]["souls_per_second"])


func format_number(raw_number):
	var formatted_number : String
	
	if raw_number >= 1000000000:
		if raw_number >= 10000000000:
			formatted_number = str(snapped(raw_number / 1000000000, 1)) + "B"
		else:
			formatted_number = str(snapped(raw_number / 1000000000, 0.1)) + "B"
	elif raw_number >= 1000000:
		if raw_number >= 10000000:
			formatted_number = str(snapped(raw_number / 1000000, 1)) + "M"
		else:
			formatted_number = str(snapped(raw_number / 1000000, 0.1)) + "M"
	elif raw_number >= 1000:
		if raw_number >= 10000:
			formatted_number = str(snapped(raw_number / 1000, 1)) + "K"
		else:
			formatted_number = str(snapped(raw_number / 1000, 0.1)) + "K"
	else:
		formatted_number = str(raw_number)
	
	return formatted_number
