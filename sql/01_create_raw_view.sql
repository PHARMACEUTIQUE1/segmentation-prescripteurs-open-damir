-- ============================================================================
      -- Vue brute Open DAMIR
      -- Les colonnes sont conservées en texte pour éviter toute perte à l'import.
      -- Les conversions seront réalisées dans la couche staging.
-- ============================================================================

CREATE OR REPLACE VIEW raw_open_damir AS

SELECT * EXCLUDE (filename, Column56),
    filename AS source_file
FROM read_csv_auto(
    '{{RAW_GLOB}}',
    delim = ';',
    header = true,
    compression = 'gzip',
    all_varchar = true,
    filename = true,
    union_by_name = true,
    ignore_errors = false);