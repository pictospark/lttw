extends Node2D

@onready var score = ScoreManagement.score

func _ready() -> void:
	if score <= 0:
		$rating.text = "SHIT"
	elif score >= 1 and score < 10:
		$rating.text = "GOOD"
	elif score >= 10:
		$rating.text = "GREAT"

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_down"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")
