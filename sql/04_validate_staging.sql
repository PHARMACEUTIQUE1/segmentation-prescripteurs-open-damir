SELECT
    COUNT(*) AS nombre_lignes,
    COUNT(DISTINCT source_file) AS nombre_fichiers,
    MIN(flx_ann_moi) AS periode_min,
    MAX(flx_ann_moi) AS periode_max,
    COUNT(prs_rem_mnt) AS remboursements_bruts_valides,
    COUNT(flt_rem_mnt) AS remboursements_prefiltres_valides,
    SUM(prs_rem_mnt) AS montant_rembourse_brut,
    SUM(flt_rem_mnt) AS montant_rembourse_prefiltre
FROM staging_open_damir