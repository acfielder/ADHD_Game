extends Node2D


var Sequence = load("res://Sequence.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_sequence = Sequence.instantiate()
	get_tree().get_root().get_node("InvestigationBoardGame/Board").add_child(new_sequence)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


	
