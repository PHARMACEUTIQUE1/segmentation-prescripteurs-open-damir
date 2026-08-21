# -----------------------------------------------------------------------------
# Fonctions utilitaires pour exécuter les fichiers SQL
# -----------------------------------------------------------------------------

#Lire et contrôler un fichier SQL
read_sql_file <- function(sql_file) {
  if (!fs::file_exists(sql_file)) {
    stop("Fichier SQL introuvable : ", sql_file)
  }
  
  
 
  sql_query <- paste(
    readLines(sql_file,warn = FALSE,encoding = "UTF-8"),
    collapse = "\n")
  if (nchar(trimws(sql_query)) == 0) {
    stop("Le fichier SQL est vide : ", sql_file)
  }
  sql_query
}

#Exécuter SQL et récupérer un tableau
run_sql_query <- function(connection, sql_file) {
  if (!DBI::dbIsValid(connection)) {
    stop("La connexion à la base est invalide.")
  }
  DBI::dbGetQuery(connection,read_sql_file(sql_file))
}

#Créer ou modifier un objet dans la base
run_sql_statement <- function(connection, sql_file) {
  if (!DBI::dbIsValid(connection)) {
    stop("La connexion à la base est invalide.")
  }
  DBI::dbExecute(connection,read_sql_file(sql_file))
}