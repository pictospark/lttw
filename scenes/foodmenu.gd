extends Control

#signal ordered
#@onready var options = $Menu.get_children()
#func _ready() -> void:
	#for i in options.size():
		#var callable = Callable(self, pressed(i))
		#connect('pressed', pressed)
##fix this bs later
#func pressed(chosen):
	#ordered.emit()
	#ScoreManagement.order = chosen
	#print(ScoreManagement.order)
