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
	if BigNumbers.array_is_greater_than(souls_info["souls"], souls_info["highest_souls"]) == true:
		souls_info["highest_souls"] = souls_info["souls"]
	
	update_souls_per_second()
	

func update_souls_per_second():
	
	#First set global sps to 0.
	souls_info["global_souls_per_second"] = [0]
	
	#For every COD, add their sps to the global sps.
	for cod in cod_info:
		
		souls_info["global_souls_per_second"] = BigNumbers.add_arrays(souls_info["global_souls_per_second"], cod_info[cod]["souls_per_second"])
