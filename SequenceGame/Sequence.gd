class_name Sequence
extends Node2D

var image_containers : Array

var pins : Array = [] #pointers to pins in scene
enum state {HIGHLIGHT, RESPONSE}
var pins_dict : Dictionary #pins with associated number to recognize correct pin
var pin_coords : Dictionary

var sequence_controller : Sequence_Controller
var user : UserModel

var images_folder_path : String = "res://Art/filler_images/"
var image_files : Array

var current_string : Path2D = null
var string_line : Line2D
var in_str : bool = false
var initial_point : Vector2
var final_point : Vector2
var mousePos : Vector2

func _ready():
	pins = [$PushPin1, $PushPin2, $PushPin3, $PushPin4, $PushPin5, $PushPin6, $PushPin7, $PushPin8]
	for i in range(pins.size()):
		pins[i].pin_pressed.connect(_on_pin_pressed_test)
	pins_dict = {1:$PushPin1, 2:$PushPin2, 3:$PushPin3, 4:$PushPin4, 5:$PushPin5, 6:$PushPin6, 7:$PushPin7, 8:$PushPin8}
	pin_coords = {1:Vector2(353,173), 2:Vector2(294,444), 3:Vector2(463,328), 4:Vector2(555,167), 5:Vector2(597,423), 6:Vector2(720,273), 7:Vector2(843,463), 8:Vector2(878,242)}
	
	sequence_controller = Sequence_Controller.new(self,user)
	
	image_files = get_pin_images()
	#for path in image_files:
	#	print(path)
	
	image_containers = [$PinImage1, $PinImage2, $PinImage3, $PinImage4, $PinImage5, $PinImage6, $PinImage7, $PinImage8]
	
	set_pin_images()
	
	#randomly select from images in a particular location to assign as images - images may become sprites or texture or something idk yet

func _process(delta):
	if in_str: #&& current_string.curve.get_point_count() == 1:
		mousePos = get_global_mouse_position()
		if current_string.curve.get_point_count() == 1:
			# Add a temporary second point that follows the mouse
			current_string.curve.add_point(mousePos)
			# Initialize control points for a smoother curve
			current_string.curve.set_point_in(0, initial_point)
			current_string.curve.set_point_out(0, mousePos)
		else:
			# Update the position of the second point to follow the mouse
			#current_string.curve.set_point_position(1, mousePos)
			# Adjust control points for curvature
			#var control_offset = (mousePos - initial_point) / 3
			#current_string.curve.set_point_in(1, mousePos - control_offset) 
			#current_string.curve.set_point_out(0, initial_point + control_offset) 
			
			
			var outX = mousePos.x/3 
			current_string.curve.set_point_out(0, Vector2(outX,-outX))
			current_string.curve.set_point_position(1, mousePos)
			current_string.curve.set_point_in(1, Vector2(-outX,-outX))
			final_point = mousePos

		# Update the Line2D points to match the Curve2D points
		update_string_line_points()

	
	#if in_str:
		#var mousePos = get_global_mouse_position() - current_string.position
		#var outX = mousePos. x/3
		#current_string.curve.set_point_out(0, Vector2(outX,-outX))
		#current_string.curve.set_point_position(1, mousePos)
		#current_string.curve.set_point_in(1, Vector2(-outX,-outX))


#begins trials
func _on_start_button_pressed():
	$ColorRect.hide()
	show_instructions()
	#would probably lead to an instruction section rather than already the starting trial
	#sequence_controller.run_trial()
	
func show_instructions():
	$game_instructions.show()	
	
#just creates a small timer to create a delay
func create_short_timer(time: float):
	await get_tree().create_timer(time).timeout
	
func prompt_next_trial():
	await get_tree().create_timer(1).timeout
	$ColorRect.show()
	
func update_display(level: int, trial: int, score: int, session_length: int):
	$SessionStats/ColorRect/current_level.text = "Level: " + str(level)
	$SessionStats/ColorRect/current_trial.text = "Trial: " + str(trial)
	$SessionStats/ColorRect/session_score.text = "Score: " + str(score)
	$SessionStats/ColorRect/session_length.text = "Session\nLength: " + str(session_length)
	#$SessionStats/ColorRect/trial_type.text = "Trial Type: " + str(type)

#highlights individual pin based on highlight reason
func highlight_pin(pin_key: int, highlight_type: int, highlight_length: float): #deals with pins
	var pin = pins_dict.get(pin_key)
	match highlight_type:
		0: pin.change_icon(0)
		1: pin.change_icon(1)
		2: pin.change_icon(2)
		3: pin.change_icon(3)
		_: pin.change_icon(0)
	await get_tree().create_timer(highlight_length).timeout
	pin.change_icon(0)
	await get_tree().create_timer(0.30).timeout
	
func _on_pin_pressed_test(pin):
	var pin_key = pins_dict.find_key(pin)
	sequence_controller.pin_press_detected(pin_key)

