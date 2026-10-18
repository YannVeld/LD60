shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float curve : hint_range(0.0, 1.0) = 0.05;
uniform float chroma : hint_range(0.0, 5.0) = 1.0;

uniform float line_sep = 5.0;
uniform float line_intens : hint_range(0.0, 1.0) = 0.3;

vec3 sample_screen(vec2 uv) {
	return textureLod(screen_texture, uv, 0.0).rgb;
}

vec2 curve_screen(vec2 uv) {
	vec2 tt = 2.0*uv - 1.0;
	vec2 dd = tt * tt;
	float scale = 1.0 + curve * dd.x * dd.y;
	tt = tt * scale;
	
	uv = 0.5*tt + 0.5;
	return uv;
}

float check_bounds(vec2 uv) {
	return step(0.0, uv.x) * step(uv.x, 1.0) * step(0.0, uv.y) * step(uv.y, 1.0);
}

void fragment() {
	// Get uv coordinates
	vec2 uv = SCREEN_UV;
	
	// Curve the screen
	uv = curve_screen(uv);
	float outside_bounds = check_bounds(uv);
	
	// Chromatic abberation
	vec3 color;
	vec2 chroma_offset = chroma * vec2(SCREEN_PIXEL_SIZE.x,0.0);
	color.r = sample_screen(uv + chroma_offset).r;
	color.g = sample_screen(uv).g;
	color.b = sample_screen(uv- chroma_offset).b;
	
	// Lines on screen
	float line_intensity = 1.0 - line_intens * sin(2.0 * PI * uv.x / (line_sep*SCREEN_PIXEL_SIZE.x));
	
	// Sample color
	COLOR.rgb = color * outside_bounds * line_intensity;
}
