CREATE OR REPLACE VIEW analytics_prescriber_monthly AS

WITH base AS (
    SELECT flx_ann_moi AS periode_traitement,
        COALESCE(NULLIF(TRIM(etp_reg_cod), ''), 'INCONNU') AS region_etablissement_prescripteur,
        COALESCE(NULLIF(TRIM(etp_cat_snds), ''), 'INCONNU') AS categorie_etablissement_prescripteur,
        COALESCE(NULLIF(TRIM(pre_ins_reg), ''), 'INCONNU') AS region_prescripteur,
        COALESCE(NULLIF(TRIM(psp_act_snds), ''), 'INCONNU') AS nature_activite_prescripteur,
        COALESCE(NULLIF(TRIM(psp_act_cat), ''), 'INCONNU') AS categorie_prescripteur,
        COALESCE(NULLIF(TRIM(psp_spe_snds), ''), 'INCONNU') AS specialite_medicale_prescripteur,
        COALESCE(NULLIF(TRIM(psp_stj_snds), ''), 'INCONNU') AS statut_juridique_prescripteur,
        *
    FROM staging_open_damir),
agregation AS (
    SELECT
        periode_traitement,
        region_etablissement_prescripteur,
        categorie_etablissement_prescripteur,
        region_prescripteur,
        nature_activite_prescripteur,
        categorie_prescripteur,
        specialite_medicale_prescripteur,
        statut_juridique_prescripteur,

        COUNT(*) AS nombre_lignes_source,
        COUNT(DISTINCT prs_nat) AS diversite_natures_prestation,

        SUM(prs_act_nbr) AS nombre_actes_bruts,
        SUM(prs_act_qte) AS quantite_prestations_brute,
        SUM(prs_pai_mnt) AS montant_depense_brut,
        SUM(prs_dep_mnt) AS montant_depassement_brut,
        SUM(prs_rem_bse) AS base_remboursement_brute,
        SUM(prs_rem_mnt) AS montant_rembourse_brut,

        SUM(flt_act_nbr) AS nombre_actes_prefiltres,
        SUM(flt_act_qte) AS quantite_prestations_prefiltree,
        SUM(flt_pai_mnt) AS montant_depense_prefiltre,
        SUM(flt_dep_mnt) AS montant_depassement_prefiltre,
        SUM(flt_rem_mnt) AS montant_rembourse_prefiltre

    FROM base

    GROUP BY
        periode_traitement,
        region_etablissement_prescripteur,
        categorie_etablissement_prescripteur,
        region_prescripteur,
        nature_activite_prescripteur,
        categorie_prescripteur,
        specialite_medicale_prescripteur,
        statut_juridique_prescripteur)
SELECT
    MD5(CONCAT_WS( '|',
            region_etablissement_prescripteur,
            categorie_etablissement_prescripteur,
            region_prescripteur,
            nature_activite_prescripteur,
            categorie_prescripteur,
            specialite_medicale_prescripteur,
            statut_juridique_prescripteur )) AS profil_prescripteur_id,
    *
FROM agregation;