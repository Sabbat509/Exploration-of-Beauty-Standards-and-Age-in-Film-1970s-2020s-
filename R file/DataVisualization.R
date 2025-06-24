library(dplyr)
library(stringr)
library(readr)

# Read the CSV
df <- read_csv("Actress Appearance Data Collection - Sheet1.csv")

# Define keyword mappings for ethnicity and race
ethnicity_keywords <- list(
  "Hispanic or Latino" = c("cuban", "mexican", "puerto rican", "colombian", "dominican",
                           "brazilian", "portuguese", "spanish", "latina", "latino")
)

race_keywords <- list(
  "American Indian or Alaska Native" = c("cherokee", "indigenous", "native american"),
  "Asian" = c("asian", "indian", "korean", "japanese", "chinese", "filipino", "malaysian", "han"),
  "Black or African American" = c("african", "afro", "african-american", "black", "zulu", "sotho"),
  "Native Hawaiian or Other Pacific Islander" = c("native hawaiian", "samoan", "guamanian", "pacific islander"),
  "White" = c("white", "american", "caucasian", "nordic", "icelandic", "jewish", "english", "german", "germanic",
              "irish", "scottish", "welsh", "french", "italian", "norwegian", "swedish", "dutch", "swiss", 
              "austrian", "polish", "hungarian", "russian", "romanian", "greek", "armenian", "british", "canadian",
              "australian", "slavic", "manx", "scots", "breton", "cornish", "finnish", "kven", "tornedalian", "danish")
)

# Function to categorize race and ethnicity
categorize_race_ethnicity <- function(entry) {
  entry_lower <- ifelse(is.na(entry), "", tolower(entry))
  tokens <- unlist(str_split(entry_lower, "[,\\(\\)/\\- ]+"))
  tokens <- str_trim(tokens[tokens != ""])
  
  ethnicity <- "Not Hispanic or Latino"
  race_category <- "Other"
  ethnic_origins <- character(0)
  
  for (eth_label in names(ethnicity_keywords)) {
    if (any(tokens %in% ethnicity_keywords[[eth_label]])) {
      ethnicity <- eth_label
      break
    }
  }
  
  for (race_label in names(race_keywords)) {
    if (any(tokens %in% race_keywords[[race_label]])) {
      race_category <- race_label
      break
    }
  }
  
  for (token in tokens) {
    for (race_set in race_keywords) {
      if (token %in% race_set && !(token %in% c("white", "caucasian"))) {
        ethnic_origins <- union(ethnic_origins, str_to_title(token))
      }
    }
  }
  
  return(tibble(Race_Category = race_category, Ethnicity = ethnicity, Ethnic_Origins = paste(ethnic_origins, collapse = ", ")))
}

# Apply function
df <- df %>%
  rowwise() %>%
  mutate(temp = list(categorize_race_ethnicity(Race))) %>%
  unnest(temp)

# Save to CSV
write_csv(df, "cleaned_actress_data.csv")

# Preview
print(head(select(df, Race, Race_Category, Ethnicity, Ethnic_Origins), 10))

# Define keyword mappings for hair color
hair_color_keywords <- list(
  "Black" = c("black"),
  "Brown" = c("brown", "brunette"),
  "Blonde" = c("blonde", "golden blonde", "strawberry blonde", "red/blonde"),
  "Red" = c("red", "ginger")
)

categorize_hair_color <- function(entry) {
  entry_lower <- ifelse(is.na(entry), "", tolower(entry))
  
  # Corrected regex: move '-' to the start or end of the character class
  tokens <- unlist(strsplit(entry_lower, "[-,()\\/ ]+"))
  tokens <- stringr::str_trim(tokens[tokens != ""])
  
  hair_category <- "Other"
  
  for (label in names(hair_color_keywords)) {
    if (any(tokens %in% hair_color_keywords[[label]])) {
      hair_category <- label
      break
    }
  }
  
  return(hair_category)
}


# Apply to the dataframe
df$Hair_Category <- sapply(df$`Hair Color`, categorize_hair_color)

# Optional: View the result
print(head(df[c("Hair Color", "Hair_Category")], 10))

#
#.    Hair
#

library(ggplot2)

# Ensure 'Decade' is a factor with correct order (optional, but helps with control)
df$Decade <- factor(df$Decade, levels = sort(unique(df$Decade)))

