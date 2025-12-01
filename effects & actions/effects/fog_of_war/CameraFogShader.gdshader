shader_type canvas_item;

uniform sampler2D vision_mask;
uniform vec2 screen_size = vec2(1920.0, 1080.0);
uniform float fog_strength = 0.5;

void fragment() {
	
	vec2 uv = UV;

	float visible = texture(vision_mask, uv).r;
	
	COLOR = vec4(0.0,0.0,0.0, fog_strength - visible);

}
