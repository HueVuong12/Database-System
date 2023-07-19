 use Northwind
 go
 --1.Liệt kê danh sách các orders ứng với tổng tiền của từng hóa đơn. Thông 
--tin  bao  gồm  OrderID,  OrderDate,  Total.  Trong  đó  Total  là  Sum  của 
--Quantity * Unitprice, kết nhóm theo OrderID.
SELECT od.orderid,OrderDate, SUM(quantity*unitprice) AS 'Total'
FROM [Order Details] od join orders o on od.orderid = od.orderid
GROUP BY od.orderid, Orderdate

--2.  Liệt kê danh sách các orders mà địa chỉ nhận hàng ở thành phố  ‘Madrid’
--(Shipcity).  Thông  tin  bao  gồm  OrderID,  OrderDate,  Total.  Trong  đó 
--Total là tổng trị giá hóa đơn, kết nhóm theo OrderID. 

select  o.OrderID, OrderDate, sum(quantity*unitprice) as 'Total'
from Orders o join [Order Details] od on o.orderid = od.orderid
where ShipCity like 'Madrid'
group by o.orderid,orderdate
--3.  Sử dụng 2 table  [Orders] và [Order Details], hãy viết các truy vấn thống 
--kê tổng trị giá các hóa đơn được xuất bán theo :
---  Tháng …
---  Năm …
---  CustomerID …
---  EmployeeID …
---  ProductID …

select datepart(month, orderdate) as 'month',sum(quantity*unitprice) as 'Total'
from orders o join [Order Details] od on o.orderid = od.orderid
group by datepart(month, orderdate)

select datepart(year,orderdate) as 'year', sum(quantity*unitprice) as 'Total'
from orders o join [Order Details] od on o.orderid = od.orderid
group by datepart(year, orderdate)

select  o.CustomerID, sum(quantity*unitprice) as 'Total'
from orders o join [Order Details] od on o.orderid = od.orderid
group by o.CustomerID

select EmployeeID, sum(quantity*unitprice) as 'Total'
from orders o join [Order Details] od on o.orderid = od.orderid
group by EmployeeID

select ProductID, sum(quantity*unitprice) as 'Total'
from orders o join [Order Details] od on o.orderid = od.orderid
group by ProductID
--4.  Cho  biết  mỗi  Employee  đã  lập  bao  nhiêu  hóa  đơn.  Thông  tin  gồm 
--EmployeeID,  EmployeeName,  CountOfOrder.  Trong đó CountOfOrder 
--Trường ĐH Công Nghiệp TP.HCM    Bài Tập Thực Hành Môn Hệ Cơ Sở Dữ Liệu
---Khoa Công Nghệ Thông Tin    42/51
--là  tổng  số  hóa  đơn  của  từng  employee.  EmployeeName  được  ghép  từ 
--LastName và FirstName.
select o.EmployeeID, lastname +'' + firstname as EmployeeName,count (orderid) as CountOfOrder
from orders o join employees e on o.EmployeeID = e.employeeid
group by o.EmployeeID,lastname , firstname
--5.  Cho  biết  mỗi  Employee  đã  lập  được  bao  nhiêu  hóa  đơn,  ứng  với  tổng 
--tiền  các  hóa  đơn  tương  ứng.  Thông  tin  gồm  EmployeeID, 
--EmployeeName, CountOfOrder , Total.
select o.EmployeeID,lastname +'' + firstname as EmployeeName,count  (distinct o.orderid) CountOfOrder ,sum (distinct  quantity*unitprice) as 'Total'
from orders o join Employees e on o.EmployeeID = e.EmployeeID join [Order Details] od on od.OrderID= o.OrderID
group by o.EmployeeID, lastname,firstname
--6.  Liệt kê bảng lương của mỗi  Employee  theo từng tháng trong năm 1996 
--gồm  EmployeeID,  EmployName,  Month_Salary,  Salary  = 
--sum(quantity*unitprice)*10%.  Được  sắp  xếp  theo Month_Salary, cùmg 
--Month_Salary thì sắp xếp theo Salary giảm dần.
select e.employeeid, lastname +'' + firstname as EmployeeName,(month(OrderDate)) as month, round(sum(distinct quantity*unitprice)*0.1,2 ) as 'Salary'
from Employees e join Orders o on e.EmployeeID= o.EmployeeID join [Order Details] od on o.OrderID = od.OrderID
where datepart (YEAR,OrderDate)= 1996 
group by e.employeeid,lastname,firstname,MONTH(OrderDate)
order by  month,Salary desc

