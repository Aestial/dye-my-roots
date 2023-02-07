extends Node

signal completed(gains)

export var base_price = 5
export var lose_price = 15
export var min_likeness = 72
export var price_multiplier = 0.5

var gains = 0
var timer = Timer.new()

func _ready():
	timer.connect("timeout", self, "on_timeout")
	timer.wait_time = 0.88
	timer.one_shot = true
	add_child(timer)

func reset():
	$Dye.reset()
	$Player.reset()
		
func failed():
	gains -= stepify(lose_price, 0.01)
	$FailSFXPlayer.play_all()
	print ("Failed!")
	
func won(likeness):
	var price = base_price + price_multiplier * likeness
	gains += stepify(price, 0.01)
	$WinSFXPlayer.play_all()
	print("Dollars earned: %.02f" % price)
	
func on_timeout():
	reset()

func _on_Dye_completed(likeness):
	if (likeness < min_likeness):
		failed()
	else:
		won(likeness)
	emit_signal("completed", gains)
	timer.start()

func _on_Player_submit(color):
	$Dye.submit(color)
