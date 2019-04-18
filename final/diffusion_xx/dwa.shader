shader_type canvas_item;

uniform float alpha = 0.99999;

void fragment(){
	vec4 c0 = vec4(0.0,0.0,0.0,1.0);
	vec4 c1 = vec4(0.0,0.0,0.0,1.0);
	vec4 c2 = vec4(0.0,0.0,0.0,1.0);
	if(FRAGCOORD.x >= 2.0 && FRAGCOORD.x <= 1024.0-2.0){
	c1 = texture(TEXTURE, UV+vec2(1.0)).rgba;
	c2 = texture(TEXTURE, UV-vec2(1.0)).rgba;
	c0 = vec4(NORMAL.b,NORMAL.g,NORMAL.r,1.0);
	texture(TEXTURE, UV).r += 1.1;
	//texture(TEXTURE, vec2(FRAGCOORD.x,FRAGCOORD.y)).rgba;
	/*COLOR.rgb = c;//0.5*(c.r+d.r);
	/*COLOR.g += 0.0;
	COLOR.b += 0.0;
	COLOR.a += 1.0;*/
	}
	COLOR = alpha*COLOR + (1.0-alpha)*c0;//COLOR - 0.0*0.01*(1.0-alpha)*c1;
	alpha = abs(sin(TIME));
	NORMAL = COLOR.bgr;
}

void vertex(){
	//VERTEX.x += TIME;
	}