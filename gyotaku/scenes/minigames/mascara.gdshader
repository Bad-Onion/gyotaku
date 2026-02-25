shader_type canvas_item;

void fragment() {
    vec4 cor = texture(TEXTURE, UV);
    
    // Confere se o pixel é claro (o fundo vazio da sua tela de pintura)
    if (cor.r > 0.8 && cor.g > 0.8 && cor.b > 0.8) {
        // Zera o Alpha.
        COLOR.a = 0.0;
    } else {
        COLOR = cor;
    }
}