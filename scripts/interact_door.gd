extends Node
class_name door

@onready var animation_player = get_node("AnimationPlayer")
@export var display_text:String = "Open"

var doorOpen:bool;
# Called when the node enters the scene tree for the first time.
func _ready():
	doorOpen = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact():
	open_close()
	
func open_close():
	if animation_player.is_playing():
		return #avoids playing animation while it's still player
		
	if doorOpen:
		animation_player.play("door_close")
	else:
		animation_player.play("door_open")
	doorOpen = !doorOpen
		

func getInterfaceText():
	return display_text
