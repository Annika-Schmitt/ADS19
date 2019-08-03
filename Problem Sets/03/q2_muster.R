require(jsonlite)
require(tidyverse)
require(tidygraph)
require(ggraph)

if (!file.exists("clinton_emails.rda")) {
  clinton_emails <- fromJSON("http://graphics.wsj.com/hillary-clinton-email-documents/api/search.php?subject=&text=&to=&from=&start=&end=&sort=docDate&order=desc&docid=&limit=27159&offset=0")$rows
  save(clinton_emails, file="clinton_emails.rda")
}

load("clinton_emails.rda")

clinton_emails %>% 
  mutate(from=trimws(from),
         to=trimws(to)) %>% 
  filter(from != "") %>% 
  filter(to != "") %>% 
  filter(!grepl(";", from)) %>% 
  filter(!grepl(";", to)) -> clinton_emails


# a)
clinton_emails %>%
  as_tbl_graph(directed = FALSE) %>%
  ggraph() + geom_node_point() + 
  geom_edge_link(width = 1, alpha = 0.1) + 
  geom_node_text(aes(label = name)) 
  
  
# b)
clinton_emails %>%
  filter(from == "Hillary Clinton" | to == "Hillary Clinton") -> clinton_emails

clinton_emails %>%
  as_tbl_graph(directed = FALSE) %>%
  ggraph() + 
  geom_edge_link(width = 1, alpha = 0.1) + 
  geom_node_point() +
  geom_node_text(aes(label = name)) 


# c)
clinton_emails %>%
  as_tbl_graph(directed = FALSE) %>%
  mutate(centrality = centrality_degree()) -> emailGraph

emailGraph %>%  
  ggraph() + 
  geom_edge_link(width = 1, alpha = 0.1) + 
  geom_node_point(aes(size = log(centrality))) +
  geom_node_label(aes(filter=centrality>=500, label=name), repel = TRUE)

# d)
clinton_emails %>%
  group_by(to, from) %>%
  summarise(count = n()) %>%
  mutate(contact = if_else(to == "Hillary Clinton", from, to)) %>%
  arrange(desc(count)) -> contacts

clinton_emails %>%
  mutate(contact = if_else(to == "Hillary Clinton", from, to)) %>%
  left_join(contacts) %>%
  as_tbl_graph(directed = FALSE) %>%
  mutate(centrality = centrality_degree()) %>%
  activate(edges) %>% 
  filter(!edge_is_multiple()) -> emailGraph

emailGraph %>%  
  ggraph() + 
  geom_edge_link(aes(width = log(count)), alpha = 0.2, show.legend = FALSE) + 
  geom_node_point(aes(size = log(centrality)), show.legend = FALSE) +
  geom_node_label(aes(filter=centrality>=500, label=name), 
                  repel = TRUE, show.legend = FALSE) +
  theme_graph()
