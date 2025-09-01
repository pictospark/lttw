extends Control

@onready var txtname = $box/name
@onready var bodytxt = $box/body
@onready var anims = $box/AnimationPlayer

var CHOICE = false
var index = -1

var curLine:String
var dialogue:TextEdit
var charname:String

var tween:Tween
var isTextBoxActive = false #to separate dialogue from wheel gameplay (presumably i hope past me isnt lying to me)
var canInput = true

signal boxclosed
signal spritechange

#1) Parse JSON
#2) Set name text with name in json
#3) Paste dialogue for current phase from json into a TextEdit
#4) Draw the rest of the owl


func _process(_delta: float) -> void:
	if isTextBoxActive == true:
		if Input.is_action_just_pressed("ui_accept") and !tween.is_running() and CHOICE == false and canInput == true:
				proceedtext()
func init_box():
	print("Textbox called")
	isTextBoxActive = true
	anims.play("fadein")
	proceedtext()
				
func proceedtext():
	bodytxt.visible_characters = 0
	#odd numbers are sprite tags, evens are actual dialogue. and by odds i mean evens and by evens i mean odds because computers count weird
	index = index + 1
	spritechange.emit(str(dialogue.get_line(index)))
	index = index + 1
	txtname.text = charname
	if charname.is_empty():
		txtname.text = "null"
	
	curLine = dialogue.get_line(index)
	bodytxt.text = curLine
	if curLine == "":
		closebox()
	
	tween = create_tween()
	tween.tween_property(bodytxt,"visible_characters",curLine.length(), curLine.length() * 0.03)
	await tween.finished
	tween.kill()
	return

func closebox():
	if CHOICE == false:
		isTextBoxActive = false
		anims.play("fadeout")
		boxclosed.emit()