# Define pale hair color palette (similar to Seaborn tones)
hair_color_palette <- c(
  'Black' = '#A9A9A9',
  'Brown' = '#D2B48C',
  'Blonde' = '#F0E68C',
  'Red' = '#F08080',
  'Other' = '#E0E0E0'
)

# Plot (Seaborn-style)
ggplot(df, aes(x = Decade, fill = Hair_Category)) +
  geom_bar(position = "dodge", color = "black", width = 0.7) +
  scale_fill_manual(values = hair_color_palette) +
  labs(
    title = "Categorized Hair Color Distribution by Decade",
    fill = "Hair Category",
    x = "Decade",
    y = "Count"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(hjust = 0.5),
    panel.grid.major.x = element_blank()
  )

#
#.    Eyes
#
library(stringr)
library(dplyr)

# Define specific keywords for each eye color
eye_color_keywords_specific <- list(
  Amber = c("amber"),
  Blue = c("blue"),
  Brown = c("brown", "dark brown", "light brown"),
  Gray = c("gray", "grey"),
  Green = c("green"),
  Hazel = c("hazel")
)

# Define hazel combinations
hazel_combinations <- list(
  c("blue", "green"),
  c("green", "brown"),
  c("blue", "brown"),
  c("green", "gold"),
  c("brown", "gold")
)

# Function to categorize eye color
categorize_eye_color_refined <- function(entry) {
  if (is.na(entry) || entry == "") return("Other")
  
  entry_lower <- tolower(entry)
  
  # ✅ FIXED regex here
  tokens <- unlist(strsplit(entry_lower, "[,()/[:space:]-]+"))
  tokens <- tokens[tokens != ""]
  
  eye_category <- "Other"
  
  for (eye_label in names(eye_color_keywords_specific)) {
    keywords <- eye_color_keywords_specific[[eye_label]]
    if (any(tokens %in% keywords)) {
      eye_category <- eye_label
      if (eye_label != "Hazel") {
        return(eye_category)
      }
    }
  }
  
  token_set <- unique(tokens)
  for (combo in hazel_combinations) {
    if (all(combo %in% token_set)) {
      eye_category <- "Hazel"
      return(eye_category)
    }
  }
  
  return(eye_category)
}


# Apply to the DataFrame's 'Eye Color' column
df$Eye_Category_Refined <- sapply(df$`Eye Color`, categorize_eye_color_refined)

# Optional: View result
# head(df[, c("Eye Color", "Eye_Category_Refined")])

library(ggplot2)

# Define a named vector for the paler eye color palette
eye_color_palette <- c(
  "Amber" = "#FFECB3",   # Paler Amber (light yellow-orange)
  "Blue" = "#B3E5FC",    # Paler Blue (light blue)
  "Brown" = "#D7CCC8",   # Paler Brown (light gray-brown)
  "Gray" = "#E0E0E0",    # Paler Gray (very light gray)
  "Green" = "#C8E6C9",   # Paler Green (light green)
  "Hazel" = "#FFF9C4",   # Paler Hazel (very light yellow)
  "Other" = "#F5F5F5"    # Even lighter gray for 'Other'
)

# Make sure the Eye_Category_Refined column is a factor to control legend order
df$Eye_Category_Refined <- factor(df$Eye_Category_Refined, 
                                  levels = names(eye_color_palette))

