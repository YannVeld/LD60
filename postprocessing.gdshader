shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float curve : hint_range(0.0, 1.0) = 0.05;
uniform float chroma : hint_range(0.0, 5.0) = 1.0;

uniform float line_sep = 7.0;
uniform float line_intens : hint_range(0.0, 1.0) = 0.1;

uniform float vignette_radius : hint_range(0.0, 1.0) = 0.9;
uniform float vignette_smooth : hint_range(0.0, 1.0) = 0.5;

uniform float grain : hint_range(0.0, 1.0) = 0.2;

uniform float smooth_edges : hint_range(0.0, 1.0) = 0.01;

vec3 sample_screen(vec2 uv) {
	return textureLod(screen_texture, uv, 0.0).rgb;
}

float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

vec2 curve_screen(vec2 uv) {
	vec2 tt = 2.0*uv - 1.0;
	vec2 dd = tt * tt;
	float scale = 1.0 + curve * dd.x * dd.y;
	tt = tt * scale;
	
	uv = 0.5*tt + 0.5;
	return uv;
}

float get_vignette(vec2 uv) {
	vec2 tt = uv - 0.5;
	float dist = length(tt);
	return smoothstep(vignette_radius, vignette_radius-vignette_smooth, dist);
}

float check_bounds(vec2 uv) {
	return step(0.0, uv.x) * step(uv.x, 1.0) * step(0.0, uv.y) * step(uv.y, 1.0);
}

float smoothen_edges(vec2 uv) {
	vec2 tt = abs(2.0*uv - 1.0);
	float dist = max(tt.x, tt.y);
	return 1.0 - smoothstep(1.0-smooth_edges, 1.0, dist);
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
	color = color * line_intensity;
	
	// Vignette
	color = color * get_vignette(uv);
	
	// Grain
	float grain_intensity = 1.0 - grain * random(uv + fract(TIME));
	color = color * grain_intensity;
	
	// Smoothen edges
	color = color * smoothen_edges(uv);
	
	// Sample color
	COLOR.rgb = color * outside_bounds;
}
