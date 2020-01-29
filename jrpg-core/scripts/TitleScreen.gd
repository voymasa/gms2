extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# screen info
var screen_width = ProjectSettings.get_setting("display/window/size/width");
var screen_height = ProjectSettings.get_setting("display/window/size/height");
onready var vab_bar = $visual_accessibility_info;
#onready var options_container = $title_label/menu_container;

onready var selector_image : Sprite = $selector; # a reference to the selector sprite
onready var selector_anim : AnimationPlayer = $selector/selector_animator;
var menu_index : int; # the index reference to the title menu items
var menu_options = ["new_game", "load_game", "options_menu", "exit_game"];
var selector_offset : int; # the offset in pixels from the menu items. this should be about 5-10% of the width of the viewport
var offset_factor : int = 20;

# Called when the node enters the scene tree for the first time.
func _ready():
	#options_container.position = $title_label/title_options.rect_global_position;
	#options_container.rect_size = $title_label/title_options.rect_size;
	# set the initial index to 0
	menu_index = 0;
	# calculate the offset position for the selector_images
	selector_offset = calculate_offset();
	selector_anim.play("loop_spin");
	# place the selector image to the left and right of the index
	move_selector();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_player_inputs();

func calculate_offset():
	return screen_width / offset_factor;
	
func move_selector():
	var highlight_color = Color.linen;
	
	var new_position: Vector2;
	# update vab_info
	var vab_info : Label = $visual_accessibility_info/visual_accessibility_info/selected_description;
	var title_options = $title_rect/title_label/menu_container/title_options;
	
	for label in title_options.get_children():
		if label.has_color_override("font_color"):
			label.add_color_override("font_color", Color.gray);
			
	match menu_index:
		0: 
			new_position = title_options.get_node("new_game_label").rect_global_position;
			title_options.get_node("new_game_label").add_color_override("font_color", highlight_color);
			vab_info.text = "Start a New Game.";
		1: 
			new_position = title_options.get_node("load_game_label").rect_global_position;
			title_options.get_node("load_game_label").add_color_override("font_color", highlight_color);
			vab_info.text = "Load a saved game.";
		2: 
			new_position = title_options.get_node("options_label").rect_global_position;
			title_options.get_node("options_label").add_color_override("font_color", highlight_color);
			vab_info.text = "Go to the game options menu.";
		3: 
			new_position = title_options.get_node("exit_game_label").rect_global_position;
			title_options.get_node("exit_game_label").add_color_override("font_color", highlight_color);
			vab_info.text = "Quit the game.";
	new_position.x = new_position.x - selector_offset;
	new_position.y = new_position.y + vab_info.get_line_height() / 2;
	# move the select to the new position
	selector_image.position = new_position;

func get_player_inputs():
	# selector movement
	var up = Input.is_action_just_pressed("ui_up");
	var down = Input.is_action_just_pressed("ui_down");
	
	if down:
		menu_index = menu_index + 1;
		if menu_index >= menu_options.size():
			menu_index = 0;
	elif up:
		menu_index = menu_index - 1;
		if menu_index < 0:
			menu_index = menu_options.size() - 1;
	
	move_selector();
	
	# selection and cancelling
	var accept = Input.is_action_just_pressed("ui_accept");
	
	if accept:
		print("Selected: " + menu_options[menu_index]);
		match menu_index:
			0:
				#get_tree().change_scene("res://objects/levels/intro_scene.tscn");
				pass;
			1:
				#get_tree().change_scene("res://objects/levels/save_load_scene.tscn"); 
				pass;
			2:
				get_tree().change_scene("res://objects/menus/options.tscn"); 
			3: 
				get_tree().quit();