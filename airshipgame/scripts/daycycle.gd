extends WorldEnvironment

@onready var sun: DirectionalLight3D = $DirectionalLight3D

var daylength: float = 15 # make heigher number later, this is just 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Globals.timeofday = fmod(Globals.timeofday + delta / daylength, 1)
	sun.rotation_degrees.x = Globals.timeofday * 360 - 90
	var sunheight: float = -sun.global_transform.basis.z.y
	sun.light_energy = clampf(sunheight * 4, 0, 2)
