{{ config(materialized='table') }}

with sales as (
    select * from {{ ref('int_sales_enriched') }}
),
products as (
    select * from {{ ref('stg_products') }}
)

select 
    s."ProductID",
    s."ProductName",
    s."CategoryName",
    p."Class",
    sum(s."Quantity") as "TotalQuantitySold",
    sum(s."NetAmount") as "TotalRevenue",
    count(distinct s."TransactionNumber") as "OrderCount"
from sales s
left join products p on s."ProductID" = p."ProductID"
group by 1, 2, 3, 4
