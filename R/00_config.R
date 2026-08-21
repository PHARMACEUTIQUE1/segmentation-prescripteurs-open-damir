                # ---------------------------------------------
                     # Configuration générale du projet
                # ----------------------------------------------

# Localisation du fichier de configuration
config_file <- here::here("config", "project.yml")

# Vérification de son existence
if (!fs::file_exists(config_file)) {
  stop("Le fichier config/project.yml est introuvable.")
}

# Lecture de la configuration
project_config <- yaml::read_yaml(config_file)

# Vérification des sections obligatoires
required_sections <- c("project", "data", "paths")
missing_sections <- setdiff(required_sections, names(project_config))

if (length(missing_sections) > 0) {
  stop("Sections manquantes dans project.yml : ", paste(missing_sections, collapse = ", "))
}

# Construction des chemins absolus
project_paths <- list(
  raw       = here::here(project_config$paths$raw),
  interim   = here::here(project_config$paths$interim),
  processed = here::here(project_config$paths$processed),
  database  = here::here(project_config$paths$database),
  models    = here::here(project_config$paths$models),
  outputs   = here::here(project_config$paths$outputs),
  logs      = here::here(project_config$paths$logs))

# Création automatique des dossiers manquants
directories <- c(
  project_paths$raw,
  project_paths$interim,
  project_paths$processed,
  fs::path_dir(project_paths$database),
  project_paths$models,
  project_paths$outputs,
  project_paths$logs)

invisible(lapply(directories, fs::dir_create, recurse = TRUE))

# Graine aléatoire reproductible
set.seed(project_config$project$random_seed)
message("Configuration chargée : ",project_config$project$name," | Année : ",project_config$data$year)