extends Control

@onready var menu = $Panel
@onready var charselect = $Panel2

@onready var click = $Panel/clicksnd
@onready var confirm = $Panel/confirmsnd
@onready var secret = $Panel/secretsnd
@onready var music = $music
@onready var musicchord = $fuckinggchord
@onready var anim = $AnimationPlayer

signal game_start

var selectedChar = "cathy"

func _ready() -> void:
	anim.play("fadein")

func opencharselect():
	menu.visible = false
	charselect.visible = true
	
func closecharselect():
	menu.visible = true
	charselect.visible = false

func _on_play_mouse_entered() -> void:
	click.play()

func _on_finderr_mouse_entered() -> void:
	click.play()

func _on_quit_mouse_entered() -> void:
	click.play()

func _on_options_mouse_entered() -> void:
	click.play()

func _on_play_pressed() -> void:
	music.stop()
	musicchord.play()
	release_focus()
	confirm.play()
	anim.play("gamestart")

func _on_finderr_pressed() -> void:
	confirm.play()
	opencharselect()

func _on_quit_pressed() -> void:
	music.stop()
	musicchord.play()
	release_focus()
	confirm.play()
	anim.play("gamestart")
	await anim.animation_finished
	get_tree().quit()

func _on_options_pressed() -> void:
	confirm.play()
	$Panel.visible = false
	$Panel3.visible = true

func _on_code_success() -> void:
	secret.play()

func _on_secretsnd_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/colin.tscn")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "gamestart":
		emit_signal("game_start")
		self.queue_free()

func _on_vicky_pressed() -> void:
	selectedChar = "vicky"
	closecharselect()
	
func _on_cathy_pressed() -> void:
	selectedChar = "cathy"
	closecharselect()
	
func _on_sheila_pressed() -> void:
	selectedChar = "sheila"
	closecharselect()

func _on_me_pressed() -> void:
	confirm.play()
	OS.shell_open("https://bsky.app/profile/pictospark.bsky.social")

func _on_n_pressed() -> void:
	confirm.play()
	OS.shell_open("https://twitter.com/existnt_k#m")


func _on_returnbtn_pressed() -> void:
	confirm.play()
	$Panel3.visible = false
	$Panel.visible = true
	$Logo.visible = true

func _on_returnbtn_mouse_entered() -> void:
	click.play()
