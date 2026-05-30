{{ config(materialized='table') }}

with sales as (
    select * from {{ ref('int_sales_enriched') }}
),
emp_geo as (
    select * from {{ ref('int_employee_geography') }}
)

select 
    s."EmployeeID",
    e."EmployeeName",
    date_trunc('month', s."SalesDate"::timestamp) as "SalesMonth",
    count(distinct s."TransactionNumber") as "TotalOrdersHandled",
    sum(s."NetAmount") as "TotalRevenueGenerated",
    sum(s."Quantity") as "TotalItemsSold"
from sales s
left join emp_geo e on s."EmployeeID" = e."EmployeeID"
group by 1, 2, 3