#tell player there response is now being collected
func prompt(hide: int, prompt: String = ""):
	if hide == 1:
		$trial_prompt.text = prompt
		$trial_prompt.visible = true
	else:
		$trial_prompt.visible = false

func get_pin_images():
	var image_files = []
	var dir = DirAccess.open(images_folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name:
			if file_name.ends_with(".png"):
				image_files.append(images_folder_path + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	return image_files
	
func set_pin_images():
	var texture
	var rand_image_path
	for cont in image_containers:
		rand_image_path = image_files.pick_random()
		texture = ResourceLoader.load(rand_image_path)
		if texture:
			cont.texture = texture
		else:
			print("failed to add texture: ", rand_image_path)
		

#hides the pins for the duration of the delay period - delay time may eventually become a parameter
func display_delay_distraction():
	$delay_distraction.visible = true
	await get_tree().create_timer(3).timeout 
	$delay_distraction.visible = false
	
func display_session_over():
	$session_over_display.visible = true
	var report_load = load("res://Report/Report.tscn")
	#breakpoint below
	var report = report_load.instantiate()
	#report.set_game_type(0)
	report.position = Vector2(-250,0)
	report.setup_report(0,sequence_controller.get_performances(),sequence_controller.get_scores(),sequence_controller)
	#report.setup_graph(sequence_controller.get_performances())
	#report.setup_report()
	#report.setup_graph(sequence_controller.get_performances())
	#get_performances should return an array of the performance arrays
	#performance arrays are the stm, then updating/manipulating
	add_child(report)
	



func _on_button_pressed():
	#when done with instructions
	$game_instructions.hide()
	sequence_controller.run_trial()
	
func begin_string(pin_key):
	var string = Path2D.new()
	string.curve = Curve2D.new()
	string.curve.clear_points()
	initial_point = pin_coords.get(pin_key)
	final_point = initial_point
	string.curve.add_point(initial_point)
	current_string = string
	in_str = true
	$String.add_child(string)
	
	string_line = Line2D.new()
	string_line.width = 5
	string_line.default_color = Color(1,0,0)
	$String.add_child(string_line)

	#string.curve.add_point(Vector2(0,0)) 
	#string.curve.add_point(pin_coords.get(pin_key))
	#string.curve.set_point_position(1,pin_coords.get(pin_key))
	#string.curve.set_point_in(1,Vector2(50, 50)) # Set the in control point for the first point
	#string.curve.set_point_out(0,Vector2(50, 50))
	#current_string = string
	#in_str = false
	#add_child(string)
	
	
	#path = Path2D.new()
	#curve = Curve2D.new()
	#path.curve = curve
	#add_child(path)

	
	#initial_point = get_global_mouse_position()
	#curve.clear_points()
	#curve.add_point(initial_point)
	#is_path_started = true

	
func update_string_line_points():
	#working for straight
	#string_line.clear_points()
	#for i in range(current_string.curve.get_point_count()):
	#	string_line.add_point(current_string.curve.get_point_position(i))
		
	#working to curve
	#string_line.clear_points()
	#var points = current_string.curve.get_baked_points()
	#for point in points:
		#string_line.add_point(point)
		
		
	#testing for gentle string curve	
	string_line.clear_points()
	string_line.add_point(initial_point)
	
	# Calculate a control point for a gentle curve
	var control_point = (initial_point + final_point) / 2 + Vector2(0, 50)
	
	var num_segments = 20  # Number of segments to approximate the curve
	for i in range(num_segments + 1):
		var t = float(i) / num_segments
		var point = get_quadratic_bezier_point(t, initial_point, control_point, final_point)
		string_line.add_point(point)

func get_quadratic_bezier_point(t: float, p0: Vector2, p1: Vector2, p2: Vector2) -> Vector2:
	var u = 1 - t
	var tt = t * t
	var uu = u * u
	var p = uu * p0  # (1 - t)^2 * p0
	p += 2 * u * t * p1  # 2 * (1 - t) * t * p1
	p += tt * p2  # t^2 * p2
	return p

	
	
	
func end_string(pin_key):
	#var mousePos = get_global_mouse_position() - current_string.position #process
	#var outX = mousePos.x/3
	#current_string.curve.add_point(pin_coords.get(pin_key))
	#current_string.curve.set_point_out(0, Vector2(outX,-outX))
	#current_string.curve.set_point_position(0, pin_coords.get(pin_key))
	#current_string.curve.set_point_in(1, Vector2(-outX,-outX))
	
	
	if in_str:
		final_point = pin_coords.get(pin_key)
		current_string.curve.set_point_position(1, final_point)
		# Finalize the control points for the curve
		var control_offset = (final_point - initial_point) / 3
		current_string.curve.set_point_in(1, final_point - control_offset)
		current_string.curve.set_point_out(0, initial_point + control_offset)
		
		# Update the Line2D points to match the Curve2D points
		update_string_line_points()
		in_str = false
		current_string = null
		
		
func clear_string():
	# Remove all children from the parent node
	await get_tree().create_timer(1).timeout
	for child in $String.get_children():
		child.queue_free()

	

