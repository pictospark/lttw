extends Node2D

func _ready() -> void:
	$pictologo.play()
	$pictoaudio.play()
	await $pictoaudio.finished
	var tween = create_tween()
	tween.tween_property($pictologo, "modulate:a", 0, .5)
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	$godotlogo.visible = true
	$godotlogo.play()
	$godotaudio.play()
	await $godotaudio.finished
	tween = create_tween()
	tween.tween_property($godotlogo, "modulate:a", 0, .5)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/game.tscn")
