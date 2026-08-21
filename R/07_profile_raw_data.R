# -------------------------------------------------------------
        # Profilage complet des variables brutes Open DAMIR
# -------------------------------------------------------------

source("R/04_database.R")
source("R/06_sql_utils.R")

profile_raw_data <- function() {
  sql_file <- here::here("sql","02_profile_raw_data.sql")
  output_file <- here::here("outputs","tables","raw_data_profile.csv")
  
  connection <- connect_open_damir()
  on.exit(disconnect_open_damir(connection),add = TRUE)
  message("Début du profilage des données brutes...")
  
  profile <- run_sql_query(connection,sql_file)
  
  fs::dir_create(
    fs::path_dir(output_file),
    recurse = TRUE)
  
  utils::write.csv(
    profile,
    output_file,
    row.names = FALSE,
    fileEncoding = "UTF-8",
    na = "")
  
  message("Profilage terminé : ",nrow(profile), " variables analysées.")
  message("Résultat enregistré dans : ",output_file)
  profile
}

raw_data_profile <- profile_raw_data()
print(raw_data_profile[
    ,
    c(
      "column_name",
      "column_type",
      "approx_unique",
      "null_percentage"
    )
  ],
  row.names = FALSE)