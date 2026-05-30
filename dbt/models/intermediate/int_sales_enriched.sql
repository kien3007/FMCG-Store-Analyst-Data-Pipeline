{{ config(materialized='table') }}

with sales as (
    select * from {{ ref('stg_sales') }}
),
products as (
    select * from {{ ref('stg_products') }}
),
categories as (
    select * from {{ ref('stg_categories') }}
)

select
    s."SalesID",
    s."SalesPersonID" as "EmployeeID",
    s."CustomerID",
    s."ProductID",
    s."Quantity",
    s."Discount",
    s."SalesDate",
    s."TransactionNumber",
    p."ProductName",
    p."Price",
    p."CategoryID",
    c."CategoryName",
    (s."Quantity" * p."Price") as "GrossAmount",
    (s."Quantity" * p."Price" * s."Discount") as "DiscountAmount",
    (s."Quantity" * p."Price" * (1 - s."Discount")) as "NetAmount"
from sales s
left join products p on s."ProductID" = p."ProductID"
left join categories c on p."CategoryID" = c."CategoryID"
