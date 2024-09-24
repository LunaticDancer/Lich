shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec4 color : source_color = vec4(1.0);
uniform vec4 obscured_color : source_color = vec4(1.0);
uniform vec4 background_color : source_color = vec4(1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if(texture(screen_texture, SCREEN_UV) != background_color)
	{
		COLOR = texture(TEXTURE, UV) * obscured_color;
	}
	else
	{
		COLOR = texture(TEXTURE, UV) * color;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
