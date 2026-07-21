extends KinematicBody2D

#========================
# Movement
#========================
export var walk_speed = 100
export var sprint_speed = 280
export var acceleration = 900
export var friction = 1200

onready var sprite = $AnimatedSprite

#========================
# Jump
#========================
export var jump_force = -320

export var gravity = 900
export var max_fall_speed = 500
var grounded_timer = 0.0
export var grounded_memory = 0.08
export var floor_memory = 0.08
var was_grounded_timer = 0.0

#========================
# Jump Assist
#========================
export var coyote_time = 0.12
export var jump_buffer = 0.20

#========================
# Wall Mechanics
#========================
export var wall_slide_speed = 60
export var wall_jump_force = 260
export var wall_jump_height = -380

#========================
# Dash
#========================
export var dash_speed = 420
export var dash_time = 0.11
export var dash_cooldown = 1.0

#========================
# Variables
#========================
var velocity = Vector2.ZERO

var coyote_timer = 0.0
var jump_buffer_timer = 0.0

# Facing direction
# 1 = right
# -1 = left
var facing = 1

#========================
# Dash Variables
#========================
var is_dashing = false
var dash_timer = 0.0

var can_air_dash = true
var dash_cooldown_timer = 0.0

#========================
# States
#========================
enum State {
	IDLE,
	RUN,
	SPRINT,
	JUMP,
	FALL,
	WALL_SLIDE,
	DASH
}

var state = State.IDLE

#========================
# Cached Input
#========================
var input = 0.0
var current_speed = walk_speed



func _get_input():

	input = Input.get_action_strength("right") - Input.get_action_strength("left")

	if input != 0:
		facing = sign(input)

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer

	current_speed = walk_speed

	if input != 0 and Input.is_action_pressed("sprint"):
		current_speed = sprint_speed



func _update_timers(delta):

	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	coyote_timer -= delta
	jump_buffer_timer -= delta



func _floor_logic(delta):

	if is_on_floor():

		was_grounded_timer = floor_memory

		coyote_timer = coyote_time

		can_air_dash = true

	else:

		was_grounded_timer -= delta



func _horizontal_movement(delta):

	if input != 0:

		velocity.x = move_toward(
			velocity.x,
			input * current_speed,
			acceleration * delta
		)

	else:

		velocity.x = move_toward(
			velocity.x,
			0,
			friction * delta
		)



func _gravity(delta):

	if !is_on_floor():
		velocity.y += gravity * delta

	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed



func _variable_jump():

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5



func _jump():

	if jump_buffer_timer > 0 and coyote_timer > 0:

		velocity.y = jump_force

		jump_buffer_timer = 0
		coyote_timer = 0
		
func _dash():

	if Input.is_action_just_pressed("dash") and !is_dashing:

		# Ground dash
		if is_on_floor() and dash_cooldown_timer <= 0:

			is_dashing = true
			dash_timer = dash_time

			dash_cooldown_timer = dash_cooldown

			velocity.y = 0


		# Air dash
		elif !is_on_floor() and can_air_dash:

			is_dashing = true
			dash_timer = dash_time

			can_air_dash = false

			velocity.y = 0



func _handle_dash(delta):

	if !is_dashing:
		return false


	state = State.DASH

	dash_timer -= delta


	velocity.x = facing * dash_speed
	velocity.y = 0


	velocity = move_and_slide(
		velocity,
		Vector2.UP
	)


	if dash_timer <= 0:

		is_dashing = false


	return true



func _get_wall_direction():

	var wall_direction = Vector2.ZERO


	if get_slide_count() > 0:

		var collision = get_slide_collision(0)

		wall_direction = collision.normal


	return wall_direction



func _wall_slide():

	if is_on_wall() and !is_on_floor() and velocity.y > 0:


		state = State.WALL_SLIDE


		# Wall restores air dash

		can_air_dash = true


		if velocity.y > wall_slide_speed:

			velocity.y = wall_slide_speed



		# Wall jump

		if Input.is_action_just_pressed("jump"):


			var wall_direction = _get_wall_direction()


			velocity.x = wall_direction.x * wall_jump_force

			velocity.y = wall_jump_height


			# Wall jump refreshes dash

			can_air_dash = true


			return true


	return false



func _move_player():

	velocity = move_and_slide(
		velocity,
		Vector2.UP
	)



func _update_state():


	var grounded = was_grounded_timer > 0


	if grounded:


		if abs(velocity.x) < 5:

			state = State.IDLE


		elif Input.is_action_pressed("sprint"):

			state = State.SPRINT


		else:

			state = State.RUN



	else:


		if state != State.WALL_SLIDE and state != State.DASH:


			if velocity.y < 0:

				state = State.JUMP

			else:

				state = State.FALL
func _physics_process(delta):

	# Input
	_get_input()


	# Timers
	_update_timers(delta)


	# Floor checks
	_floor_logic(delta)


	# Movement
	_horizontal_movement(delta)


	# Gravity
	_gravity(delta)


	# Variable jump
	_variable_jump()


	# Jump
	_jump()


	# Dash start
	_dash()


	# Dash movement
	if _handle_dash(delta):

		_update_animation()
		return



	# Wall mechanics
	if _wall_slide():

		_move_player()
		_update_state()
		_update_animation()
		return



	# Normal movement
	_move_player()


	# Update state
	_update_state()


	# Update visuals
	_update_animation()



func _update_animation():

	# Sprite direction
	sprite.flip_h = facing < 0


	#========================
	# Wall Grab
	#========================
	# Only play wall grab if we are currently sliding
	# (prevents wall jump keeping the animation)

	if state == State.WALL_SLIDE and is_on_wall() and !is_on_floor():

		if sprite.animation != "wall grab":
			sprite.play("wall grab")

		return



	#========================
	# Dash
	#========================

	if state == State.DASH:

		if sprite.animation != "dash":
			sprite.play("dash")

		return



	#========================
	# Air
	#========================

	if was_grounded_timer <= 0:

		if sprite.animation != "jump":
			sprite.play("jump")

		return



	#========================
	# Sprint
	#========================

	if state == State.SPRINT:

		if sprite.animation != "sprint":
			sprite.play("sprint")

		return



	#========================
	# Walk
	#========================

	if state == State.RUN:

		if sprite.animation != "walk":
			sprite.play("walk")

		return



	#========================
	# Idle
	#========================

	if sprite.animation != "idle":
		sprite.play("idle")
