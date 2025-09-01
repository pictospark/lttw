extends Node2D

@onready var textbox = $Textbox
@onready var menu = $menu
@onready var dialoguenode = get_node("Current Dialogue")
@onready var wheel:Wheel = $Wheel

@onready var anim = $Wheel/AnimationPlayer

@onready var tutorialbutton = $tutorial
@onready var notutorialbutton = $notutorial

var current_wheel_value:int = 0

var music = AudioStreamPlayer2D.new()


var character:String

var chardir
var gamephase = 1
var gamesubphase = 1
var subsubphase = ["good", "bad", "great"]
var previoussubsubphase = 0
var tutorialOver = false
var orderedFood = false
var foodDelivered = false
var orderedFoodAlready = false
var gottedFood = false

var character_data

var score = 0

# -----------------------------------------TUTORIAL--------------------------------------------#


var opening = [
	"none
ay ay yo yo
buckypoint
yo yo ay ay
buckypoint",
	"none
make WAYYYY I NEED TO GET TO MY APPRENTICEEEEEEEE
none
THIS IS IMPORTAAAAAAAAAAAAAAAAANT
buckypoint",
	"none
imlateimlateiMLATEIMLATEIMLATEIMLATEIMALETIMELATMTEKIDFS
none
...
buckylaugh
no im not i lied
buckypoint"
]

func _ready() -> void:
	wheel.set_process_input(false)
	music.autoplay = true

func _on_menu_game_start() -> void:
	character = "cathy"
	chardir = "res://jsons/" + character + ".json"
	
	textbox.charname = "???"
	dialoguenode.text = str(opening[randi_range(0,2)])
	textbox.dialogue = dialoguenode
	call_textbox()
	await textbox.boxclosed
	
	var funnysound = AudioStreamPlayer2D.new()
	funnysound.stream = load("res://sounds/buckyentrancefunny.ogg")
	add_child(funnysound)
	funnysound.play()
	anim.play("buckee")
	await anim.animation_finished
	textbox.charname = "Bucky"
	dialoguenode.text = "buckylaugh
Hoooo boy! Today's the big day, eh?
buckyneutral
Ya nervous? I bet yer nervous.
buckylaugh
You ain't got nothing to sweat man. Again, I know this girl up and down.
buckysrs
Metaphorically.
buckyreach
And plus, I got a lil something for you.
buckyreach
An old family good luck charm, passed down from generations and generations.
buckyWHEEL
Boom.
buckywheel
As your dating coach, I believe you're now worthy enough to inherit this charm.
buckyfuckingwithwheel
But first, I gotta show you how it works.
buckyfuckingwithwheel
Unless you for some reason know exactly how this thing works despite me only ever showing it to you now."
	call_textbox()
	add_child(music)
	change_music(1)
	await textbox.boxclosed
	choicesenable()

func BRINGINTHEWHEEL():
	wheel.visible = true
	anim.play("weel on")
	
	
func choicesenable():
	textbox.CHOICE = true
	tutorialbutton.visible = true
	notutorialbutton.visible = true
		
func _on_tutorial_pressed() -> void:
	textbox.CHOICE = false
	tutorialbutton.visible = false
	notutorialbutton.visible = false
	dialoguenode.text = "buckyneutral
Aight I gotchu fam.
buckyneutral
Don't be intimidated by it's innovative and complex design; it's actually really simple.
buckyneutral
Each segment of the wheel is given a value, from -1 to 2. These correspond to yer girl's likes and dislikes.
buckyneutral
Each slice in the wheel is a multiplier, smallest being x1 and the biggest being x4.
buckysrs
(or maybe it was the other way around? uhhh...)
buckylaugh
...Err, whatever, it doesnt matter! Just focus on getting the big slices on the good options and you'll be set.
buckyneutral
You can use your directional buttons to select a segment of the wheel. But I'm assuming you knew that already.
buckyneutral
Every time you select an option, the wheel will spin clockwise once. Make sure you plan ahead!
buckyneutral
And remember, you can't just chose the same options over and over again. Context is very important.
buckyneutral
Like for example, you wouldn't want to crack a joke if your date's talking about how her dad just died. Be glad I'm telling you this now, cuz nobody told me.
buckyneutral
And that's pretty much it for the wheel!
buckyneutral
Now, I think we should work on some one liners for you. Chicks love that shit.
none
I personally like to go for a-
none
...Oh, that's her.
none
I'll get into position. You got this, man."
	call_textbox()
	await textbox.boxclosed
	startthegameforreal()

