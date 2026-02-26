shader_type canvas_item;

uniform sampler2D pintura_tex;
uniform vec2 fish_size; 
uniform vec2 paint_size = vec2(500.0, 300.0); // O tamanho do seu canvas de pintura

void fragment() {
    vec2 scale = fish_size / paint_size;
    vec2 offset = (paint_size - fish_size) / (2.0 * paint_size);
    vec2 paint_uv = offset + UV * scale;
	
    vec4 peixe_cor = texture(TEXTURE, UV);
    vec4 pintura_cor = texture(pintura_tex, paint_uv);
    
    if (paint_uv.x < 0.0 || paint_uv.x > 1.0 || paint_uv.y < 0.0 || paint_uv.y > 1.0) {
        pintura_cor = vec4(1.0);
    }
	
    if (pintura_cor.r > 0.9 && pintura_cor.g > 0.9 && pintura_cor.b > 0.9) {
        COLOR.a = 0.0; // Fundo branco = invisível
    } else {
        COLOR.rgb = peixe_cor.rgb * pintura_cor.rgb; // Tinta = Multiply
        COLOR.a = peixe_cor.a; // Formato original do peixe
    }
}