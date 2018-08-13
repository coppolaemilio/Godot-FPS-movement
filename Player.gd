extends KinematicBody

var mouse_sensitivity = 0.05
var camera_angle = 0
var camera_change = Vector2()

# Movement
var velocity = Vector3()
var direction = Vector3()

# Fly variables
const FLY_SPEED = 40
const FLY_ACCEL = 4

# Walk variables
var gravity = -9.3 * 3
const MAX_SPEED = 20
const MAX_RUNNING_SPEED = 30
const ACCEL = 2
const DEACCEL = 6

# Jumping
var jump_height = 15


func _ready():
	pass

func _physics_process(delta):
	aim()
	walk(delta)
	

func _input(event):
	if event is InputEventMouseMotion: #Checking mouse movement
		camera_change = event.relative
		

func walk(delta):
	# Reset the direction of the player
	direction = Vector3()
	
	# Get the rotation of the camera
	var aim = $Head/Camera.get_global_transform().basis
	
	# Handling user input and changing direction
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backwards"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
	
	# Normalize speed 
	direction = direction.normalized()
	
	velocity.y += gravity * delta
	
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	var speed 
	if Input.is_action_pressed("move_sprint"):
		speed = MAX_RUNNING_SPEED
	else:
		speed = MAX_SPEED
	
	# Where would the player go at max speed
	var target = direction * speed
	
	var acceleration
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCEL
	else:
		acceleration = DEACCEL
	
	# Calculate a portion of the distance to go
	temp_velocity = temp_velocity.linear_interpolate(target, acceleration * delta)
	
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	
	# Move
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = jump_height

func fly(delta):
	# Reset the direction of the player
	direction = Vector3()
	
	# Get the rotation of the camera
	var aim = $Head/Camera.get_global_transform().basis
	
	# Handling user input and changing direction
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backwards"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
	
	# Normalize speed 
	direction = direction.normalized()
	
	# Where would the player go at max speed
	var target = direction * FLY_SPEED
	
	# Calculate a portion of the distance to go
	velocity = velocity.linear_interpolate(target, FLY_ACCEL * delta)
	
	# Move
	move_and_slide(velocity)

func aim():
	if camera_change.length() > 0:
		# Moving left and right
		$Head.rotate_y(deg2rad(-camera_change.x * mouse_sensitivity))
		# Moving up and down
		var change = -camera_change.y * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle > -90:
			$Head/Camera.rotate_x(deg2rad(change))
			camera_angle += change
		camera_change = Vector2()