CREATE DATABASE IF NOT EXISTS financial_project;
USE financial_project;

DROP TABLE IF EXISTS financial_data;

CREATE TABLE financial_data (
    Transaction_ID                  VARCHAR(15) PRIMARY KEY,
    Branch_ID                       SMALLINT,
    Device_ID                       VARCHAR(15),
    Region                          VARCHAR(10),
    Department                      VARCHAR(15),
    Smart_Terminal_Usage            DECIMAL(6,2),
    ERP_Response_Time_ms            DECIMAL(8,2),
    Network_Latency_ms              DECIMAL(8,2),
    Sensor_Data_Integrity           DECIMAL(6,2),
    Connected_Devices_Count         SMALLINT,
    Cloud_Sync_Delay_s              DECIMAL(5,2),
    System_Uptime                   DECIMAL(6,2),
    API_Request_Rate                INT,
    Transaction_Processing_Time_ms  DECIMAL(8,2),
    Device_Error_Rate               DECIMAL(5,2),
    Revenue                         DECIMAL(12,2),
    Net_Profit                      DECIMAL(12,2),
    Operating_Cost                  DECIMAL(12,2),
    Gross_Margin                    DECIMAL(6,2),
    ROI                             DECIMAL(6,2),
    EBITDA                          DECIMAL(12,2),
    Current_Ratio                   DECIMAL(5,2),
    Quick_Ratio                     DECIMAL(5,2),
    Cash_Flow                       DECIMAL(12,2),
    Working_Capital                 DECIMAL(12,2),
    Debt_to_Equity                  DECIMAL(5,2),
    Resource_Utilization            DECIMAL(6,2),
    Energy_Consumption_kWh          DECIMAL(8,2),
    Maintenance_Cost                DECIMAL(10,2),
    Transaction_Cost                DECIMAL(8,2),
    Automation_Efficiency           DECIMAL(6,2),
    Fraud_Risk_Score                DECIMAL(5,3),
    Credit_Risk_Level               DECIMAL(5,3),
    Security_Breach_Attempts        TINYINT,
    Compliance_Score                DECIMAL(6,2),
    Market_Volatility_Index         DECIMAL(6,2),
    Anomaly_Score                   DECIMAL(5,3),
    Performance_Score               DECIMAL(6,2),
    Financial_Status                VARCHAR(15),
    Net_Profit_Margin_Pct           DECIMAL(8,2),
    Expense_Ratio_Pct               DECIMAL(8,2),
    Gross_Profit                    DECIMAL(12,2),
    EBITDA_Margin_Pct               DECIMAL(8,2),
    Profit_Category                 VARCHAR(25),
    Risk_Level                      VARCHAR(15),
    Is_High_Performer               TINYINT(1)
);

USE financial_project;
SET SESSION sql_mode = '';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/financial_clean.csv'
INTO TABLE financial_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM financial_data;
-- Should show: 8,900 ✅

SELECT * FROM financial_data LIMIT 3;

CREATE INDEX idx_region      ON financial_data(Region);
CREATE INDEX idx_dept        ON financial_data(Department);
CREATE INDEX idx_branch      ON financial_data(Branch_ID);
CREATE INDEX idx_status      ON financial_data(Financial_Status);
CREATE INDEX idx_profit_cat  ON financial_data(Profit_Category);
CREATE INDEX idx_risk        ON financial_data(Risk_Level);

-- Query 1 — Overall KPIs:
SELECT
    COUNT(*)                                 AS total_transactions,
    ROUND(SUM(Revenue),2)                   AS total_revenue,
    ROUND(SUM(Net_Profit),2)               AS total_net_profit,
    ROUND(SUM(Operating_Cost),2)           AS total_operating_cost,
    ROUND(SUM(EBITDA),2)                   AS total_ebitda,
    ROUND(AVG(Net_Profit_Margin_Pct),2)    AS avg_net_margin_pct,
    ROUND(AVG(Gross_Margin),2)             AS avg_gross_margin_pct,
    ROUND(AVG(ROI),2)                      AS avg_roi_pct,
    ROUND(AVG(Expense_Ratio_Pct),2)        AS avg_expense_ratio_pct,
    ROUND(AVG(Performance_Score),2)        AS avg_performance_score,
    ROUND(AVG(Compliance_Score),2)         AS avg_compliance_score
FROM financial_data;

-- Query 2 — Financial Status Distribution:
SELECT
    Financial_Status,
    COUNT(*)                                AS transaction_count,
    ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM financial_data),2) AS pct_share,
    ROUND(AVG(Revenue),2)                  AS avg_revenue,
    ROUND(AVG(Net_Profit_Margin_Pct),2)   AS avg_net_margin_pct,
    ROUND(AVG(Performance_Score),2)        AS avg_performance
