# Nossos relatórios terão como base as cores BRANCO e AZUL.
# No entanto, utilizar apenas essas 2 cores é bastante limitante,
# Então, outras cores auxiliares podem ser utilizadas,
# Quando for necessário CONTRASTE.

# Caso não seja necessário contraste, utilizar a PALETA PRINCIPAL.

# Paleta de séries === CORES VIVAS (primárias), POIS AS LINHAS SÃO FINAS
paleta_series <- c("#010440", "#ff7f00", "#1e96fc", "#ff6392", 
                   "#009D00", "#9381ff", "#e31a1c", "#25a18e")

# Paleta de histograma === SIMILAR À DE SÉRIES, MAS COM CORES MAIS AGRADÁVEIS PARA OS OLHOS
paleta_hist <- c("#A6CEE3", "#FB9A99", "#FFDB58", "#1F78B4", 
                 "#B2DF8A", "#33A02C", "#8F8164")

# Paleta de histograma VARIÁVEL ORDINAL (EXEMPLO: FAIXAS ETÁRIAS)
paleta_hist_ordinal <- function(n) {
  # Cria a função geradora de paleta
  paleta_func <- colorRampPalette(c("#9AC7D9", "#010440"))
  
  # Gera a paleta de cores com n cores
  paleta <- paleta_func(n)
  
  return(paleta)
}

# Paleta para gradientes (CORES CONTÍNUAS), EXEMPLO: HEATMAP
scale_fill_gradient(low = "lightblue", high = "#010440")

# AZUIS QUE PODEM SER ÚTEIS PARA DETALHES
paleta_azul <- c("#FFFFFF", "#E0E0E0", "#8A8A8A", "#496373",  
                 "#9AC7D9", "#024059", "#223459", "#0000FF", 
                 "#010440", "#222333", "#2B2B33", "#000000")

# TAMANHO DO TEXTO DA LEGENDA
size_titulo_legenda <- 12
size_texto_legenda <- 10

