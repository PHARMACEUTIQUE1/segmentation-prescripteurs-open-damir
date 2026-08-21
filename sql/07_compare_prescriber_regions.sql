SELECT
    COUNT(*) AS nombre_lignes,
    COUNT(DISTINCT etp_reg_cod) AS regions_etablissement,
    COUNT(DISTINCT pre_ins_reg) AS regions_prescripteur,
    COUNT(*) FILTER ( WHERE etp_reg_cod <> pre_ins_reg) AS lignes_regions_differentes,

    ROUND(100.0 * COUNT(*) FILTER (  WHERE etp_reg_cod <> pre_ins_reg) / COUNT(*),2
    ) AS pourcentage_regions_differentes,

    COUNT(
        DISTINCT (
            etp_reg_cod,
            etp_cat_snds,
            pre_ins_reg,
            psp_act_snds,
            psp_act_cat,
            psp_spe_snds,
            psp_stj_snds
        )
    ) AS profils_avec_etablissement

FROM staging_open_damir;