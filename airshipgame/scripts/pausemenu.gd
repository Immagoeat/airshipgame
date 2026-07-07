extends Control

@onready var check_button: CheckButton = $YourExactNodeNameHere

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if check_button:
		check_button.set_pressed_no_signal(Globals.film_grain_toggle)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().quit()


func _on_check_button_toggled(toggled_on: bool) -> void:
	Globals.film_grain_toggle = toggled_on

func _on_resume_button_pressed() -> void:
	pass 
	
