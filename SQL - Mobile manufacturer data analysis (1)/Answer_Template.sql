--SQL Advance Case Study

--1.LIST ALL THE STATES IN WHICH WE HAVE CUSTOMERS WHO HAVE BOUGHT
--CELLPHONES FROM 2005 TILL TODAY

--Q1--BEGIN 
	
	select distinct [State] from DIM_LOCATION A 
	join FACT_TRANSACTIONS B on A.IDLocation=B.IDLocation 
	join DIM_CUSTOMER C on B.IDCustomer=C.IDCustomer
	where  YEAR(B.[date]) >=2005


--Q1--END


--2.what state in the US is buying the most 'samsung' cell phones?

--Q2--BEGIN
  

	select DISTINCT Country,[state] from DIM_LOCATION  A 
	join FACT_TRANSACTIONS B on A.IDLocation=B.IDLocation
	join DIM_MODEL C on B.IDModel=C.IDModel
	join DIM_MANUFACTURER D on C.IDManufacturer=D.IDManufacturer
	where Country='US' AND Manufacturer_Name='SAMSUNG'


--Q2--END


--3.show the number of transactions for each model per zip code per state?

--Q3--BEGIN 


	select distinct c.Model_Name, B.zipcode,B.state,count( A.idmodel)as num_transactions from FACT_TRANSACTIONS A 
	join DIM_LOCATION B on A.IDLocation=B.IDLocation
	join DIM_MODEL C on A.IDModel=C.IDModel
	group by C.model_name, B.zipcode,B.state


--Q3--END


--4.show the cheapest cellphone(output should contain the price also)

--Q4--BEGIN


	select top 1 Model_Name,MIN(totalprice) as price_list from DIM_MODEL A
	left join FACT_TRANSACTIONS B on A.IDModel=B.IDModel 
	group by Model_Name


--Q4--END

--5.find out the average price for each model in the top 5 manufacturers in terms of sales quantity and order by average price.

--Q5--BEGIN


	select top 5 Manufacturer_Name, model_name,max(Quantity) as sales_quantity, avg(totalprice) as average_price from DIM_MANUFACTURER A 
	join DIM_MODEL B on A.IDManufacturer=B.IDManufacturer
	join FACT_TRANSACTIONS C on B.IDModel=C.IDModel
	group by Manufacturer_Name,Model_Name
	order by avg(totalprice) desc

    
--Q5--END


--6.list the names of the customer and the average amount spent in 2009,where the average is higher than 500.

--Q6--BEGIN


	select customer_name,avg(totalprice)as avg_amount from DIM_CUSTOMER A 
	join FACT_TRANSACTIONS B on A.IDCustomer=B.IDCustomer
	where YEAR([date])=2009
	group by Customer_Name
	having AVG(totalprice)>500
	order by avg_amount desc 


--Q6--END

--7.list if there is any model that was in the top5 in terms of quantity,simultaneously in 2008,2009 and 2010

--Q7--BEGIN  

 select top 5 * from (
		select model_name,sum(quantity) as qty from DIM_MODEL A 
		join FACT_TRANSACTIONS B on A.IDModel=B.IDModel and year(date)=2008
		group by Model_Name
 union all
		select model_name,sum(quantity) as qty from DIM_MODEL A 
		join FACT_TRANSACTIONS B on A.IDModel=B.IDModel and year(date)=2009
		group by Model_Name
 union all
		select model_name,sum(quantity) as qty from DIM_MODEL A 
		join FACT_TRANSACTIONS B on A.IDModel=B.IDModel and year(date)=2010
		group by Model_Name)top_5_mob
 order by qty desc


--Q7--END	

--8.show the manufacturer with the 2nd top sales in the year of 2009 and the manufacturer with the 2nd top sales in the year of 2010
--Q8--BEGIN

	select * from (
		select '2009 2nd top' as In_the_year ,Manufacturer_Name from (
			select *,DENSE_RANK() over(order by sales desc) as top_n_sales from(
				select Manufacturer_Name,sum(totalprice) as sales from DIM_MANUFACTURER A 
				join DIM_MODEL B on A.IDManufacturer=B.IDManufacturer
				join FACT_TRANSACTIONS C on B.IDModel=C.IDModel and YEAR(date)=2009
				group by Manufacturer_Name)T1)T1
				where top_n_sales=2
	union
	select '2010 2nd top' as In_the_year,Manufacturer_Name from (
		select *,DENSE_RANK() over(order by sales desc) as top_n_sales from(
			select Manufacturer_Name,sum(totalprice) as sales from DIM_MANUFACTURER A 
			join DIM_MODEL B on A.IDManufacturer=B.IDManufacturer
			join FACT_TRANSACTIONS C on B.IDModel=C.IDModel and YEAR(date)=2010
			group by Manufacturer_Name)T2)T2
			where top_n_sales=2)
	top_2nd_sales

--Q8--END


--9.show the manufacturers that sold cellphones in 2010 but did not in 2009.

--Q9--BEGIN

	
	select distinct Manufacturer_Name from DIM_MANUFACTURER A 
	join DIM_MODEL B on A.IDManufacturer=B.IDManufacturer
	join FACT_TRANSACTIONS C on B.IDModel=C.IDModel
	where YEAR(date)=2010 
	

--Q9--END


--10.find top 100 customers and their average spend,average quantity by each year.also find the percentage of change in their spend

--Q10--BEGIN
	
	select top 100 Customer_Name,sum(totalprice) as sum_sales,
		avg (case when YEAR(date)=2003 then (TotalPrice)end ) as avg_spend_in_2003,
		avg (case when YEAR(date)=2003 then (Quantity)end ) as avg_quantity_in_2003,
		avg (case when YEAR(date)=2004 then (TotalPrice)end ) as avg_spend_in_2004,
		avg (case when YEAR(date)=2004 then (Quantity)end ) as avg_quantity_in_2004,
		avg (case when YEAR(date)=2005 then (TotalPrice)end ) as avg_spend_in_2005,
		avg (case when YEAR(date)=2005 then (Quantity)end ) as avg_auantity_in_2005,
		avg (case when YEAR(date)=2006 then (TotalPrice)end ) as avg_spend_in_2006,
		avg (case when YEAR(date)=2006 then (Quantity)end ) as avg_quantity_in_2006,
		avg (case when YEAR(date)=2007 then (TotalPrice)end ) as avg_spend_in_2007,
		avg (case when YEAR(date)=2007 then (Quantity)end ) as avg_quantity_in_2007,
		avg (case when YEAR(date)=2008 then (TotalPrice)end ) as avg_spend_in_2008,
		avg (case when YEAR(date)=2008 then (Quantity)end ) as avg_quantity_in_2008,
		avg (case when YEAR(date)=2009 then (TotalPrice)end ) as avg_spend_in_2009,
		avg (case when YEAR(date)=2009 then (Quantity)end ) as avg_quantity_in_2009,
		avg (case when YEAR(date)=2010 then (TotalPrice)end ) as avg_spend_in_2010,
		avg (case when YEAR(date)=2010 then (Quantity)end ) as avg_quantity_in_2010
	from  DIM_CUSTOMER A join FACT_TRANSACTIONS B on A.IDCustomer=B.IDCustomer
	group by Customer_Name
	order by sum_sales
--Q10--END
	