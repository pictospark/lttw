extends Node2D

func _process(delta: float) -> void:
	$Camera2D.position = (get_local_mouse_position())


func _on_textbox_spritechange(tag:String) -> void:
	$ParallaxBackground/ParallaxLayer5/interchangablesprite.spritechange(tag)

func waitressAnim(anim: String):
	$ParallaxBackground/ParallaxLayer5/Waitress/AnimationPlayer.play(anim)
