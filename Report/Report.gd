extends Node2D


enum Report_Type {CBTT,SG,WCST}
var game_type : Report_Type

#text info for report, could be in a dict with user so the whole dict is passed and has everything
var sequence_tracking : Array = ["Sequences completed", "Total correct", "Crimes solved", "Overall Performance"]
var stop_go_tracking : Array = ["Probability of successful inhibition","Average reaction time", "Stop signal reaction time", "Evidence collected", "Accidents avoided"]
var wcst_tracking : Array = []

var chosen_texts : Array


func set_game_type(game_type_in: int):
	match game_type_in:
		0:
			game_type = Report_Type.CBTT
			chosen_texts = sequence_tracking
		1:
			game_type = Report_Type.SG
		2:
			game_type = Report_Type.WCST
		_:
			pass

func _ready(): #maybe init - takes in values needed for report
	#setup_report(0,[[3,4,2,1,5,8]],["10","4/10","4","50/100"])
#func _init(longest_legnth: int, total_correct: Array, crimes_solved: int, overall_performance: Array:
	#pass #above are arrays for fractions, but this is specific to sequence, others would be rather different
	#should instead take in users session obj with that games specific info - one will tell type 0-2
	#take in the above mentioned dict
	pass

func setup_report(game_type_in: int, performances: Dictionary, scores: Array, controller):
	set_game_type(game_type_in)
	var key = setup_graph(performances,controller)
	set_tracking_texts()
	set_scores(scores)
	setup_graph_key(key)


func set_tracking_texts():
	#if this type, or from dict take each - keys maybe be the strings
	var position_track = Vector2(40,120)
	for text in chosen_texts:
		var label = Label.new()
		label.position = position_track
		label.text = text
		label.set("theme_override_colors/font_color",Color(0,0,0))
		label.set("theme_override_font_sizes/font_size",20)
		position_track.y += 70
		$Page1.add_child(label)
		#var left_space = 379 - label.rect_size.x
		
func set_scores(scores: Array):
	var position_track_x = 350
	var position_track_y = 120
	for score in scores:
		var label = Label.new()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		label.text = str(score)
		label.position = Vector2(position_track_x,position_track_y)
		label.set("theme_override_colors/font_color",Color(1,0,0))
		label.set("theme_override_font_sizes/font_size",20)
		$Page1.add_child(label)
		position_track_y += 70
	
#graph updating logic
func setup_graph(performances: Dictionary, controller): #controller will come in as whatever game controller it is
	
	if game_type == Report_Type.CBTT:
		var colors = [Color(1,0,0),Color(0,1,0),Color(0,0,1)]
		var per_count = 0
		var key = {}
		$Page2/graph_cont/GraphReport.set_tick_vars(43,26)
		$Page2/graph_cont/GraphReport.build_graph(3,9,0,1,1,"Sequence Length","Sequence Completed")
		for per in performances:
			var points = $Page2/graph_cont/GraphReport.determine_line_points_sequence(performances[per])
			if points != null:
				$Page2/graph_cont/GraphReport.create_line(points, colors[per_count])
				key[per] = colors[per_count]
				per_count += 1
		return key
	elif game_type == Report_Type.SG:
		var key = {}
		$Page2/graph_cont/GraphReport.set_tick_vars((305/controller.get_performances().size()),8)
		$Page2/graph_cont/GraphReport.build_graph(1,controller.get_performances().size(),0,1,50, "Stop Go Trials", "Reaction Time")
		for per in performances:
			var points = $Page2/graph_cont/GraphReport.determine_line_points_stop_go(performances[per])
			if points != null:
				$Page2/graph_cont/GraphReport.create_line(points,Color(0,0,0))
				key[per] = Color(0,0,0)
		key["Unsuccessful stop trial"] = Color(1,0,0)#this should be the x
		key["Incorrect go trial"] = Color(1,1,0)
		return key	
	elif game_type == Report_Type.WCST:
		pass
	

func setup_graph_key(keys: Dictionary):
	var y_coord_counter = 30
	for key in keys:
		var label = Label.new()
		label.set("theme_override_colors/font_color",Color(0,0,0))
		label.set("theme_override_font_sizes/font_size",15)
		label.text = key
		#label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		label.position = Vector2(60,y_coord_counter)
		$Page2/graph_key_cont.add_child(label)
		var line = Line2D.new()
		line.default_color = keys[key]
		line.points =[Vector2(15,y_coord_counter+13),Vector2(45,y_coord_counter+13)]
		line.width = 3
		y_coord_counter += 15
		$Page2/graph_key_cont.add_child(line)








