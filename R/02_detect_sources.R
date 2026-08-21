# ---------------------------------------------------
      # Détection des fichiers mensuels Open DAMIR
# ---------------------------------------------------

source("R/00_config.R")

catalog_url <- project_config$data$catalog_url
study_year <- project_config$data$year

# Lecture sécurisée de la page officielle
response <- httr2::request(catalog_url) |>
  httr2::req_user_agent("segmentation-prescripteurs-open-damir/0.1") |>
  httr2::req_timeout(60) |>
  httr2::req_retry(max_tries = 3) |>
  httr2::req_perform()

page <- httr2::resp_body_html(response)

# Extraction des liens
nodes <- rvest::html_elements(page, "a")

source_manifest <- tibble::tibble(
  label = rvest::html_text2(nodes),
  href  = rvest::html_attr(nodes, "href")) |>
  dplyr::mutate(
    file_name = stringr::str_extract(
      paste(label, href),
      "A[0-9]{6}\\.csv\\.gz"),
    download_url = xml2::url_absolute(href, catalog_url)) |>
  dplyr::filter(
    stringr::str_detect(
      file_name,
      paste0("^A", study_year, "[0-9]{2}\\.csv\\.gz$"))) |>
  dplyr::distinct(file_name, .keep_all = TRUE) |>
  dplyr::arrange(file_name) |>
  dplyr::select(file_name, download_url)

if (nrow(source_manifest) != 12) {
  stop("Nombre inattendu de fichiers détectés : ", nrow(source_manifest), " au lieu de 12.")
}

message(nrow(source_manifest), " fichiers mensuels détectés.")

print(source_manifest$file_name)