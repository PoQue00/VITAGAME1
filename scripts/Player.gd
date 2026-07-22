extends KinematicBody2D

onready var hud = get_parent().get_node("HUD")

#==================================================
# Movement
#==================================================

export var walk_speed = 100
export var sprint_speed = 280
export var acceleration = 900
export var friction = 1200

onready var sprite = $AnimatedSprite


#==================================================
# Jump
#==================================================

export var jump_force = -320
export var gravity = 900
export var max_fall_speed = 500


# Ground memory
var grounded_timer = 0.0
export var grounded_memory = 0.08

export var floor_memory = 0.08
var was_grounded_timer = 0.0



#==================================================
# Jump Assist
#==================================================

export var coyote_time = 0.12
export var jump_buffer = 0.20

var coyote_timer = 0.0
var jump_buffer_timer = 0.0



#==================================================
# Wall Mechanics
#==================================================

export var wall_slide_speed = 60
export var wall_jump_force = 260
export var wall_jump_height = -380

export var no_wallgrab_mask = 8

var can_grab_wall = true
var no_wall_grab_count = 0


# Wall climb

export var wall_climb_speed = 120
export var wall_climb_time = 2.0

var wall_climb_timer = 0.0
var is_wall_climbing = false



#==================================================
# Dash
#==================================================

export var dash_speed = 420
export var dash_time = 0.11
export var dash_cooldown = 1.0


var is_dashing = false
var dash_timer = 0.0

var can_air_dash = true
var dash_cooldown_timer = 0.0



#==================================================
# Movement Variables
#==================================================

var velocity = Vector2.ZERO

# 1 = right
# -1 = left
var facing = 1


var input_direction = 0.0
var current_speed = walk_speed



#==================================================
# States
#==================================================

enum State {

	IDLE,
	RUN,
	SPRINT,

	JUMP,
	FALL,

	WALL_SLIDE,
	WALL_CLIMB,

	DASH
}


var state = State.IDLE



#==================================================
# Input
#==================================================

func _get_input():


	input_direction = (
		Input.get_action_strength("right")
		-
		Input.get_action_strength("left")
	)


	if input_direction != 0:

		facing = sign(input_direction)



	if Input.is_action_just_pressed("jump"):

		jump_buffer_timer = jump_buffer



	current_speed = walk_speed


	if input_direction != 0 and Input.is_action_pressed("sprint"):

		current_speed = sprint_speed





#==================================================
# Timers
#==================================================

func _update_timers(delta):


	if dash_cooldown_timer > 0:

		dash_cooldown_timer -= delta



	if coyote_timer > 0:

		coyote_timer -= delta



	if jump_buffer_timer > 0:

		jump_buffer_timer -= delta





#==================================================
# Ground Check
#==================================================

func _floor_logic(delta):


	if is_on_floor():


		was_grounded_timer = floor_memory


		coyote_timer = coyote_time


		can_air_dash = true


		# Refill wall climb only on ground

		wall_climb_timer = wall_climb_time



	else:


		was_grounded_timer -= delta





#==================================================
# Horizontal Movement
#==================================================

func _horizontal_movement(delta):


	if input_direction != 0:


		velocity.x = move_toward(

			velocity.x,

			input_direction * current_speed,

			acceleration * delta
		)


	else:


		velocity.x = move_toward(

			velocity.x,

			0,

			friction * delta
		)





#==================================================
# Gravity
#==================================================

func _apply_gravity(delta):


	if !is_on_floor():


		velocity.y += gravity * delta



	if velocity.y > max_fall_speed:


		velocity.y = max_fall_speed





#==================================================
# Variable Jump
#==================================================

func _variable_jump():


	if Input.is_action_just_released("jump"):


		if velocity.y < 0:


			velocity.y *= 0.5





#==================================================
# Normal Jump
#==================================================

func _jump():


	if jump_buffer_timer > 0 and coyote_timer > 0:


		velocity.y = jump_force


		jump_buffer_timer = 0

		coyote_timer = 0
		
#
#
#
#
#
#
#
#
#
#
#
#
#part 2
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#


#==================================================
# Dash
#==================================================

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





#==================================================
# Wall Direction
#==================================================

func _get_wall_direction():


	var direction = Vector2.ZERO



	if get_slide_count() > 0:


		var collision = get_slide_collision(0)


		direction = collision.normal



	return direction





#==================================================
# NoWallGrab System
#==================================================

func can_wall_grab():

	return no_wall_grab_count == 0





func _on_WallGrabDetector_area_entered(area):


	if area.is_in_group("NoWallGrab"):


		no_wall_grab_count += 1