FROM financial_data
GROUP BY Financial_Status
ORDER BY avg_net_margin_pct DESC;

-- Query 3 — Performance by Region:
SELECT
    Region,
    COUNT(*)                                AS total_txns,
    ROUND(SUM(Revenue),2)                  AS total_revenue,
    ROUND(SUM(Net_Profit),2)              AS total_net_profit,
    ROUND(AVG(Net_Profit_Margin_Pct),2)   AS avg_net_margin_pct,
    ROUND(AVG(ROI),2)                     AS avg_roi,
    ROUND(AVG(Gross_Margin),2)            AS avg_gross_margin,
    ROUND(AVG(Compliance_Score),2)        AS avg_compliance
FROM financial_data
GROUP BY Region
ORDER BY total_revenue DESC;

-- Query 4 — Performance by Department:
SELECT
    Department,
    COUNT(*)                                AS total_txns,
    ROUND(SUM(Revenue),2)                  AS total_revenue,
    ROUND(SUM(Net_Profit),2)              AS total_net_profit,
    ROUND(AVG(Net_Profit_Margin_Pct),2)   AS avg_net_margin_pct,
    ROUND(AVG(Expense_Ratio_Pct),2)       AS avg_expense_ratio,
    ROUND(AVG(ROI),2)                     AS avg_roi,
    ROUND(AVG(Fraud_Risk_Score),3)        AS avg_fraud_risk
FROM financial_data
GROUP BY Department
ORDER BY total_revenue DESC;

-- Query 5 — Top 10 & Bottom 10 Branches by Net Profit Margin:
-- Top 10
SELECT
    Branch_ID,
    COUNT(*)                               AS total_txns,
    ROUND(AVG(Net_Profit_Margin_Pct),2)   AS avg_net_margin_pct,
    ROUND(AVG(Revenue),2)                 AS avg_revenue,
    ROUND(AVG(ROI),2)                     AS avg_roi,
    ROUND(AVG(Performance_Score),2)       AS avg_performance
FROM financial_data
GROUP BY Branch_ID
ORDER BY avg_net_margin_pct DESC
LIMIT 10;

-- Bottom 10
SELECT
    Branch_ID,
    COUNT(*)                               AS total_txns,
    ROUND(AVG(Net_Profit_Margin_Pct),2)   AS avg_net_margin_pct,
    ROUND(AVG(Revenue),2)                 AS avg_revenue,
    ROUND(AVG(ROI),2)                     AS avg_roi,
    ROUND(AVG(Performance_Score),2)       AS avg_performance
FROM financial_data
GROUP BY Branch_ID
ORDER BY avg_net_margin_pct ASC
LIMIT 10;

-- Query 6 — Profit Category & Risk Level Cross Analysis:
SELECT
    Profit_Category,
    Risk_Level,
    COUNT(*)                               AS txn_count,
    ROUND(AVG(Revenue),2)                 AS avg_revenue,
    ROUND(AVG(Net_Profit_Margin_Pct),2)   AS avg_margin,
    ROUND(AVG(Compliance_Score),2)        AS avg_compliance
FROM financial_data
GROUP BY Profit_Category, Risk_Level
ORDER BY Profit_Category, Risk_Level;

-- Query 7 — Create Analytical VIEW:
CREATE OR REPLACE VIEW vw_financial_summary AS
SELECT
    Region,
    Department,
    Financial_Status,
    Profit_Category,
    Risk_Level,
    COUNT(*)                               AS txn_count,
    ROUND(SUM(Revenue),2)                 AS total_revenue,
    ROUND(SUM(Net_Profit),2)             AS total_net_profit,
    ROUND(SUM(Operating_Cost),2)         AS total_operating_cost,
    ROUND(SUM(EBITDA),2)                 AS total_ebitda,
    ROUND(AVG(Net_Profit_Margin_Pct),2)  AS avg_net_margin_pct,
    ROUND(AVG(Gross_Margin),2)           AS avg_gross_margin,
    ROUND(AVG(ROI),2)                    AS avg_roi,
    ROUND(AVG(Expense_Ratio_Pct),2)      AS avg_expense_ratio,
    ROUND(AVG(Performance_Score),2)      AS avg_performance_score,
    ROUND(AVG(Compliance_Score),2)       AS avg_compliance_score,
    ROUND(AVG(Fraud_Risk_Score),3)       AS avg_fraud_risk
FROM financial_data
GROUP BY Region, Department, Financial_Status, Profit_Category, Risk_Level;