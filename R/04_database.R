        # -------------------------------------------------
                # Connexion à la base DuckDB
        # -------------------------------------------------

source("R/00_config.R")
connect_open_damir <- function(read_only = FALSE) {
  fs::dir_create(
    fs::path_dir(project_paths$database),
    recurse = TRUE)
  
  connection <- DBI::dbConnect(
    duckdb::duckdb(),
    dbdir = project_paths$database,
    read_only = read_only)
  
  message("Connexion DuckDB ouverte.")
  connection
}

disconnect_open_damir <- function(connection) {
  
  if (DBI::dbIsValid(connection)) {
    DBI::dbDisconnect(
      connection,
      shutdown = TRUE)
  }
  
  message("Connexion DuckDB fermée.")
  invisible(NULL)
}