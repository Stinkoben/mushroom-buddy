shader_type canvas_item;

uniform sampler2D noise_img: repeat_enable;
uniform sampler2D gradient_img;
uniform float time_speed;

void fragment() {
	COLOR = vec4(1,1,1,1);
	float gradient = texture(gradient_img, vec2(UV.y, UV.x)).r;
	COLOR.a = texture(noise_img, vec2(UV.x + ((TIME/30.0) * time_speed), UV.y)).r * gradient;
}