func _on_notutorial_pressed() -> void:
	textbox.CHOICE = false
	tutorialbutton.visible = false
	notutorialbutton.visible = false
	dialoguenode.text = "buckylaugh
I like that confidence, man. I like that. We like that. We all like that.
buckyneutral
In that case, I'm gonna get into position. Knock em' dead, bud.
none"
	call_textbox()
	await textbox.boxclosed
	#Intro Bucky animation goes here. Instantiate the background bucky
	startthegameforreal()
	
#------------------------------------------------GAME--------------------------------------------------#

var finalVal

func parsedata(file):
	if FileAccess.file_exists(file):
		var datafile =  FileAccess.open(file, FileAccess.READ)
		var parsedshit = JSON.parse_string(datafile.get_as_text())
		if parsedshit is Dictionary:
			print("character file parsed")
			return parsedshit
		else:
				print("uh oh")
	else:
		print("fuck")
		print(chardir)

func startthegameforreal():
	print("GAAAAAAAAAAAAAAAAMEEEEEEEEEEEEEEEEEEE STARRRRRRRRRRRRRRRRRRRTTTTTTTTTTTTTTTT")
	remove_child(music)
	change_music(0)
	add_child(music)
	
	character_data = parsedata(chardir)
	tutorialOver = true
	textbox.closebox()
	initphase(1,1,"good")
	if wheel.visible == false:
		wheel.visible = true
		anim.play("weel on")
		await anim.animation_finished
		anim.play("wheeldown")
	else:
		anim.play("wheeldown")
		
func initphase(phase:int, subphase:int, level:String):
	print("!!!!!!!!!!!!!!!! A NEW PHASE HAS BEEN CALLED!!!!!!!!!!!!!!!!!!!")
	if subphase >= 4:
		gamesubphase = 1
		subphase = 1
		gamephase += 1
		phase += 1
		print("wait nvm")
		initphase(gamephase,gamesubphase,subsubphase[previoussubsubphase])
		return
	if gamephase == 2 and orderedFoodAlready == false:
		orderFood()
		return
	if gamephase == 3 and gottedFood == false:
		getFood()
		return
	if gamephase == 4:
		endGame()
		return
	dialoguenode.text = str(character_data[str(phase)][str(subphase)]["dialogue"][level])
	textbox.charname = character_data["name"]
	call_textbox()
	await textbox.boxclosed
	initwheel()

func call_textbox():
	textbox.index = -1
	textbox.init_box()
		
func initwheel():
	#how the fuck do i use this
	print("WHEEL DEPLOYED")
	print("SUBSUBPHASE VAL =" + str(gamesubphase))
	print("PHASE VAL =" + str(gamephase))
	wheel.base_numbers = character_data[str(gamephase)][str(gamesubphase)]["values"][str(subsubphase[previoussubsubphase])]
	wheel.reset()
	anim.play("weel on")
	await wheel.puzzle_finished
	finalVal = wheel._current_value.total_value
	anim.play("wheelfadeout")
	
	await get_tree().create_timer(1).timeout
	determine_phase()
	
var snds = [load("res://sounds/bad.wav"), load("res://sounds/good.wav"), load("res://sounds/great.wav")]
var sfx = AudioStreamPlayer2D.new()

