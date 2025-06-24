# 1. Load required libraries
library(readxl)     # for reading Excel files
library(dplyr)      # for data manipulation
# Replace the file paths below with the actual path if needed
setwd("H:/study/GCIT/GCIT-Y2s1/DataProject")


# 2. Load the datasets
# Replace the file paths below with the actual path if needed
actress_data <- read_excel("actresses_data.xlsx")
movie_data <- read.csv("final_dataset.csv", stringsAsFactors = FALSE)

actress_data <- actress_data %>%
  mutate(
    knownForTitle = case_when(
      primaryName == "Angelina Jolie" ~ "Girl, Interrupted",
      primaryName == "Michelle Yeoh" ~ "Tomorrow Never Dies",
      primaryName == "Sandra Bullock" ~ "Speed",
      primaryName == "Meryl Streep" ~ "Kramer vs. Kramer",
      primaryName == "Gemma Chan" ~ "Crazy Rich Asians",
      primaryName == "Anne Hathaway" ~ "The Devil Wears Prada",
      primaryName == "Linda Hamilton" ~ "The Terminator",
      primaryName == "Felicity Jones" ~ "The Theory of Everything",
      primaryName == "Natalie Portman" ~ "Star Wars: Episode I - The Phantom Menace",
      primaryName == "Aunjanue Ellis-Taylor" ~ "Men of Honor",
      primaryName == "Mila Kunis" ~ "Forgetting Sarah Marshall",
      primaryName == "Emily Blunt" ~ "The Young Victoria",
      TRUE ~ knownForTitle  # Keep original value if no match
    )
  )

movie_data <- movie_data  %>%
  mutate(
    knownForTitle = case_when(
      title == "American Beauty" ~ "['Kevin Spacey', 'Mena Suvari','Annette Bening', 'Thora Birch', 'Wes Bentley','Peter Gallagher', 'Allison Janney', 'Chris Cooper', 'Scott Bakula', 'Sam Robards']",
      TRUE ~ stars  # Keep original value if no match
    )
  )
# 3. Merge on knownForTitle and title
merged_data <- inner_join(actress_data, movie_data, by = c("knownForTitle" = "title")) 

# 4. Select specified columns
selected_data <- merged_data %>%
  select(primaryName, birthYear, primaryProfession,
         knownForTitle, year, stars,genres, gross_worldwide, gross_us_canada, languages)


# 5. Keep only movies that contain English in the languages list
selected_data <- selected_data %>%
  filter(grepl("English", languages, ignore.case = TRUE))


# 6. Create a new column 'leadactors' by selecting only the first 3 names from the 'stars' column becasue they are lead actor/actress
selected_data$leadactors <- sapply(selected_data$stars, function(x) {
  # Remove square brackets and quotes, then split the string by comma
  names <- strsplit(gsub("\\[|\\]|'", "", x), ",\\s*")[[1]]
  # Return the first 5 names (or fewer if less than 5)
  paste(head(names, 3), collapse = ", ")
})


# 7. Create new column "check" that is TRUE if primaryName appears in stars list
#Rita Hayworth, Glenn Ford, George Macready, Joseph Calleia, Steven Geray
selected_data <- selected_data %>%
  mutate(check = mapply(function(name, leadactors) {
    # Step 1: remove brackets and quotes
    stars_clean <- gsub("\\[|\\]|'", "", leadactors)
    
    # Step 2: split by comma
    stars_list <- strsplit(stars_clean, ",\\s*")[[1]]
    
    # Step 3: trim spaces (this was the missing part)
    stars_list <- trimws(stars_list)
    
    # Step 4: check match
    name %in% stars_list
  }, primaryName, leadactors))

table(selected_data$check)

# 8. Filter only rows where check is TRUE
filtered_data <- selected_data %>%
  filter(check == TRUE)


# 9. Remove rows with NA in gross_us_canada, it means that the movie is not popular or it is TV series
filtered_data <- filtered_data %>%
  filter(
      !is.na(gross_us_canada) & gross_us_canada != "")

