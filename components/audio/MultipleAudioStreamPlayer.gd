extends Node

export(Array, AudioStream) var streams
var players = []

func _ready():
	for stm in streams:
		var player = AudioStreamPlayer.new()
		players.append(player)
		add_child(player)

func play_all ():
	for i in range(len(streams)):
		var player = players[i]
		var stream = streams[i]
		player.stream = stream
		player.play()
