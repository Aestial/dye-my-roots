extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func preview(color):
	$Preview.self_modulate = color

func submit(color):
	# current_dye.submit(color)
	pass

func _on_LineEdit_text_changed(new_text):
	var color = Color(new_text)
	preview(color)

func _on_LineEdit_text_entered(new_text):
	var color = Color(new_text)
	preview(color)
	submit(color)
