# -----------------------------------------------------------------------------
# Création et validation de la vue analytique des prescripteurs
# -----------------------------------------------------------------------------

source("R/04_database.R")
source("R/06_sql_utils.R")


build_analytics_view <- function() {

  # Ouverture de la connexion DuckDB
  connection <- connect_open_damir()
  # Fermeture garantie de la connexion
  on.exit(disconnect_open_damir(connection), add = TRUE)
  
  # Création ou actualisation de la vue analytique
  run_sql_statement(
    connection,
    here::here("sql","08_create_prescriber_monthly_view.sql"))
  
  # Comparaison entre la couche staging et la couche analytique
  validation <- DBI::dbGetQuery(
    connection,
    "WITH staging AS (
        SELECT ROUND(SUM(flt_rem_mnt), 2) AS remboursement
        FROM staging_open_damir
    ),
    analytics AS (
        SELECT COUNT(*) AS nombre_profils_mensuels,
            COUNT(
                DISTINCT (
                    periode_traitement,
                    profil_prescripteur_id)) AS nombre_profils_uniques,
            ROUND(SUM(montant_rembourse_prefiltre), 2) AS remboursement
        FROM analytics_prescriber_monthly)
    SELECT
        analytics.nombre_profils_mensuels,
        analytics.nombre_profils_uniques,
        staging.remboursement AS remboursement_staging,
        analytics.remboursement AS remboursement_analytics,
        ROUND(analytics.remboursement -  staging.remboursement,  2) AS ecart_remboursement
    FROM staging, analytics "
  )
  
  # Affichage avant les contrôles
  print(validation)
  
  # Contrôle des doublons
  if (
    validation$nombre_profils_mensuels !=
    validation$nombre_profils_uniques
  ) {
    stop("Des profils mensuels sont dupliqués.")
  }
  
  # Contrôle de conservation des montants
  tolerance_remboursement <-
    0.05 +
    1e-12 * abs(validation$remboursement_staging)
  
  if (abs(validation$ecart_remboursement) >tolerance_remboursement) {
    stop(paste0("Écart financier anormal détecté : ", validation$ecart_remboursement, " €.")
    )
  }
  
  # Enregistrement du rapport de validation
  utils::write.csv(
    validation,
    here::here(
      "outputs",
      "tables",
      "analytics_validation.csv"),
    row.names = FALSE, fileEncoding = "UTF-8")
  
  message("Vue analytique créée et validée.")
  validation
}


# Exécution
analytics_validation <- build_analytics_view()
print(analytics_validation)