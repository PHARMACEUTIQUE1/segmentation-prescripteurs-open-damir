# -----------------------------------------------------------------
        # Construction du mapping des colonnes Open DAMIR
# -----------------------------------------------------------------

source("R/01_import_dictionnaire.R")
source("R/04_database.R")

build_column_mapping <- function() {
  
  output_file <- here::here("outputs", "tables", "column_mapping.csv")
  connection <- connect_open_damir()
  on.exit(disconnect_open_damir(connection),add = TRUE)
  raw_schema <- DBI::dbGetQuery(connection, "DESCRIBE raw_open_damir")
  
  dictionary_lookup <- dictionary_variables |>
    dplyr::transmute(
      join_name = toupper(nom_variable),
      official_label = libelle,
      category = categorie) |>
    dplyr::distinct(join_name, .keep_all = TRUE)
  
  column_mapping <- raw_schema |>
    tibble::as_tibble() |>
    dplyr::transmute(
      raw_name = column_name,
      standard_name = janitor::make_clean_names(column_name),
      join_name = toupper(column_name)) |>
    dplyr::left_join(dictionary_lookup, by = "join_name") |>
    dplyr::mutate(
      official_label = dplyr::case_when(
        raw_name == "source_file" ~ "Fichier source",
        raw_name == "ETB_DCS_MCO" ~ "Domaine d'activité",
        raw_name == "PSP_SPE_SNDS" ~ "Spécialité médicale PS prescripteur",
        TRUE ~ official_label),
      category = dplyr::case_when(
        raw_name == "ETB_DCS_MCO" ~ "EXECUTANT",
        raw_name == "source_file" ~ "TECHNIQUE",
        
        TRUE ~ category),
      documentation_source = dplyr::case_when(
        raw_name == "ETB_DCS_MCO" ~ "Documentation SNDS - ER_ETE_F",
        raw_name == "source_file" ~ "Projet",
        raw_name == "PSP_SPE_SNDS" ~ "Dictionnaire Open DAMIR - libellé corrigé",
        TRUE ~ "Dictionnaire Open DAMIR"),
      documentation_status = dplyr::case_when(
        raw_name == "source_file" ~ "Technique",
        !is.na(official_label) ~ "Documentée",
        TRUE ~ "À documenter")) |>
    dplyr::select(
      raw_name,
      standard_name,
      official_label,
      category,
      documentation_source,
      documentation_status)
  
  utils::write.csv(column_mapping,output_file,row.names = FALSE,fileEncoding = "UTF-8",na = "")
  
  message("Mapping créé : ",nrow(column_mapping)," colonnes.")
  print(table(column_mapping$documentation_status))
  column_mapping
}
column_mapping <- build_column_mapping()
print(column_mapping,n = Inf)