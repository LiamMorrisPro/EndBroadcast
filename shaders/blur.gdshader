shader_type canvas_item;
render_mode unshaded;


/**
 * How blurry the result should be.
 */
uniform float strength : hint_range(0.0, 10.0) = 3.0;

/**
 * Exponent value for number of samples (2^sample_power samples total).
 */
uniform int sample_power : hint_range(3, 8, 1) = 4;

/**
 * Vision mask and screen info.
 */
uniform sampler2D vision_mask;
uniform vec2 screen_size = vec2(1920.0, 1080.0);
uniform float fog_strength = 0.5;

vec2 rotate(vec2 v, float angle) {
	mat2 rotation_matrix = mat2(vec2(cos(angle), sin(angle)), vec2(-sin(angle), cos(angle)));
	return v * rotation_matrix;
}

void fragment() {
	vec2 uv = UV;
	vec2 pixel_size = 1.0 / screen_size;

	float samples = pow(2.0, float(sample_power));
	float layer_increment = strength / samples;
	float angle_increment = TAU / samples;

	// Start with the base mask color
	float visible = texture(vision_mask, uv).r;

	// Iterate over radial blur layers
	for (float d = layer_increment; d <= strength && strength > 0.0; d += layer_increment) {
		float layer_sum = 0.0;

		for (float t = 0.0; t < TAU; t += angle_increment) {
			vec2 sample_uv = uv + rotate(pixel_size * d, t);
			layer_sum += texture(vision_mask, sample_uv).r;
		}

		float layer_avg = layer_sum / samples;
		float weight = 1.0 - sqrt(d / strength);
		visible = mix(visible, layer_avg, weight);
	}

	COLOR = vec4(0.0, 0.0, 0.0, fog_strength - visible);
}