# 0) Install once if needed:
# install.packages(c("dplyr","ggplot2","cluster"))

# 1) Load libraries
library(dplyr)
library(ggplot2)
library(cluster)

# 2) Read your cleaned data
df <- read.csv(
  "~/Desktop/R Practice/Final_Cleaned_Dataset.csv",
  stringsAsFactors = FALSE
)

# 3) Sanitize column names
names(df) <- make.names(names(df))

# 4) Convert your numeric columns & flag “Youth”
df <- df %>%
  mutate(
    PopAge = as.numeric(Pop.Age),
    Height = as.numeric(Height.cm),
    Weight = as.numeric(Weight.kg),
    BMI    = as.numeric(BMI),
    Youth  = ifelse(PopAge < 30, 1, 0)
  )

# 5) Specify categorical vars (now only Race_Category, plus eyes & hair)
cat_vars <- c("Eye.Color", "Hair.Color", "Race_Category")

# 6) Dummy-code those categories
dummies <- df %>%
  select(all_of(cat_vars)) %>%
  mutate(across(everything(), as.factor)) %>%
  model.matrix(~ . - 1, data = .) %>%
  as.data.frame()

# 7) Pull out just the numeric features
num_feats <- df %>%
  select(PopAge, Height, Weight, BMI)

# 8) Combine numeric + dummies into your feature matrix
feat_mat <- bind_cols(num_feats, dummies)

# 9) Drop any rows with NA/Inf before scaling
ok       <- apply(feat_mat, 1, function(r) all(is.finite(r)))
feat_mat <- feat_mat[ok, ]
df_clean <- df[ok, ]

# 10) Scale everything
mat_scaled <- scale(feat_mat)

# 11) (Optional) Elbow plot to choose k
safe_elbow <- function(data, k_max=10) {
  data2 <- data[, apply(data,2,sd, na.rm=TRUE)>0, drop=FALSE]
  max_k <- min(k_max, nrow(data2)-1)
  wss   <- sapply(1:max_k, function(k)
    kmeans(data2, centers=k, nstart=10)$tot.withinss )
  plot(1:max_k, wss, type="b",
       xlab="k", ylab="Total within-ss",
       main="Elbow Method")
  invisible(wss)
}
safe_elbow(mat_scaled, k_max=10)

# 12) Run K-means with k=3
set.seed(2025)
k  <- 3
km <- kmeans(mat_scaled, centers=k, nstart=25)
df_clean$Cluster <- factor(km$cluster)

# 13) Ensure you have a Decade column
if (!"Decade" %in% names(df_clean)) {
  df_clean$Decade <- floor(df_clean$PopAge / 10) * 10
}

# —— H₁: cluster vs. decade —— #

# A) Proportional bar-fill chart
ggplot(df_clean, aes(x=factor(Decade), fill=Cluster)) +
  geom_bar(position="fill") +
  labs(
    x = "Decade",
    y = "Proportion",
    title = "H1: Beauty Clusters by Decade"
  ) +
  theme_minimal()

# B) χ² test of independence
chi1 <- chisq.test(table(df_clean$Decade, df_clean$Cluster))
print(chi1)

# —— H2: youth trend —— #
youth_trend <- df %>%
  group_by(Decade) %>%
  summarise(PctUnder30 = mean(Youth, na.rm=TRUE))

ggplot(youth_trend, aes(x=Decade, y=PctUnder30)) +
  geom_line() + geom_point(size=2) +
  labs(y="Pct Under 30", title="H2: Youth-Centered Trend") +
  theme_minimal()

# Logistic regression of Youth ~ Decade
glm_y <- glm(Youth ~ Decade, data=df, family="binomial")
summary(glm_y)
