extends Node3D

@onready var light1: SpotLight3D = $SpotLight3D
@onready var light2: SpotLight3D = $SpotLight3D2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.timeofday > 0.75 or Globals.timeofday < 0.25:
		light1.light_energy = 15
		light2.light_energy = 15
	else:
		light1.light_energy = 0
		light2.light_energy = 0
		print("Hi")
