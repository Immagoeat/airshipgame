extends WorldEnvironment

@onready var sun: DirectionalLight3D = $DirectionalLight3D

var daylength: float = 30 

var day_sky_color = Color("#4a8cff", 1)      
var day_horizon_color = Color("#22437a", 1)  
var night_sky_color = Color("#08000f", 1)    
var night_horizon_color = Color("#13001a", 1)
var noise: FastNoiseLite = FastNoiseLite.new()

func _ready():
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = randi()
	noise.frequency = 0.1
	star_map()

func _process(delta: float) -> void:
	Globals.timeofday = fmod(Globals.timeofday + delta / daylength, 1)
	sun.rotation_degrees.x = Globals.timeofday * 360 - 90
	
	# Extract the sun's forward direction vector
	var sun_direction: Vector3 = -sun.global_transform.basis.z
	
	var sky_mat = environment.sky.sky_material as ShaderMaterial
	if sky_mat:
		# Send the direction and colors to the shader
		sky_mat.set_shader_parameter("sun_direction", sun_direction)
		sky_mat.set_shader_parameter("day_sky", day_sky_color)
		sky_mat.set_shader_parameter("day_horizon", day_horizon_color)
		sky_mat.set_shader_parameter("night_sky", night_sky_color)
		sky_mat.set_shader_parameter("night_horizon", night_horizon_color)

	# Smoothly fade light intensity as the sun sets
	if sun_direction.y > 0:
		sun.light_energy = clampf(sun_direction.y * 4, 0, 2)
		sun.visible = true
	else:
		sun.light_energy = 0.0
		sun.visible = false

func star_map():
	pass
