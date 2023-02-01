extends Sprite

signal dyed

export var wait_time = 5 
export(Color) var target = Color.blanchedalmond

var target_html
var is_editable

func _ready():
	target = Color(randf(), randf(), randf())
	self_modulate = target
	target_html = target.to_html(false)
	# print("Current color: %s" % target_html)
	# Update with instantiated
	is_editable = true
		
func submit(color):
	self_modulate = color
	print("Guess: %s" % color.to_html(false))
	var distance = color_distance_rgb(target, color)
	print("Distance: %s" % distance)
	emit_signal("dyed", distance)
	
func color_distance_rgb(color_a, color_b):
	var r = color_a.r - color_b.r
	var g = color_a.g - color_b.g
	var b = color_a.b - color_b.b
	return sqrt(r*r + g*g + b*b)
