SELECT COUNT(*) AS nombre_lignes,
    COUNT(DISTINCT pre_ins_reg) AS regions_prescripteur,
    COUNT(DISTINCT psp_act_snds) AS activites_prescripteur,
    COUNT(DISTINCT psp_act_cat) AS categories_prescripteur,
    COUNT(DISTINCT psp_spe_snds) AS specialites_prescripteur,
    COUNT(DISTINCT psp_stj_snds) AS statuts_prescripteur,

    COUNT(DISTINCT (
            pre_ins_reg,
            psp_act_snds,
            psp_act_cat,
            psp_spe_snds,
            psp_stj_snds
        )) AS nombre_profils_prescripteurs,

    SUM(flt_act_nbr) AS nombre_actes,
    SUM(flt_act_qte) AS quantite_prestations,
    SUM(flt_pai_mnt) AS montant_depense,
    SUM(flt_rem_mnt) AS montant_rembourse
FROM staging_open_damir;