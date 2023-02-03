extends Node

func _ready():
	$"../DialogSystem".next_phase()
	
func _on_Player_submit(color):
	print(color)
	$Dye.submit(color)

func _on_Dye_dyed(distance):
	var dollars = 1.0/(distance/2) * 1.50
	print("Dollars earned: %s" %dollars)
	$Dye.reset()

func _on_DialogSystem_finished():
	$Dye.reset()
