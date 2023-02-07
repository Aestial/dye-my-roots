extends Control

signal on_ended

export var declaration = "/root/MissKellyDeclaration"

var dialog
var ended = false
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
	var name_bbcode = "[color=%s][b] %s [/b][/color]" % [phrase["NameColor"], phrase["Name"]]
	$Phrase/Name.bbcode_text = name_bbcode
	$Phrase/Text.bbcode_text = phrase["Text"]
	voicebox.base_pitch = phrase["Pitch"]

	# Call PortraitTexture function with character and emotion as parameters
	$Background/PortraitTexture.set_emotion(declaration, phrase["Emotion"])
	
	$Phrase/Text.visible_characters = 0
	voicebox.play_string($Phrase/Text.text)
	
func get_dialog() -> Array:
	var array = get_node(declaration).dialogues
	if typeof(array) == TYPE_ARRAY:
		return array
	else:
		return []

func _on_voicebox_characters_sounded(characters: String):
	var count = len(characters)
	$Phrase/Text.visible_characters += count

func _on_voicebox_finished_phrase():
	$Phrase/Text.visible_characters = len($Phrase/Text.text)
	finished = true
	index += 1
