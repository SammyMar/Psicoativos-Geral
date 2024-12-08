# 1 ORGANIZAR BASE DE DADOS

#a. DADOS DE POPULACAO

pop13a21 <- readRDS("Iane/Bases/pop13a21.rds")

# Pegar informacoes para pop22 presente em "dados_br_total"
pop22 <- dados_br_total %>% select(codigoUF, pop22)
pop22 <- pop22 %>% distinct()

# Converter a coluna pop22 para numerico
pop22 <- pop22 %>%
  mutate(pop22 = as.numeric(pop22))

# Somar as populaCOES para ter a populacao do Brasil
total_br_pop22 <- pop22 %>% summarise(pop22 = sum(pop22, na.rm = TRUE))

brasil_pop22 <- data.frame(
  codigoUF = as.character(1),
  pop22 = total_br_pop22$pop22
)

# Adicionar a nova linha Com  base de dados pop22
pop22 <- pop22 %>% mutate(codigoUF = as.character(codigoUF))

pop22 <- bind_rows(pop22, brasil_pop22)

# Adicionar a coluna "ano" com o valor 2022 e garantir que "codigoUF" C) "character" e "ano" C) numeric
pop22 <- pop22 %>%
  rename(valor = pop22) %>%
  mutate(codigoUF = as.character(codigoUF),
         ano = as.numeric(2022))  # Adiciona a coluna "ano" com o valor 2022

# Unir a base de dados pop22 com var_extras_UF para adicionar as colunas "Estado" e "Sigla"
pop22 <- pop22 %>%
  left_join(var_extras_UF, by = "codigoUF")


# Garantir que "codigoUF" e "ano" em "pop13a21" tambem sao character e numeric, respectivamente
pop13a21 <- pop13a21 %>%
  mutate(codigoUF = as.character(codigoUF),
         ano = as.numeric(ano))

# Combinar os data frames usando bind_rows()
pop13a22 <- bind_rows(pop13a21, pop22)


# Adicionar os valores "Brasil" e "BR" nas colunas "Estado" e "Sigla" para as linhas com codigoUF igual a "1"
pop13a22 <- pop13a22 %>%
  mutate(
    Estado = ifelse(codigoUF == "1", "Brasil", Estado),
    Sigla = ifelse(codigoUF == "1", "BR", Sigla)
  )


#b. DADOS DE MORTES POR PSICOATIVOS

#agrupar mortes por psicoativos por estado e ano

tabela_estado_ano <- dados_br_psic %>%
  group_by(Sigla, ANOOBITO) %>%
  summarise(Quantidade_Obitos = n())

# Agrupar os dados de C3bitos para o Brasil
tabela_brasil_ano <- dados_br_psic %>%
  group_by(ANOOBITO) %>%
  summarise(Quantidade_Obitos = n()) %>%
  mutate(Sigla = "BR")

# Combinar as tabelas tabela_estado_ano e tabela_brasil_ano
tab_mortes_estado_ano_psic <- bind_rows(tabela_estado_ano, tabela_brasil_ano)


#combinando as tabelas tab_mortes_estado_ano_psic com pop_13a22

pop13a22 <- pop13a22 %>%
  rename(ANOOBITO = ano)

tab_mortes_estado_ano_psic <- tab_mortes_estado_ano_psic %>%
  left_join(pop13a22, by = c("Sigla", "ANOOBITO"))


#2. PLOTAR O GRAFICO

# Calcular a taxa de C3bitos por 100.00 habitantes
tab_mortes_estado_ano_psic <- tab_mortes_estado_ano_psic %>%
  mutate(Taxa_Obitos_100k = (Quantidade_Obitos / valor) * 100000)

# calcular a mC)dia da taxa de C3bitos por 100k habitantes para cada estado, excluindo o Brasil
media_taxa_obitos <- tab_mortes_estado_ano_psic %>%
  filter(Sigla != "BR") %>%
  group_by(Sigla) %>%
  summarise(Media_Taxa_Obitos_100k = mean(Taxa_Obitos_100k, na.rm = TRUE)) %>%
  arrange(desc(Media_Taxa_Obitos_100k))

# colocar a linha do Brasil (BR) ao final da tabela de mC)dias
media_taxa_obitos <- bind_rows(media_taxa_obitos, data.frame(Sigla = "BR", Media_Taxa_Obitos_100k = NA))

# Reordenar os dados principais de acordo com a nova ordem dos estados
tab_mortes_estado_ano_psic$Sigla <- factor(tab_mortes_estado_ano_psic$Sigla, levels = rev(media_taxa_obitos$Sigla))

# Ordenar os dados pela nova ordem dos estados
tab_mortes_estado_ano_psic <- tab_mortes_estado_ano_psic %>%
  arrange(Sigla, ANOOBITO)

anos <- seq(2013, 2022)

# Plotar o grC!fico de calor
heatmap_mortes_psic <- ggplot(tab_mortes_estado_ano_psic, 
                              aes(x = ANOOBITO,
                                  y = Sigla, 
                                  fill = Taxa_Obitos_100k,
                                  text = paste("Ano: ", ANOOBITO,
                                               "<br>UF: ", Sigla,
                                               "<br> Taxa: ", round(Taxa_Obitos_100k, 2)))) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "lightblue", high = "#010440", name = "Óbitos por 100 mil habitantes") +
  scale_x_continuous(breaks = anos) +
  labs(title = "Taxa de mortes por Psicoativos a cada 100.000 habitantes nos estados brasileiros ao longo dos anos",
       x = "Ano",
       y = "Estado") +
  theme_minimal()+
  theme(plot.title = element_text(size = 20)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.title = element_text(size = size_titulo_legenda),               
        legend.text = element_text(size = size_texto_legenda))

ggplotly(heatmap_mortes_psic, tooltip = "text")


save(heatmap_mortes_psic, file="GRAFICOS_RDA/heatmap_mortes_psic.RData")


