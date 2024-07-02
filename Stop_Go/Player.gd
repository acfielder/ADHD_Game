extends CharacterBody3D


var SPEED = 4.5
const JUMP_VELOCITY = 4.25
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

enum State {MOVE, TRIAL}
var stop_go_player_state = State.TRIAL

#this will 10000% need to go away
func _ready():
	set_process_input(false)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if stop_go_player_state == State.MOVE:
		velocity.z = -SPEED #maybe change back, maybe not
		var input_dir = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),Input.get_action_strength("ui_up"))
		if input_dir.y < 0:
			input_dir.y = 0
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			#velocity.z = -(direction.z * SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			#velocity.z = move_toward(velocity.z, 0, SPEED)
		move_and_slide()

func change_player_state(state: int):
	if state == 0:
		stop_go_player_state = State.TRIAL
		SPEED = 0
	else:
		stop_go_player_state = State.MOVE
		SPEED = 5.0
