extends Node3D

@export var height: int = 32
@export var width: int = 32
@export var depth: int = 32
@export var fill_threshold: float = 0.0

var noise: FastNoiseLite = FastNoiseLite.new()

func _ready() -> void:
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = randi()
	noise.frequency = 0.1
	
	generate_3d_map()


func generate_3d_map() -> void:
	var box_mesh = BoxMesh.new()
	box_mesh.size = Vector3(1, 1, 1)
	
	for x in range(width):
		for y in range(depth):
			for z in range(height):
				var noise_val = noise.get_noise_3d(float(x), float(y), float(z))
				var height_factor = float(y)/float(depth)
				var density = noise_val - (height_factor - 0.5)
				
				if density > fill_threshold:
					var block = MeshInstance3D.new()
					block.mesh = box_mesh
					block.position = Vector3(x, y, z)
					add_child(block)
					
				
