extends Node2D


@onready var vid = $VideoStreamPlayer

func _ready() -> void:
	DisplayServer.window_set_title("colin")

func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/splashscreenshit.tscn")
#	originally this quit the game but for the html build i just made it restart the game LOL
