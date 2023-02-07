extends Node

func _ready():
	$TutorialDialog.next_phase()

func _on_TutorialDialog_on_ended():
	$OneInfiniteMechanic.reset()
