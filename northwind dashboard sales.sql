-- dashboard for global numbers of the company

-- visualisation num. 1: total premium, total quantity, average premium per order, average discount per order, average sale per order and total discount in premium

select year(o.OrderDate) as 'OrderYear',
		SUM(od.UnitPrice*od.Quantity) as 'Premium',
		SUM(od.Quantity) as 'Sales',
		AVG(od.UnitPrice*od.Quantity) as ' AveragePremium',
		AVG(od.Quantity) as 'AverageSale',
		AVG(od.Discount) as 'AverageDiscount',
		SUM(od.Discount*od.Quantity*od.UnitPrice) as 'DiscountPremium'
from [Order Details] od join Orders o on od.OrderID = o.OrderID
group by YEAR(o.OrderDate)
order by YEAR(o.OrderDate);

-- visualisation num. 2: premium & quantity by date (featuring by month-year in tableau)

select o.OrderDate,
	   	SUM(od.UnitPrice*od.Quantity) as 'Premium',
		SUM(od.Quantity) as 'Sales'
from [Order Details] od join Orders o on od.OrderID = o.OrderID
group by o.OrderDate
order by o.OrderDate;

-- visualisation num. 3: quantity by category and month (the month-year filter to be applied in tableau)

select odc.CategoryName,
	   o.OrderDate,
	   SUM(odc.Quantity) as 'Sales'
from Orders o join (select od.OrderID,
						   od.Quantity,
						   pc.CategoryName
					from [Order Details] od join (select p.ProductID,
														c.CategoryName
													from Products p join Categories c 
													on p.CategoryID = c.CategoryID) pc
					on od.ProductID = pc.ProductID) odc
on o.OrderID = odc.OrderID
group by odc.CategoryName, o.OrderDate
order by 1,2;				  

-- visualisation num. 4: premium by country and date
create view PremByDateCount as
select o.ShipCountry,
		o.OrderDate,
		SUM(od.UnitPrice*od.Quantity) as 'Premium'
from [Order Details] od join Orders o
on od.OrderID = o.OrderID
group by o.ShipCountry, o.OrderDate
order by o.ShipCountry, o.OrderDate;
