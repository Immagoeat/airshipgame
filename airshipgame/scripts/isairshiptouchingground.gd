extends Area3D



var airshiponground := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_body_entered(body: Node3D):
	airshiponground = true
	get_parent().lockdownwards()

func _on_body_exited(body: Node3D):
	airshiponground = false
	get_parent().unlockdownwards()


	
