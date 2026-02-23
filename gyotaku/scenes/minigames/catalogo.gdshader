shader_type canvas_item;

uniform sampler2D paper_noise; 
// Controla a quantidade de falhas na tinta (0 = sem falhas, 1 = falha tudo)
uniform float ink_threshold : hint_range(0.0, 1.0) = 0.5; 

void fragment() {
    // Pega a imagem prontinha que veio do SubViewport
    vec4 final_image = texture(TEXTURE, UV);
    
    // Pega a textura de ruído
    vec4 noise = texture(paper_noise, UV);
    
    // Se o pixel não for transparente E o ruído for forte, a tinta falha
    if (final_image.a > 0.0 && noise.r > ink_threshold) {
        // Tira 50% da opacidade onde a tinta falhou
        final_image.a -= 0.5; 
        // Dica: se quiser que a tinta suma 100% nas falhas, troque por final_image.a = 0.0;
    }
    
    COLOR = final_image;
}