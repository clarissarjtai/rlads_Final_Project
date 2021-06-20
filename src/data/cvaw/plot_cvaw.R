library(tibble)
library(dplyr)
library(ggplot2)

## 台股
# 大盤
TAIEX_COVID_df <- as_tibble(readr::read_csv("TAIEX-COVID.csv")) %>%
    rename(Date = X1) %>%
    mutate(Date = as.Date(Date)) %>%
    filter(between(Date, as.Date("2021-04-01"), as.Date("2021-05-31")))
# 類股
TAIEX_df <- as_tibble(readr::read_csv("TAIEX.csv")) %>%
    select(-X1) %>%
    mutate(Date = as.Date(Date)) %>%
    filter(between(Date, as.Date("2021-04-01"), as.Date("2021-05-31")))
# 類股變動率
TAIEX_ROC_df <- as_tibble(readr::read_csv("TAIEX_ROC.csv")) %>%
    select(-X1) %>%
    mutate(Date = as.Date(Date)) %>%
    filter(between(Date, as.Date("2021-04-01"), as.Date("2021-05-31")))


## 選擇時間範圍、計算加權分數
# covid板
plt_df_cwaw_covid <- as_tibble(readr::read_csv("cvaw_covid.csv")) %>%
    mutate(Date = as.Date(Date)) %>%
    filter(between(Date, as.Date("2021-04-01"), as.Date("2021-05-31"))) %>%
    mutate(score_sum = round(Valence_Sum * (Arousal_Sum + words_Num * 5), 6), 
           score_avg = if_else(score_sum == 0, 0, round(score_sum / ((words_Num)** 2), 6)))

# stock板
plt_df_cwaw_stock <- as_tibble(readr::read_csv("cvaw_stock.csv")) %>%
    mutate(Date = as.Date(Date)) %>%
    filter(between(Date, as.Date("2021-04-01"), as.Date("2021-05-31"))) %>%
    mutate(score_sum = round(Valence_Sum * (Arousal_Sum + words_Num * 5), 6), 
           score_avg = if_else(score_sum == 0, 0, round(score_sum / ((words_Num)** 2), 6)))

## 做每日平均分數
# covid板
group_plt_df_cvaw_covid <- plt_df_cwaw_covid %>%
    group_by(Date) %>%
    summarise(score_sum_date = mean(score_sum), score_avg_date = mean(score_avg)) %>%
    ungroup()

# stock板
group_plt_df_cvaw_stock <- plt_df_cwaw_stock %>%
    group_by(Date) %>%
    summarise(score_sum_date = mean(score_sum), score_avg_date = mean(score_avg)) %>%
    ungroup()
    
ggplot(data = plt_df_cwaw_covid)+
    geom_point(aes(x = Valence_Avg, y = Arousal_Avg, color = Date), size = 0.1)

ggplot(data = plt_df_cwaw_covid)+
    geom_point(aes(x = Valence_Sum, y = Arousal_Sum, color = Date), size = 0.1)

# covid-19板
ggplot()+
    geom_hline(yintercept = 0) +
    geom_point(data = plt_df_cwaw_covid, aes(x = Date, y = score_avg), color = ifelse(plt_df_cwaw_covid$score_avg >= 0, "pink", "lightgreen"), size = 1)+
    geom_point(data = group_plt_df_cvaw_covid, aes(x = Date, y = score_avg_date), 
               color = ifelse(TAIEX_COVID_df$大盤變動率 >= 0, "red", "darkgreen"), 
               size = abs(TAIEX_COVID_df$大盤變動率) * 100) + 
    geom_line(data = group_plt_df_cvaw_covid, aes(x = Date, y = score_avg_date), color = "red") + 
    theme_bw() + 
    labs(title = "sentiment analysis in ptt covid-19")

# stock板
ggplot()+
    geom_hline(yintercept = 0) +
    geom_point(data = plt_df_cwaw_stock, aes(x = Date, y = score_avg), color = ifelse(plt_df_cwaw_stock$score_avg >= 0, "pink", "lightgreen"), size = 1)+
    geom_point(data = group_plt_df_cvaw_stock, aes(x = Date, y = score_avg_date), 
               color = ifelse(TAIEX_ROC_df$觀光 >= 0, "red", "darkgreen"), 
               size = abs(TAIEX_ROC_df$觀光) * 100) + 
    geom_line(data = group_plt_df_cvaw_stock, aes(x = Date, y = score_avg_date), color = "red") + 
    theme_bw() + 
    labs(title = "sentiment analysis in ptt stock")    
