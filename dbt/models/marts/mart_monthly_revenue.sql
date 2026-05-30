{{ config(materialized='table') }}

with sales as (
    select * from {{ ref('int_sales_enriched') }}
)

select 
    date_trunc('month', "SalesDate"::timestamp) as "SalesMonth",
    "CategoryName",
    sum("NetAmount") as "TotalRevenue",
    sum("Quantity") as "TotalQuantity",
    count(distinct "TransactionNumber") as "TotalTransactions"
from sales
group by 1, 2
