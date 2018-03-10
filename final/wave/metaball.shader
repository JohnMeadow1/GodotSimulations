shader_type canvas_item;

void fragment() {
	
float threshold = 0.7;

vec4 col = texture(TEXTURE, UV);
COLOR.a  = step ( threshold ,col.a ) * 0.8;

COLOR.rgb = vec3( 0.2, 0.3, 0.9 ) * ( SCREEN_UV.y*2.0 + 0.5 );

}
