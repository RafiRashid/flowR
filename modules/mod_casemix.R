# Module UI ---------------------------------------------------------------
casemixUI <- function(id) {
  ns <- NS(id)

  navset_card_underline(
    title = "Tables des structures",
    nav_panel("Services", reactableOutput(ns("structure"))),
    nav_panel("GHM", reactableOutput(ns("ghm"))),
    nav_panel("CIM", reactableOutput(ns("cim"))),
    nav_panel("CCAM", reactableOutput(ns("ccam"))),
    nav_panel("TarifGHS", reactableOutput(ns("tarifghs"))),
    nav_panel("TarifSUPP", reactableOutput(ns("tarifsupp")))
  )
}

# Module Logic ------------------------------------------------------------
casemixServer <- function(input, output, session){
  
  output$structure <- renderReactable({
    
    dropdown %>% 
      reactable( 
        columns = list(
          hopital = colDef(name = "Hôpital"),
          secteur_med = colDef(name = "Secteur"),
          ServiceGroup = colDef(name = "Service"),
          umaGroup = colDef(name = "UMA")),
        searchable = TRUE,
        filterable = TRUE,
        highlight = TRUE,
        defaultPageSize = 15,
        showPageSizeOptions = TRUE, 
        pageSizeOptions = c(5, 10, 15)
      )
  })
  
  output$ghm <- renderReactable({
    
    ghm %>% 
      unite(GHM, c(ghm,ghm_lib), sep = " - ") %>% 
      unite(DA, c(da,da_lib), sep = " - ") %>%
      unite(GP, c(gp,gp_lib), sep = " - ") %>% 
      unite(GA, c(ga,ga_lib), sep = " - ") %>% 
      select(GHM, DA, GP, GA) %>% 
      reactable( 
        columns = list(
        GHM = colDef(name = "GHM"),
        DA = colDef(name = "Domaine d'activité"),
        GP = colDef(name = "Groupe de planification"),
        GA = colDef(name = "Groupe d'activité")),
        searchable = TRUE,
        filterable = TRUE,
        highlight = TRUE,
        defaultPageSize = 15,
        showPageSizeOptions = TRUE, 
        pageSizeOptions = c(5, 10, 15)
      )
  })
  
  output$cim <- renderReactable({
    
    cim %>% 
      select(cim_code, cim_lib, cim_categorie, cim_groupe) %>% 
      reactable( 
        columns = list(
          cim_code = colDef(name = "Code"),
          cim_lib = colDef(name = "Libellé"),
          cim_categorie = colDef(name = "Catégorie"),
          cim_groupe = colDef(name = "Groupe")),
        searchable = TRUE,
        filterable = TRUE,
        highlight = TRUE,
        defaultPageSize = 15,
        showPageSizeOptions = TRUE, 
        pageSizeOptions = c(5, 10, 15)
      )
  })
  
  output$ccam <- renderReactable({
    
    ccam %>% 
      select(ccam_pmsi_code, 
             ccam_pmsi_lib, 
             ccam_pmsi_chapitre_lib, 
             ccam_pmsi_sous_chapitre_lib,
             ccam_pmsi_paragraphe_lib,
             ccam_pmsi_sous_paragraphe_lib,
             ccam_pmsi_classant,
             ccam_pmsi_debut_validite,
             ccam_pmsi_fin_validite) %>% 
      reactable( 
        columns = list(
          ccam_pmsi_code = colDef(name = "Code"), 
          ccam_pmsi_lib = colDef(name = "Libellé"), 
          ccam_pmsi_chapitre_lib = colDef(name = "Chapitre"), 
          ccam_pmsi_sous_chapitre_lib = colDef(name = "Sous-chapitre"),
          ccam_pmsi_paragraphe_lib = colDef(name = "Paragraphe"),
          ccam_pmsi_sous_paragraphe_lib = colDef(name = "Sous-paragraphe"),
          ccam_pmsi_classant = colDef(name = "Classant"),
          ccam_pmsi_debut_validite = colDef(name = "Début validité"),
          ccam_pmsi_fin_validite = colDef(name = "Fin validité")),
        searchable = TRUE,
        filterable = TRUE,
        highlight = TRUE,
        defaultPageSize = 15,
        showPageSizeOptions = TRUE, 
        pageSizeOptions = c(5, 10, 15)
      )
  })
  
  output$tarifghs <- renderReactable({
    
    tarifs_mco_ghs %>% 
      select(-time_i) %>% 
      reactable( 
        columns = list(
          ghs = colDef(name = "GHS"),
          ghm = colDef(name = "GHM"),
          libelle_ghm = colDef(name = "Libellé GHM"),
          borne_basse = colDef(name = "Borne basse"),
          borne_haute = colDef(name = "Borne haute"),
          tarif_base = colDef(name = "Tarif base", format = colFormat(currency = "EUR", separators = TRUE, locales = "fr-FR")),
          forfait_exb = colDef(name = "Forfait EXB", format = colFormat(currency = "EUR", separators = TRUE, locales = "fr-FR")),
          tarif_exb = colDef(name = "Tarif EXB", format = colFormat(currency = "EUR", separators = TRUE, locales = "fr-FR")),
          tarif_exh = colDef(name = "Tarif EXH", format = colFormat(currency = "EUR", separators = TRUE, locales = "fr-FR")),
          date_effet = colDef(name = "Date effet"),
          anseqta = colDef(name = "Année séquentielle")),
        searchable = TRUE,
        filterable = TRUE,
        highlight = TRUE,
        defaultPageSize = 15,
        showPageSizeOptions = TRUE, 
        pageSizeOptions = c(5, 10, 15)
      )
  })
  
  output$tarifsupp <- renderReactable({
    
    tarifs_mco_supplements %>% 
      reactable( 
        columns = list(
          anseqta = colDef(name = "Année séquentielle"),
          Supplément = colDef(name = "Supplément"),
          Tarif = colDef(name = "Tarif", format = colFormat(currency = "EUR", separators = TRUE, locales = "fr-FR"))),
        searchable = TRUE,
        filterable = TRUE,
        highlight = TRUE,
        defaultPageSize = 15,
        showPageSizeOptions = TRUE, 
        pageSizeOptions = c(5, 10, 15)
      )
  })
}