# listar arquivos na pasta media/ (e nas pastas que estão
# dentro dela)
arquivos <-
  list.files(path = "media",
             full.names = TRUE,
             recursive = TRUE)

# descobrir o tamanho dos arquivos
tamanho_em_b <- sapply(arquivos, file.size)


# criar uma tabela com isso
arquivos_repo <- tibble::tibble(arquivos,
                                tamanho_em_b)

# converter tamanho de b em mb
imagens <- arquivos_repo |>
  dplyr::filter(!stringr::str_starts(arquivos, "media/cover/cover")) |>
  dplyr::arrange(desc(tamanho_em_b)) |>
  dplyr::mutate(tamanho_em_mb = tamanho_em_b / (1024 ^ 2))

# soma do tamanho das imagens atualmente
sum(imagens$tamanho_em_mb)
#> [1] 113.2696

# filtrar por arquivos de certo tamanho,
# esse numero é baseado nas vozes da minha cabeça
# e é legal experimentar alterar ele
arquivos_diminuir_tamanho <- imagens |>
  dplyr::filter(tamanho_em_mb > 0.2)

# somar o tamanho
sum(arquivos_diminuir_tamanho$tamanho_em_mb)

# ler as imagens
imagens_m <- magick::image_read(arquivos_diminuir_tamanho$arquivos)


# redimensionar - alterar a altura desejada
imagens_resized <- magick::image_resize(imagens_m, "x500")

# salvar todas as imagens
purrr::map2(
  as.list(imagens_resized),
  arquivos_diminuir_tamanho$arquivos,
  magick::image_write
)
