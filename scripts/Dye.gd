extends Sprite

signal dyed(distance)

export var wait_time = 5 
export(Color) var roots_color = Color.whitesmoke
export(Texture) var curly
export(Texture) var dread
export(Texture) var straight

var is_editable
var target
var target_html
var timer = Timer.new()
var max_value

func _ready():
	max_value = $ProgressBar.max_value
	timer.connect("timeout", self, "on_timeout")
	timer.wait_time = wait_time
	timer.one_shot = true
	add_child(timer)
	# Update when instantiated
	is_editable = true
	
func _process(_delta):
	update_clock(wait_time - timer.time_left)
	
func reset():
	randomize()
	set_hair_style()
	set_hair_color()
	update_clock(0)
	timer.start()
		
func submit(color):
	self_modulate = color
	# print("Guess: %s" % color.to_html(false))
	var distance = color_distance_rgb(target, color)
	print("Color distance: %s" % distance)
	emit_signal("dyed", distance)
	
func set_hair_color():
	var r = rand_range(0.2, 0.8)
	var g = rand_range(0.2, 0.8)
	var b = rand_range(0.2, 0.8)
	target = Color(r, g, b)
	target_html = target.to_html(false)
	self_modulate = roots_color
	$Cloud/Target.self_modulate = target
	# print("Current color: %s" % target_html)
	
func set_hair_style():
	var style
	match randi() % 3:
		0:	
			style = curly
		1:
			style = dread
		2:
			style = straight
	texture = style
	$Cloud/Target.texture = style

func update_clock(elapsed):
	var progress = elapsed / wait_time * max_value
	$ProgressBar.value = max_value - progress

func color_distance_rgb(color_a, color_b):
	var r = color_a.r - color_b.r
	var g = color_a.g - color_b.g
	var b = color_a.b - color_b.b
	return sqrt(r*r + g*g + b*b)

func on_timeout():
	reset()
