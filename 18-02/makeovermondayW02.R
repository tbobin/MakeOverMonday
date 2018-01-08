

library(tidyverse)
library(data.world)

ds <-  "https://data.world/makeovermonday/2018-w-2-looks-vs-personality"

sql_string <- data.world::qry_sql("Select * from looks_vs_personality")

mm_1802_df <- data.world::query(sql_string, dataset = ds)


x_labels <- mm_1802_df %>% 
  select(rank_number, rank_text) %>% 
  distinct() %>% 
  arrange(rank_number)


brit <- mm_1802_df %>% 
  filter(nationality == "British") %>% 
  mutate(rank_text = factor(rank_text, levels = x_labels$rank_text), gender = factor(gender), question = factor(question))

# order teh questions
brit <- brit %>% 
  group_by(gender, rank_text) %>% 
  mutate(g_rank = min_rank(percentage))

q_order_prep <- brit %>% select(question, gender, rank_text, g_rank) %>% 
  spread(gender, g_rank) %>% 
  ungroup() %>% 
  mutate(question_rank = Men + Women)

q_order <- q_order_prep %>% group_by(rank_text) %>% filter(question_rank == max(question_rank))

q_order_man <- c("They have a personality I like",
                 "They have a sense of humour I like",
                 "They have similar interests to me",
                 "They are intelligent",
                 "They are good looking",
                 "They have/make a decent amount of money")


brit <- brit %>% mutate(question = factor(question, levels = q_order_man, ordered = TRUE)) %>% arrange(question) %>% 
  group_by(question, gender) %>% 
  mutate(cum_percentage = cumsum(percentage)) %>% 
  ungroup()

myplot <- brit %>% ggplot(aes(y = percentage, x = rank_text, fill = gender)) + 
  geom_col(position = "dodge") + 
  geom_hline(aes(yintercept = 0)) +
  geom_line(aes(y = cum_percentage, color = gender, group = gender), size = 0.8, show.legend = T) +
  geom_point(aes(y = cum_percentage, color = gender)) +
  scale_color_manual(values = c(Men = "#5b94ef", Women = "#af0549")) +
  scale_fill_manual(values = c(Men = "#5b94ef", Women = "#af0549")) +
  facet_wrap( ~ question, nrow = 6) +
  #geom_text(aes(label = scales::percent(percentage)), position = position_dodge(0.9), vjust = 0.5, size = 2.5) +
  geom_text(aes(y = cum_percentage + 0.05, label = scales::percent(cum_percentage), color = gender), vjust = 0, size = 3.5, position = position_dodge(0.7)) +
  coord_cartesian(ylim = c(0,1.2))+
  theme_minimal() +
  theme( axis.text.y = element_blank(),
         panel.grid = element_blank(),
         axis.text.x = element_text(angle = 45, hjust = 1),
         legend.position = "bottom",
         legend.title = element_blank()) +
  labs(y = "", 
       title = "Is good looking important to men and money to women?",
       subtitle = 
"Yes - if you look at the individual characteristics then men rate the appearance as more important than women.
For women, money is faster an important characteristic. If you compare both questions, then for both sexes the 
appearance is more important than the partner's money. Both characteristics are most unimportant for both sexes 
compared to the rest of the survey. The most important characteristic is the personality
",
       caption = "SOURCE: @YouGov and provided by @mattsmithetc")

myplot
ggsave("18-02/mm02.png", plot = myplot, device = "png", units = "cm", height = 30, width = 15)


