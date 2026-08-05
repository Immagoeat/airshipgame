extends Node3D

@onready var light: SpotLight3D = $SpotLight3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.timeofday > 0.75 or Globals.timeofday < 0.25:
		light.light_energy = 15
	else:
		light.light_energy = 0
		
