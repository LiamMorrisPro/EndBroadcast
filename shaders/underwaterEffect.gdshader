shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;


uniform sampler2D waterDistortionNoise : repeat_enable, filter_nearest;

uniform vec2 tiling = vec2(1);
uniform vec2 offSetSpeed = vec2(.1);

group_uniforms BG_distortion;
uniform float backGroundDirX : hint_range(-0.1, 0.1) = 0.01;
uniform float backGroundDirY : hint_range(-0.1, 0.1) = 0.01;




void fragment() {


	vec2 noiseUV = UV * tiling + offSetSpeed * TIME;
	float noiseValue = texture(waterDistortionNoise, noiseUV).r;



	vec2 backGroundUV = SCREEN_UV;
	backGroundUV.x += noiseValue * backGroundDirX;
	backGroundUV.y += noiseValue * backGroundDirY;



	COLOR = texture(SCREEN_TEXTURE, backGroundUV);

}
