shader_type canvas_item;

uniform sampler2D paint_texture; 
uniform sampler2D paper_noise; 
uniform float ink_threshold : hint_range(0.0, 1.0) = 0.5; 

void fragment() {
    // 1. Pega o peixe
    vec4 fish = texture(TEXTURE, UV);
    
    // 2. Pega a pintura
    vec4 paint = texture(paint_texture, UV);
    
    // 3. Cropa a pintura
    paint.a *= fish.a;
    
	//Mescla de acordo com o alpha
    vec4 final_image = mix(fish, paint, paint.a);
    
    // 5. Aplica ruído na imagem já mesclada
    vec4 noise = texture(paper_noise, UV);
    if (noise.r > ink_threshold) {
        final_image.a -= 0.5;
    }
    
    COLOR = final_image;
}