# Plot using ggplot2
ggplot(df, aes(x = Decade, fill = Eye_Category_Refined)) +
  geom_bar(position = "dodge") +  # side-by-side bars like seaborn countplot with hue
  scale_fill_manual(values = eye_color_palette, name = "Eye Category") +
  labs(title = "Categorized Eye Color Distribution by Decade", x = "Decade", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#
#.   Skin
#
library(stringr)

clean_skin_type_strict <- function(skin_type_entry) {
  if (!is.na(skin_type_entry) && is.character(skin_type_entry)) {
    # Remove extra spaces and split at hyphen, take first part
    cleaned_entry <- str_squish(str_split(skin_type_entry, "-", simplify = TRUE)[1])
    
    # Add space after 'Type' if missing
    if (str_starts(cleaned_entry, "Type") && !str_starts(cleaned_entry, "Type ")) {
      cleaned_entry <- str_replace(cleaned_entry, "^Type", "Type ")
    }
    
    # Extract Roman numeral after 'Type '
    match <- str_match(cleaned_entry, "^Type\\s+([IVX]+)")
    
    valid_roman_numerals <- c("I", "II", "III", "IV", "V", "VI")
    
    if (!is.na(match[1,2]) && match[1,2] %in% valid_roman_numerals) {
      return(paste("Type", match[1,2]))
    } else {
      return("Other")
    }
  } else {
    return(skin_type_entry)
  }
}

# Apply the function to the column
df$`Estimated Fitzpatrick Skin Type` <- sapply(df$`Estimated Fitzpatrick Skin Type`, clean_skin_type_strict)

# To check results:
# table(df$`Estimated Fitzpatrick Skin Type`)
# head(df$`Estimated Fitzpatrick Skin Type`)

library(ggplot2)

# Define a named vector with hex colors for Fitzpatrick types
fitzpatrick_palette <- c(
  "Type I" = "#fcd7d7",
  "Type II" = "#f8c8a0",
  "Type III" = "#e0ac69",
  "Type IV" = "#c68642",
  "Type V" = "#8d5524",
  "Type VI" = "#5a3b1e"
)

ggplot(df, aes(x = Decade, fill = `Estimated Fitzpatrick Skin Type`)) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = fitzpatrick_palette, na.value = "grey80") +
  labs(
    title = "Skin Tone Distribution by Decade",
    fill = "Fitzpatrick Type"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "top",
    legend.title = element_text(size = 10),
    legend.text = element_text(size = 8)
  )

#
# by Race
#

# Define your Fitzpatrick color palette again (if not already defined)
fitzpatrick_palette <- c(
  "Type I" = "#fcd7d7",
  "Type II" = "#f8c8a0",
  "Type III" = "#e0ac69",
  "Type IV" = "#c68642",
  "Type V" = "#8d5524",
  "Type VI" = "#5a3b1e"
)

ggplot(df, aes(x = Race_Category, fill = `Estimated Fitzpatrick Skin Type`)) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = fitzpatrick_palette, na.value = "grey80") +
  labs(
    title = "Skin Tone Distribution by Race Category",
    x = "Race Category",
    y = "Count",
    fill = "Fitzpatrick Skin Type"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1), # Rotate labels, right-aligned
    legend.position = "right",
    legend.title = element_text(size = 10),
    legend.text = element_text(size = 8)
  )

#African

# Filter for Black or African American actresses
black_df <- df %>%
  filter(Race_Category == "Black or African American")

# Compute the order of Fitzpatrick types by count descending
fitz_order <- black_df %>%
  count(`Estimated Fitzpatrick Skin Type`) %>%
  arrange(desc(n)) %>%
  pull(`Estimated Fitzpatrick Skin Type`)

# Plot
ggplot(black_df, aes(x = factor(`Estimated Fitzpatrick Skin Type`, levels = fitz_order), fill = `Estimated Fitzpatrick Skin Type`)) +
  geom_bar() +
  scale_fill_manual(values = fitzpatrick_palette, na.value = "grey80") +
  labs(
    title = "Skin Tone Distribution for Black or African American Actresses",
    x = "Estimated Fitzpatrick Skin Type",
    y = "Count",
    fill = "Fitzpatrick Skin Type"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none"
  )

#Asian
# Filter for Asian actresses
asian_df <- df %>%
  filter(Race_Category == "Asian")

# Order skin types by count descending
fitz_order_asian <- asian_df %>%
  count(`Estimated Fitzpatrick Skin Type`) %>%
  arrange(desc(n)) %>%
  pull(`Estimated Fitzpatrick Skin Type`)

# Plot
ggplot(asian_df, aes(x = factor(`Estimated Fitzpatrick Skin Type`, levels = fitz_order_asian), fill = `Estimated Fitzpatrick Skin Type`)) +
  geom_bar() +
  scale_fill_manual(values = fitzpatrick_palette, na.value = "grey80") +
  labs(
    title = "Skin Tone Distribution for Asian Actresses",
    x = "Estimated Fitzpatrick Skin Type",
    y = "Count",
    fill = "Fitzpatrick Skin Type"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none"
  )

#Native American

