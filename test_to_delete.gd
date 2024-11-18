extends Node2D

signal request_user_data
signal update_player_stats

@onready var datamanager = preload("res://SequenceGame/CBTT_DataManager.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	await setup_things()
	print("pleasseeeee")
	#emit_signal("request_user_data")
	var data = {"id": 2343, "name": "jeremiah", "randnum": 234524}
	emit_signal("update_player_stats", data)

func setup_things():
	var datamanagerscene = datamanager.instantiate()
	datamanagerscene.initialize(self)
	call_deferred("add_child", datamanagerscene)