func determine_phase():
	add_child(sfx)
	print("FinalVal = " + str(finalVal))
	if finalVal <= 0:
		score += -1
		print("YOU DID SHIT!!!!!!!!!!!!!!!!!!")
		sfx.stream = snds[0]
		sfx.play()
		await initresponse(gamephase, gamesubphase, subsubphase[previoussubsubphase], "bad")
		previoussubsubphase = 1
	elif finalVal >= 1 and finalVal <= 4:
		score += 1
		sfx.stream = snds[1]
		sfx.play()
		print("YOU DID GOOD!!!!!!!!!!!!!!!!!!")
		await initresponse(gamephase, gamesubphase, subsubphase[previoussubsubphase], "good")
		previoussubsubphase = 0
	elif finalVal > 4:
		score += 2
		sfx.stream = snds[2]
		sfx.play()
		print("YOU DID GREAT!!!!!!!!!!!!!!!!!!")
		await initresponse(gamephase, gamesubphase, subsubphase[previoussubsubphase], "great")
		previoussubsubphase = 2
	
func initresponse(phase:int,subphase:int,level1:String, level2:String):
	print("!!!!!!!!!!!!!! INITRESPONSE CALLED !!!!!!!!!!!!!!!!!")
	print("Initializing phase "+str(phase)+", subphase "+str(subphase)+", on level " +level1 + level2)
	dialoguenode.text = str(character_data[str(phase)][str(subphase)]["dialogue"][str(level1 + level2)])
	textbox.charname = character_data["name"]
	call_textbox()
	if level2 == "bad":
		var tween:Tween = create_tween()
		tween.tween_property(music,"pitch_scale", 0.8, 1)
		await tween.finished
		tween.kill()
	else:
		var tween:Tween = create_tween()
		tween.tween_property(music,"pitch_scale", 1, 1)
		await tween.finished
		tween.kill()
	await textbox.boxclosed
	gamesubphase += 1
	initphase(phase,gamesubphase,level2)
	return
	
func endGame():
	print("game end")
	ScoreManagement.score = score
	print("Final score: " + str(score))
	get_tree().change_scene_to_file("res://scenes/results.tscn")
	

func orderFood():
	change_music(1)
	orderedFoodAlready = true
	textbox.charname = "Waitress"
	dialoguenode.text = "
	Hello! Are you two ready to order?"
	$SubViewportContainer/SubViewport/Environment.waitressAnim("enter")
	call_textbox()
	await textbox.boxclosed
	await get_tree().create_timer(.5).timeout
	textbox.charname = character_data["name"]
	dialoguenode.text = character_data["order"]
	call_textbox()
	await textbox.boxclosed
	#$foodmenu.visible = true
	#await $foodmenu.ordered
	#Play anim of Bucky being kicked out here
	#$foodmenu.visible = false
	textbox.charname = "Waitress"
	dialoguenode.text = "
	Thank you. Your food will be ready shortly."
	$SubViewportContainer/SubViewport/Environment.waitressAnim("2")
	call_textbox()
	await textbox.boxclosed
	$SubViewportContainer/SubViewport/Environment.waitressAnim("leave")
	textbox.charname = character_data["name"]
	initphase(2,1,subsubphase[previoussubsubphase])
	
func getFood():
	gottedFood = true
	textbox.charname = "Waitress"
	dialoguenode.text = "
	Here is your food. Enjoy."
	$SubViewportContainer/SubViewport/Environment.waitressAnim("enter")
	call_textbox()
	await textbox.boxclosed
	$SubViewportContainer/SubViewport/Environment.waitressAnim("leave")
	textbox.charname = character_data["name"]
	initphase(3,1,subsubphase[previoussubsubphase])

func change_music(track:int):
	var audiotween = create_tween()
	print("MUSIC PLAYING = " + str(music.playing))
	# 0 - Main Theme / 1 - Coach / 
	var tracks = [
		load("res://myusic/dasdask.jnbadsj.knhdashjl.mp3"),
		load("res://myusic/coach.mp3")
	]
	audiotween.tween_property(music,"volume_db", -80, 2)
	await audiotween.finished
	music.volume_db = -8
	music.stream = tracks[track]
	music.play()
