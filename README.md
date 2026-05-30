# 🛒 FMCG Store Analyst - End-to-End Modern Data Pipeline

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![Apache Airflow](https://img.shields.io/badge/Airflow-017CEE?style=for-the-badge&logo=Apache%20Airflow&logoColor=white)
![Power BI](https://img.shields.io/badge/PowerBI-F2C811?style=for-the-badge&logo=Power%20BI&logoColor=black)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)

## 📌 Project Overview
This project simulates an **End-to-End Modern Data Stack (MDS)** pipeline for a multinational FMCG (Fast-Moving Consumer Goods) retail chain. 

The goal of this project is to ingest raw transactional data, transform it into a robust Star Schema, and visualize the actionable insights to answer **strategic business questions** regarding Revenue, Product Performance, Customer Behavior, and Employee KPIs. This robust pipeline ensures data is accurate, up-to-date, and readily available for business decision-making.

## 🏗️ Architecture & Tech Stack (ELT Approach)

![Project Architecture](images/Project_Architecture.jpg)

The pipeline follows the modern **ELT (Extract, Load, Transform)** paradigm, ensuring scalable and maintainable data processing:
1. **Extract & Load (EL):** `Python` (`pandas`, `sqlalchemy`) is used to extract raw data from `.csv` files and load it directly into a local Data Warehouse. This approach minimizes data manipulation outside the warehouse.
2. **Data Warehouse:** `PostgreSQL` powered by local `Supabase`. It provides a reliable and performant relational database environment.
3. **Transform (T):** `dbt` (Data Build Tool) is used to transform raw data through 3 logical layers: `staging` ➡️ `intermediate` ➡️ `marts`. This enforces software engineering best practices in SQL.
4. **Orchestration:** `Apache Airflow` (running on Docker) combined with `astronomer-cosmos` to automatically orchestrate the dbt models as individual DAG tasks. This allows fine-grained monitoring and dependency management.
5. **Data Visualization:** `Power BI` connects directly to the `marts` schema to deliver a highly interactive, 2-page C-level dashboard.

## 🗃️ Data Modeling (dbt)
The transformation logic is strictly organized into 3 conceptual layers to build a Kimball-style dimensional model:

### Raw Data Schema (ERD)
![Raw Data Schema](images/raw_data_schema.png)

*   **Staging (`stg_`):** Base views focusing on type casting, renaming, and basic deduplication. (e.g., `stg_sales`, `stg_customers`). These are exactly 1:1 with the raw tables but cleaned.
*   **Intermediate (`int_`):** Denormalized tables linking facts with dimensions (e.g., `int_sales_enriched`, `int_customer_geography`). This layer houses complex business logic and joins.
*   **Marts (`mart_`):** Highly aggregated, business-ready tables optimized for BI tools. They serve as the single source of truth for downstream reporting.
    *   `mart_monthly_revenue`: Tracks revenue trends over time.
    *   `mart_product_performance`: Analyzes top-selling products and categories.
    *   `mart_customer_behavior`: Segments customers by purchasing habits.
    *   `mart_employee_performance`: Evaluates staff KPIs and consistency.
    *   `mart_geographic_revenue`: Maps sales across different regions.

## 🚀 How to Run the Project Locally

### Prerequisites
*   Docker & Docker Compose
*   Python 3.10+
*   Supabase CLI

### Step-by-Step Setup

**1. Clone the repository & Setup Environment**
```bash
git clone https://github.com/YourUsername/FMCG-Store-Analyst-Data-Pipeline.git
cd FMCG-Store-Analyst-Data-Pipeline
python -m venv .venv
source .venv/Scripts/activate  # Windows: .venv\Scripts\activate
pip install -r docs/requirements.txt
```

**2. Start the Data Warehouse (Supabase)**
```bash
cd supabase
supabase start
```
*(The Postgres database will be available at `postgresql://postgres:postgres@localhost:54322/postgres`)*

**3. Download and Ingest Raw Data**
> [!NOTE]
> The raw CSV files are not included in this repository. Please download the dataset from [[Dataset Link Here](https://drive.google.com/drive/folders/1rtawsOtllVE3FUwRZx7slywGLLU7mvol?fbclid=IwY2xjawSHZXBleHRuA2FlbQIxMABicmlkETF3dTMyYXNUN0dZY3hHb3Y5c3J0YwZhcHBfaWQQMjIyMDM5MTc4ODIwMDg5MgABHt1x4HVj2a3FeeDvAUEUUY0rmLk4TAZCHY4gzNCtWTNQ5SJEkwemAT9_ZFkf_aem_Ku_odymbV_1bzKWFssJkfQ)] and extract the `.csv` files into the `datasets/` folder.

```bash
python scripts/load_data.py
```
*(This extracts CSVs from `/datasets` and loads them into the `raw` schema).*

**4. Start Airflow (Orchestration)**
```bash
cd airflow
docker-compose up -d
```
*   Access Airflow UI at: `http://localhost:8080` (admin/admin).
*   Create a Postgres Connection named `supabase_postgres` inside Airflow.
*   Trigger the `fmcg_dbt_pipeline` DAG to execute the entire dbt transformation flow.

## 📈 Power BI Dashboard
The repository contains the final Power BI file (`.pbix`). The dashboard is designed following a **Traditional 2-Page Navigation** layout to serve different analytical needs:

### Page 1: Revenue Performance
Focuses on overall financial health, top-selling categories, product matrix (loss leaders vs star products), and global geographic distribution.

![Revenue Performance Dashboard](images/Revenue_Performance.png)

### Page 2: Operational Insights
Highlights customer retention rates (Repeat vs One-time), VIP customer segmentation, and employee consistency trends using Small Multiples line charts.

![Operational Insights Dashboard](images/Operational_Insights.png)


## 📁 Repository Structure
```text
📦 FMCG-Store-Analyst-Data-Pipeline
 ┣ 📂 airflow/            # Docker setup and Airflow DAGs (fmcg_dbt_dag.py)
 ┣ 📂 datasets/           # Raw CSV files
 ┣ 📂 dbt/                # dbt project containing SQL models (stg, int, marts)
 ┣ 📂 scripts/            # Python EL scripts (load_data.py)
 ┣ 📂 supabase/           # Local Supabase configuration
 ┣ 📂 images/             # Documentation images
 ┣ 📜 .gitignore
 ┗ 📜 README.md
```

---
