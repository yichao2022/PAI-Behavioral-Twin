library(mlogit)
library(data.table)

# 1. Load data
cat("Loading data...\n")
dat <- fread("/Users/cary/.openclaw/workspace/telegram-inbox/tg-282523157-data2_-_Copy.csv")

# 2. Data Preparation
# Construct binary moderator: irregular_pa = 1 (PhysicalActivities = 0), else 0
# PhysicalActivities: 0=Rare, 1=Sometimes, 2=Quite often
dat[, irregular_pa := ifelse(PhysicalActivities == 0, 1, 0)]

# Standardize Choice and Factors
dat$alt <- factor(dat$alt)
dat$VaccineOrigin <- factor(dat$VaccineOrigin)
dat$Choice <- as.integer(dat$Choice)

# Formatting for mlogit
mld <- mlogit.data(dat, choice = "Choice", shape = "long", 
                  chid.var = "chid", alt.var = "alt", id.var = "RespondentID")

# 3. Model 1: Base Mixed Logit (No Interactions)
cat("Running Base Mixed Logit (R=100 for speed)...\n")
fml_base <- Choice ~ WaitTime_std + VaccineEfficacy_std + SideEffects_std + 
            CashIncentives_std + VaccineOrigin + ASC_optout | 0

# Random parameter for WaitTime_std (Normal distribution)
fit_base <- mlogit(fml_base, data = mld, 
                  rpar = c(WaitTime_std = "n"), 
                  panel = TRUE, R = 100)

# 4. Model 2: Interaction Mixed Logit (WaitTime x Physical Activity)
cat("Running Interaction Mixed Logit (R=100)...\n")
fml_inter <- Choice ~ WaitTime_std + VaccineEfficacy_std + SideEffects_std + 
             CashIncentives_std + VaccineOrigin + ASC_optout + 
             WaitTime_std:irregular_pa | 0

fit_inter <- mlogit(fml_inter, data = mld, 
                   rpar = c(WaitTime_std = "n"), 
                   panel = TRUE, R = 100)

# 5. Extraction and Computation
cf <- coef(fit_inter)
vc <- vcov(fit_inter)

inter_name <- "WaitTime_std:irregular_pa"
beta_inter <- cf[inter_name]
se_inter <- sqrt(vc[inter_name, inter_name])
z_inter <- beta_inter / se_inter
p_inter <- 2 * (1 - pnorm(abs(z_inter)))

slope_ref <- cf["WaitTime_std"] # Slope for regular_pa=0
se_ref <- sqrt(vc["WaitTime_std", "WaitTime_std"])
slope_comp <- slope_ref + beta_inter # Slope for irregular_pa=1
se_comp <- sqrt(vc["WaitTime_std", "WaitTime_std"] + 
                vc[inter_name, inter_name] + 
                2 * vc["WaitTime_std", inter_name])

res_table <- data.frame(
  Variable = c("WaitTime (Active)", "WaitTime (Rare PA)", "Interaction (Rare PA)"),
  Estimate = c(slope_ref, slope_comp, beta_inter),
  StdErr   = c(se_ref, se_comp, se_inter),
  z_value  = c(slope_ref/se_ref, slope_comp/se_comp, z_inter),
  p_value  = c(2*(1-pnorm(abs(slope_ref/se_ref))), 2*(1-pnorm(abs(slope_comp/se_comp))), p_inter)
)

# Likelihood Ratio Test
lrt <- lrtest(fit_base, fit_inter)

# Print Summary Table
cat("\n--- MIXED LOGIT RESULTS (WAIT TIME x PHYSICAL ACTIVITY) ---\n")
print(res_table)
cat("\n--- LIKELIHOOD RATIO TEST ---\n")
print(lrt)

# MWTA Calculation (WaitTime vs CashIncentives)
# MWTA = - beta_wait / beta_cash
# For active group:
mwta_active <- - slope_ref / cf["CashIncentives_std"]
# For rare PA group:
mwta_rare <- - slope_comp / cf["CashIncentives_std"]

cat("\n--- MARGINAL WILLINGNESS TO ACCEPT (MWTA) ---\n")
cat(sprintf("Active Group (Standardized): %.4f\n", mwta_active))
cat(sprintf("Rare PA Group (Standardized): %.4f\n", mwta_rare))

# Save for audit
write.csv(res_table, "mixed_logit_analysis_results.csv", row.names = FALSE)
cat("\n--- FULL MODEL COEFFICIENTS (INTERACTION MODEL) ---\n")
print(summary(fit_inter)$CoefTable)
