extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const MOVE_SPEED = 128;
var velocity = Vector2();
var speed_modifier = 1.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#get_action_inputs();
	velocity = move_and_slide(velocity * speed_modifier);
#	pass

func get_action_inputs():
	if Input.is_action_pressed("ui_cancel"):
		speed_modifier = 2.0;
	else:
		speed_modifier = 1.0;
		
func get_4dir_follower_move(follow_velocity):
	velocity = follow_velocity;
	velocity = move_and_slide(velocity * speed_modifier);
	
	var left = false;
	var right = false;
	var up = false;
	var down = false;
	
	if velocity.x > 0:
		right = true;
	elif velocity.x < 0:
		left = true;
	elif velocity.y > 0:
		down = true;
	elif velocity.y < 0:
		up = true;
	
	if up:
		$spr_player_avatar.flip_h = false;
		$spr_player_avatar/anim_player_avatar.play("move_up");
	elif down:
		$spr_player_avatar.flip_h = false;
		$spr_player_avatar/anim_player_avatar.play("move_down");
	elif left:
		$spr_player_avatar.flip_h = true;
		$spr_player_avatar/anim_player_avatar.play("move_right");
	elif right:
		$spr_player_avatar.flip_h = false;
		$spr_player_avatar/anim_player_avatar.play("move_right");
	else:
		var current_anim = $spr_player_avatar/anim_player_avatar.get_current_animation();
		if current_anim == "move_up":
			$spr_player_avatar/anim_player_avatar.queue("idle_up");
		if current_anim == "move_down":
			$spr_player_avatar/anim_player_avatar.queue("idle_down");
		if current_anim == "move_right":
			$spr_player_avatar/anim_player_avatar.queue("idle_right");
	pass