import pandas as pd
import numpy as np

# ============================================
# STEP 1: LOAD DATA
# ============================================
print("Loading IoT_Financial_Management_Dataset.csv...")
df = pd.read_csv("IoT_Financial_Management_Dataset.csv")
print(f"Shape: {df.shape}")
print(f"Nulls: {df.isnull().sum().sum()}")
print(f"Duplicates: {df.duplicated().sum()}")

# ============================================
# STEP 2: FIX NEGATIVE VALUES (only 3 each)
# ============================================
neg_latency = (df['Network_Latency_ms'] < 0).sum()
neg_proc = (df['Transaction_Processing_Time_ms'] < 0).sum()
print(f"\nNegative Network_Latency_ms: {neg_latency}")
print(f"Negative Transaction_Processing_Time_ms: {neg_proc}")

# Use absolute value — these are measurement artifacts not real negatives
df['Network_Latency_ms'] = df['Network_Latency_ms'].abs()
df['Transaction_Processing_Time_ms'] = df['Transaction_Processing_Time_ms'].abs()

print("Fixed: set negative latency/processing times to absolute values")

# ============================================
# STEP 3: CALCULATE DERIVED FINANCIAL COLUMNS
# ============================================

# Net Profit Margin % = Net_Profit / Revenue * 100
df['Net_Profit_Margin_Pct'] = (df['Net_Profit'] / df['Revenue'] * 100).round(2)

# Expense Ratio % = Operating_Cost / Revenue * 100
df['Expense_Ratio_Pct'] = (df['Operating_Cost'] / df['Revenue'] * 100).round(2)

# Gross Profit = Revenue - Operating_Cost (estimated gross)
df['Gross_Profit'] = (df['Revenue'] - df['Operating_Cost']).round(2)

# EBITDA Margin % = EBITDA / Revenue * 100
df['EBITDA_Margin_Pct'] = (df['EBITDA'] / df['Revenue'] * 100).round(2)

# Profit Category based on Net_Profit_Margin_Pct
def profit_category(margin):
    if margin >= 40: return '01-High (40%+)'
    elif margin >= 25: return '02-Medium (25-39%)'
    elif margin >= 10: return '03-Low (10-24%)'
    else: return '04-Very Low (<10%)'

df['Profit_Category'] = df['Net_Profit_Margin_Pct'].apply(profit_category)

# Risk Level based on Fraud_Risk_Score
def risk_level(score):
    if score >= 0.75: return 'High Risk'
    elif score >= 0.50: return 'Medium Risk'
    elif score >= 0.25: return 'Low Risk'
    else: return 'Very Low Risk'

df['Risk_Level'] = df['Fraud_Risk_Score'].apply(risk_level)

# Efficiency Flag
df['Is_High_Performer'] = (df['Performance_Score'] >= 90).astype(int)

print(f"\nDerived columns created:")
print(f"  Net_Profit_Margin_Pct: mean={df['Net_Profit_Margin_Pct'].mean():.2f}%")
print(f"  Expense_Ratio_Pct: mean={df['Expense_Ratio_Pct'].mean():.2f}%")
print(f"  Gross_Profit: mean={df['Gross_Profit'].mean():,.2f}")
print(f"  EBITDA_Margin_Pct: mean={df['EBITDA_Margin_Pct'].mean():.2f}%")
print(f"  Profit_Category distribution:\n{df['Profit_Category'].value_counts()}")
print(f"  Risk_Level distribution:\n{df['Risk_Level'].value_counts()}")
print(f"  High Performers (score>=90): {df['Is_High_Performer'].sum():,} ({df['Is_High_Performer'].mean()*100:.1f}%)")

# ============================================
# STEP 4: FINAL DATA QUALITY CHECK
# ============================================
print(f"\n=== FINAL DATASET SUMMARY ===")
print(f"Total rows: {len(df):,}")
print(f"Total columns: {df.shape[1]}")
print(f"Null values: {df.isnull().sum().sum()}")
print(f"Duplicate rows: {df.duplicated().sum()}")
print(f"\nFinal columns ({df.shape[1]}):")
print(df.columns.tolist())

# Verify no more negatives
print(f"\nNegative check after fix:")
print(f"  Network_Latency_ms negatives: {(df['Network_Latency_ms']<0).sum()}")
print(f"  Transaction_Processing_Time_ms negatives: {(df['Transaction_Processing_Time_ms']<0).sum()}")

# ============================================
# STEP 5: EXPORT CLEAN CSV
# ============================================
output_file = "financial_clean.csv"
df.to_csv(output_file, index=False)
print(f"\n✅ Clean file saved as: {output_file}")
print(f"✅ Ready for Excel and MySQL!")