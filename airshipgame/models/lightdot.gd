extends Node3D

@onready var light1: SpotLight3D = $CSGBox3D2/SpotLight3D
@onready var light2: SpotLight3D = $CSGBox3D2/SpotLight3D2
@onready var light3: SpotLight3D = $CSGBox3D2/SpotLight3D3
@onready var light4: SpotLight3D = $CSGBox3D2/SpotLight3D4
@onready var light5: SpotLight3D = $CSGBox3D2/SpotLight3D5
@onready var light6: SpotLight3D = $CSGBox3D2/SpotLight3D6
@onready var light7: SpotLight3D = $CSGBox3D2/SpotLight3D7
@onready var light8: SpotLight3D = $CSGBox3D2/SpotLight3D8
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.timeofday > 0.75 or Globals.timeofday < 0.25:
		light1.light_energy = 1
		light2.light_energy = 1
		light3.light_energy = 1
		light4.light_energy = 1
		light5.light_energy = 1
		light6.light_energy = 1
		light7.light_energy = 1
		light8.light_energy = 1
	else:
		light1.light_energy = 0
		light2.light_energy = 0
		light3.light_energy = 0
		light4.light_energy = 0
		light5.light_energy = 0
		light6.light_energy = 0
		light7.light_energy = 0
		light8.light_energy = 0
		
