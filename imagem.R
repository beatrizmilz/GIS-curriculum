arquivos <-
  list.files(path = "media",
             full.names = TRUE,
             recursive = TRUE)


tamanho_em_b <- sapply(arquivos, file.size)

arquivos_repo <- tibble::tibble(arquivos,
                                tamanho_em_b)

imagens <- arquivos_repo |>
  dplyr::filter(!stringr::str_starts(arquivos, "media/cover/cover")) |>
  dplyr::arrange(desc(tamanho_em_b)) |>
  dplyr::mutate(tamanho_em_mb = tamanho_em_b / (1024 ^ 2))

sum(imagens$tamanho_em_mb)
#> [1] 113.2696

arquivos_diminuir_tamanho <- imagens |>
  dplyr::filter(tamanho_em_mb > 0.2)

sum(arquivos_diminuir_tamanho$tamanho_em_mb)


imagens_m <- magick::image_read(arquivos_diminuir_tamanho$arquivos)

info_m <- magick::image_info(imagens_m)

# largura desejada
imagens_resized <- magick::image_resize(imagens_m, "x500")

magick::image_info(imagens_resized)

purrr::map2(
  as.list(imagens_resized),
  arquivos_diminuir_tamanho$arquivos,
  magick::image_write
)
