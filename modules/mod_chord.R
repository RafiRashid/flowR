# Module UI ---------------------------------------------------------------
chordUI <- function(id) {
  ns <- NS(id)
  echarts4rOutput(ns("chord"))
}


# Module Logic ------------------------------------------------------------
chordServer <- function(input, output, session, od_data, hopital, service_origine, service_destination, type_flux, sens){
   
  output$chord <- renderEcharts4r({
    
    # FILTER
    od_data <- od_data %>% filter(hopital == hopital())
    
    # EDGES
    edges <- od_data %>% 
      select(origine,destination) %>% 
      count(origine, destination)
    
    # NODES = Nombres de passages total (entrant et sortant) pour chaque service !
    entrant <- od_data %>% count(destination)
    sortant <- od_data %>% count(origine)
    es_data <- sortant %>% 
      left_join(entrant, by = c("origine"="destination")) %>% 
      replace(is.na(.),0) %>%
      rename(Sortant = n.x, Entrant = n.y) %>%
      mutate(n = Entrant + Sortant)
    
    # Jointure pour avoir le secteur médicale pour la légende
    nodes <- es_data %>%
      left_join(od_data %>% select(destination, secteur_med) %>% unique(), by = c("origine" = "destination")) %>% # car pour joindre le secteur_med, il est lié au Service de destination (l'origine est crée)
      mutate(secteur_med = case_when(origine %in% c("SAU", "SAU (autre établissement)") ~ "Urgences",
                                     origine %in% c("MCO (sauf réa)", "Réa", "SSR", "SLD", "PSY", "HAD") ~ "Mutation / transfert",
                                     origine %in% c("Structure d'hébergement médicosociale", "Domicile", "Naissance") ~ "Autres",
                                     TRUE ~ secteur_med)) %>%
      drop_na()
    
    # Filtre
    edges <- edges %>% filter(origine %in% service_origine(), destination %in% service_destination())
    nodes <- nodes %>% filter(origine %in% service_origine() |  origine %in% service_destination())
    
    # Sens
    if(sens() == TRUE){
      
      edges <- edges %>% 
        group_by(grp = paste(pmax(origine, destination), pmin(origine, destination), sep = "_")) %>%
        slice(1) %>% # on enlève la 1ère ligne des 2 flux possibles
        ungroup()
      
      #nodes <- nodes %>% mutate(n=Sortant)
      
    } else{
      
      edges <- edges %>% 
        group_by(grp = paste(pmax(origine, destination), pmin(origine, destination), sep = "_")) %>%
        slice(2) %>% # on enlève la 2ème ligne des 2 flux possibles
        ungroup()
      
      #nodes <- nodes %>% mutate(n=Entrant)
    }
    
    
    # Rendre les nodes et edges proportionnelles aux volumes (interractivement)
    if(type_flux() == "Ensemble des flux"){
      edges <- edges %>% mutate(size = 1)
      nodes <- nodes %>% mutate(size = 10)
    } else{
      edges <- edges %>% mutate(size = round(n/sum(n),2)*100)
      nodes <- nodes %>% mutate(size = 10 + round(n/sum(n),2)*100)
    }
    
    # PLOT
    e_charts() %>% 
      e_graph(
        layout = "circular", 
        circular = list(
          rotateLabel = TRUE
        ),
        #symbol = "arrow",
        roam = TRUE,
        lineStyle = list(
          color = "source",
          type = "solid",
          curveness = 0.3
        ),
        emphasis = list(
          focus = "adjacency"
        ),
        label = list(
          position = "right",
          formatter = "{b}"
        )
      ) %>%
      e_graph_nodes(
        nodes = nodes, 
        names = origine, 
        value = n, 
        size = size,
        category = secteur_med
      ) %>%
      e_graph_edges(
        edges = edges, 
        source = origine,
        target = destination,
        value = n,
        size = size
      ) %>%
      e_tooltip() %>%
      e_color(color = c("#e01f54",
                        "#001852",
                        "#f5e8c8",
                        "#b8d2c7",
                        "#c6b38e",
                        "#a4d8c2",
                        "#f3d999",
                        "#d3758f",
                        "#dcc392",
                        "#2e4783",
                        "#82b6e9",
                        "#ff6347",
                        "#a092f1"))
    
  })
  
  
}