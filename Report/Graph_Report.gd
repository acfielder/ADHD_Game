extends Node2D


var tick_length = 5
var tick_interval_x = 43
var tick_interval_y = 26

var x_axis
var y_axis
var x_label
var y_label
var origin = Vector2(100,500)

func _ready():
	#var o_p = Line2D.new()
	#o_p.points = [origin, Vector2(110,510)]
	#o_p.width = 5
	#o_p.default_color = Color(0.36, 0.89, 0.10)
	#add_child(o_p)
	
	x_axis = Line2D.new()
	x_axis.points = [Vector2(65, 215), Vector2(370, 215)]
	x_axis.width = 2
	x_axis.default_color = Color(0, 0, 0)
	add_child(x_axis)
	
	y_axis = Line2D.new()
	y_axis.points = [Vector2(65, 30), Vector2(65, 215)]
	y_axis.width = 2
	y_axis.default_color = Color(0, 0, 0)
	add_child(y_axis)
	
	#add ticks to x axis
	var x_counter = 0
	for x in range(65, 370, tick_interval_x):
		var tick = Line2D.new()
		tick.points = [Vector2(x, 215 - tick_length), Vector2(x, 215 + tick_length)]
		tick.width = 2
		tick.default_color = Color(0, 0, 0)
		add_child(tick)
		
		if x_counter > 0 && x_counter < 9:
			var label = Label.new()
			label.text = str(x_counter)
			x_counter += 1
			label.set_position(Vector2(x - label.get_minimum_size().x / 2, 220))
			label.set("theme_override_colors/font_color", Color(0,0,0))
			add_child(label)
		else:
			x_counter = 3
	
	#add ticks to y axis
	var y_counter = 0
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
		add_child(label)
		y_counter += 1
		
		
	x_label = Label.new()
	x_label.text = "Sequence Length"
	x_label.set_position(Vector2(155, 240))
	x_label.set("theme_override_colors/font_color",Color(0,0,0))
	add_child(x_label)
	
	y_label = Label.new()
	y_label.text = "Sequences Completed"
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
	line.points = line_points
	line.width = 2
	line.default_color = color
	add_child(line)
		
	
func determine_line_points_sequence(performance: Array):
	var line_points = []
	for length in range(performance.size()):
		var x = origin.x + ((length + 1) * tick_interval_x)
		var y = origin.y - (tick_interval_y * performance[length])
		line_points.append(Vector2(x,y))
	return line_points
