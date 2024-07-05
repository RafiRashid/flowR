ui <- page_navbar(
  
  # TITRE ET THEME -----------------------
  title = HTML('<img src="flowr_logo.png" width="200px" height="60px">'),
  window_title = "FlowR",
  theme = bs_theme() %>%
    bs_add_rules(sass::sass_file("www/style.scss")),
  footer = includeHTML("www/footer.html"),
  
  # SIDEBAR -----------------------
  # sidebar = sidebar(
  #   title = "Filtres",
  #   selectInput("hopitalInput", "Selectionner l'hôpital :", choices = unique(dropdown$hopital), selected = "Saint Louis")
  # ),
  
  sidebar = accordion(
    accordion_panel(
      "Filtres", icon = bsicons::bs_icon("sliders"),
      selectInput("hopitalInput", "Selectionner l'hôpital :", choices = unique(dropdown$hopital), selected = "Saint Louis")
    )
  ),
  
  nav_spacer(),
  
  # PAGE FLUX SERVICE -----------------------
  nav_panel("Flux service",

            card(
              full_screen = TRUE,
              card_header(
                "Chord Diagram", 
                class = "bg-light d-flex align-items-center gap-1",
                tooltip(
                  bsicons::bs_icon("question-circle"),
                  tags$div(tags$p("Une couleur représente un secteur médical."),
                           
                           tags$p("Un noeud représente un service."),
                           
                           tags$p("Un secteur regroupe plusieurs services."),

                           tags$p("Une liaison représente un flux entre 2 services avec un nombre de passages n."),

                           tags$p("Il est possible de choisir explicitement les services d'origine et de destination pour visualiser les flux (si ils existent !)."),

                           tags$p("Le sens du flux peut être choisi (si le flux existe). Par exemple, le flux SAU > UHCD existe mais le flux UHCD > SAU n'existe pas."),

                           tags$p("En type 'Flux principaux', la taille des noeuds et des flux sont proportionnels en volumes."),

                  ),
                  placement = "right"
                ),
                popover(
                  bsicons::bs_icon("gear", class = "ms-auto"),
                  
                  prettyRadioButtons(inputId = "typeflux", 
                                     label = "Type de flux",
                                     choices = c("Ensemble des flux","Flux principaux"),
                                     selected = "Flux principaux",
                                     status = "info",
                                     animation = "pulse"),
                  
                  virtualSelectInput(inputId = "fluxServiceOrigineInput",
                                     label = "Origine",
                                     choices = prepare_choices(.data = dropdownOrigineFlux,
                                                               label = origine,
                                                               value = origine,
                                                               group_by = secteur_med,
                                                               description = hopital),
                                     selected = unique(dropdownOrigineFlux$origine),
                                     multiple = TRUE,
                                     search = TRUE,
                                     hasOptionDescription = TRUE,
                                     placeholder = "Sélectionner...",
                                     searchPlaceholderText = "Rechercher...",
                                     noSearchResultsText = "Aucun service trouvé",
                                     noOptionsText = "Aucun service",
                                     optionsSelectedText = "service sélectionné",
                                     width = "100%"),
                  
                  virtualSelectInput(inputId = "fluxServiceDestinationInput",
                                     label = "Destination",
                                     choices = prepare_choices(.data = dropdownDestinationFlux,
                                                               label = destination,
                                                               value = destination,
                                                               group_by = secteur_med,
                                                               description = hopital),
                                     selected = unique(dropdownDestinationFlux$destination),
                                     multiple = TRUE,
                                     search = TRUE,
                                     hasOptionDescription = TRUE,
                                     placeholder = "Sélectionner...",
                                     searchPlaceholderText = "Rechercher...",
                                     noSearchResultsText = "Aucun service trouvé",
                                     noOptionsText = "Aucun service",
                                     optionsSelectedText = "service sélectionné",
                                     width = "100%"),
                  "Sens",
                  switchInput(inputId = "sensInput",
                              onLabel = "⬅",
                              offLabel = "➡",
                              label = " ",
                              value = TRUE),
                  
                  title = "Options graphiques"
                )
              ),
              chordUI("fluxService")
            )
  ),
  
  # PAGE FLUX HOPITAL -----------------------
  nav_panel("Flux hôpital",

            card(
              full_screen = TRUE,
              card_header(
                "Chord Diagram Hospital", 
                class = "bg-light d-flex align-items-center gap-1",
                tooltip(
                  bsicons::bs_icon("question-circle"),
                  tags$div(tags$p("La question est : combien de patient s'échangent les différents sites ?"),
                           
                           tags$p("Chaque IPP a exactement 1 séjour dans chaque hôpital sur la même année."),
                           
                           tags$p("Les dates de sortie et d'entrée se juxtaposent : date de sortie du séjour dans l'hôpital 1 = date d'entrée du séjour dans l'hôpital 2."),
                           
                  ),
                  placement = "right"
                ),
                popover(
                  bsicons::bs_icon("gear", class = "ms-auto"),
                  "Sens",
                  switchInput(inputId = "sensHopitalInput",
                              onLabel = "⬅",
                              offLabel = "➡",
                              label = " ",
                              value = TRUE),
                  
                  title = "Options graphiques"
                )
              ),
              chordHopitalUI("fluxHopital")
            )
  ),
  
  # AUTRES PAGES -----------------------
  nav_panel("Structures",
            
            casemixUI("casemix")
  ),
  
  nav_spacer(),
  nav_item(actionBttn("show","", style = "material-circle", color = "primary", size = "xs", icon = bsicons::bs_icon("info")))
)
