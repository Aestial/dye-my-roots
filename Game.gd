extends Node

var good = "[center]Good enough![/center]"
var nonsense = "[center]Yo' talking [color=#e2b3d5]nonsense!![/color][/center]"

# Called when the node enters the scene tree for the first time.
func _ready():	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!Input.is_action_just_pressed("ui_down")):
		return
