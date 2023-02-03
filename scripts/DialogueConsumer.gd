extends Node

var good = "[center]Good enough![/center]"
var nonsense = "[center]Yo' talking [color=#e2b3d5]nonsense!![/color][/center]"

var started = false

func _ready():
	pass # Replace with function body.

func _process(_delta):
	if (!Input.is_action_just_pressed("ui_up") or started):
		return
	started = true
	
