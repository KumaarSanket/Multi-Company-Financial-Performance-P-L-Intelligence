# Multi-Company-Financial-Performance-P-L-Intelligence

# 💰 IoT Financial Performance Dashboard

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Excel](https://img.shields.io/badge/Microsoft%20Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Revenue](https://img.shields.io/badge/Revenue-$4.67B-D4AF37?style=for-the-badge)

## 💹 Financial Performance Dashboard

![Financial Performance Dashboard](Financial%20Performance%20Dashboard.jpeg)

![Financial Performance Dashboard 2](Financial%20Performance%20Dashboard%20%282%29.jpeg)

![Financial Performance Dashboard 3](Financial%20Performance%20Dashboard%20%283%29.jpeg)

![Financial Performance Dashboard 4](Financial%20Performance%20Dashboard%20%284%29.jpeg)

> Data Analytics · K.S. · Tools: Python → Excel → MySQL → Power BI

---

## 📌 Project Overview

Analyzed 8,900 IoT financial transaction records across 100 branches, 5 regions, and 6 departments through a complete 4-tool pipeline. • Python EDA fixed 6 negative sensor values and engineered 7 derived financial columns (Net_Profit_Margin_Pct, Expense_Ratio_Pct, Gross_Profit, EBITDA_Margin_Pct, Profit_Category, Risk_Level, Is_High_Performer). • Excel built a branch KPI comparison PivotTable with conditional formatting and Financial Status cross-tabs. • MySQL executed 7 analytical queries surfacing $4.67B revenue, 48.01% avg net margin, Branch 1025 as top performer (64.33%), and a key risk-profit independence finding. • Built a 3-page Power BI dashboard (24 visuals, 12 DAX measures) with waterfall chart, Region×Department heatmap, and compliance-performance scatter.

---

## 🎯 Problem Statement

An IoT financial management system generated 8,900 transaction records with no pre-calculated financial ratios, no branch performance rankings, no risk-profitability cross-analysis, and no executive reporting layer — leaving a $4.67B portfolio entirely unanalyzed.

> ⚠️ **EDA-Driven Workflow Redesign:** Project brief described "multi-company data with YoY growth." Actual dataset has no Company or Date column. EDA identified this immediately — workflow was redesigned to use Region/Branch as business unit equivalents before writing any SQL or Power BI steps.

---

## 🎯 Objectives

- Python EDA — fix 6 negative sensor values, engineer 7 financial derived columns
- Excel — build branch KPI PivotTable with conditional formatting + status cross-tabs
- MySQL — import 8,900 records, create 6 indexes, run 7 analytical queries + 1 VIEW
- Power BI — 3-page dashboard with 12 DAX measures and 24 visuals
- Identify top/bottom performing branches from all 100 branches
- Cross-analyze profit category vs risk level for portfolio risk management insights

---

## 📁 Dataset

| Attribute | Detail |
|-----------|--------|
| **Name** | IoT Financial Management Dataset |
| **Source** | Kaggle — IoT Financial Management |
| **Format** | CSV (.csv) |
| **Raw Records** | 8,900 rows · 39 columns |
| **Final Records** | 8,900 rows · 46 columns (7 Python-derived) |
| **Null Values** | Zero ✅ |
| **Duplicates** | Zero ✅ |
| **Dimensions** | 5 Regions · 6 Departments · 100 Branches |

### EDA Findings

| Check | Result | Action |
|-------|--------|--------|
| Nulls | 0 | None needed |
| Duplicates | 0 | None needed |
| Negative Network_Latency_ms | 3 rows | `abs()` fix applied |
| Negative Transaction_Processing_Time_ms | 3 rows | `abs()` fix applied |
| No Date/Year column | Confirmed | No YoY/CAGR — redesigned workflow |
| No Company column | Confirmed | Used Region/Branch as equivalent |

---

## 🛠️ Tools & Technologies

| Tool | Phase | Purpose |
|------|-------|---------|
| **Python 3.11** | Phase 1 | EDA, 6 negative fixes, 7 derived columns, CSV export |
| **Microsoft Excel** | Phase 2 | Branch KPI PivotTable, conditional formatting, KPI Summary |
| **MySQL 8.0** | Phase 3 | LOAD DATA INFILE, 6 indexes, 7 queries, 1 VIEW |
| **Power BI Desktop** | Phase 4 | Live MySQL connection, 12 DAX measures, 3-page dashboard |

---

## ⚙️ PHASE 1 — Python

### 7 Derived Columns Created

```python
import pandas as pd, numpy as np

df = pd.read_csv("IoT_Financial_Management_Dataset.csv")

# Fix 6 negative sensor values
df['Network_Latency_ms'] = df['Network_Latency_ms'].abs()
df['Transaction_Processing_Time_ms'] = df['Transaction_Processing_Time_ms'].abs()

# Engineer 7 financial derived columns
df['Net_Profit_Margin_Pct'] = (df['Net_Profit'] / df['Revenue'] * 100).round(2)
df['Expense_Ratio_Pct'] = (df['Operating_Cost'] / df['Revenue'] * 100).round(2)
df['Gross_Profit'] = (df['Revenue'] - df['Operating_Cost']).round(2)
df['EBITDA_Margin_Pct'] = (df['EBITDA'] / df['Revenue'] * 100).round(2)

def profit_category(m):
    if m >= 40: return '01-High (40%+)'
    elif m >= 25: return '02-Medium (25-39%)'
    elif m >= 10: return '03-Low (10-24%)'
    else: return '04-Very Low (<10%)'

def risk_level(s):
    if s >= 0.75: return 'High Risk'
    elif s >= 0.50: return 'Medium Risk'
    elif s >= 0.25: return 'Low Risk'
    else: return 'Very Low Risk'

df['Profit_Category'] = df['Net_Profit_Margin_Pct'].apply(profit_category)
df['Risk_Level'] = df['Fraud_Risk_Score'].apply(risk_level)
df['Is_High_Performer'] = (df['Performance_Score'] >= 90).astype(int)

df.to_csv("financial_clean.csv", index=False)
# Result: 8,900 rows · 46 columns · 0 nulls · 0 duplicates ✅
```

**Python Output Summary:**

| Derived Column | Value |
|----------------|-------|
| Avg Net Profit Margin % | **48.01%** |
| Avg Expense Ratio % | **81.02%** |
| Avg EBITDA Margin % | **40.08%** |
| Profit Category — High (40%+) | 3,145 transactions |
| Risk Level — even split | ~2,250 per level |
| High Performers (score≥90) | 6,344 (71.3%) |

---

## ⚙️ PHASE 2 — Excel

### Branch KPI PivotTable (Sheet: Branch KPIs)
- **Rows:** Branch_ID (100 branches)
- **Values:** Avg Revenue · Avg Net Margin % · Avg ROI % · Avg Expense Ratio % · Avg Performance · Avg Compliance
- **Conditional Formatting:** Color Scale on Net Margin % (Green=high) · Data Bars on ROI · Traffic Lights on Performance Score · Red→Green on Expense Ratio

### Financial Status Cross-Tabs (Sheet: Status Summary)
- Region × Financial_Status count table
- Department × Financial_Status count table
- Both with Color Scale conditional formatting

### KPI Summary (Sheet: KPI Summary)
- 10 formula-driven KPIs linking to raw data sheet
- Conditional formatting thresholds (green/amber/red)

---

## ⚙️ PHASE 3 — MySQL

### Import

```sql
CREATE DATABASE IF NOT EXISTS financial_project;
USE financial_project;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/financial_clean.csv'
INTO TABLE financial_data
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- Result: 8,900 rows · 0 warnings ✅
```

### 7 Analytical Queries

```sql
-- Q1: Overall KPIs
SELECT COUNT(*) total_transactions,
       ROUND(SUM(Revenue),2) total_revenue,
       ROUND(SUM(Net_Profit),2) total_net_profit,
       ROUND(SUM(Operating_Cost),2) total_operating_cost,
       ROUND(SUM(EBITDA),2) total_ebitda,
       ROUND(AVG(Net_Profit_Margin_Pct),2) avg_net_margin_pct,
       ROUND(AVG(ROI),2) avg_roi_pct
FROM financial_data;
-- $4.67B revenue · $1.36B net profit · 48.01% margin · 18.56% ROI

-- Q2: Financial Status Distribution
SELECT Financial_Status, COUNT(*) transaction_count,
       ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM financial_data),2) pct_share,
       ROUND(AVG(Performance_Score),2) avg_performance
FROM financial_data GROUP BY Financial_Status ORDER BY avg_net_margin_pct DESC;
-- Excellent 77.07% (perf 96.63) · Good 13.20% · Moderate 6.82% · Poor 2.91%

-- Q3: Performance by Region
SELECT Region, COUNT(*) total_txns,
       ROUND(SUM(Revenue),2) total_revenue,
       ROUND(AVG(Net_Profit_Margin_Pct),2) avg_net_margin_pct,
       ROUND(AVG(ROI),2) avg_roi
FROM financial_data GROUP BY Region ORDER BY total_revenue DESC;
-- South #1 revenue $954.8M · East #1 margin 49.20%

-- Q4: Performance by Department
SELECT Department, COUNT(*) total_txns,
       ROUND(SUM(Revenue),2) total_revenue,
       ROUND(AVG(Net_Profit_Margin_Pct),2) avg_net_margin_pct,
       ROUND(AVG(Expense_Ratio_Pct),2) avg_expense_ratio
FROM financial_data GROUP BY Department ORDER BY total_revenue DESC;
-- Audit #1 revenue $801.4M · Investment #1 margin 50.49%

-- Q5: Top 10 Branches
SELECT Branch_ID, ROUND(AVG(Net_Profit_Margin_Pct),2) avg_net_margin_pct,
       ROUND(AVG(ROI),2) avg_roi
FROM financial_data GROUP BY Branch_ID
ORDER BY avg_net_margin_pct DESC LIMIT 10;
-- Branch 1025: 64.33% · Branch 1005: 62.20%

-- Bottom 10 Branches
SELECT Branch_ID, ROUND(AVG(Net_Profit_Margin_Pct),2) avg_net_margin_pct
FROM financial_data GROUP BY Branch_ID
ORDER BY avg_net_margin_pct ASC LIMIT 10;
-- Branch 1017: 36.32% · Branch 1077: 38.14%

-- Q6: Profit Category × Risk Level Cross Analysis
SELECT Profit_Category, Risk_Level, COUNT(*) txn_count,
       ROUND(AVG(Net_Profit_Margin_Pct),2) avg_margin
FROM financial_data GROUP BY Profit_Category, Risk_Level ORDER BY Profit_Category, Risk_Level;
-- KEY INSIGHT: High profit margin ~100% regardless of risk level → profit & risk are INDEPENDENT

-- Q7: Create VIEW
CREATE OR REPLACE VIEW vw_financial_summary AS
SELECT Region, Department, Financial_Status, Profit_Category, Risk_Level,
       COUNT(*) txn_count, ROUND(SUM(Revenue),2) total_revenue,
       ROUND(AVG(Net_Profit_Margin_Pct),2) avg_net_margin_pct,
       ROUND(AVG(ROI),2) avg_roi, ROUND(AVG(Performance_Score),2) avg_performance
FROM financial_data
GROUP BY Region, Department, Financial_Status, Profit_Category, Risk_Level;
```

---

## 📐 DAX Measures (12 Total)

```dax
Total Transactions = COUNTROWS(financial_data)               -- 8,900
Total Revenue = SUM(financial_data[Revenue])                 -- $4,667,647,699
Total Net Profit = SUM(financial_data[Net_Profit])           -- $1,364,116,559
Total Operating Cost = SUM(financial_data[Operating_Cost])   -- $2,293,341,164
Total EBITDA = SUM(financial_data[EBITDA])                   -- $1,139,068,843
Avg Net Margin % = AVERAGE(financial_data[Net_Profit_Margin_Pct])  -- 48.01%
Avg ROI % = AVERAGE(financial_data[ROI])                     -- 18.56%
Avg Gross Margin % = AVERAGE(financial_data[Gross_Margin])   -- 37.86%
Avg Compliance Score = AVERAGE(financial_data[Compliance_Score])   -- 80.03
High Performer Count = SUM(financial_data[Is_High_Performer])      -- 6,344
Excellent Status Count = CALCULATE([Total Transactions], Financial_Status="Excellent")  -- 6,859
Poor Status Count = CALCULATE([Total Transactions], Financial_Status="Poor")            -- 259
```

---

## 📊 3-Page Dashboard (24 Visuals)

### Page 1 — Financial Overview (11 visuals)
| # | Visual | Key Insight |
|---|--------|-------------|
| 1-6 | 6 KPI Cards | $4.67B · $1.36B · $2.29B · $1.14B · 48.01% · 18.56% |
| 7 | Waterfall Chart | Revenue by Financial Status — Excellent dominates |
| 8 | Bar Chart | Revenue by Region — South #1 at $954.8M |
| 9 | Donut Chart | Financial Status — Excellent 77.07% |
| 10-11 | Slicers | Financial_Status · Region |

### Page 2 — Department & Profitability (7 visuals)
| # | Visual | Key Insight |
|---|--------|-------------|
| 12 | Bar Chart | Avg Net Margin by Dept — Investment leads 50.49% |
| 13 | Column Chart | Revenue vs Net Profit by Department |
| 14 | Bar Chart | Profit Category — High (3,145) largest group |
| 15 | **Matrix Heatmap** | Region × Department Net Margin — color-coded grid |
| 16 | Donut Chart | Risk Level — equal 4-way split (~25% each) |
| 17-18 | Slicers | Department · Profit_Category |

### Page 3 — Branch Performance & Risk (6 visuals)
| # | Visual | Key Insight |
|---|--------|-------------|
| 19 | Bar Chart (Top 10) | Branch 1025 leads — 64.33% margin |
| 20 | Bar Chart (Bottom 10) | Branch 1017 worst — 36.32% margin |
| 21 | Column Chart | Avg ROI by Region — South leads 19.04% |
| 22 | Scatter Chart | Compliance vs Performance by Financial_Status |
| 23-24 | Slicers | Risk_Level · Financial_Status (synced) |

---

## 📈 Key Insights & Results

### Overall Portfolio
- **$4.67B revenue** · **$1.36B net profit** · **48.01% avg net margin**
- **81.02% expense ratio** — $0.81 of every $1 revenue goes to operating costs
- **77.07% Excellent** financial status · **71.3% High Performers**

### Regional Performance
| Region | Revenue | Net Profit | Margin | ROI |
|--------|---------|-----------|--------|-----|
| **South** | **$954.8M** | $281.2M | 47.67% | **19.04%** |
| West | $946.2M | $269.4M | 46.62% | 18.36% |
| Central | $945.8M | $275.9M | 47.89% | 18.71% |
| North | $941.8M | $275.3M | 48.69% | 18.11% |
| **East** | $879.0M | $262.2M | **49.20%** | 18.54% |

### Department Performance
| Department | Revenue | Margin | Expense Ratio |
|-----------|---------|--------|--------------|
| **Audit** | **$801.4M** | 48.47% | 81.92% |
| Accounts | $794.6M | 47.65% | 80.59% |
| Treasury | $789.7M | 45.67% | 80.46% |
| **Investment** | $776.4M | **50.49%** | 83.25% |
| Operations | $763.3M | 46.79% | **77.72%** ← Most efficient |
| Risk | $742.3M | 48.96% | 82.13% |

### Top / Bottom Branches
| Rank | Branch | Margin | Performance |
|------|--------|--------|-------------|
| #1 | **1025** | **64.33%** | 90.66 |
| #2 | 1005 | 62.20% | 89.72 |
| #3 | 1026 | 61.73% | 89.63 |
| #99 | 1077 | 38.14% | 91.46 |
| #100 | **1017** | **36.32%** | 90.94 |

> **28pp gap** between best and worst branch — all branches maintain high performance scores regardless of margin

### 🔑 Key Risk Finding
**Profit category and risk level are INDEPENDENT:**
- High profit (40%+) margins average ~100% across ALL risk levels
- Low profit (<10%) averages ~17% regardless of risk level
- High-margin transactions do NOT carry elevated fraud risk — pursue them freely

---

## 📊 KPI Summary

| KPI | Value | KPI | Value |
|-----|-------|-----|-------|
| Total Revenue | **$4.67B** | Total Net Profit | **$1.36B** |
| Total Operating Cost | $2.29B | Total EBITDA | $1.14B |
| Avg Net Margin % | **48.01%** | Avg ROI % | **18.56%** |
| Avg Gross Margin % | 37.86% | Avg Expense Ratio % | 81.02% |
| Avg Performance Score | 90.45 | Avg Compliance Score | 80.03 |
| Excellent Status | 6,859 (77.07%) | Poor Status | 259 (2.91%) |
| Top Branch | 1025 — 64.33% | Bottom Branch | 1017 — 36.32% |
| Top Region (Revenue) | South $954.8M | Top Region (Margin) | East 49.20% |
| Top Dept (Margin) | Investment 50.49% | Most Cost-Efficient | Operations 77.72% |

---

## ⚡ Challenges & Solutions

**Challenge 1 — Dataset Doesn't Match Workflow Brief**
Brief said "multi-company, YoY growth." Actual data has no Company or Date column. EDA caught this before any SQL written → redesigned to use Region/Branch as business unit equivalents.

**Challenge 2 — 6 Negative Sensor Values**
Network_Latency_ms and Transaction_Processing_Time_ms had 3 negative values each — physically impossible. Fixed with `abs()` preserving magnitude.

**Challenge 3 — Waterfall Chart Configuration**
Power BI waterfall requires specific Category/Y-axis/Breakdown mapping. Configured Financial_Status as Category, Total Revenue as Y-axis for revenue distribution breakdown.

**Challenge 4 — 100 Branches Unreadable in Bar Chart**
100 bars cramped in one visual. Fixed: Filters pane → Top N / Bottom N filters showing only top/bottom 10 dynamically.

**Challenge 5 — Risk-Profit Independence Discovery**
Q6 cross-analysis revealed profit category and risk level are completely independent — an unexpected but valuable portfolio insight.

---

## 🎓 Skills Learned

- **EDA-Driven Workflow Redesign** — Adapting entire project plan when actual data differs from brief
- **Financial Ratio Engineering** — 7 ratios pre-computed in Python before SQL/BI work
- **Excel as Analytical Layer** — PivotTables, conditional formatting, formula-driven KPI Summary
- **Waterfall Chart Design** — Power BI native waterfall field configuration
- **Top N Filter** — Dynamic branch ranking without fixed filters
- **Risk-Profit Cross Analysis** — GROUP BY cross-dimensional query revealing portfolio independence

---

## 🎨 Custom Theme

`Corporate_Finance_Gold_Dark_Theme.json` — Apply via **View → Themes → Browse for themes**

| Element | Color | Meaning |
|---------|-------|---------|
| Canvas | `#1C1C2E` — Deep Corporate Dark | Premium finance identity |
| Visuals | `#252540` — Dark Navy | Executive dashboard aesthetic |
| KPI Borders + Numbers | `#D4AF37` — Corporate Gold | Financial authority |
| Highlight | `#4CAF50` — Green | Positive performance |
| Data Colors | Gold · Blue · Green · Red | Standard finance palette |

---

## 📂 Repository Structure

```
financial-performance-dashboard/
│
├── 📊 Financial_Performance_Dashboard.pbix
├── 📁 Dataset/
│   └── IoT_Financial_Management_Dataset.csv
├── 📁 Python/
│   └── clean_financial_data.py
├── 📁 Clean/
│   └── financial_clean.csv
├── 📁 Excel/
│   └── Financial_Performance_Analysis.xlsx
├── 📁 MySQL/
│   ├── create_table.sql
│   ├── load_data.sql
│   └── analytical_queries.sql
├── 📁 Theme/
│   └── Corporate_Finance_Gold_Dark_Theme.json
├── 📄 Financial_Performance_Portfolio_Documentation.pdf
└── 📄 README.md
```


---

*Data Analytics · K.S.*
