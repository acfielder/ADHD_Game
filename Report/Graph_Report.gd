extends Node2D


const tick_length = 5


var tick_interval_x : int
var tick_interval_y : int 


var origin = Vector2(20,215)

func _ready():
	#var colors = [Color(1,0,0),Color(0,1,0),Color(0,0,1)]
	#var per_count = 0
	#set_tick_vars(43,26)
	#build_graph(3,9,0,1,1)
	#var per = [4,5,3,0,2,0]
	#var points = determine_line_points_sequence(per)
	#if points != null:
	#	create_line(points, colors[per_count])
	#	per_count += 1
	pass
	
#should create a key to stand to the side - should take color and name 
func create_key(key_color: Color, key_name: String):
	pass

func set_tick_vars(x_tick_int: int, y_tick_int: int):
	tick_interval_x = x_tick_int
	tick_interval_y = y_tick_int

	
func build_graph(start_x_count: int, x_count_max: int, start_y_count: int, x_count_increase: int, y_count_increase: int, x_axis_label: String, y_axis_label: String):
	add_tick_lines(start_x_count, x_count_max, start_y_count, x_count_increase, y_count_increase) 
	create_axis_lines()
	create_axis_labels(x_axis_label,y_axis_label)

	#tick_interval, counters-what counting by - need to figure out why those nums for sequence and what should be for stop go
func add_tick_lines(start_x_count: int, x_count_max: int, start_y_count: int, x_count_increase: int, y_count_increase: int):
	#add ticks to x axis
	var x_counter = start_x_count
	for x in range(65, 370, tick_interval_x):
		var tick = Line2D.new()
		tick.points = [Vector2(x, 215 - tick_length), Vector2(x, 215 + tick_length)] #the x values were literally just x
		print(tick.points)
		tick.width = 2
		tick.default_color = Color(0, 0, 0)
		add_child(tick)
		
		if x_counter <= x_count_max:
			var label = Label.new()
			label.text = str(x_counter)
			x_counter += x_count_increase
			label.set_position(Vector2(x - label.get_minimum_size().x / 2, 220))
			label.set("theme_override_colors/font_color", Color(0,0,0))
			label.set("theme_override_font_sizes/font_size", 12)
			add_child(label)
	
	#add ticks to y axis
	var y_counter = start_y_count
	for y in range(215, 35, -tick_interval_y):
		var tick = Line2D.new()
		tick.points = [Vector2(65 - tick_length, y), Vector2(65 + tick_length, y)]
		tick.width = 2
		tick.default_color = Color(0, 0, 0)
		add_child(tick)
		
		var label = Label.new()
		label.text = str(y_counter)
		label.set_position(Vector2(40,y - label.get_minimum_size().y / 2-3))
		label.set("theme_override_colors/font_color", Color(0,0,0))
		label.set("theme_override_font_sizes/font_size", 12)
		add_child(label)
		y_counter += y_count_increase
		
	
	
#these numbers should be fine
func create_axis_lines():
	var x_axis = Line2D.new()
	x_axis.points = [Vector2(65, 215), Vector2(370, 215)]
	x_axis.width = 2
	x_axis.default_color = Color(0, 0, 0)
	add_child(x_axis)
	
	var y_axis
	y_axis = Line2D.new()
	y_axis.points = [Vector2(65, 30), Vector2(65, 215)]
	y_axis.width = 2
	y_axis.default_color = Color(0, 0, 0)
	add_child(y_axis)
	
#x_label: String, y_label: String
func create_axis_labels(x_label_in: String, y_label_in: String):
	var x_label
	x_label = Label.new()
	x_label.text = x_label_in
	x_label.set_position(Vector2(155, 240))
	x_label.set("theme_override_colors/font_color",Color(0,0,0))
	add_child(x_label)
	
	var y_label
	y_label = Label.new()
	y_label.text = y_label_in
	y_label.set_position(Vector2(5, 210))
	y_label.rotation_degrees = -90
	y_label.set("theme_override_colors/font_color",Color(0,0,0))
	add_child(y_label)

	#testing create_line
	#create_line([Vector2(200,400),Vector2(300,300), Vector2(400,500)], Color(1,2,25))
	#testing determine_line_points
	#determine_line_points_sequence([10,15,9,13,11])
	#create_line(determine_line_points_sequence([12,15,16,13,11]), Color(.48,.65,.30))

func create_line(line_points: Array, color: Color):
	var line = Line2D.new()
	line.set_points(line_points)
	line.width = 2
	line.default_color = color
	add_child(line)
		
func determine_line_points_sequence(performance: Array):
	if !all_zero(performance):
		var line_points = []
		for length in range(performance.size()):
			var x = origin.x + ((length + 1) * tick_interval_x)
			var y = origin.y - (tick_interval_y * performance[length])
			line_points.append(Vector2(x,y))
		return line_points
		
func determine_line_points_stop_go(performance: Array, trial_types: Dictionary):
	var line_points = []
	var stop_points = []
	var direction_points = []
	for i in range(performance.size()):
		var x = origin.x + ((i+1) * tick_interval_x) + (tick_interval_x)
		var y = origin.y - (tick_interval_y * (performance[i]/100))
		line_points.append(Vector2(x,y))
		var trial = trial_types[i]
		if trial[0] && !trial[1]:
			direction_points.append(Vector2(x,y))
		elif !trial[0] && !trial[1]:
			stop_points.append(Vector2(x,y))
		#print(line_points)
		#print(stop_points)
		#print(direction_points)
	return [line_points, stop_points, direction_points]
	
func determine_line_points_wcst(performance: Array, trial_info: Dictionary): #trial info - 
	var line_points = []
	var incorrect_points = []
	var rule_change_points = []
	var prev_rule = -1
	for i in range(performance.size()):
		var x = origin.x + ((i+1) * tick_interval_x) #+ (tick_interval_x)
		var y = origin.y - (tick_interval_y * (performance[i]/100))
		line_points.append(Vector2(x,y))
		var trial = trial_info[i]
		if trial[0] != prev_rule:
			rule_change_points.append(Vector2(x,y))
			prev_rule = trial[0]
		if !trial[1]:
			incorrect_points.append(Vector2(x,y))
		print(line_points)
		print(incorrect_points)
		print(rule_change_points)
	return [line_points, incorrect_points, rule_change_points]
	
func add_rule_line(point: Vector2, color: Color):
	var line = Line2D.new()
	var points = [point, Vector2(point.x,origin.y)]
	line.set_points(points)
	line.width = 2
	line.default_color = color
	add_child(line)


func all_zero(array: Array):
	for item in array:
		if item != 0:
			return false
	return true
	
func add_image(point: Vector2,path: String):
	var image = Sprite2D.new()
	image.texture = load(path)
	image.position = point
	image.scale = Vector2(0.01, 0.01)
	add_child(image)
