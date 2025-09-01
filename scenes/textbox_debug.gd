extends Node2D

@onready var textbox = $Textbox
@onready var textedit = $TextEdit

func _ready() -> void:
	textbox.dialogue = textedit
	textbox.init_box()
