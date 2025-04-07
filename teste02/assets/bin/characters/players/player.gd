extends CharacterBody3D
# Movement speed
@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var gravity: float = 9.8

# Called every frame
func _physics_process(delta):
	var direction = Vector3.ZERO

	# Get input directions (WASD / Arrow keys)
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var forward = -transform.basis.z
	var right = transform.basis.x

	# Combine directions
	direction += forward * input_dir.y
	direction += right * input_dir.x
	direction = direction.normalized()

	# Handle gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity

	# Apply horizontal movement
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Move the character
	move_and_slide()
