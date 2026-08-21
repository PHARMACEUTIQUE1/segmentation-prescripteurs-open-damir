# ------------------------------------------------------------
        # Téléchargement sécurisé des fichiers Open DAMIR
# ------------------------------------------------------------

source("R/02_detect_sources.R")

download_open_damir_month <- function(month) {
  if (!month %in% 1:12) {
    stop("Le mois doit être compris entre 1 et 12.")
  }
  
  expected_file <- sprintf("A%d%02d.csv.gz", project_config$data$year, month)
  source_row <- source_manifest |>
    dplyr::filter(file_name == expected_file)
  
  if (nrow(source_row) != 1) {
    stop("Lien introuvable pour : ", expected_file)
  }
  
  destination <- fs::path(project_paths$raw, expected_file)
  temporary_file <- paste0(destination, ".part")
  
  # Ne pas télécharger une deuxième fois un fichier existant
  if (
    fs::file_exists(destination) &&
    fs::file_size(destination) > 0
  ) {
    message("Fichier déjà présent : ", expected_file)
    return(invisible(destination))
  }
  
  message("Téléchargement de : ", expected_file)
  
  httr2::request(source_row$download_url[[1]]) |>
    httr2::req_user_agent("segmentation-prescripteurs-open-damir/0.1") |>
    httr2::req_timeout(7200) |>
    httr2::req_retry(max_tries = 3) |>
    httr2::req_progress() |>
    httr2::req_perform(path = temporary_file)
  
  # Contrôle rapide du fichier compressé
  connection <- gzfile(temporary_file, open = "rt")
  header <- readLines(connection, n = 1, warn = FALSE)
  close(connection)
  
  if (length(header) != 1 || nchar(header) == 0) {
    fs::file_delete(temporary_file)
    stop("Le fichier téléchargé est invalide.")
  }
  
  fs::file_move(temporary_file, destination)
  message("Téléchargement terminé : ", expected_file," | Taille : ", fs::file_size(destination))
  invisible(destination)
}

#download_open_damir_month(1)

#Packages necessaires :
#  DBI : connexion entre R et la base ;
#  duckdb : moteur de base de données analytique ;
#  dbplyr : traduction des opérations R en SQL.