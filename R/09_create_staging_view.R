# -----------------------------------------------------------------------------
# Création de la vue staging Open DAMIR
# -----------------------------------------------------------------------------

source("R/04_database.R")
source("R/06_sql_utils.R")

create_staging_view <- function() {
  sql_file <- here::here("sql","03_create_staging_view.sql")
  connection <- connect_open_damir()
  
  on.exit(disconnect_open_damir(connection), add = TRUE)
  run_sql_statement(connection, sql_file)
  
  schema <- DBI::dbGetQuery(connection, "DESCRIBE staging_open_damir")
  message("Vue staging_open_damir créée : ", nrow(schema), " colonnes.")
  schema
}

staging_schema <- create_staging_view()
print(staging_schema[, c("column_name", "column_type")], row.names = FALSE)