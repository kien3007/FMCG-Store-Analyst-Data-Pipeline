{{ config(materialized='table') }}

with sales as (
    select * from {{ ref('int_sales_enriched') }}
),
customer_geo as (
    select * from {{ ref('int_customer_geography') }}
)

select 
    c."CountryName",
    c."CityName",
    sum(s."NetAmount") as "TotalRevenue",
    sum(s."Quantity") as "TotalQuantity",
    count(distinct s."TransactionNumber") as "TotalOrders",
    count(distinct s."CustomerID") as "UniqueCustomers"
from sales s
left join customer_geo c on s."CustomerID" = c."CustomerID"
group by 1, 2