--7.  Tính tổng số hóa đơn và tổng tiền các hóa đơn của mỗi nhân viên đã bán 
--trong  tháng  3/1997,  có  tổng  tiền  >4000.  Thông  tin  gồm  EmployeeID, 
--LastName, FirstName, CountofOrder, Total.
select e.Employeeid, lastname,firstname,count  (distinct o.orderid) CountOfOrder, sum(quantity*unitprice) Total
from Employees e join Orders o on o.EmployeeID=e.EmployeeID join [Order Details] od on od.OrderID= o.OrderID
where datepart(month, OrderDate)=3 and datepart(year,OrderDate)=1997
group by e.EmployeeID,LastName,firstname
having  sum(quantity*UnitPrice) >4000
--8.  Liệt kê danh sách các customer ứng với tổng số hoá đơn, tổng tiền các 
--hoá đơn, mà các hóa đơn được lập từ 31/12/1996 đến 1/1/1998 và tổng 
--tiền  các  hóa  đơn  >20000.  Thông  tin  được  sắp  xếp  theo  CustomerID, 
--cùng mã thì sắp xếp theo tổng tiền giảm dần.
select c.CustomerID,CompanyName,count(distinct o.orderid) as countoforder,sum(distinct quantity*unitprice) as total 
from Customers c join orders o on o.CustomerID= c.CustomerID join [Order Details] od on od.OrderID=o.OrderID
where OrderDate > '1996-12-31' and OrderDate < '1998-1-1'
group by c.customerID ,companyName,o.orderid
having sum(distinct quantity*unitprice) >20.000
order by total desc
--9.  Liệt kê danh sách các customer ứng với tổng tiền của các hóa đơn ở từng 
--tháng.  Thông  tin  bao  gồm  CustomerID,  CompanyName,  Month_Year, 
--Total. Trong đó Month_year là tháng và năm lập hóa đơn, Total là tổng 
--của Unitprice* Quantity.
select c.CustomerID,CompanyName,month_year = cast(MONTH(OrderDate)as varchar) + ' - ' + cast(YEAR(OrderDate) as varchar),sum(distinct quantity*unitprice) as total 
from Customers c join orders o on o.CustomerID= c.CustomerID join [Order Details] od on od.OrderID=o.OrderID
group by c.customerID ,companyName,o.orderdate
order by total desc
--10.  Liệt  kê  danh  sách  các  nhóm  hàng  (category)  có  tổng  số  lượng  tồn 
--(UnitsInStock) lớn hơn 300, đơn giá trung bình nhỏ hơn 25. Thông tin 
--bao  gồm  CategoryID,  CategoryName,  Total_UnitsInStock, 
--Average_Unitprice.
select c.CategoryID, CategoryName, Total_UnitsInStock = sum(UnitsInStock), Average_Unitprice = avg (unitprice)
from Categories c join Products p on p.CategoryID=c.CategoryID 
group by c.CategoryID, categoryname 
having sum(UnitsInStock)>300 and avg (UnitPrice)<25
--11.  Liệt  kê  danh  sách  các  nhóm  hàng  (category)  có  tổng  số  mặt  hàng
--(product)  nhỏ  hớn  10.  Thông  tin  kết  quả  bao  gồm  CategoryID, 
--CategoryName,  CountOfProducts.  Được  sắp  xếp  theo  CategoryName, 
--cùng CategoryName thì sắp theo CountOfProducts giảm dần.
select c.CategoryID, CategoryName,CountOfProducts = count(ProductID)
from Categories c join Products p on p.CategoryID=c.CategoryID 
group by categoryname, c.CategoryID
order by CountOfProducts desc
--12.  Liệt  kê  danh  sách  các  Produca  t  bán  trong  quý  1  năm  1998  có  tổng  số 
--lượng  bán  ra  >200,  thông  tin  gồm  [ProductID],  [ProductName], 
--SumofQuatity 
select p.productid ,productname,sumofquatity = sum(distinct Quantity)
from Products p join [Order Details] od on od.ProductID=p.ProductID join orders o on o.OrderID=od.OrderID
where datepart (QUARTER,OrderDate) =1 and datepart (year,orderdate) = 1998
group by p.ProductID,productname
having sum(distinct Quantity) > 200
--13.  Cho biết Employee nào bán được nhiều tiền nhất trong tháng 7 năm 1997
select top 1 e.EmployeeID,e.FirstName+''+e.LastName as emloyeeName, total = sum(distinct UnitPrice*Quantity)
from employees e join Orders o on o.EmployeeID= e.EmployeeID join [Order Details] od on od.OrderID=o.OrderID
where datepart (month,orderdate) = 7 and  datepart (year,orderdate) = 1997
group by e.EmployeeID,e.firstname,e.lastname
order by total desc
--14.  Liệt kê danh sách 3 Customer có nhiều đơn hàng nhất của năm 1996.
select top 3 e.EmployeeID,e.FirstName+''+e.LastName as emloyeeName, countoforder = count(distinct orderid)
from Employees e join Orders o on o.EmployeeID= e.EmployeeID
where datepart(year,orderdate)=1996
group by e.EmployeeID,e.firstname,e.lastname
order by countoforder desc
--15.  Liệt kê danh sách các  Products có tổng  số lượng lập hóa đơn lớn nhất.
--Thông tin gồm ProductID, ProductName                                                                                                    , CountOfOrders.
SELECT TOP 1 p.ProductID, ProductName,CountOfOrders =  COUNT(distinct OrderID)
FROM Products p join [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, ProductName
ORDER BY CountOfOrders desc