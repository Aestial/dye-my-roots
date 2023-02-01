extends Control

export var dialog_path = ""
var dialog

var index = 0
var finished = false
var is_typing

onready var voicebox: ACVoiceBox = $ACVoicebox

func _ready():
	voicebox.connect("characters_sounded", self, "_on_voicebox_characters_sounded")
	voicebox.connect("finished_phrase", self, "_on_voicebox_finished_phrase")
	dialog = get_dialog()
	assert(dialog, "Dialog not found")
	clear()
	
func _process(_delta):
	$Indicator.visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			next_phase()
		else:
			voicebox.stop()
	
func clear():
	$Phrase/Name.bbcode_text = ""
	$Phrase/Text.bbcode_text = ""
	$Phrase/Text.visible_characters = 0
	
func next_phase() -> void:
	if index >= len(dialog):
		queue_free()
		return
		
	finished = false
	
	$Phrase/Name.bbcode_text = dialog[index]["Name"]
	$Phrase/Text.bbcode_text = dialog[index]["Text"]
	voicebox.base_pitch = dialog[index]["Pitch"]
	
	$Phrase/Text.visible_characters = 0
	voicebox.play_string($Phrase/Text.text)
	
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

func _on_voicebox_characters_sounded(characters: String):
	$Phrase/Text.visible_characters += 1

func _on_voicebox_finished_phrase():
	$Phrase/Text.visible_characters = len($Phrase/Text.text)
	finished = true
	index += 1