# Filter for American Indian or Alaska Native actresses
american_indian_df <- df %>%
  filter(Race_Category == "American Indian or Alaska Native")

# Order skin types by count descending for this group
fitz_order_ai <- american_indian_df %>%
  count(`Estimated Fitzpatrick Skin Type`) %>%
  arrange(desc(n)) %>%
  pull(`Estimated Fitzpatrick Skin Type`)

# Plot for American Indian or Alaska Native
ggplot(american_indian_df, aes(x = factor(`Estimated Fitzpatrick Skin Type`, levels = fitz_order_ai), fill = `Estimated Fitzpatrick Skin Type`)) +
  geom_bar() +
  scale_fill_manual(values = fitzpatrick_palette, na.value = "grey80") +
  labs(
    title = "Skin Tone Distribution for American Indian or Alaska Native Actresses",
    x = "Estimated Fitzpatrick Skin Type",
    y = "Count",
    fill = "Fitzpatrick Skin Type"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none"
  )


# Hispanic

# Filter for Other race category actresses
other_race_df <- df %>%
  filter(Race_Category == "Other")

# Order skin types by count descending for this group
fitz_order_other <- other_race_df %>%
  count(`Estimated Fitzpatrick Skin Type`) %>%
  arrange(desc(n)) %>%
  pull(`Estimated Fitzpatrick Skin Type`)

# Plot for Other race category
ggplot(other_race_df, aes(x = factor(`Estimated Fitzpatrick Skin Type`, levels = fitz_order_other), fill = `Estimated Fitzpatrick Skin Type`)) +
  geom_bar() +
  scale_fill_manual(values = fitzpatrick_palette, na.value = "grey80") +
  labs(
    title = "Skin Tone Distribution for Other Race Category Actresses",
    x = "Estimated Fitzpatrick Skin Type",
    y = "Count",
    fill = "Fitzpatrick Skin Type"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none"
  )









avg_traits <- df %>%
  group_by(Decade) %>%
  summarise(
    `Pop Age` = round(mean(.data[["Pop Age"]], na.rm = TRUE), 1),
    `Height (cm)` = round(mean(.data[["Height cm"]], na.rm = TRUE), 1),
    `Weight (kg)` = round(mean(.data[["Weight kg"]], na.rm = TRUE), 1),
    BMI = round(mean(BMI, na.rm = TRUE), 1)
  ) %>%
  ungroup()

avg_traits_long <- avg_traits %>%
  pivot_longer(cols = c(`Pop Age`, `Height (cm)`, `Weight (kg)`, BMI),
               names_to = "Trait",
               values_to = "Value")

ggplot(avg_traits_long, aes(x = Decade, y = Value, color = Trait, group = Trait)) +
  geom_line() +
  geom_point() +
  labs(
    title = "Average Appearance Traits of Actresses Over Time",
    x = "Decade",
    y = "Value",
    color = "Trait"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_color_brewer(palette = "Set1")






ggplot(df, aes(x = factor(Decade), y = BMI)) +
  geom_violin(trim = FALSE, fill = "skyblue", color = "black") +
  stat_summary(fun = median, geom = "point", size = 3, color = "red") +  # median dots
  labs(title = "BMI Distribution by Decade", x = "Decade", y = "BMI") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))





ggplot(df, aes(x = BMI, color = factor(Decade), fill = factor(Decade))) +
  geom_histogram(aes(y = after_stat(density)), position = "identity", alpha = 0.1, bins = 30) +
  geom_density(alpha = 0.7) +
  labs(
    title = "BMI Distribution by Decade",
    x = "BMI",
    color = "Decade",
    fill = "Decade"
  ) +
  theme_minimal()







ggplot(df, aes(x = factor(Decade), y = `Pop Age`)) +
  geom_boxplot() +
  labs(
    title = "Age Distribution of Actresses by Decade",
    x = "Decade",
    y = "Pop Age"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))








# Make sure 'Decade' is a factor with the correct order
decade_order <- c('70', '80', '90', '2000', '2010', '2020')

avg_age <- df %>%
  group_by(Decade) %>%
  summarise(avg_age = mean(`Pop Age`, na.rm = TRUE)) %>%
  mutate(Decade = factor(Decade, levels = decade_order, ordered = TRUE)) %>%
  arrange(Decade)

