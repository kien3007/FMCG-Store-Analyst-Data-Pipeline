{{ config(materialized='table') }}

with employees as (
    select * from {{ ref('stg_employees') }}
),
cities as (
    select * from {{ ref('stg_cities') }}
),
countries as (
    select * from {{ ref('stg_countries') }}
)

select 
    e."EmployeeID",
    e."FirstName",
    e."LastName",
    e."FirstName" || ' ' || e."LastName" as "EmployeeName",
    e."BirthDate",
    e."Gender",
    e."HireDate",
    e."CityID",
    ci."CityName",
    co."CountryName"
from employees e
left join cities ci on e."CityID" = ci."CityID"
left join countries co on ci."CountryID" = co."CountryID"
