extends Control

signal on_ended

export var dialog_path = ""
export var faces_root = "res://sprites/faces/"
var dialog

var index = 0
var finished = false
var ended = false
var is_typing

onready var voicebox: ACVoiceBox = $ACVoicebox

func _ready():
	voicebox.connect("characters_sounded", self, "_on_voicebox_characters_sounded")
	voicebox.connect("finished_phrase", self, "_on_voicebox_finished_phrase")
	dialog = get_dialog()
	assert(dialog, "Dialog not found")
	clear()
	
func _process(_delta):
	if ended: return
	$Indicator.visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			next_phase()
		else:
			voicebox.stop()
	if Input.is_action_just_pressed("ui_cancel"):
		end()
		
func end():
	ended = true
	emit_signal("on_ended")
	clear()
	
func clear():
	$Phrase/Name.bbcode_text = ""
	$Phrase/Text.bbcode_text = ""
	$Phrase/Text.visible_characters = 0
	$Background/PortraitTexture.clear()
	
func next_phase() -> void:
	if index >= len(dialog):
		end()
		return
		
	finished = false
	var phrase = dialog[index]
	
	$Phrase/Name.bbcode_text = "[color=%s][b] %s [/b][/color]" % [phrase["NameColor"], phrase["Name"]]
	$Phrase/Text.bbcode_text = phrase["Text"]
	voicebox.base_pitch = phrase["Pitch"]

	# Call PortraitTexture function with character and emotion as parameters
	$Background/PortraitTexture.set_character_emotion(faces_root, phrase["Name"], phrase["Emotion"])
	
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
	var count = len(characters)
	$Phrase/Text.visible_characters += count

func _on_voicebox_finished_phrase():
	$Phrase/Text.visible_characters = len($Phrase/Text.text)
	finished = true
	index += 1
