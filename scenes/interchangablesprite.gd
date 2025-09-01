extends Control

@onready var spritebefore = $before
@onready var spriteafter = $before/after

@onready var spriteDir = "res://sprites/CharacterSprites/"

var previoustag:String
var tween:Tween

var currentlyVisible = false #true = after, false = before

func spritechange(tag:String) -> void:
	if tag == "":
		return
	else:
		var newSprite = load(spriteDir + tag + ".png")
		if previoustag == tag:
			return
		else:
			tween = create_tween()
			tween.set_parallel()
			if currentlyVisible == false:
				spritebefore.texture = newSprite
				tween.tween_property(spritebefore, "self_modulate:a", 1, .5)
				tween.tween_property(spriteafter, "self_modulate:a", 0, .5)
				currentlyVisible = true
			else:
				spriteafter.texture = newSprite
				tween.tween_property(spritebefore, "self_modulate:a", 0, .5)
				tween.tween_property(spriteafter, "self_modulate:a", 1, .5)
				currentlyVisible = false
			await tween.finished
			tween.kill()
			previoustag = tag
