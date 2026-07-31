extends Control

@onready var check_button: CheckButton = $CheckButton

var ison: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if check_button:
		check_button.set_pressed_no_signal(Globals.film_grain_toggle)
	if Globals.grainbuttonstate:
		check_button.button_pressed = true
	elif !Globals.grainbuttonstate:
		check_button.button_pressed = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if check_button.button_pressed:
		Globals.filmgrain = true
		Globals.nofilmgrain = false
		Globals.grainbuttonstate = true
	elif !check_button.button_pressed:
		Globals.filmgrain = false
		Globals.nofilmgrain = true
		Globals.grainbuttonstate = false


func _on_button_pressed() -> void:
	get_tree().quit()
