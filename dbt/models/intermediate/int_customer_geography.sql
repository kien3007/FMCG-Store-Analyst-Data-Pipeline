{{ config(materialized='table') }}

with customers as (
    select * from {{ ref('stg_customers') }}
),
cities as (
    select * from {{ ref('stg_cities') }}
),
countries as (
    select * from {{ ref('stg_countries') }}
)

select 
    c."CustomerID",
    c."FirstName",
    c."LastName",
    c."FirstName" || ' ' || c."LastName" as "CustomerName",
    c."CityID",
    c."Address",
    ci."CityName",
    ci."Zipcode",
    co."CountryID",
    co."CountryName",
    co."CountryCode"
from customers c
left join cities ci on c."CityID" = ci."CityID"
left join countries co on ci."CountryID" = co."CountryID"
