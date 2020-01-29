extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screen_width = ProjectSettings.get_setting("display/window/size/width");
var screen_height = ProjectSettings.get_setting("display/window/size/height");
onready var reference_box = $char_dev_hbox/skill_tree_vbox/character_name_box;
onready var reference_height = reference_box.rect_size.y;
onready var reference_width = reference_box.margin_right;
var aspect_ratio;

onready var selector_image : Sprite = $selector; # a reference to the selector sprite
onready var selector_anim : AnimationPlayer = $selector/selector_animator;

onready var list = $char_dev_hbox/skill_tree_vbox/skill_scroll_container/skill_list;
var list_index : int; # the index reference to the title menu items
var skill_list = {"MERCY STRIKE I":"Gain a subdual strike", "SHIELD PROF+":"Increase Shield Proficiency by 1", "SWORD PROF+":"Increase Sword Proficiency by 1", "HP+":"Gain 25 HP", "Prayers+":"Gain another Prayer slot", "HP++":"Gain 50 HP"}; # these are placeholders for later
var skills = skill_list.keys();
var selector_offset : int; # the offset in pixels from the menu items. this should be about 5-10% of the width of the viewport
var offset_factor : int = 10;


# Called when the node enters the scene tree for the first time.
func _ready():
	aspect_ratio = screen_width / screen_height;
	# todo -- clear the skill_list and then read in the values available for the current character
	if skill_list.size() < 1:
		skill_list.append("none");
	list_index = 0;
	create_list_of_skills();
	# set the location and sizes of the boxes and windows
	set_size_and_location_of_panels();
	# calculate the offset position for the selector_images
	selector_offset = calculate_offset();
	selector_anim.play("loop_spin");
	# place the selector image to the left and right of the index
	move_selector();


func set_size_and_location_of_panels():
	# place visual_accessibility bar
	var vab_info = $visual_accessibility_info;
	vab_info.rect_global_position.y = screen_height - vab_info.rect_size.y;
	
	# place skill container
	var skill_container = $char_dev_hbox/skill_tree_vbox/skill_scroll_container;
	skill_container.rect_global_position.y = reference_box.rect_global_position.y + reference_height;
	skill_container.rect_min_size.y = screen_height - reference_height - vab_info.rect_size.y;
	list.rect_min_size.y = skill_container.rect_min_size.y;
	
	# place stat container
	var stat_container = $char_dev_hbox/stat_vbox;
	var character_stats_panel = $char_dev_hbox/stat_vbox/character_stats_panel;
	stat_container.rect_global_position.x = reference_box.margin_right;
	stat_container.rect_min_size.x = screen_width - reference_box.margin_right;
	character_stats_panel.rect_min_size.y = (screen_height - vab_info.rect_size.y) * 0.75;
	var skill_desc_panel = $char_dev_hbox/stat_vbox/skill_description_panel;
	skill_desc_panel.rect_min_size.y = (screen_height - vab_info.rect_size.y) * 0.25;


func calculate_offset():
	return list.margin_right / offset_factor;
	
	
func move_selector():
	var new_position: Vector2;
	# update skill_info
	var skill_name : Label = $char_dev_hbox/stat_vbox/skill_description_panel/skill_info_vbox/skill_name_label;
	var skill_info : Label = $char_dev_hbox/stat_vbox/skill_description_panel/skill_info_vbox/skill_description_label;
	
	for item in list.get_children():
		if item.get_child(0).has_color_override("font_color"):
			item.get_child(0).add_color_override("font_color", Color.gray);
	
	var chosen_skill = list.get_child(list_index);
	new_position = chosen_skill.rect_global_position;
	chosen_skill.get_child(0).add_color_override("font_color", Color.linen);
	
	skill_name.text = skills[list_index];
	skill_info.text = skill_list.get(skills[list_index]);
	
	new_position.x = list.margin_right;
	new_position.y = new_position.y + (reference_height / 2);
	
	# move the select to the new position
	selector_image.flip_h = true;
	selector_image.position = new_position;
	
	# fill accessibility info
	var vab_info = $visual_accessibility_info;
	var vab_selection_info_label : Label = vab_info.get_node("visual_accessibility_info/selected_description");
	vab_selection_info_label.text = "Learn " + skills[list_index];


func create_list_of_skills():
	var skill_item = load("res://objects/menus/menu_option.tscn");
	for skill in skills:
		#instance a menu_option and set the label text
		var skill_instance = skill_item.instance();
		skill_instance.set_name(skill);
		var label_ref : Label = skill_instance.get_node("menu_option_label");
		label_ref.text = skill;
		label_ref.add_color_override("font_color", Color.gray);
		list.add_child(skill_instance, true);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_player_inputs();


func get_player_inputs():
	# selector movement
	var up = Input.is_action_just_pressed("ui_up");
	var down = Input.is_action_just_pressed("ui_down");
	
	if down:
		list_index = list_index + 1;
		if list_index >= skills.size():
			list_index = skills.size() - 1;
	elif up:
		list_index = list_index - 1;
		if list_index < 0:
			list_index = 0;
	
	move_selector();
	
	# selection and cancelling
	var accept = Input.is_action_just_pressed("ui_accept");
	
	if accept:
		print("Selected: " + skills[list_index]);