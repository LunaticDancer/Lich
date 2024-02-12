shader_type canvas_item;

uniform float fill = 0.5f;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.a = (UV.y > (1.0 - fill)) ? COLOR.a : 0.0;
}
