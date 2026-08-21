# -----------------------------------------------------------------------------
# Création de la vue brute Open DAMIR dans DuckDB
# -----------------------------------------------------------------------------

source("R/04_database.R")

create_raw_view <- function() {
  sql_file <- here::here("sql","01_create_raw_view.sql")
  if (!fs::file_exists(sql_file)) {
    stop("Le fichier SQL de création de la vue est introuvable.")
  }
  
  available_files <- fs::dir_ls(
    project_paths$raw,
    regexp = paste0("A", project_config$data$year, "[0-9]{2}\\.csv\\.gz$"),
    type = "file")
  if (length(available_files) == 0) {
    stop("Aucun fichier Open DAMIR disponible.")
  }
  
  raw_glob <- fs::path(
    project_paths$raw,
    paste0("A", project_config$data$year, "*.csv.gz"))
  
  # DuckDB utilise plus facilement les slashs
  raw_glob <- gsub("\\\\", "/", raw_glob)
  sql_query <- paste(
    readLines(sql_file, warn = FALSE, encoding = "UTF-8"),
    collapse = "\n")
  
  sql_query <- gsub("{{RAW_GLOB}}", raw_glob, sql_query, fixed = TRUE)
  connection <- connect_open_damir()
  
  on.exit(disconnect_open_damir(connection), add = TRUE)
  DBI::dbExecute(connection,sql_query)
  schema <- DBI::dbGetQuery(connection, "DESCRIBE raw_open_damir")
  
  message("Vue raw_open_damir créée : ", nrow(schema), " colonnes.")
  schema
}

raw_view_schema <- create_raw_view()
print(raw_view_schema[, c("column_name", "column_type")], row.names = FALSE)