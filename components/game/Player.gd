extends Node2D

signal submit(color)

func _ready():
	$Cloud.visible = false

func reset():
	$Cloud.visible = true
	$Cloud/LineEdit.clear()
	$Cloud/Preview.self_modulate = Color.whitesmoke
	$Cloud/LineEdit.add_color_override("font_color", Color.whitesmoke)
	$Cloud/LineEdit.grab_focus()

func preview(color):
	$Cloud/Preview.self_modulate = color
	$Cloud/LineEdit.add_color_override("font_color", color)

func _on_LineEdit_text_changed(new_text):
	var validation = validate_color(new_text)
	show_feedback(validation.is_valid)
	if validation.is_valid:
		preview(validation.color)

func _on_LineEdit_text_entered(new_text):
	var validation = validate_color(new_text)
	if validation.is_valid:
		emit_signal("submit", validation.color)
	else:
		$InvalidStreamPlayer.play()

func validate_color(new_text):
	var color = Color(new_text)
	var is_valid_color = not color.is_equal_approx(Color.black)
	var has_valid_length = len(new_text) == 6
	return {
		"is_valid": is_valid_color and has_valid_length, 
		"color": color
	}

func show_feedback(is_valid):
	$Cloud/LineEdit/Good.visible = is_valid
	$Cloud/LineEdit/Wrong.visible = not is_valid
