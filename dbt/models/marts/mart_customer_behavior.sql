{{ config(materialized='table') }}

with sales as (
    select * from {{ ref('int_sales_enriched') }}
),
customer_geo as (
    select * from {{ ref('int_customer_geography') }}
)

select 
    s."CustomerID",
    c."CustomerName",
    count(distinct s."TransactionNumber") as "TotalOrders",
    sum(s."NetAmount") as "TotalRevenue",
    sum(s."Quantity") as "TotalItemsBought",
    (sum(s."NetAmount") / count(distinct s."TransactionNumber")) as "AverageOrderValue",
    (sum(s."Quantity") * 1.0 / count(distinct s."TransactionNumber")) as "AverageBasketSize",
    min(s."SalesDate") as "FirstPurchaseDate",
    max(s."SalesDate") as "LastPurchaseDate"
from sales s
left join customer_geo c on s."CustomerID" = c."CustomerID"
group by 1, 2
