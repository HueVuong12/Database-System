use Northwind
go
--1. Liệt kê danh sách các mặt hàng (Products).
select * from Products
--2. Liệt kê danh sách các mặt hàng (Products). Thông tin bao gồm ProductID, ProductName, UnitPrice.
select ProductID, ProductName, Unitprice from Products
--3. Liệt kê danh sách các nhân viên (Employees). Thông tin bao gồm EmployeeID, EmployeeName, Phone, Age. Trong đó EmployeeName được ghép từ LastName và FirstName; Age là tuổi được tính dựa trên năm hiện hành (GetDate()) và năm sinh.
select EmployeeID,FirstName +''+ LastName as EmployeeName,HomePhone as Phone,GETDATE() -BirthDate as Age from Employees
--4. Liệt kê danh sách các khách hàng (Customers) mà người đại diện có ContactTitle bắt đầu bằng chữ ‘O’. Thông tin bao gồm CustomerID, CompanyName, ContactName, ContactTitle, City, Phone.
select CustomerID, CompanyName,ContactName,ContactTitle,City,Phone
from Customers
where ContactTitle Like 'O%'
--5. Liệt kê danh sách khách hàng (Customers) ở thành phố LonDon, Boise và Paris.
select * from dbo.Customers
where city = 'LonDon' or city = 'Boise' or city = 'Paris'
--6. Liệt kê danh sách khách hàng (Customers) có tên bắt đầu bằng chữ V mà ở thành phố Lyon.
select * from dbo.Customers
where CompanyName Like 'V%' and city = 'Lyon'
--7. Liệt kê danh sách các khách hàng (Customers) không có số fax.
select * from dbo.Customers
where Fax is null
--8. Liệt kê danh sách các khách hàng (Customers) có số Fax.
select * from dbo.Customers
Where Fax is not null
--9. Liệt kê danh sách nhân viên (Employees) có năm sinh <=1960
select * from dbo.Employees
where YEAR(BirthDate) <=1960
--10.Liệt kê danh sách các sản phẩm (Products) có chứa chữ ‘Boxes’ trong cột QuantityPerUnit. 
select * from Products
where QuantityPerUnit like '%Boxes%'
--11.Liệt kê danh sách các mặt hàng (Products) có đơn giá (Unitprice) lớn hơn 10 và nhỏ hơn 15. 
select * from dbo.Products
where Unitprice > 10 AND Unitprice < 15
--13.Liệt kê danh sách các mặt hàng (Products) ứng với tiền tồn vốn. Thông tin bao gồm ProductId, ProductName, Unitprice, UnitsInStock, Total. Trong đó Total= UnitsInStock*Unitprice. Được sắp xếp theo Total giảm dần.
select ProductID, ProductName, Unitprice, UnitsInStock , UnitsInStock*Unitprice as Total from [dbo].[Products] 
Order by Total desc
--14.Hiển thị thông tin OrderID, OrderDate, CustomerID, EmployeeID của 2 hóa đơn có mã OrderID là ‘10248’ và ‘10250’
select top 2 OrderID,OrderDate,CustomerID, EmployeeID from Orders
where OrderID = '10248' or OrderID = '10250'
--15.Liệt kê chi tiết của hóa đơn có OrderID là ‘10248’. Thông tin gồm OrderID, ProductID, Quantity, Unitprice, Discount, ToTalLine = Quantity * unitPrice *(1-Discount)
select OrderID, ProductID, Quantity, Unitprice, Discount, ToTalLine = Quantity * unitPrice *(1-Discount)
from [Order Details]
where OrderID='10248'
--16.Liệt kê danh sách các hóa đơn (orders) có OrderDate được lập trong tháng 9 năm 1996. Được sắp xếp theo mã khách hàng, cùng mã khách hàng sắp xếp theo ngày lập hóa đơn giảm dần.
select *
from Orders
where MONTH(OrderDate)=9 and YEAR(Orderdate)=1996
order by CustomerID, OrderDate desc
--17.Liệt kê danh sách các hóa đơn (Orders) được lập trong quý 4 năm 1997. Thông tin gồm OrderID, OrderDate, CustomerID, EmployeeID. Được sắp xếp theo tháng của ngày lập hóa đơn.
select OrderID, OrderDate, CustomerID, EmployeeID from Orders 
where datepart(QUARTER,Orderdate)=4 and YEAR(orderdate)=1997
order by CustomerID, OrderDate desc
--18.Liệt kê danh sách các hóa đơn (Orders) được lập trong trong ngày thứ 7 và chủ nhật của tháng 12 năm 1997. Thông tin gồm OrderID, OrderDate, Customerid, EmployeeID, WeekDayOfOrdate (Ngày thứ mấy trong tuần).
select  OrderID, OrderDate,Customerid, EmployeeID,datepart(WEEKDAY, OrderDate) as WeekDayOfOrdate
from Orders
where datepart(weekday,OrderDate)=7 or datepart(weekday,OrderDate)=1 and month(OrderDate)=12 and Year(OrderDate) = 1997
--19.Liệt kê danh sách 5 customers có city có ký tự bắt đầu ‘M’.
select top 5 * from customers
where city like 'M%'
--20.Liệt kê danh sách 2 employees có tuổi lớn nhất. Thông tin bao gồm EmployeeID, EmployeeName, Age. Trong đó, EmployeeName được ghép từ LastName và FirstName; Age là tuổi.
select top 2 EmployeeID, FirstName +''+ LastName as EmployeeName,datediff(year,BirthDate,getdate()) as Age
from Employees
Order by Age desc
