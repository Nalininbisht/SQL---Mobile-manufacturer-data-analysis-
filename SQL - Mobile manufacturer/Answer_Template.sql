use db_SQLCaseStudies
 
--Q1--BEGIN 	List all the states in which we have customers who have bought cellphones from 2005 till today. 
select X.[state],date  from FACT_TRANSACTIONS as Y
 inner join
DIM_LOCATION as X on X.IDLocation=Y.IDLocation
group by [state],[date]
having year(date)>=2005
and year(date)<=2024

--Q1--END



--Q2--BEGIN   What state in the US is buying the most 'Samsung' cell phones?
select top 1 X.IDManufacturer,Y.Country,Y.[state], sum(quantity) as mobile_sold from FACT_TRANSACTIONS as Z
  inner join
DIM_MODEL as X on X.IDModel=Z.IDModel
  inner join
DIM_LOCATION as Y on Y.IDLocation=Z.IDLocation
where country='us'and idmanufacturer in (12)
group by idmanufacturer, Country,[state]




--Q2--END

--Q3--BEGIN  Show the number of transactions for each model per zip code per state.     
	
select X.model_name, Y.zipcode,[state] ,count(IDCustomer) as [no. of transactions]from FACT_TRANSACTIONS as Z
  inner join
DIM_MODEL as X on X.IDModel=Z.IDModel
  inner join
DIM_LOCATION as Y on Y.IDLocation=Z.IDLocation
group by Model_Name,ZipCode,[State]



--Q3--END

--Q4--BEGIN  Show the cheapest cellphone (Output should contain the price also)
select top 1 model_name, unit_price from DIM_MODEL
order by Unit_price asc



--Q4--END

--Q5--BEGIN   5. Find out the average price for each model in the top5 manufacturers in terms of sales quantity and order by average price.


select X.IDManufacturer, X.manufacturer_name ,Y.model_name,avg(totalprice) from FACT_TRANSACTIONS as Z
  inner join
DIM_MODEL as Y on Y.IDModel=Z.IDModel
  inner join 
DIM_MANUFACTURER as X on X.IDManufacturer=Y.IDManufacturer
group by X.manufacturer_name ,Y.model_name,X.IDManufacturer




select X.IDManufacturer, X.manufacturer_name ,Y.model_name,avg(totalprice) from FACT_TRANSACTIONS as Z
  inner join
DIM_MODEL as Y on Y.IDModel=Z.IDModel
  inner join 
DIM_MANUFACTURER as X on X.IDManufacturer=Y.IDManufacturer

where X.IDManufacturer in ( select top 5 X.IDManufacturer  from FACT_TRANSACTIONS as y join
DIM_MODEL as X on Y.IDModel=x.IDModel
group by X.IDManufacturer
                              order by sum(quantity) desc )
 group by X.manufacturer_name ,Y.model_name,X.IDManufacturer


--Q5--END

--Q6--BEGIN   List the names of the customers and the average amount spent in 2009, where the average is higher than 500  

select X.idcustomer,X.customer_name, avg(totalprice) as avg_amt from FACT_TRANSACTIONS as Y
inner join 
DIM_CUSTOMER as X on X.IDCustomer=Y.IDCustomer
where year(date)=2009
group by X.IDCustomer,Customer_Name,[date]
having avg(totalprice)>500 
           
		


--Q6--END
	
--Q7--BEGIN  . List if there is any model that was in the top 5 in terms of quantity, simultaneously in 2008, 2009 and 2010 

select X.IDModel,X.model_name from FACT_TRANSACTIONS as Y
  inner join
DIM_MODEL as X on X.IDModel=Y.IDModel
group by  X.Model_Name,X.IDModel
having X.IDModel in( select top 5 IDModel from FACT_TRANSACTIONS where year(date)=2008
group by IDModel  order by sum(quantity) desc
      intersect
select top 5 IDModel from FACT_TRANSACTIONS where year(date)=2009 
group by IDModel order by sum(quantity) desc
      intersect
select top 5 IDModel from FACT_TRANSACTIONS where year(date)=2010
group by IDModel order by sum(quantity) desc)	
	

--Q7--END


--Q8--BEGIN   Show the manufacturer with the 2nd top sales in the year of 2009 and the manufacturer with the 2nd top sales in the year of 2010.

select* from(
  select Manufacturer_Name, sum(TotalPrice) as qty,
  DENSE_RANK() over( order by sum(TotalPrice) desc) as ranks
  from FACT_TRANSACTIONS as X
  inner join DIM_MODEL as Y
  on X.IDModel = Y.IDModel
  inner join DIM_MANUFACTURER as Z
  on Z.IDManufacturer = Y.IDManufacturer
  where year(Date) = 2009
  group by Manufacturer_Name
      union all
  select Manufacturer_Name, sum(TotalPrice) as qty, 
  DENSE_RANK() over( order by sum(TotalPrice) desc) as ranks
  from FACT_TRANSACTIONS as X
  inner join DIM_MODEL as Y
  on X.IDModel = Y.IDModel
  inner join DIM_MANUFACTURER as z
  on Z.IDManufacturer = Y.IDManufacturer
  where year(Date) = 2010
  group by Manufacturer_Name) T1
where ranks=2


--Q8--END
--Q9--BEGIN  9. Show the manufacturers that sold cellphones in 2010 but did not in 2009
select distinct(Y.manufacturer_name)  from DIM_MODEL as Z
inner join 
DIM_MANUFACTURER as Y on Z.IDManufacturer=Y.IDManufacturer
inner join
FACT_TRANSACTIONS as X on X.IDModel=Z.IDModel
where year(date) in (2010)
group by Quantity,Manufacturer_Name,Z.IDManufacturer,year(date)
                 except
select distinct(Y.manufacturer_name)  from DIM_MODEL as Z
inner join 
DIM_MANUFACTURER as Y on Z.IDManufacturer=Y.IDManufacturer
inner join
FACT_TRANSACTIONS as X on X.IDModel=Z.IDModel
where year(date) in (2009)
group by Quantity,Manufacturer_Name,Z.IDManufacturer,year(date)
	

--Q9--END

	