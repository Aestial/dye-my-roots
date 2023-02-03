extends Node2D

signal submit(color)

func _ready():
	reset()
	
func reset():
	$LineEdit.clear()
	$Preview.self_modulate = Color.whitesmoke

func preview(color):
	$Preview.self_modulate = color

func submit(color):
	emit_signal("submit", color)
	reset()

func _on_LineEdit_text_changed(new_text):
	var color = Color(new_text)
	if color:
		preview(color)

func _on_LineEdit_text_entered(new_text):
	var color = Color(new_text)
	if color:
		submit(color)
	else:
		print("Enter a valid color!")