func _on_WallGrabDetector_area_exited(area):


	if area.is_in_group("NoWallGrab"):


		no_wall_grab_count = max(
			0,
			no_wall_grab_count - 1
		)





#==================================================
# Wall Climb
#==================================================

func _wall_climb(delta):


	is_wall_climbing = false



	if !can_wall_grab():

		return



	if !is_on_wall():

		return



	if is_on_floor():

		return





	if Input.is_action_pressed("sprint") and Input.is_action_pressed("up"):


		if wall_climb_timer > 0:


			is_wall_climbing = true


			state = State.WALL_CLIMB


			velocity.y = -wall_climb_speed


			wall_climb_timer -= delta





#==================================================
# Wall Slide / Wall Jump
#==================================================

func _wall_slide():


	if !can_wall_grab():

		return false



	if !is_on_wall():

		return false



	if is_on_floor():

		return false



	# Wall climb takes priority

	if is_wall_climbing:


		return true





	state = State.WALL_SLIDE



	# Wall contact restores air dash

	can_air_dash = true





	if velocity.y > wall_slide_speed:


		velocity.y = wall_slide_speed





	# Wall jump


	if Input.is_action_just_pressed("jump"):


		var wall_direction = _get_wall_direction()



		velocity.x = (
			wall_direction.x
			*
			wall_jump_force
		)



		velocity.y = wall_jump_height



		can_air_dash = true


		state = State.JUMP


		return true





	return true





#==================================================
# Movement
#==================================================

func _move_player():


	velocity = move_and_slide(

		velocity,

		Vector2.UP

	)
	
	#
	#
	#
	#
	#
	#
	#
	#
	#
	#
	#
	#
	#
	#
	#
	#part 3
	#
	#
	#
	#
	#
	#
	#
	#
	#
	#
	#
	#
	#
	#
	#
	#
	#
	#
	#
	
	#==================================================
# Physics Process
#==================================================

func _physics_process(delta):


	_get_input()


	_update_timers(delta)


	_floor_logic(delta)


	_horizontal_movement(delta)


	_apply_gravity(delta)


	_variable_jump()


	_jump()



	# Dash input

	_dash()



	# Dash movement

	if _handle_dash(delta):


		_update_animation()

		return





	# Wall climb check

	_wall_climb(delta)



	# Wall climb movement

	if is_wall_climbing:


		_move_player()


		_update_animation()


		return





	# Wall slide / jump

	if _wall_slide():


		_move_player()


		_update_animation()

		_update_hud()

		return





	_move_player()



	_update_state()



	_update_animation()

	_update_hud()



#==================================================
# State Machine
#==================================================

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


		if state != State.WALL_SLIDE \
		and state != State.WALL_CLIMB \
		and state != State.DASH:



			if velocity.y < 0:


				state = State.JUMP



			else:


				state = State.FALL





#==================================================
# Animation
#==================================================

func _update_animation():


	sprite.flip_h = facing < 0





	# Wall climb

	if state == State.WALL_CLIMB:


		if sprite.animation != "wall grab":


			sprite.play("wall grab")


		return





	# Wall slide

	if state == State.WALL_SLIDE:


		if sprite.animation != "wall grab":


			sprite.play("wall grab")


		return





	# Dash

	if state == State.DASH:


		if sprite.animation != "dash":


			sprite.play("dash")


		return





	# Air

	if was_grounded_timer <= 0:


		if sprite.animation != "jump":


			sprite.play("jump")


		return





	# Sprint

	if state == State.SPRINT:


		if sprite.animation != "sprint":


			sprite.play("sprint")


		return





	# Walk

	if state == State.RUN:


		if sprite.animation != "walk":


			sprite.play("walk")


		return





	# Idle

	if sprite.animation != "idle":


		sprite.play("idle")
		
#
#
#
#
#
##

#
#
#
#

#
#
#Part4 
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#


#==================================================
# HUD References
#==================================================

onready var wall_climb_label = get_node("../HUD/WallClimbLabel")
onready var dash_label = get_node("../HUD/DashLabel")





#==================================================
# HUD Update
#==================================================

func _update_hud():

	print("HUD update:", GameSettings.dev_stats_enabled)
	hud.visible = GameSettings.dev_stats_enabled


	if !GameSettings.dev_stats_enabled:
		return

	if wall_climb_label:
		wall_climb_label.text = "Climb: " + str(round(wall_climb_time))

	if dash_label:
		dash_label.text = "Dash: " + str(round(dash_cooldown))
