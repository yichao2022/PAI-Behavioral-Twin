library(mlogit)
library(data.table)

# 1. Load data
data_path <- "/Users/cary/.openclaw/workspace/telegram-inbox/tg-282523157-data2_-_Copy.csv"
dat <- fread(data_path)

# 2. Trust groups
dat[GoverTrust %in% c("-2", "-1"), trust_grp := "Low"]
dat[GoverTrust %in% c("0", "Prefer not to say"), trust_grp := "Neutral"]
dat[GoverTrust %in% c("1", "2"), trust_grp := "High"]

# Reference: High Trust
dat$trust_grp <- factor(dat$trust_grp, levels = c("High", "Low", "Neutral"))

# Hygiene
dat$alt <- factor(dat$alt)
dat$VaccineOrigin <- factor(dat$VaccineOrigin)
dat$Choice <- as.integer(dat$Choice)

# 3. Model Formatting
mld <- mlogit.data(dat, choice = "Choice", shape = "long", 
                  chid.var = "chid", alt.var = "alt", id.var = "RespondentID")

# Interaction terms
mld$wt_low <- mld$WaitTime_std * (mld$trust_grp == "Low")
mld$wt_neutral <- mld$WaitTime_std * (mld$trust_grp == "Neutral")

# WaitTime_std is alternative-specific.
# trust_grp is respondent-specific.
# Controls are alternative-specific.

# Correct mlogit syntax for respondent-specific variables is | trust_grp
# choice ~ alternative-specific | respondent-specific
# Choice ~ WaitTime_std + controls | trust_grp
# This will create trust_grp effects for all alternatives except the reference.
# But since our model is choice ~ attributes | 0, we can use manual interactions.

# The singularity in v5 was likely because trust_low_dummy was constant across alternatives for each chid.
# Individual-specific variables must be modeled in the second part of the formula.

fml_trust <- Choice ~ WaitTime_std + wt_low + wt_neutral + 
             VaccineEfficacy_std + SideEffects_std + CashIncentives_std + 
             VaccineOrigin + ASC_optout | 0

cat("Running Formal Trust Interaction Model (v4 style with correct result capture)...\n")
fit_trust <- mlogit(fml_trust, data = mld)

# 4. Extract Results
s <- summary(fit_trust)
cat("\nSummary:\n")
print(s)

coefs <- s$CoefTable
target_terms <- c("WaitTime_std", "wt_low", "wt_neutral")
results <- coefs[rownames(coefs) %in% target_terms, ]

cat("\n--- TARGET RESULTS ---\n")
print(results)

# Wald Test for interaction terms
fml_red <- Choice ~ WaitTime_std + 
             VaccineEfficacy_std + SideEffects_std + CashIncentives_std + 
             VaccineOrigin + ASC_optout | 0
fit_red <- mlogit(fml_red, data = mld)
wt <- lrtest(fit_red, fit_trust)
cat("\n--- JOINT TEST FOR INTERACTION TERMS ---\n")
print(wt)

write.csv(results, "trust_interaction_results_v7.csv")
