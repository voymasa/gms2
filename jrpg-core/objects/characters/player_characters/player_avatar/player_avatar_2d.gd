extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const MOVE_SPEED = 128;
var velocity = Vector2();
var speed_modifier = 1.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_4dir_movement();
	get_action_inputs();
	velocity = move_and_slide(velocity * speed_modifier);
	#var collision_info = move_and_collide(velocity);
	#if collision_info:
	#	velocity = velocity.slide(collision_info.normal);

func get_action_inputs():
	if Input.is_action_pressed("ui_cancel"):
		speed_modifier = 2.0;
	else:
		speed_modifier = 1.0;

func get_4dir_movement():
	velocity.x = 0;
	velocity.y = 0;
	var left = Input.is_action_pressed("ui_left");
	var right = Input.is_action_pressed("ui_right");
	var up = Input.is_action_pressed("ui_up");
	var down = Input.is_action_pressed("ui_down");
	
	if up:
		velocity.y = -MOVE_SPEED;
		$spr_player_avatar.flip_h = false;
		$anim_player_avatar.play("move_up");
	elif down:
		velocity.y = MOVE_SPEED;
		$spr_player_avatar.flip_h = false;
		$anim_player_avatar.play("move_down");
	elif left:
		velocity.x = -MOVE_SPEED;
		$spr_player_avatar.flip_h = true;
		$anim_player_avatar.play("move_right");
	elif right:
		velocity.x = MOVE_SPEED;
		$spr_player_avatar.flip_h = false;
		$anim_player_avatar.play("move_right");
	else:
		var current_anim = $anim_player_avatar.get_current_animation();
		if current_anim == "move_up":
			$anim_player_avatar.queue("idle_up");
		if current_anim == "move_down":
			$anim_player_avatar.queue("idle_down");
		if current_anim == "move_right" or current_anim == "move_left":
			$anim_player_avatar.queue("idle_right");