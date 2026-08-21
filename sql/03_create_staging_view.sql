-- ============================================================================
        -- Couche staging Open DAMIR
        -- Nettoyage des textes, normalisation des noms et conversion des types
-- ============================================================================

CREATE OR REPLACE VIEW staging_open_damir AS

SELECT TRY_CAST(NULLIF(TRIM(FLX_ANN_MOI), '') AS INTEGER) AS flx_ann_moi,

    NULLIF(TRIM(ORG_CLE_REG), '') AS org_cle_reg,
    NULLIF(TRIM(AGE_BEN_SNDS), '') AS age_ben_snds,
    NULLIF(TRIM(BEN_RES_REG), '') AS ben_res_reg,
    NULLIF(TRIM(BEN_CMU_TOP), '') AS ben_cmu_top,
    NULLIF(TRIM(BEN_QLT_COD), '') AS ben_qlt_cod,
    NULLIF(TRIM(BEN_SEX_COD), '') AS ben_sex_cod,
    NULLIF(TRIM(DDP_SPE_COD), '') AS ddp_spe_cod,
    NULLIF(TRIM(ETE_CAT_SNDS), '') AS ete_cat_snds,
    NULLIF(TRIM(ETE_REG_COD), '') AS ete_reg_cod,
    NULLIF(TRIM(ETE_TYP_SNDS), '') AS ete_typ_snds,
    NULLIF(TRIM(ETP_REG_COD), '') AS etp_reg_cod,
    NULLIF(TRIM(ETP_CAT_SNDS), '') AS etp_cat_snds,
    NULLIF(TRIM(MDT_TYP_COD), '') AS mdt_typ_cod,
    NULLIF(TRIM(MFT_COD), '') AS mft_cod,
    NULLIF(TRIM(PRS_FJH_TYP), '') AS prs_fjh_typ,

    TRY_CAST(REPLACE(NULLIF(TRIM(PRS_ACT_COG), ''), ',', '.') AS DOUBLE) AS prs_act_cog,
    TRY_CAST(REPLACE(NULLIF(TRIM(PRS_ACT_NBR), ''), ',', '.') AS DOUBLE) AS prs_act_nbr,
    TRY_CAST(REPLACE(NULLIF(TRIM(PRS_ACT_QTE), ''), ',', '.') AS DOUBLE) AS prs_act_qte,
    TRY_CAST(REPLACE(NULLIF(TRIM(PRS_DEP_MNT), ''), ',', '.') AS DOUBLE) AS prs_dep_mnt,
    TRY_CAST(REPLACE(NULLIF(TRIM(PRS_PAI_MNT), ''), ',', '.') AS DOUBLE) AS prs_pai_mnt,
    TRY_CAST(REPLACE(NULLIF(TRIM(PRS_REM_BSE), ''), ',', '.') AS DOUBLE) AS prs_rem_bse,
    TRY_CAST(REPLACE(NULLIF(TRIM(PRS_REM_MNT), ''), ',', '.') AS DOUBLE) AS prs_rem_mnt,

    TRY_CAST(REPLACE(NULLIF(TRIM(FLT_ACT_COG), ''), ',', '.') AS DOUBLE) AS flt_act_cog,
    TRY_CAST(REPLACE(NULLIF(TRIM(FLT_ACT_NBR), ''), ',', '.') AS DOUBLE) AS flt_act_nbr,
    TRY_CAST(REPLACE(NULLIF(TRIM(FLT_ACT_QTE), ''), ',', '.') AS DOUBLE) AS flt_act_qte,
    TRY_CAST(REPLACE(NULLIF(TRIM(FLT_PAI_MNT), ''), ',', '.') AS DOUBLE) AS flt_pai_mnt,
    TRY_CAST(REPLACE(NULLIF(TRIM(FLT_DEP_MNT), ''), ',', '.') AS DOUBLE) AS flt_dep_mnt,
    TRY_CAST(REPLACE(NULLIF(TRIM(FLT_REM_MNT), ''), ',', '.') AS DOUBLE) AS flt_rem_mnt,

    TRY_CAST(NULLIF(TRIM(SOI_ANN), '') AS INTEGER) AS soi_ann,
    TRY_CAST(NULLIF(TRIM(SOI_MOI), '') AS INTEGER) AS soi_moi,

    NULLIF(TRIM(ASU_NAT), '') AS asu_nat,
    NULLIF(TRIM(ATT_NAT), '') AS att_nat,
    NULLIF(TRIM(CPL_COD), '') AS cpl_cod,
    NULLIF(TRIM(CPT_ENV_TYP), '') AS cpt_env_typ,
    NULLIF(TRIM(DRG_AFF_NAT), '') AS drg_aff_nat,
    NULLIF(TRIM(ETE_IND_TAA), '') AS ete_ind_taa,
    NULLIF(TRIM(EXO_MTF), '') AS exo_mtf,
    NULLIF(TRIM(MTM_NAT), '') AS mtm_nat,
    NULLIF(TRIM(PRS_NAT), '') AS prs_nat,
    NULLIF(TRIM(PRS_PPU_SEC), '') AS prs_ppu_sec,

    TRY_CAST(REPLACE(NULLIF(TRIM(PRS_REM_TAU), ''), ',', '.') AS DOUBLE) AS prs_rem_tau,

    NULLIF(TRIM(PRS_REM_TYP), '') AS prs_rem_typ,
    NULLIF(TRIM(PRS_PDS_QCP), '') AS prs_pds_qcp,
    NULLIF(TRIM(EXE_INS_REG), '') AS exe_ins_reg,
    NULLIF(TRIM(PSE_ACT_SNDS), '') AS pse_act_snds,
    NULLIF(TRIM(PSE_ACT_CAT), '') AS pse_act_cat,
    NULLIF(TRIM(PSE_SPE_SNDS), '') AS pse_spe_snds,
    NULLIF(TRIM(PSE_STJ_SNDS), '') AS pse_stj_snds,
    NULLIF(TRIM(PRE_INS_REG), '') AS pre_ins_reg,
    NULLIF(TRIM(PSP_ACT_SNDS), '') AS psp_act_snds,
    NULLIF(TRIM(PSP_ACT_CAT), '') AS psp_act_cat,
    NULLIF(TRIM(PSP_SPE_SNDS), '') AS psp_spe_snds,
    NULLIF(TRIM(PSP_STJ_SNDS), '') AS psp_stj_snds,
    NULLIF(TRIM(TOP_PS5_TRG), '') AS top_ps5_trg,
    NULLIF(TRIM(ETB_DCS_MCO), '') AS etb_dcs_mco,
    source_file

FROM raw_open_damir;