ggplot(avg_age, aes(x = Decade, y = avg_age, group = 1)) +
  geom_line() +
  geom_point() +
  labs(
    title = "Average Age of Actresses by Decade",
    x = "Decade",
    y = "Average Age"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))






# Calculate average BMI by Decade
avg_bmi <- df %>%
  group_by(Decade) %>%
  summarise(avg_bmi = mean(BMI, na.rm = TRUE)) %>%
  # Make sure Decade is a factor with correct order
  mutate(Decade = factor(Decade, levels = c('70', '80', '90', '2000', '2010', '2020'), ordered = TRUE)) %>%
  arrange(Decade)

# Plot
ggplot(avg_bmi, aes(x = Decade, y = avg_bmi, group = 1)) +
  geom_line(color = "green") +
  geom_point(color = "green") +
  labs(
    title = "Average BMI of Actresses by Decade",
    x = "Decade",
    y = "Average BMI"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))







ggplot(df, aes(x = Decade, fill = `BMI Status`)) +
  geom_bar(position = "dodge") +  # side-by-side bars (like hue)
  labs(
    title = "BMI Status Distribution by Decade",
    x = "Decade",
    fill = "BMI Status"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))







# Select numeric columns and drop rows with NA in any selected columns
features <- df %>%
  select(`Pop Age`, `Height cm`, `Weight kg`, BMI) %>%
  na.omit()

# Scale the features
scaled_features <- scale(features)

# Run K-Means clustering with 4 clusters and a fixed seed for reproducibility
set.seed(42)
kmeans_result <- kmeans(scaled_features, centers = 4, nstart = 25)

# Add cluster assignment back to original dataframe (only for rows without NA in features)
# Create a new column "Cluster" as factor
df$Cluster <- NA  # initialize column with NA
df_complete <- df[complete.cases(df[, c("Pop Age", "Height cm", "Weight kg", "BMI")]), ]
df$Cluster[complete.cases(df[, c("Pop Age", "Height cm", "Weight kg", "BMI")])] <- as.factor(kmeans_result$cluster)

# Plot clusters: BMI vs Pop Age colored by cluster
ggplot(df_complete, aes(x = BMI, y = `Pop Age`, color = as.factor(kmeans_result$cluster))) +
  geom_point() +
  labs(
    title = "K-Means Clustering: BMI vs Age",
    color = "Cluster"
  ) +
  theme_minimal()














library(reshape2)
library(scales)  # for pretty breaks if needed
library(dplyr)
library(ggplot2)

# Calculate average traits by Decade
traits_by_decade <- df %>%
  group_by(Decade) %>%
  summarise(
    `Pop Age` = mean(`Pop Age`, na.rm = TRUE),
    BMI = mean(BMI, na.rm = TRUE),
    `Height cm` = mean(`Height cm`, na.rm = TRUE),
    `Weight kg` = mean(`Weight kg`, na.rm = TRUE)
  )

# Reshape to long format for ggplot
traits_long <- melt(traits_by_decade, id.vars = "Decade", variable.name = "Trait", value.name = "Average")

# Plot heatmap with annotations
ggplot(traits_long, aes(x = Decade, y = Trait, fill = Average)) +
  geom_tile() +
  geom_text(aes(label = sprintf("%.1f", Average)), color = "black", size = 4) +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = mean(traits_long$Average, na.rm = TRUE)) +
  labs(
    title = "Average Traits per Decade",
    x = "Decade",
    y = "Trait",
    fill = "Average"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))










library(ggplot2)

# Violin plot of Height by Race Category
ggplot(df, aes(x = Race_Category, y = `Height cm`)) +
  geom_violin(trim = FALSE, aes(fill = Race_Category)) +
  stat_summary(fun = median, geom = "point", size = 2, color = "black") +  # show median
  labs(
    title = "Height Distribution (Violin Plot) by Race Category",
    x = "Race Category",
    y = "Height (cm)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  guides(fill = "none")  # remove legend for fill

ggplot(df, aes(x = Race_Category, y = `Height cm`)) +
  geom_boxplot(aes(fill = Race_Category)) +
  labs(
    title = "Height Distribution (Boxplot) by Race Category",
    x = "Race Category",
    y = "Height (cm)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  guides(fill = "none")






