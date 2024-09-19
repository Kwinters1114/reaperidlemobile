extends Control

@export var TestNumber1 = "123.456"
@export var TestNumber2 = "0.25"

func _ready() -> void:
	print(BigNumbers.array_to_display(BigNumbers.string_to_array(TestNumber1)))
