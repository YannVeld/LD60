class_name PostProcessingManager extends ColorRect

@export var gameProperties: GameProperties

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameProperties.property_changed.connect(_on_property_changed)
	_set_raw_shader_colors(gameProperties.raw_color_palette)
	_set_shader_colors(gameProperties.color_palette)

func _on_property_changed(property: String, new_value):
	if property != "color_palette": return
	_set_shader_colors(gameProperties.color_palette)

func _set_shader_colors(palette: ColorPalette):
	var _mat: ShaderMaterial = material
	var _colors := palette.get_colors()
	_mat.set_shader_parameter("new_color1", _colors[0])
	_mat.set_shader_parameter("new_color2", _colors[1])
	_mat.set_shader_parameter("new_color3", _colors[2])

func _set_raw_shader_colors(palette: ColorPalette):
	var _mat: ShaderMaterial = material
	var _colors := palette.get_colors()
	_mat.set_shader_parameter("placeholder_color1", _colors[0])
	_mat.set_shader_parameter("placeholder_color2", _colors[1])
	_mat.set_shader_parameter("placeholder_color3", _colors[2])