#9.1 Neve Campbell duplicate data
neve_data <- filtered_data %>%
  filter(grepl("Neve Campbell", primaryName, ignore.case = TRUE))

filtered_data <- filtered_data %>%
  filter(!(primaryName == "Neve Campbell" & year == 2022))
#9.2 Jamie Lee Curtis duplicate data
jamie_data <- filtered_data %>%
  filter(grepl("Jamie Lee Curtis", primaryName, ignore.case = TRUE))
filtered_data <- filtered_data %>%
  filter(!(primaryName == "Jamie Lee Curtis" & year == 2018))

# 10. Create PopAge column
filtered_data <- filtered_data %>%
  mutate(PopAge = year - birthYear)

# 11. Remove kids actress (age < 15)
filtered_data <- filtered_data %>%
  filter(PopAge > 15 | is.na(PopAge))


# 12. Remove rows where the genres column contains animation-related words
filtered_data <- filtered_data %>%
  filter(!grepl("Animation|Computer Animation|Anime|Documentary", genres, ignore.case = TRUE))

# 13. Remove rows where year <= 1969:
filtered_data <- filtered_data %>%
  filter(year > 1969)

# 14. Create a new column decade based on year:
filtered_data <- filtered_data %>%
  mutate(decade = case_when(
    year >= 1970 & year <= 1979 ~ "70s",
    year >= 1980 & year <= 1989 ~ "80s",
    year >= 1990 & year <= 1999 ~ "90s",
    year >= 2000 & year <= 2009 ~ "2000s",
    year >= 2010 & year <= 2019 ~ "2010s",
    year >= 2020 & year <= 2025 ~ "2020s",
    TRUE ~ NA_character_  # optional: to handle out-of-range or NA values
  ))


# 15.Clean and convert gross_us_canada to numeric
filtered_data$gross_worldwide_clean <- as.numeric(gsub("[^0-9]", "", filtered_data$gross_worldwide))


# 16.Selecting TOP 20 from each decades

#----------TOP 70s----------# 

actress70s <- filtered_data[filtered_data$decade == "70s", ]

# Step 1 List of names to remove
names_to_remove70s <- c("Catlin Adams", "Barbara Rhoades", "Shelley Winters", 
                     "Mabel King", "Corinne Cléry", "Billie Whitelaw", 
                     "Nancy Kyes", "P.J. Soles", "Caroline Munro", "Lana Wood", "Beulah Garrick", "Patsy Garrett","Jane Alexander","Pamela Hensley","Lee Remick")
# step 2: Filter out those names
actress70s  <- actress70s %>%
  filter(!primaryName %in% names_to_remove70s)

top70s <- actress70s[order(-actress70s$gross_worldwide_clean), ][1:30, ]
# Step 3: Select only the specified columns
top70s <- top70s %>%
  select(primaryName, birthYear,
         knownForTitle, year, gross_worldwide_clean, PopAge, genres, leadactors)
# View the top70s dataframe
View(top70s)

#----------TOP 80s----------#

actress80s <- filtered_data[filtered_data$decade == "80s", ]
# Step 1: List of names to remove
names_to_remove80s <- c("Teri Garr", "Glenn Close", "Shirley MacLaine", "Esther Rolle", "Lilia Skala", "Sunny Johnson","Olympia Dukakis","Jessica Tandy")
# Step 2: Filter out those names
actress80s <- actress80s %>%
  filter(!primaryName %in% names_to_remove80s)

top80s <- actress80s[order(-actress80s$gross_worldwide_clean), ][1:30, ]
# Step 3: Select only the specified columns
top80s <- top80s %>%
  select(primaryName, birthYear,
         knownForTitle, year, gross_worldwide_clean, PopAge, genres, leadactors)
# View the top80s dataframe
View(top80s)

#----------TOP 90s----------#

