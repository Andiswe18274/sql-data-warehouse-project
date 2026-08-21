# Data Warehouse and Analytics Project

Welcome to my **Data Warehouse and Analytics Project** repository!
This project demonstrates a complete end-to-end data warehousing and analytics solution — from building a data warehouse to generating actionable business insights.

---

## 🏗️ Data Architecture

The data architecture for this project follows the **Medallion Architecture** with three layers:

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV files into a MySQL database.
2. **Silver Layer**: Includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema optimized for reporting and analytics.

---

## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a modern data warehouse using Medallion Architecture (Bronze, Silver, and Gold layers).
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable business insights.

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using MySQL to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

### BI: Analytics & Reporting (Data Analysis)

#### Objective
Develop SQL-based analytics to deliver detailed insights into:

- **Customer Behavior** — Top customers, segmentation, revenue by country and gender
- **Product Performance** — Best sellers, category revenue, profitability and margins
- **Sales Trends** — Monthly and yearly trends, month-over-month growth, shipping performance.

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

---

## 📊 Analytics Highlights

### Customer Insights
- Total revenue and orders per customer
- Customer segmentation: **VIP / Regular / Low Value**
- Revenue breakdown by country, gender, and marital status

### Product Insights
- Top products by revenue and units sold
- Profit margin analysis (revenue vs cost)
- Slow-moving product identification

### Sales Trends
- Monthly and yearly revenue trends
- Month-over-Month (MoM) revenue growth %
- Shipping performance (average days to ship)
- Revenue by product line over time

### Executive KPIs
- Total orders, customers, products sold, and revenue in a single summary view

---

## 📂 Repository Structure

```
sql-data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # Draw.io file showing ETL techniques and methods
│   ├── data_architecture.drawio        # Draw.io file showing the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables and columns
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models (star schema)
│   ├── analytics/                      # SQL-based analytics and reporting queries
│       └── analytics_reports.sql       # Business intelligence queries (customers, products, sales)
│
├── tests/                              # Test scripts and data quality checks
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
└── requirements.txt                    # Dependencies and requirements for the project
```

---

## 🛠️ Tools & Technologies

- **Database**: MySQL
- **Language**: SQL
- **Version Control**: Git & GitHub
- **Documentation**: Draw.io, Markdown
- **Architecture Pattern**: Medallion Architecture (Bronze / Silver / Gold)
- **Data Modeling**: Star Schema (Fact & Dimension tables)

---

## ✅ Project Status

| Phase | Status |
|---|---|
| Bronze Layer — Raw Data Ingestion | ✅ Complete |
| Silver Layer — Data Cleaning & Transformation | ✅ Complete |
| Gold Layer — Star Schema Modeling | ✅ Complete |
| Analytics & Reporting | ✅ Complete |

---

## 🎯 Skills Demonstrated

This project showcases expertise in:
- SQL Development
- Data Architecture & Engineering
- ETL Pipeline Development
- Data Modeling (Star Schema)
- Business Intelligence & Analytics
- Git & GitHub Version Control

---

## About

Building a modern data warehouse using MySQL, including ETL processes, data modelling, and analytics.DME.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
├── .gitignore                          # Files and directories to be ignored by Git
└── requirements.txt                    # Dependencies and requirements for the project
```
---
