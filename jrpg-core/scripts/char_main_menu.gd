extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screen_width = ProjectSettings.get_setting("display/window/size/width");
var screen_height = ProjectSettings.get_setting("display/window/size/height");
onready var reference_box = $HBoxContainer/left_panel;
onready var reference_height = reference_box.get_line_height();
onready var reference_width = reference_box.margin_right;
var aspect_ratio;

# menu options
onready var selector_image : Sprite = $selector; # a reference to the selector sprite
onready var selector_anim : AnimationPlayer = $selector/selector_animator;
var menu_index : int; # the index reference to the title menu items
var menu_options = ["new_game", "load_game", "options_menu", "exit_game"];
var selector_offset : int; # the offset in pixels from the menu items. this should be about 5-10% of the width of the viewport
var offset_factor : int = 10;

# Called when the node enters the scene tree for the first time.
func _ready():
	add_item("Items",null,true);
	add_item("Abilities",null,true);
	add_item("Equipment",null,true);
	add_item("Status",null,true);
	add_item("Data",null,true);
	select(0,true);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
