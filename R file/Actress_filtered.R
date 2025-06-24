# Step 1: Load necessary libraries
library(readxl)  # To read Excel files
library(dplyr)   # For data manipulation
library(writexl) # To write data to Excel

# Step 2: Load the dataset from the provided Excel file
file_path <- "D:/Big Data Analysis/Project/combined.xlsx"  
data <- read_excel(file_path)

# Step 3: View the first few rows of the data to confirm it's loaded correctly
head(data)

# Step 4: Explore the data structure
str(data)

# Filter actresses (those whose profession includes 'actress')
actresses_data <- data %>% filter(grepl("actress", primaryProfession, ignore.case = TRUE))

# Display the filtered data
head(actresses_data)

write_xlsx(actresses_data, "D:/Big Data Analysis/Project/actresses_data.xlsx")
