# -----------------------------------------------------------------------------
# Import du dictionnaire officiel Open DAMIR
# -----------------------------------------------------------------------------

source("R/00_config.R")
dictionary_file <- here::here("data","reference","descriptif_variables_open_damir.xlsx")

# Vérification du fichier
if (!fs::file_exists(dictionary_file)) {
  stop("Le dictionnaire Open DAMIR est introuvable.")
}

# Vérification des feuilles Excel
available_sheets <- readxl::excel_sheets(dictionary_file)

required_sheets <- c("OPEN DAMIR", "MOD OPEN DAMIR")
missing_sheets <- setdiff(required_sheets, available_sheets)

if (length(missing_sheets) > 0) {
  stop(
    "Feuilles manquantes : ",
    paste(missing_sheets, collapse = ", ")
  )
}

# Import de la description des variables
dictionary_variables <- readxl::read_excel(
  path = dictionary_file,
  sheet = "OPEN DAMIR",
  skip = 3) |>
  janitor::clean_names() |>
  dplyr::filter(
    !is.na(nom_variable),
    nom_variable != "")

message("Dictionnaire importé : ",nrow(dictionary_variables)," variables documentées.")
print(table(dictionary_variables$categorie))