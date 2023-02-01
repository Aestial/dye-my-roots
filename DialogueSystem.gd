extends Control

export var dialog_path = ""
export(float) var speed = 0.05
var dialog

var index = 0
var finished = false
var is_typing

func _ready():
	$Timer.wait_time = speed
	dialog = get_dialog()
	assert(dialog, "Dialog not found")
	next_phase()
	
func _process(_delta):
	$Indicator.visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			next_phase()
		else:
			$Phrase/Text.visible_characters = len($Phrase/Text.text)
			# Voice speak stop
	
func next_phase() -> void:
	if index >= len(dialog):
		queue_free()
		return
		
	finished = false
	$Phrase/Name.bbcode_text = dialog[index]["Name"]
	$Phrase/Text.bbcode_text = dialog[index]["Text"]
	
	$Phrase/Text.visible_characters = 0
	
	# Voice speak start with text
	
	while $Phrase/Text.visible_characters < len($Phrase/Text.text):
		$Phrase/Text.visible_characters += 1
		$Timer.start()
		yield($Timer, "timeout")
		
	finished = true
	index += 1
	return
	
func get_dialog() -> Array:
	var f = File.new()
	assert(f.file_exists(dialog_path), "File path does not exist")
	
	f.open(dialog_path, File.READ)
	var json = f.get_as_text()
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
