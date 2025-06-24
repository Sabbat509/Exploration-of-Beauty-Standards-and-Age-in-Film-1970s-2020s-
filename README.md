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

![][image1]

[image1]: <data:image/png;base64,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>

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


