extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var static_text_font : DynamicFont = load("res://fonts/ModernSans-light28px.tres");
onready var short_lived_text_font : DynamicFont = load("res://fonts/ModernSans-Light46px.tres");
var default_static_size : float;
var default_short_lived_size : float;

# Called when the node enters the scene tree for the first time.
func _ready():
	default_static_size = static_text_font.get_size();
	default_short_lived_size = short_lived_text_font.get_size();
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_font_slider_value_changed(value):
	# multiply the value the default sizes and assign it to the font sizes
	static_text_font.size = (default_static_size * value);
	short_lived_text_font.size = (default_short_lived_size * value);
	static_text_font.update_changes();
	short_lived_text_font.update_changes();
