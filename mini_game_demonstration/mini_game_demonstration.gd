extends Node

var user : UserModel

@export var CBTT: PackedScene = preload("res://SequenceGame/InvestigationBoardGame.tscn")
@export var Stop_Go: PackedScene = preload("res://Stop_Go/stop_go_world.tscn")
@export var WCST: PackedScene = preload("res://WCST/wcst_view.tscn")

func _ready():
	user = User_Data_Manager.load_resource()


func _on_cbtt_start_game_pressed():
	$Demo.hide()
	load_game(CBTT)

func _on_stop_go_start_game_pressed():
	#get_tree().change_scene_to_file("res://Stop_Go/stop_go_world.tscn")
	load_game(Stop_Go)
	$Demo.hide()
	#var game = load("res://Stop_Go/stop_go_world.tscn")
	#var game_instance = game.instantiate()
	#add_child(game_instance)
	#game_instance.connect("mini_game_finished", Callable(self, "_on_game_finished"))
	#load_game(Stop_Go)

func _on_wcst_start_game_pressed():
	load_game(WCST)
	$Demo.hide()


func _on_reset_user_pressed():
	user.reset_user_data()
	User_Data_Manager.save(user)


func load_game(game: PackedScene):
	var game_instance = game.instantiate()
	add_child(game_instance)
	game_instance.connect("mini_game_finished", Callable(self, "_on_game_finished"))
	
	
func _on_game_finished():
	$Demo.show()
	for child in get_children():
		if child is Node and child.has_signal("mini_game_finished"):
			remove_child(child)
			child.queue_free()
			break
