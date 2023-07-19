use Northwind
go
--1. Hiển thị thông tin về hóa đơn có mã ‘10248’, bao gồm: OrderID,
--OrderDate, CustomerID, EmployeeID, ProductID, Quantity, Unitprice,
--Discount.
select o.OrderID, OrderDate, CustomerID, EmployeeID , ProductID, Quantity, UnitPrice ,discount
from Orders o join [order details] od on o.OrderId=od.OrderID
where o.OrderID = '10248'
--2. Liệt kê các khách hàng có lập hóa đơn trong tháng 7/1997 và 9/1997.
--Thông tin gồm CustomerID, CompanyName, Address, OrderID,
--Orderdate. Được sắp xếp theo CustomerID, cùng CustomerID thì sắp xếp
--theo OrderDate giảm dần.
select o.CustomerID,CompanyName, Address ,OrderID,OrderDate
from   Orders o join Customers od on o.CustomerID=od.CustomerID
where (datepart(Month, OrderDate) =9 and datepart(Year, OrderDate)= 1996) or ( datepart(Month, OrderDate) =7 and datepart(YEAR, OrderDate)=1996)
Order by  o.OrderDate desc
--3. Liệt kê danh sách các mặt hàng xuất bán vào ngày 19/7/1996. Thông tin
--gồm : ProductID, ProductName, OrderID, OrderDate, Quantity.
select p.ProductID, ProductName, o.OrderID, OrderDate, Quantity
from Orders o join [order details] od on o.OrderId=od.OrderID join Products p on p.ProductID= od.ProductID
where OrderDate = '1996-07-19'
--4. Liệt kê danh sách các mặt hàng từ nhà cung cấp (supplier) có mã 1,3,6 và
--đã xuất bán trong quý 2 năm 1997. Thông tin gồm : ProductID,
--ProductName, SupplierID, OrderID, Quantity. 
--nhà cung cấp (SupplierID), cùng mã nhà cung cấp thì sắp xếp theo
--ProductID.
select p.ProductID,ProductName, s.SupplierID, od.OrderID, Quantity
from Products p join  [Order Details]  od on od.ProductID = p.ProductID join Suppliers s on s.SupplierID= p.SupplierID join Orders o on o.OrderID=od.OrderID
where (s.SupplierID = 1 or s.SupplierID = 3 or s.SupplierID = 6)  and  datepart(QUARTER, OrderDate) =2 and DATEPART(YEAR, OrderDate)=1997
Order by s.SupplierID desc
--5. Liệt kê danh sách các mặt hàng có đơn giá bán bằng đơn giá mua.
select *
from Products p join [Order Details] od on p.UnitPrice=od.UnitPrice
--6. Danh sách các mặt hàng bán trong ngày thứ 7 và chủ nhật của tháng 12
--năm 1996, thông tin gồm ProductID, ProductName, OrderID, OrderDate,
--CustomerID, Unitprice, Quantity, ToTal= Quantity*UnitPrice. Được sắp
--xếp theo ProductID, cùng ProductID thì sắp xếp theo Quantity giảm dần.
select p.ProductID, ProductName, od.OrderID, OrderDate,CustomerID, p.Unitprice, Quantity, ToTal= Quantity*od.UnitPrice
from Products p join [Order Details] od on p.ProductID=od.ProductID join Orders o on o.OrderID=od.OrderID
where (datepart(WEEKDAY,o.OrderDate)=7 or datepart(WEEKDAY,o.OrderDate)=1)  and datepart(MONTH,o.OrderDate)=12 and datepart(year,o.OrderDate)=1996
Order by Quantity desc
--7. Liệt kê danh sách các nhân viên đã lập hóa đơn trong tháng 7 của năm
--1996. Thông tin gồm : EmployeeID, EmployeeName, OrderID,
--Orderdate.
select e.EmployeeID, FirstName +''+ LastName as EmployeeName , OrderID, Orderdate
from Employees e join Orders o on o.EmployeeID=e.EmployeeID
where DATEPART(MONTH, OrderDate)= 7 and datepart(year, OrderDate)=1996
--8. Liệt kê danh sách các hóa đơn do nhân viên có Lastname là ‘Fuller’ lập.
--Thông tin gồm : OrderID, Orderdate, ProductID, Quantity, Unitprice.
select o.OrderID, Orderdate, ProductID, Quantity, Unitprice
from Orders o join [Order Details] od on o.OrderID= od.OrderID join Employees e on e.EmployeeID=o.EmployeeID
where e.LastName Like 'Fuller'
--9. Liệt kê chi tiết bán hàng của mỗi nhân viên theo từng hóa đơn trong năm
--1996. Thông tin gồm: EmployeeID, EmployName, OrderID, Orderdate,
--ProductID, quantity, unitprice, ToTalLine=quantity*unitprice.
select e.EmployeeID, FirstName +''+ LastName as EmployeeName, o.OrderID, Orderdate,ProductID, quantity, unitprice, ToTalLine=quantity*unitprice
from Orders o join [Order Details] od on o.OrderID= od.OrderID join Employees e on e.EmployeeID=o.EmployeeID
where datepart(year, OrderDate)=1996
--10.Danh sách các đơn hàng sẽ được giao trong các thứ 5 của tháng 12 năm
--1996.
select *
from Orders
where datepart(month, OrderDate)= 12 and datepart(weekday,OrderDate)=5 and datepart(year,OrderDate)=1996
--11.Liệt kê danh sách các nhân viên chưa lập hóa đơn (dùng LEFT
--JOIN/RIGHT JOIN).
select *
from Employees e left join Orders o on e.EmployeeID=o.EmployeeID
where e.EmployeeID is not null
--12.Liệt kê danh sách các sản phẩm chưa bán được (dùng LEFT
--JOIN/RIGHT JOIN).
select *
from Products p left join [Order Details] od on p.ProductID= od.ProductID
where od.OrderID is not null
--13.Liệt kê danh sách các khách hàng chưa mua hàng lần nào (dùng LEFT
--JOIN/RIGHT JOIN).
select *
from Customers c left join Orders o on c.CustomerID= o.CustomerID
where o.OrderDate is null