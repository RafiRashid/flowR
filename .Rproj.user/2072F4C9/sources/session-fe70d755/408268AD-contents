server <- function(input, output){
  
  # MODAL -----------------------------------------------------------------------------------------------------------------
  
  observeEvent(input$show, {
    showModal(modalDialog(

      h4("A propos"),
      hr(),
      "L'objectif de l'application est de visualiser les flux de patients en milieu hospitalier entre les différents services, mais aussi entre les différents hopitaux du GHU Nord.",
      br(),br(),br(),
      h4("Données"),
      hr(),
      "Données obtenus par traitement des données PMSI (séjours et passages hospitaliers) en flux origine / destination. Il n'y a aucune information identifiante (nom, prenom, date de naissance) après traitement.",
      footer = list("Developed with 💕", nav_spacer(), modalButton("Close"))
      
    ))
  })
  
  # UPDATE VIRTUAL SELECT DROPDOWNS ---------------------------------------------------------------------------------------
  
  output$updateDropdownOrigine <- renderPrint(input$fluxServiceOrigineInput)
  observe({
    updateVirtualSelect(inputId = "fluxServiceOrigineInput",
                        choices = prepare_choices(.data = filter(dropdownOrigineFlux, hopital == input$hopitalInput),
                                                  label = origine,
                                                  value = origine,
                                                  group_by = secteur_med,
                                                  description = hopital),
                        selected = unique(filter(dropdownOrigineFlux, hopital == input$hopitalInput)$origine))
  })
  
  output$updateDropdownDestination <- renderPrint(input$fluxServiceDestinationInput)
  observe({
    updateVirtualSelect(inputId = "fluxServiceDestinationInput",
                        choices = prepare_choices(.data = filter(dropdownDestinationFlux, hopital == input$hopitalInput),
                                                  label = destination,
                                                  value = destination,
                                                  group_by = secteur_med,
                                                  description = hopital),
                        selected = unique(filter(dropdownDestinationFlux, hopital == input$hopitalInput)$destination))
  })
  
  # MODULES ---------------------------------------------------------------------------------------------------------------
 
  callModule(module = chordServer, 
             id = "fluxService", 
             od_data = od_data, 
             hopital = reactive(input$hopitalInput), 
             service_origine = reactive(input$fluxServiceOrigineInput), 
             service_destination = reactive(input$fluxServiceDestinationInput), 
             type_flux = reactive(input$typeflux), 
             sens = reactive(input$sensInput))
  
  callModule(module = chordHopitalServer, 
             id = "fluxHopital", 
             od_data = od_data_hopitaux, 
             sens = reactive(input$sensHopitalInput))
  

  callModule(module = casemixServer, 
             id = "casemix")
  
}
