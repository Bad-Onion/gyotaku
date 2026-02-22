shader_type canvas_item;

uniform sampler2D paint_texture; 
uniform sampler2D paper_noise; 
uniform float ink_threshold : hint_range(0.0, 1.0) = 0.5; 

void fragment() {
    // 1. Pega o peixe (textura original do nó Sprite2D)
    vec4 fish = texture(TEXTURE, UV);
    
    // 2. Pega a pintura que você enviou por script
    vec4 paint = texture(paint_texture, UV);
    
    // 3. Corta a pintura pra não vazar do peixe
    paint.a *= fish.a;
    
    // 4. O PULO DO GATO: Junta o peixe e a pintura numa imagem só!
    // O mix() pega o fundo (fish), a frente (paint), e usa o Alpha da pintura pra mesclar
    vec4 final_image = mix(fish, paint, paint.a);
    
    // 5. Agora sim, aplica o ruído de carimbo na imagem JÁ JUNTADA
    vec4 noise = texture(paper_noise, UV);
    if (noise.r > ink_threshold) {
        // Tira a opacidade de tudo (peixe + pintura) onde o ruído for forte
        final_image.a -= 0.5; // Ou mude pra 0.0 se quiser furos totalmente transparentes
    }
    
    // Mostra o resultado final com a textura pegando em tudo
    COLOR = final_image;
}