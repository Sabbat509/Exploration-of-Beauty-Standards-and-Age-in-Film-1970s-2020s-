# **Project Title**

Exploration of Beauty Standards and Age in Film (1970s-2020s)

## **Project Description**

This project examines how beauty standards and age representation among leading actresses have evolved in the film industry from the 1970s to the 2020s. Using large-scale datasets from IMDb and appearance data scraped from celebrity databases, we analyzed trends in physical traits—such as height, BMI, hair and eye color, and skin tone—as well as age at peak popularity ("pop age") for top-grossing actresses in each decade. By combining data filtering, integration, and visualization using R, we reveal how race, body image, and age dynamics have shifted over time, highlighting both persistent ideals and growing inclusivity in cinematic representation.

#  **File Structure**

All File is [HERE](https://drive.google.com/drive/folders/1BXokCrC1BqL0BbPJgImccbzNo2T6ghAu?usp=sharing)

**README.md:** This file provides an overview and instructions for using the *Exploration of Beauty Standards and Age in Film (1970s–2020s)* project.

In our project *Exploration of Beauty Standards and Age in Film (1970s–2020s)*, we performed big data analysis by collecting and merging multiple datasets related to film, actress profiles, and appearance attributes. The organization of our project files is outlined as follows:

**Actress\_filtered.R** \[[link](https://drive.google.com/file/d/1vs9lOUWFAPGvzUWx7be_EL3217mUaPoP/view?usp=sharing)\] **:** This script performs data filtering to isolate actresses from the actor dataset. It uses Actor data.csv as its data source, removing male actors and retaining only female profiles relevant to our project.

**actresses\_data.xlsx** \[[link](https://docs.google.com/spreadsheets/d/172gW1DGLaMyWCT1ZpDLPbnC38VPz5uJx/edit?usp=drive_link&ouid=106441372852148497073&rtpof=true&sd=true)\] : This dataset provides structured details of actresses, including their full name, birth year, profession, and a notable movie they are associated with. Initially, it included both male and female actors; however, male actors have been filtered out. The current version contains only actress data, which will be used for further analysis.

**TopActressOfDecade.R** \[[link](https://drive.google.com/file/d/1VznvvbVl91GfSdXpJl08rchKnbbtC2jp/view?usp=share_link)\]**:** This R script selects the top 20 actresses from each decade based on global box office performance. It takes filtered actress data from Actress Filtered.R, then groups the movies by decade (1970s to 2020s) and calculates each actress’s “pop age,” or age at the time of their most popular film. Additionally, it merges actress data with movie metadata, filters out non-theatrical films (e.g., animations, documentaries), and identifies lead roles.

**ActressAppearanceDataCollection.csv** \[[link](https://drive.google.com/file/d/1gqn_QQfBC0ojyA13Oqs2YKj4pu8g-Nfb/view?usp=share_link)\]This file contains detailed attribute data for each actress, including physical appearance information such as skin tone (classified using the Fitzpatrick Skin Type Scale), hair color, eye color, height, weight, BMI, and ethnicity. It serves as a key dataset for analyzing visual and demographic trends among top actresses across decades.

**G2\_Analysis.R** \[[link](https://drive.google.com/file/d/1bbGJp2FPM39IjpB0Ym1BrTszgW5Pnkhu/view?usp=drive_link)\]**:** This script contains the core analysis logic for the project. It uses data from **ActressAppearanceDataCollection.csv** to modify in order to calculate performance indicators, which will be **Final\_Cleaned\_Dataset.csv** \[[link](https://drive.google.com/file/d/1TVirMj98wPEw0W2hTLrkeiYecLvY0H0Z/view?usp=sharing)\], appearance trends, and age statistics. We polised the categorical information to be more precise to enhance the accuracy. For example. Race \-\> Race\_Category, Hair Color \-\> Hair\_Category the defined them in 3 different clusters. 

The file has additionally contained The results enable comparative analysis of beauty standards and representation across different decades.

**DataVisualization.R** \[[link](https://drive.google.com/file/d/1uUKJwzADyINvALmorpAwdYfmL34cNRo-/view?usp=share_link)\] **:** This script focuses on data visualization. It generates graphs and charts to visually represent trends in age, appearance, and diversity across different decades in the film industry.

**Getting Started**

This project demonstrates the process of filtering data, which is then used for visualization. Below, you'll find a step-by-step guide on how to filter the dataset and prepare it for the visualization stage, including the corresponding code for each step.

#### **1\. Data Filtering Step**

In this step, we filtered the dataset based on several conditions. Download the finished file below:

* **Download the filtered dataset**:

  * [First Filtering Step Dataset](https://docs.google.com/spreadsheets/d/e/2PACX-1vQHCdkVL7UBq0v4AODjDD-mgkTflriIvDFNP0hbTjrdOehDOPbBCWTEJ3MbnqWamg/pub?output=xlsx)  
  * [Top 20 actresses per decade Dataset](https://drive.google.com/drive/folders/1RKJG3ubU2oAOkU18SL6IrDlL7Mr5T_ec?usp=sharing)  
  * [R File](https://drive.google.com/file/d/1lhR3YJQmRlPqElrPKmV1RJdflYHvameg/view?usp=sharing)

**Data Filtering Breakdown**:

Here’s the breakdown or explanation of what we did in the filtered dataset to understand the process better.

 **Step 1**: Download the raw data file “combined.csv”  from this Kaggle [link](https://www.kaggle.com/datasets/rishabjadhav/imdb-actors-and-movies/data)

Start with coding:  
Load the necessary libraries for data manipulation:
```
library(readxl)  # To read Excel files  
library(dplyr)   # For data manipulation  
library(writexl) # To write data to Excel 
```
 
 **Step 2**: Load the dataset from an Excel file using `read_excel()` and check its structure:
```
file_path <- "D:/Big Data Analysis/Project/combined.xlsx"  
data <- read_excel(file_path)  
head(data)  # View the first few rows to ensure it's loaded correctly  
str(data)   # Check the structure of the data
```

 **Step 3**: Filter out rows where the profession column (`primaryProfession`) includes the term "actress":
```
actresses_data <- data %>% filter(grepl("actress", primaryProfession, ignore.case = TRUE))  
head(actresses_data)  # View the filtered data  
write_xlsx(actresses_data, "D:/Big Data Analysis/Project/actresses\_data.xlsx")  # Save the filtered data
```

 **Step 4**: Further process the data by handling missing values, removing duplicates, and filtering based on various criteria:

Download another Raw Kaggle file "final\_dataset.csv" from this [link](https://www.kaggle.com/datasets/raedaddala/top-500-600-movies-of-each-year-from-1960-to-2024)
```
# Filter for relevant actresses data  
movie_data <- read.csv("final_dataset.csv", stringsAsFactors = FALSE)

# Modify knownForTitle for specific actresses  
actress_data <- actress_data %>%  
  mutate(  
    knownForTitle = case_when(  
      primaryName == "Angelina Jolie" ~ "Girl, Interrupted",  
      primaryName == "Michelle Yeoh" ~ "Tomorrow Never Dies",  
      TRUE ~ knownForTitle  
    )  
  )

movie_data <- movie_data %>%  
  mutate(  
    knownForTitle = case_when(  
      title == "American Beauty" ~ "['Kevin Spacey', 'Mena Suvari']",  
      TRUE ~ stars  
    )  
  )

# Merge datasets based on knownForTitle  
merged_data <- inner_join(actress_data, movie_data, by = c("knownForTitle" = "title"))
```

 **Step 5**: Filter the data further based on specific conditions (e.g., removing non-English movies, ensuring only relevant data is retained):
```
 selected\_data \<- merged\_data %\>%  
  select(primaryName, birthYear, primaryProfession, knownForTitle, year, stars, genres, gross\_worldwide, languages) %\>%  
  filter(grepl("English", languages, ignore.case \= TRUE))  \# Keep only English language movies
```

 **Step 6**: Create a new column `leadactors` by selecting the first 3 names from the `stars` column:
```
 selected\_data$leadactors \<- sapply(selected\_data$stars, function(x) {  
  names \<- strsplit(gsub("\\\\\[|\\\\\]|'", "", x), ",\\\\s\*")\[\[1\]\]  
  paste(head(names, 3), collapse \= ", ")  
})
```

 **Step 7**: Create a new column `check` to verify if the primary name appears in the `leadactors` list:
```
 selected\_data \<- selected\_data %\>%  
  mutate(check \= mapply(function(name, leadactors) {  
    stars\_clean \<- gsub("\\\\\[|\\\\\]|'", "", leadactors)  
    stars\_list \<- strsplit(stars\_clean, ",\\\\s\*")\[\[1\]\]  
    name %in% stars\_list  
  }, primaryName, leadactors))
```

 **Step 8**: Filter only rows where `check` is TRUE:
```
 filtered\_data \<- selected\_data %\>%  
  filter(check \== TRUE)
```

 **Step 9**: Remove rows with missing values in `gross_us_canada`:
```
 filtered\_data \<- filtered\_data %\>%  
  filter(\!is.na(gross\_us\_canada) & gross\_us\_canada \!= "")
```

 **Step 10**: Create a new column `PopAge` by subtracting `birthYear` from `year` to calculate the actress's age at the time of the movie release:
```
 filtered\_data \<- filtered\_data %\>%  
  mutate(PopAge \= year \- birthYear)
  ```
  
 **Step 11**: Remove actresses under the age of 15:
```
 filtered\_data \<- filtered\_data %\>%  
  filter(PopAge \> 15 | [is.na](http://is.na)(PopAge))
```

 **Step 12**: Remove rows where the `genres` column contains animation-related terms:
```
 filtered\_data \<- filtered\_data %\>%  
  filter(\!grepl("Animation|Computer Animation|Anime|Documentary", genres, ignore.case \= TRUE))
```

 **Step 13**: Remove rows with years less than or equal to 1969:
```
 filtered\_data \<- filtered\_data %\>%  
  filter(year \> 1969\)
```

 **Step 14**: Create a new column `decade` based on the movie’s release year:
```
 filtered\_data \<- filtered\_data %\>%  
  mutate(decade \= case\_when(  
    year \>= 1970 & year \<= 1979 \~ "70s",  
    year \>= 1980 & year \<= 1989 \~ "80s",  
    TRUE \~ NA\_character\_  
  ))
```

 **Step 15**: View the number of actresses in each decade:
```
 filtered\_data %\>%  
  group\_by(decade) %\>%  
  summarise(actress\_count \= n\_distinct(primaryName)) %\>%  
  arrange(decade)
```


**2\. Model Profile Collection**

After identifying the top model names, we proceeded to collect additional personal information and images using web scraping techniques:

* Step 1: We extracted data such as hair color, eye color, nationality, and images of each model by performing web scraping with BeautifulSoup.

* Step 2: We then processed the images and associated information to categorize each model based on the Fitzpatrick Skin Scale.

* Step 3: This processed data was used to fine-tune a custom ChatGPT model that can understand and respond based on skin tone classifications.

You can find the processed file here: [Download processed model profiles](https://drive.google.com/file/d/1TVirMj98wPEw0W2hTLrkeiYecLvY0H0Z/view?usp=sharing)

#### **3\. Data Analysing**

This part please refer to the [**G2\_Analysis.R**](https://drive.google.com/file/d/1TVirMj98wPEw0W2hTLrkeiYecLvY0H0Z/view?usp=sharing)**,** which contains the explanatory procedure by utilizing R coding. The file will contain both the analysis part and the visualization part. 

* **Step 1:** The filtered data above might not be coherent enough to run the analysis; therefore, the following coded pipeline foresees how we could unify some terms of the variable in one category.  
1. **Load raw data**  
    Read the “Actress Appearance Data Collection.csv” file into a tibble called `df` using `readr::read_csv()`.

2. **Define keyword maps**  
    Create two named lists—`ethnicity_keywords` and `race_keywords`—that map each target category (e.g. “Asian”, “White”, “Hispanic or Latino”) to a vector of lowercase tokens you’ll look for in the raw “Race” field.

3. **Write the categorization function**  
    Implement `categorize_race_ethnicity()` which takes one text entry and returns a tibble with three columns:

   * `Race_Category` (one of your race buckets or “Other”)

   * `Ethnicity` (“Hispanic or Latino” or “Not Hispanic or Latino”)

   * `Ethnic_Origins` (a comma-separated list of any specific origin tokens found, like “Japanese” or “Zulu”)

4. Inside the function you:

   * Convert the entry to lowercase and split on punctuation/whitespace to get clean tokens.

   * Initialize defaults (`Other` race, `Not Hispanic or Latino` ethnicity).

   * Loop through `ethnicity_keywords`—as soon as one matches, set the `Ethnicity`.

   * Loop through `race_keywords`—as soon as one matches, set the `Race_Category`.

   * Loop again to collect any more specific “origin” tokens (excluding generic “white” or “caucasian”), title-case them, and collapse them into the `Ethnic_Origins` string.

   * Return a one-row tibble with those three fields.

5. **Apply the function row-wise**  
    Using `dplyr`:

```
df <- df %>%
  rowwise() %>%                                    # operate on each row
  mutate(temp = list(categorize_race_ethnicity(Race))) %>%  # apply function
  unnest(temp)                                     # expand the returned tibble into columns
```

6. **Export the cleaned data**  
    Write the augmented `df` (now with `Race_Category`, `Ethnicity`, and `Ethnic_Origins`) out to “Final\_Cleaned\_Dataset.csv” via `readr::write_csv()`.

* **Step 2: Dummy Coding**  
  * The data is ready for the Hypothesis Test:  
    * **H1:** Each decade has a **dominant beauty cluster** that aligns with that era’s media and cultural ideals.  
       *(e.g., the 1990s favored athletic, tan actresses; the 2000s favored ultra-slim, pale-skinned types.)*  
    * **H2: Youth-centered clusters** (e.g., actresses under 30\) dominate more consistently in recent decades.  
  * The main methods implemented are   
    * 1\) K-Means Clustering 2\) Logistic Regression

  **Breakdown of your K-Means & logistic regression pipeline:**

1. Load required packages  
    Import `dplyr` for data wrangling, `ggplot2` for visualization, and `cluster` for clustering utilities.

2. Read in the cleaned dataset

```
df <- read.csv("~/Desktop/R Practice/Final_Cleaned_Dataset.csv", stringsAsFactors = FALSE)
```

3. Sanitize column names

```
names(df) <- make.names(names(df))
```

4. Convert key columns to numeric & flag youth

```
df <- df %>%
  mutate(
    PopAge = as.numeric(Pop.Age),
    Height = as.numeric(Height.cm),
    Weight = as.numeric(Weight.kg),
    BMI    = as.numeric(BMI),
    Youth  = ifelse(PopAge < 30, 1, 0)
  )
```

   * Parse age, height, weight, and BMI as numbers.

   * Create a binary `Youth` indicator for under-30.

5. Identify categorical predictors

```
cat_vars <- c("Eye.Color", "Hair.Color", "Race_Category")
```

6. Dummy-encode categorical variables

```
dummies <- df %>%
  select(all_of(cat_vars)) %>%
  mutate(across(everything(), as.factor)) %>%
  model.matrix(~ . - 1, .) %>%
  as.data.frame()
```

   Turn each level into its own 0/1 column.

7. Isolate numeric features

```
num_feats <- df %>% select(PopAge, Height, Weight, BMI)
```

8. Combine numeric & dummy features

```
feat_mat <- bind_cols(num_feats, dummies)
```

9. Remove any rows with non-finite values

```
ok       <- apply(feat_mat, 1, function(r) all(is.finite(r)))
feat_mat <- feat_mat[ok, ]
df_clean <- df[ok, ]
```

   Keep only complete cases for clustering.

10. Scale all features

```
mat_scaled <- scale(feat_mat)
```

Standardize to zero mean and unit variance.

11. (Optional) Elbow method to pick k

```
safe_elbow(mat_scaled, k_max=10)
```

    Plot total within-cluster sum of squares vs. k to find the “elbow.”

12. Run K-means clustering

```
set.seed(2025)
k     <- 3
km    <- kmeans(mat_scaled, centers=k, nstart=25)
df_clean$Cluster <- factor(km$cluster)
```

13. Ensure a Decade grouping

```
if (!"Decade" %in% names(df_clean)) {
  df_clean$Decade <- floor(df_clean$PopAge / 10) * 10
}
```

    

* **Step 3: Hypothesis Test (Continue form the Steps above)**

## **Hypothesis 1: Cluster × Decade**

14. Proportional bar-fill chart

```
ggplot(df_clean, aes(x=factor(Decade), fill=Cluster)) +
  geom_bar(position="fill") + …
```

15. Chi-squared test of independence

```
chi1 <- chisq.test(table(df_clean$Decade, df_clean$Cluster))
print(chi1)
```

---

## **Hypothesis 2: Youth trend**

16. Calculate percent under 30 by decade

```
youth_trend <- df %>%
  group_by(Decade) %>%
  summarise(PctUnder30 = mean(Youth, na.rm=TRUE))
```

17. Trend line plot

```
ggplot(youth_trend, aes(x=Decade, y=PctUnder30))
```

18. Logistic regression of Youth \~ Decade

```
glm_y <- glm(Youth ~ Decade, data=df, family="binomial")
summary(glm_y)
```

19. Quantify the strength and direction of the decade effect on being “Youth.”

#### 4\. Data Visualization 

To extend from the previous part. In this step, we visualized various patterns and trends found in the data, focusing on the representation of dominant colors, age, BMI, height, and weight across different decades. Here are the key conclusions from the visualizations:

#### **Dominant Hair Colors**

* **Overall**: Brown was the most dominant hair color.

* **Decade-wise**:

![][image1]![][image2]  
	**Most dominant colors**:

* Overall: brown  
* 70s: blonde and brown  
* 80s: brown  
* 90s: blonde  
* 2000s: brown  
* 2010s: brown  
  * 2020s: brown

  #### **Dominant Eyes Color by Decade**

* **Overall**: Brown and blue were the most common colors.

* **Decade-wise**:

![][image3]![][image4]  
**Most dominant colors**:

* Overall: brown and blue  
* 70s: blue  
* 80s: brown  
* 90s: blue  
* 2000s: blue  
* 2010s: brown  
* 2020s: brown

  #### **Ethnicity Representation**

  ![][image5]![][image6]

* **Conclusion**   
* **1970s:** Predominantly white representation with some Hispanic individuals present.  
* **1980s:** White remained the dominant group, with Black or African American individuals also represented.  
* **1990s:** White continued to be the most represented group, with an increase in Black or African American individuals and the emergence of some Asian representation.  
* **2000s:** White individuals consistently formed the majority. Black or African American representation was absent. Asian and Hispanic representation increased.  
* **2010s:** White remained the dominant group, with a noticeable increase in Asian representation and the continued presence of some Hispanic individuals.  
* **2020s:** While white individuals still formed the largest group, their representation decreased compared to previous decades. There was a significant increase in Black or African American representation, a continued presence of some Asian individuals, and a greater Hispanic representation than before.

  **Skin Color Types by Ethnicity**

  #### 

![][image7]

#### 

* **Most dominant color types**:

  * **White**: Type II.

  * **Black or African American**: Type V.

  * **Asian**: Type IV.

  * **Hispanic**: Type IV.

  * **American Indian**: Type III.

  #### **Physical Characteristics: Age, BMI, Height, and Weight Trends**  

![][image8]  
**Conclusion**   
**Pop Age**: Increased from 28.4 (70s) to 29.8 (80s), then dropped to 25.2 (2000s), and rose again to 28.9 (2020s).  
**BMI**: Fluctuated slightly between 19.4 and 20.5.  
**Height**: Increased slightly until the 90s (170.1 cm), then decreased to 165.1 cm in the 2020s.  
**Weight**: Increased until the 90s (58.1 kg), then gradually decreased to 54.5 kg in the 2020s.

* **Pop Age**:

  * Increased from 28.4 in the 70s to 29.8 in the 80s.

  * Dropped to 25.2 in the 2000s and then rose again to 28.9 in the 2020s.

* **BMI**: Fluctuated between 19.4 and 20.5 across decades, with some variation.

* **Height**:

  * Increased slightly until the 90s (170.1 cm), then decreased to 165.1 cm in the 2020s.

  * The **2020s** had the shortest median height (around 165 cm), with a wide distribution.

  * **90s** was the tallest (around 172 cm).

* **Weight**:

  * Increased until the 90s (58.1 kg) and then gradually decreased to 54.5 kg in the 2020s.

  #### **BMI by Ethnicity**

* **Asians**: The leanest with a median BMI of approximately 19\.

* **American Indian or Alaska Native**: Median BMI slightly above 19\.

* **Hispanic**: Median BMI around 19.5.

* **White**: Median BMI between 19.5 and 20, with more variation and larger outliers.

* **Black or African American**: The most corpulent group, with a median BMI around 20–20.5.

![][image9]![][image10]

![][image11]![][image12]

![][image13]

***Actress’s Appearance Data***

**1\. Scrape Appearance Attributes from Celebrity Databases**  
Use web scraping tools to extract appearance-related data from celebrity websites (e.g., Healthy Celeb), including height, weight, BMI, eye color, race/ethnicity, and hair color.

**2\. Classify Skin Tone Using Fitzpatrick Scale**  
Use the Fitzpatrick Skin Type Scale to classify skin tone. Prepare sample data and train ChatGPT (or another model) on the scale's characteristics for consistent classification.

**3\. Estimate Skin Type from Actress Images**  
Use actress images as input to the trained model to estimate each actress’s Fitzpatrick skin type based on visual features.

**4\. Compile and Export Final Dataset**  
Combine the scraped attributes and estimated skin types into a structured dataset. Export the final list containing each actress’s name and corresponding appearance data

## 

## **Results**

In our project *Exploration of Beauty Standards and Age in Film (1970s–2020s)*, we set out to examine how visual and demographic representation among leading actresses has evolved over time. Using a combination of large-scale datasets and analytical R scripts, we assessed trends across race, age, physical traits (height, weight, BMI), and visual features (hair color, eye color, skin tone) among top actresses in each decade.

## **H₁: “Each decade has a dominant beauty cluster.”**

* **Test:** χ² test of independence between Decade and Cluster

* **Result:** Χ²(10) \= 13.253, p \= 0.2099

* **Interpretation:**

  * Because p \> 0.05, you **fail to reject** the null of independence. There’s **no statistically significant** association between decade and which cluster an actress falls into.

  * In other words, although the bar-fill plot shows some visual shifts (e.g. Cluster 3 dominating the ’90s), those differences aren’t strong enough, given your sample sizes, to conclude a real change in “dominant” beauty clusters across decades.

* **Conclusion for H₁:** **Not supported** by the χ² test at α \= 0.05. There isn’t enough evidence to say that any one beauty “cluster” truly dominates in one decade versus another. However, there’s a feature that dominates each year.   
  ![][image14]


**Explanation of the cluster:**

| Cluster | n | MeanAge | MeanHeight | MeanWeight | MeanBMI | MeanSkinType | TopEye | TopHair | TopRace |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 1 | 20 | 45.3 | 168.4 | 64.2 | 22.7 | 3.1 | Brown | Brown | White |
| 2 | 45 | 32.1 | 172.5 | 58.3 | 19.6 | 2.4 | Blue | Blonde | Caucasian |
| 3 | 55 | 27.4 | 165.0 | 52.1 | 19.1 | 1.8 | Brown | Black | Mixed |

From that you can craft human-readable definitions, for example:

* **Cluster 1 (“Mature Classics”)**

  * Oldest on average (mid-40s), higher BMI (\~22.7), medium height (\~168 cm)

  * Predominantly brown hair & eyes, mostly White/Caucasian

* **Cluster 2 (“Tall Slim Blonds”)**

  * Mid-30s average age, tallest on average (\~172 cm), lowest BMI (\~19.6)

  * Largely blue-eyed and blonde, largely Caucasian

* **Cluster 3 (“Youthful Petite Mix”)**

  * Youngest group (late-20s), shortest (\~165 cm), lightest weight (\~52 kg), low BMI (\~19.1)

  * Brown eyes, darker hair colors, and more racial/ethnic diversity

## **H₂: “Youth-centered clusters (actresses under 30\) dominate more consistently in recent decades.”**

1. **Descriptive trend** (proportion under 30 by decade):

   * Rises from \~35 % in 1970 up to \~85 % in 2010, then dips to \~60 % in 2020\.

2. **Logistic regression** (Youth \~ Decade):

   * **Coefficient (Decade):** 0.0005852

   * **Std. Error:** 0.0002003

   * **z \= 2.922, p \= 0.0035**

   * Since p \< 0.01, there’s a **highly significant** positive association: as you move from earlier to later decades, the odds of an actress being under 30 **increase**.

   * In plain terms, each incremental year (the way you’ve coded Decade) is associated with a small but statistically significant rise in the likelihood of “youth.”

3. **Conclusion for H₂:** **Supported.** There is a significant upward trend in the proportion of under-30 actresses over time. **H₂ is confirmed**, but note the slight drop in 2020, consider whether sample size or external events (e.g., selection biases) could explain that dip.

![][image15]

**Example Case Study**

In 2023, Disney faced criticism for its approach to inclusion when it cast Halle Bailey, whose performance and advocacy have made her a prominent voice for the Black community, as Ariel in its live-action remake. While many praised Disney for giving a platform to a talented, underrepresented actress, some viewers argued that simply “re-skinning” an originally white character overlooks deeper issues in the studio’s history of privileging lighter skin tones. Critics suggested that Disney could have promoted genuine diversity by creating new, original stories and characters, rather than recasting established white-skinned icons, a strategy some dismissed as mere **“blackwashing”** rather than true, substantive inclusion. Additionally, the criticism regards the **“brownwashing”** of Snow White in 2025.



### **Key Findings:**

* **Racial Diversity**: Our results show a clear shift toward greater racial diversity in recent decades. While White actresses overwhelmingly dominated from the 1970s to the 1990s, the 2020s featured a marked increase in the representation of **Black**, **Asian**, and **Hispanic** actresses.

* **Hair and Eye Color Trends**: Brown hair and brown or blue eyes were most common overall. However, increases in brown eyes and darker hair colors in later decades suggest growing inclusion of actresses from diverse ethnic backgrounds.

* **Skin Tone (Fitzpatrick Scale)**: Lighter skin tones (Type II) were most dominant, especially in earlier decades. Recent data shows a broader distribution, with **Types IV and V** (medium to dark brown skin tones) becoming more common.

* **Physical Traits Over Time**:  
  * **BMI** remained within the healthy range across decades, with slight fluctuation (19.4–20.5).  
  * **Height** peaked in the 1990s and declined in the 2020s, suggesting changing beauty ideals.  
  * **Age** (Pop Age) increased in the 2020s, pointing to the industry’s growing openness to older actresses.

* **Race-Specific Patterns**:  
  * Asian actresses were leanest, with lower BMI and shorter height on average.  
  * Black actresses had slightly higher BMI values.  
  * White actresses showed the most variation in body traits, including outliers at both ends of the spectrum.

### **Conclusion:**

Our analysis confirms that **beauty standards in film have diversified over time**, particularly with respect to **race, skin tone, and body type**. While some traditional norms, such as slimness and fair skin, persist, the data indicates **a broader acceptance of different appearances** in contemporary casting. This shift aligns with increasing cultural and social awareness of inclusivity and representation.

### **Implications and Recommendations for Future Research:**

* **Representation Equity**: While diversity has improved, future research could explore **screen time, roles, and pay equity** across racial and age groups to determine whether representation translates into equal treatment.

* **Intersectionality**: Future studies should analyze how **intersections of race, age, and body type** affect career longevity, typecasting, and public reception.

* **Audience Perception**: Qualitative studies could examine how shifts in casting impact **audience attitudes and expectations**, particularly across global markets.

* **Behind the Camera**: Expanding the dataset to include **directors, writers, and producers** could uncover whether increasing diversity in creative leadership correlates with the casting trends we observed.

### **How Our Findings Address the Research Question:**

Our central research question focused on how beauty standards and age representation among top actresses have evolved across decades in the film industry. Through data-driven analysis of demographic and physical attributes, we have demonstrated **clear trends of increasing inclusivity**, suggesting that industry norms are shifting, albeit gradually, toward more **authentic and diverse representations of women**.

Ultimately, this project offers a foundation for understanding how cultural pressures and social progress shape the visual narratives presented in film.

## **Contributors**

| Thanaphon Tatinij 113zm1010 田子芃 | Data cleaning, Data Collection, Poster |
| :---- | :---- |
| Angeline Chong Jia Lin 111zu1042 張嘉琳 | Data collection, Poster, GitHub |
| Pornnapat Pumipruek 111zu1050 王長婷  | Data Collection, Data analysis, Presentation |
| Ratchadaporn Leungphetngam 111zu1051 陳秋天 | Data cleaning, Data filtering, Presentation slides  |
| Jehud Neri Sabbat 111zu1035 沙杰武 | Data cleaning, Data visualization, Github Set up |

## **Acknowledgments**

We would like to express our heartfelt gratitude to Professor Pien Chung-Pei, our instructor for the *Big Data for Social Analysis* course, for his invaluable guidance and support throughout the development of our project, *Exploration of Beauty Standards and Age in Film (1970s–2020s)*. His insights and expertise played a crucial role in shaping our approach and helping us navigate various challenges during the research process.

We are also deeply thankful to the other student teams who offered their support and encouragement along the way. Their collaboration, constructive feedback, and shared resources significantly enhanced the depth and quality of our analysis.

Finally, we would like to extend our sincere appreciation to every member of our team. Your dedication, perseverance, and collaborative spirit were essential in bringing this project to life. Through your collective efforts, we were able to conduct a meaningful exploration of media representation using big data methods.

## **References**

1. Data sources  
- Actor Data : [https://www.kaggle.com/datasets/rishabjadhav/imdb-actors-and-movies/data](https://www.kaggle.com/datasets/rishabjadhav/imdb-actors-and-movies/data)  
- Movie Data : [https://www.kaggle.com/datasets/raedaddala/top-500-600-movies-of-each-year-from-1960-to-2024](https://www.kaggle.com/datasets/raedaddala/top-500-600-movies-of-each-year-from-1960-to-2024)
