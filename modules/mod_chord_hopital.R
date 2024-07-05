# Module UI ---------------------------------------------------------------
chordHopitalUI <- function(id) {
  ns <- NS(id)
  echarts4rOutput(ns("chordhopital"))
}


# Module Logic ------------------------------------------------------------
chordHopitalServer <- function(input, output, session, od_data, sens){
   
  output$chordhopital <- renderEcharts4r({
    
    # EDGES
    edges <- od_data %>% 
      select(origine,destination) %>% 
      count(origine, destination) %>% 
      mutate(size = 5)
    
    # NODES = Nombres de passages total (entrant et sortant)
    entrant <- od_data %>% count(destination)
    sortant <- od_data %>% count(origine)
    es_data <- sortant %>% 
      left_join(entrant, by = c("origine"="destination")) %>% 
      replace(is.na(.),0) %>%
      rename(Sortant = n.x, Entrant = n.y) %>%
      mutate(n = Entrant + Sortant)
    
    nodes <- es_data %>%
      mutate(size = 50) %>%
      drop_na()
    
    # Sens
    if(sens() == TRUE){
      edges <- edges %>% 
        group_by(grp = paste(pmax(origine, destination), pmin(origine, destination), sep = "_")) %>%
        slice(1) %>% # on enlève la 1ère ligne des 2 flux possibles
        ungroup()
    } else{
      edges <- edges %>% 
        group_by(grp = paste(pmax(origine, destination), pmin(origine, destination), sep = "_")) %>%
        slice(2) %>% # on enlève la 2ème ligne des 2 flux possibles
        ungroup()
    }
    
    # Rendre les edges proportionnelles aux volumes (interractivement)
    edges <- edges %>% mutate(size = 5 + round(n/sum(n),2)*100)
    
    # PLOT
    e_charts() %>% 
      e_graph(
        layout = "circular", 
        circular = list(
          rotateLabel = FALSE
        ),
        symbol = "image://https://cdn-icons-png.flaticon.com/512/33/33777.png",
        roam = TRUE,
        lineStyle = list(
          color = "#001852",
          type = "solid",
          curveness = 0.3
        ),
        emphasis = list(
          focus = "adjacency"
        ),
        label = list(
          show = TRUE,
          position = "bottom",
          formatter = "{b}"
        )
      ) %>%
      e_graph_nodes(
        nodes = nodes, 
        names = origine, 
        value = n, 
        size = size
      ) %>%
      e_graph_edges(
        edges = edges, 
        source = origine,
        target = destination,
        value = n,
        size = size
      ) %>%
      e_tooltip()
    
  })
  
  
}