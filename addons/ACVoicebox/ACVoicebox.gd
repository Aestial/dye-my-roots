extends AudioStreamPlayer
class_name ACVoiceBox

signal characters_sounded(characters)
signal finished_phrase()


const PITCH_MULTIPLIER_RANGE := 0.3
const INFLECTION_SHIFT := 0.4

export(float, 1.5, 4.5) var base_pitch := 3.5

const sounds = {
	'a': preload('res://addons/ACVoicebox/Sounds/a.wav'),
	'b': preload('res://addons/ACVoicebox/Sounds/b.wav'),
	'c': preload('res://addons/ACVoicebox/Sounds/c.wav'),
	'd': preload('res://addons/ACVoicebox/Sounds/d.wav'),
	'e': preload('res://addons/ACVoicebox/Sounds/e.wav'),
	'f': preload('res://addons/ACVoicebox/Sounds/f.wav'),
	'g': preload('res://addons/ACVoicebox/Sounds/g.wav'),
	'h': preload('res://addons/ACVoicebox/Sounds/h.wav'),
	'i': preload('res://addons/ACVoicebox/Sounds/i.wav'),
	'j': preload('res://addons/ACVoicebox/Sounds/j.wav'),
	'k': preload('res://addons/ACVoicebox/Sounds/k.wav'),
	'l': preload('res://addons/ACVoicebox/Sounds/l.wav'),
	'm': preload('res://addons/ACVoicebox/Sounds/m.wav'),
	'n': preload('res://addons/ACVoicebox/Sounds/n.wav'),
	'o': preload('res://addons/ACVoicebox/Sounds/o.wav'),
	'p': preload('res://addons/ACVoicebox/Sounds/p.wav'),
	'q': preload('res://addons/ACVoicebox/Sounds/q.wav'),
	'r': preload('res://addons/ACVoicebox/Sounds/r.wav'),
	's': preload('res://addons/ACVoicebox/Sounds/s.wav'),
	't': preload('res://addons/ACVoicebox/Sounds/t.wav'),
	'u': preload('res://addons/ACVoicebox/Sounds/u.wav'),
	'v': preload('res://addons/ACVoicebox/Sounds/v.wav'),
	'w': preload('res://addons/ACVoicebox/Sounds/w.wav'),
	'x': preload('res://addons/ACVoicebox/Sounds/x.wav'),
	'y': preload('res://addons/ACVoicebox/Sounds/y.wav'),
	'z': preload('res://addons/ACVoicebox/Sounds/z.wav'),
	'th': preload('res://addons/ACVoicebox/Sounds/th.wav'),
	'sh': preload('res://addons/ACVoicebox/Sounds/sh.wav'),
	' ': preload('res://addons/ACVoicebox/Sounds/blank.wav'),
	'.': preload('res://addons/ACVoicebox/Sounds/longblank.wav')
}


var remaining_sounds := []


func _ready():
	connect("finished", self, "play_next_sound")


func play_string(in_string: String):
	parse_input_string(in_string)
	play_next_sound()

func stop():
	remaining_sounds.clear()

func play_next_sound():
	if len(remaining_sounds) == 0:
		emit_signal("finished_phrase")
		return
	var next_symbol = remaining_sounds.pop_front()
	emit_signal("characters_sounded", next_symbol.characters)
	# Skip to next sound if no sound exists for text
	if next_symbol.sound == '':
		play_next_sound()
		return
	var sound: AudioStreamSample = sounds[next_symbol.sound]
	# Add some randomness to pitch plus optional inflection for end word in questions
	pitch_scale = base_pitch + (PITCH_MULTIPLIER_RANGE * randf()) + (INFLECTION_SHIFT if next_symbol.inflective else 0.0)
	stream = sound
	play()


func parse_input_string(in_string: String):
	for word in in_string.split(' '):
		parse_word(word)
		add_symbol(' ', ' ', false)
	

func parse_word(word: String):
	var skip_char := false
	var is_inflective := word[-1] == '?'
	for i in range(len(word)):
		if skip_char:
			skip_char = false
			continue
		# If not the last letter, check if next letter makes a two letter substring, e.g. 'th'
		if i < len(word) - 1:
			var two_character_substring = word.substr(i, i+2)
			if two_character_substring.to_lower() in sounds.keys():
				add_symbol(two_character_substring.to_lower(), two_character_substring, is_inflective)
				skip_char = true
				continue
		# Otherwise check if single character has matching sound, otherwise add a blank character
		if word[i].to_lower() in sounds.keys():
			add_symbol(word[i].to_lower(), word[i], is_inflective)
		else:
			add_symbol('', word[i], false)


func add_symbol(sound: String, characters: String, inflective: bool):
	remaining_sounds.append({
		'sound': sound,
		'characters': characters,
		'inflective': inflective
	})