actress90s <- filtered_data[filtered_data$decade == "90s", ]
# Step 1: List of names to remove
names_to_remove90s <- c("Frances Fisher", "Sally Field","Annette Bening","Karen Duffy","Whitney Houston","Rebecca De Mornay")
# Step 2: Filter out those names
actress90ss <- actress90s %>%
  filter(!primaryName %in% names_to_remove90s)

top90s <- actress90s[order(-actress90s$gross_worldwide_clean), ][1:30, ]
# Step 3: Select only the specified columns
top90s <- top90s %>%
  select(primaryName, birthYear,
         knownForTitle, year, gross_worldwide_clean, PopAge, genres, leadactors)
# View the top90s dataframe
View(top90s)

#----------TOP 2000s----------#

actress2000s <- filtered_data[filtered_data$decade == "2000s", ]
# Step 1: List of names to remove
names_to_remove2000s <- c("Rachael Taylor","Christina Jastrzembska","Maia Morgenstern","Catherine Zeta-Jones","	
Blythe Danner","Teri Polo","Anna Kendrick","Sarah Jessica Parker","Martine McCutcheon")
# Step 2: Filter out those names
actress2000s <- actress2000s %>%
  filter(!primaryName %in% names_to_remove2000s)

top2000s <- actress2000s[order(-actress2000s$gross_worldwide_clean), ][1:30, ]
top2000s  <- top2000s  %>%
  select(primaryName, birthYear,
         knownForTitle, year, gross_worldwide_clean, PopAge, genres, leadactors)
View(top2000s)

#----------TOP 2010s----------#

actress2010s <- filtered_data[filtered_data$decade == "2010s", ]
# Step 1: List of names to remove
names_to_remove2010s <- c("Lucy Davis","Daniella Kertesz","Lisa Lu","Danai Gurira","Octavia Spencer","Janelle Monáe","Maya Rudolph","Lady Gaga","Hai-Qing","Anne Le Ny","Mireille Enos","Morena Baccarin","Annabelle Wallis","Rosa Salazar","Adrianne Palicki","Kristen Wiig","Sakshi Tanwar","Izabela Vidovic","Kristin Davis","Cho Yeo-jeong","Alison Sudol")
# Step 2: Filter out those names
actress2010s <- actress2010s %>%
  filter(!primaryName %in% names_to_remove2010s)

# Step 2: Sort the data by gross_worldwide_usd in descending order and select the top 30
top2010s <- actress2010s[order(-actress2010s$gross_worldwide_clean), ][1:30, ]
# Step 3: Select only the specified columns
top2010s <- top2010s %>%
  select(primaryName, birthYear,
         knownForTitle, year, gross_worldwide_clean, PopAge, genres, leadactors)
View(top2010s)

#----------TOP 2020s----------#

actress2020s <- filtered_data[filtered_data$decade == "2020s", ]
# Step 1: List of names to remove
names_to_remove2020s <- c("Ariana DeBose","Harriet Dyer","Laura Benanti","Elisabeth Moss","Haruka Abe","Grace Byers","Sosie Bacon","Jean Smart","Elizabeth Lail","Sherry Cola","Caitríona Balfe","Janice Man","Fantasia Barrino","Kerry Condon","Paola Cortellesi","Lee Jung-hyun")
# Step 2: Filter out those names
actress2020s <- actress2020s %>%
  filter(!primaryName %in% names_to_remove2020s)

# Step 2: Sort the data by gross_worldwide_usd in descending order and select the top 30
top2020s <- actress2020s[order(-actress2020s$gross_worldwide_clean), ][1:30, ]
# Step 3: Select only the specified columns
top2020s <- top2020s %>%
  select(primaryName, birthYear,
         knownForTitle, year, gross_worldwide_clean, PopAge, genres, leadactors)
View(top2020s)

#--------Export Dataframe----#
write.csv(top70s, "top70s.csv")
write.csv(top80s, "top80s.csv")
write.csv(top90s, "top90s.csv")
write.csv(top2000s, "top2000s.csv")
write.csv(top2010s, "top2010s.csv")
write.csv(top2020s, "top2020s.csv")


