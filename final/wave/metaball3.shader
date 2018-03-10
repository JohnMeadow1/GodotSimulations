shader_type canvas_item;

void fragment() {
float target_alpha = 0.5;
float threshold    = 0.5;
//vec4 col = textureLod(TEXTURE, UV);
vec4 col = texture(TEXTURE, UV);
//vec4 col = textureLod(SCREEN_TEXTURE,SCREEN_UV,0.0);
//float val = max(max(target_color.r,target_color.g), target_color.b);

//col.rgb = (1.0 - val) * (col.rgb/ max(max(col.r,col.g), col.b)*0.7) + 
//(val) * (target_color.rgb*0.8);

COLOR.a  = step (threshold,col.a);

//vec2 normal1  = tex ( TEXTURE, UV ).rg - vec2( 0.5 );
vec2 normal1  = col.rg - vec2( 0.5 );
vec2 cont_uv1 = vec2(  SCREEN_UV.x, SCREEN_UV.y );
vec2 cont_uv2 = vec2(  SCREEN_UV.x - normal1.x * 0.1, SCREEN_UV.y - normal1.y * 0.1 );
vec3 screen_tex1 = textureLod(SCREEN_TEXTURE,cont_uv1 + normal1 * 0.1,0.0).rgb;
vec3 screen_tex2 = textureLod(SCREEN_TEXTURE,cont_uv2 - normal1 * 0.8,0.0).rgb;
//vec3 screen_tex1 = texscreen( cont_uv1 + normal1 * 0.1 );
//vec3 screen_tex2 = texscreen( cont_uv2 - normal1 * 0.8 );

vec3 c = ( screen_tex1 * 0.85 + screen_tex2 * 0.15 );
float angle = atan( col.r-0.5, col.g-0.5 ) + 3.14;
//c = c + vec3( step(angle, 3.28) * step(6.28 - angle, 5.28));
c = c + vec3(step(length(vec2(col.r, col.g)), 0.51) * step(1.0-length(vec2(col.r, col.g)), 0.55) *step(angle, 3.28) * step(6.28 - angle, 5.28) * length(vec2(col.g, col.b)*0.1) ) ;

//vec3 c = screen_tex2;
//vec3 c = tex( screen_tex, cont_uv - normal * 0.2 ).rgb;
COLOR.rgb  = c * ( 1.0 - length( normal1 ) ) + vec3(0.0,0.0,0.8);
//COLOR.rgb  = c * ( 1.0 - length( normal1 )/2.0 )*2.0;
COLOR.rgba = COLOR.rgba + (vec4(step(col.a, 0.5) * step(1.0 - col.a, 0.65)) * vec4(0.1,0.1,0.1,1));
//COLOR.a  = col.a;

//COLOR=col;
}
