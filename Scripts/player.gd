extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
const face_left = preload("uid://70k0eloqvjom")
const face_right = preload("uid://dcisogdnwtuwp")
const jump_left = preload("uid://b258hfhbywtvb")
const jump_right = preload("uid://dks4uuvp7wy58")
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var can_dash = true
var can_move = true
func get_position_()-> Vector2:
	return position;

func _physics_process(delta: float) -> void:
		# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("Left", "Right")
	if direction > 0 and is_on_floor() == false:
		sprite_2d.texture = jump_right
	elif direction > 0:
		sprite_2d.texture = face_right
	if direction < 0 and is_on_floor() == false:
		sprite_2d.texture = jump_left
	elif direction < 0:
		sprite_2d.texture = face_left
	# The Dash itself 
	if Input.is_action_just_pressed("Dash") and can_dash:
		can_dash = false
		can_move = false
		$SmoothDashTimer.start()
		$DashCooldownTimer.start()
		velocity.x = direction*1000
	elif direction and can_move:
		velocity.x = direction * SPEED
	elif can_move:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func _on_dash_cooldown_timer_timeout() -> void:
	can_dash=true
	velocity.x =0


func _on_smooth_dash_timer_timeout() -> void:
	can_move = true
