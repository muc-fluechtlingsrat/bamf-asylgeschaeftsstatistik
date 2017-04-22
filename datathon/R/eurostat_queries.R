#' get eurostat data
#'
#' @param term A search term to get list of tables.
#' @param y A number.
#' @return Clean table in long format.
#' @examples
#' es_query()
#' add(10, 1)
#'
#' @include tidyr
#' @include dplyr
#' @include magrittr
#' @include ggplot2
#' @include eurostat
#' @include gridExtra
#' @include lubridate

cleaned_data <- function(term = "asylum") {
  datasets <- search_eurostat(term, type = "dataset")
  data <- get_eurostat("migr_asyappctza", time_format = "date") %>% label_eurostat()
  t <- data %>% filter(geo == "Germany (until 1990 former territory of the FRG)",
                       citizen == "Total",
                       age == "Total",
                       asyl_app == "First time applicant")
  t %<>% group_by(time, sex) %>% summarise(value = sum(values)) %>% arrange(sex, time) %>%
    spread(sex, value) %>% mutate(male = male / Total)
  ggplot(t, aes(x = time, y = value / t$Total, color = sex)) + geom_line()
}

load_data <- function() {
  datasets <- search_eurostat("asylum", type = "dataset")
  get_eurostat("migr_asyappctza", time_format = "date") %>% label_eurostat() %>% return()
}

load_data_acceptance <- function() {
  get_eurostat("migr_asydcfstq", time_format = "date") %>% label_eurostat() %>%
    mutate(decision = ifelse(decision == "Total positive decisions",
                             "Total_positive_decisions",
                             decision)) %>%
    filter(citizen != "Extra-EU-28")
    return()
}


filter_destination_country <- function(data, countries = c("Germany (until 1990 former territory of the FRG)")) {
  data$citizen[data$citizen == "Kosovo (under United Nations Security Council Resolution 1244/99)"] <- "Kosovo"
  data$citizen[data$citizen == "Former Yugoslav Republic of Macedonia, the"] <- "Macedonia"

  data %>%
    filter(geo %in% countries) %>%
    select(-unit, -geo) %>%
    filter(citizen != "Extra-EU-28") %>%
    return
}


plot_by_c_of_origin_sex <- function(data, year_of_interest, top = 20) {
  data %<>%
    filter(age == "Total",
           #sex == "Total",
           asyl_app == "First time applicant",
           citizen != "Total") %>%
    group_by(citizen, sex, time) %>%
    summarise(value = sum(values)) %>%
    ungroup() %>%
    arrange(citizen, time, desc(value)) %>%
    filter(., year(.$time) == year_of_interest)
  a <- (data %>% filter(sex == "Total") %>%
          arrange(desc(value)) %>%
          head(20) %>%
          getElement("citizen"))
  data %>%
    filter(citizen %in% a) %>%
    filter(!(sex %in% c("Total", "Unknown"))) %>%
    ggplot(aes(reorder(citizen, -value), value, fill = sex)) + geom_bar(stat = "identity", position = "stack") + theme(axis.text.x = element_text(angle = 90, hjust = 1))

  p1 <-
    data %>%
    filter(citizen %in% a) %>%
    filter(!(sex %in% c("Total"))) %>%
    group_by(citizen) %>%
    summarise(value = sum(value)) %>%
    ggplot(aes(reorder(citizen, -value), value)) +
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))

  p2 <-
    data %>%
    filter(citizen %in% a) %>%
    filter(!(sex %in% c("Total"))) %>%
    spread(sex, value) %>%
    mutate(Totals = Males + Females) %>%
    mutate(Females = Females/Totals, Males = Males/Totals) %>%
    gather(sex, values, -citizen, -time, -Totals) %>%
    filter(sex != "Totals") %>%
    ggplot(aes(reorder(citizen, -Totals), values, fill = sex)) +
    geom_bar(stat = "identity", position = "Stack") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))

  grid.arrange(p1, p2, ncol = 1)

}

plot_acc_by_c_of_origin <- function(data, year_of_interest, top = 20) {
  data %<>%
    mutate(decision = ifelse(decision == "Total positive decisions",
                             "Total_positive_decisions",
                             decision)) %>%
    filter(age == "Total",
           #sex == "Total",
           decision %in% c("Rejected", "Total_positive_decisions", "Total"),
           citizen != "Total") %>%
    group_by(citizen, decision, time) %>%
    summarise(value = sum(values)) %>%
    ungroup() %>%
    arrange(citizen, time, desc(value)) %>%
    filter(., year(.$time) == year_of_interest)
  a <- (data %>% filter(decision == "Total") %>%
          arrange(desc(value)) %>%
          head(top) %>%
          getElement("citizen"))
  # data %>%
  #   filter(citizen %in% a) %>%
  #   filter(decision %in% c("Rejected", "Total_positive_decision")) %>%
  #   ggplot(aes(reorder(citizen, -value), value, fill = decision)) +
  #   geom_bar(stat = "identity", position = "stack") +
  #   theme(axis.text.x = element_text(angle = 90, hjust = 1))

  p1 <-
    data %>%
    filter(citizen %in% a) %>%
    filter(!(decision %in% c("Total"))) %>%
    group_by(citizen) %>%
    summarise(value = sum(value)) %>%
    ggplot(aes(reorder(citizen, -value), value)) +
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle = 35, hjust = 1))

  p2 <-
    data %>%
    filter(citizen %in% a) %>%
    filter(!(decision %in% c("Total"))) %>%
    spread(decision, value) %>%
    mutate(Totals = Rejected + Total_positive_decisions) %>%
    mutate(Rejected = Rejected / Totals,
           Total_positive_decisions = Total_positive_decisions / Totals) %>%
    gather(decision, values, -citizen, -time, -Totals) %>%
  filter(decision != "Totals") %>%
    ggplot(aes(reorder(citizen, -Totals), values, fill = decision)) +
    geom_bar(stat = "identity", position = "Stack") +
    theme(axis.text.x = element_text(angle = 35, hjust = 1))

  grid.arrange(p1, p2, ncol = 1)

}

