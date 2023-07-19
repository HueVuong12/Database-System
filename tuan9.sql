use Northwind
go
/*6. Cho biết những sản phẩm thuộc nhóm hàng có mã 4 (categoryID) và có
tổng số lượng bán lớn hơn (tất cả) tổng số lượng của những sản phẩm
không thuộc nhóm hàng mã 4*/

SELECT*FROM Products p join [Order Details] od ON p.ProductID = od.ProductID
WHERE CategoryID = 4 AND  Quantity > (SELECT distinct top 1 Quantity FROM Products p join [Order Details] od ON p.ProductID = od.ProductID WHERE CategoryID = 4 order by quantity desc )

/*7. Danh sách các products đã có khách hàng mua hàng (tức là ProductID có
trong [Order Details]). Thông tin bao gồm ProductID, ProductName,
Unitprice*/

SELECT ProductID, ProductName, UnitPrice
FROM Products p
WHERE EXISTS (SELECT*FROM [Order Details] od WHERE p.ProductID = od.ProductID)


/*8. Danh sách các hóa đơn của những khách hàng ở thành phố LonDon và
Madrid.*/

SELECT * FROM Orders o join Customers c on o.CustomerID=c.CustomerID 
where c.city in('LonDon' ,'Madrid')

/*9. Liệt kê các sản phẩm có trên 20 đơn hàng trong quí 3 năm 1998, thông
tin gồm ProductID, ProductName.*/



select  p.ProductID, ProductName,count(distinct od.OrderID)
from Products p join [Order Details] od on p.ProductID=od.ProductID join Orders o on o.OrderID=od.OrderID
where datepart(QUARTER,orderdate) = 3 and year(orderdate)=1998 
group by  p.ProductID, ProductName
having count(distinct od.OrderID) >20

/*10.Liệt kê danh sách các sản phẩm chưa bán được trong tháng 6 năm 1996*/

select *from products p join [Order Details] od on od.ProductID=p.ProductID join Orders o ON od.OrderID = o.OrderID
where month(orderdate)=7 and year(orderdate)=1996 and UnitsOnOrder = ANY (SELECT UnitsOnOrder FROM Products WHERE UnitsOnOrder = 0) 

/*11.Liệt kê danh sách các Employes không lập hóa đơn vào ngày hôm nay*/

SELECT*FROM Employees
WHERE EmployeeID NOT IN ( SELECT e.EmployeeID FROM Employees e join Orders o ON e.EmployeeID = o.EmployeeID WHERE OrderDate =  GETDATE())

/*12.Liệt kê danh sách các Customers chưa mua hàng trong năm 1997*/

SELECT *FROM Customers
WHERE CustomerID NOT IN ( SELECT c.CustomerID FROM Customers c join Orders o ON c.CustomerID = o.CustomerID WHERE YEAR(OrderDate) = 1997)

/*13.Tìm tất cả các Customers mua các sản phẩm có tên bắt đầu bằng chữ T
trong tháng 7 năm 1997*/

SELECT*FROM Customers c join Orders o ON c.CustomerID = o.CustomerID
WHERE EXISTS (SELECT*FROM Orders o join [Order Details] od ON o.OrderID = od.OrderID join Products p ON od.ProductID = p.ProductID WHERE ProductName like 'T%') AND MONTH(OrderDate) = 7 AND YEAR(OrderDate) = 1997

/*14.Liệt kê danh sách các khách hàng mua các hóa đơn mà các hóa đơn này
chỉ mua những sản phẩm có mã >=3*/

SELECT*FROM Customers c join Orders o ON c.CustomerID = o.CustomerID join [Order Details] od ON o.OrderID = od.OrderID
WHERE ProductID IN (SELECT ProductID FROM [Order Details]  WHERE ProductID >= 3)

/*15.Tìm các Customer chưa từng lập hóa đơn (viết bằng ba cách: dùng NOT
EXISTS, dùng LEFT JOIN, dùng NOT IN )*/

--exists
SELECT*FROM Customers c
WHERE NOT EXISTS (SELECT*FROM Orders o WHERE c.CustomerID = o.CustomerID)

--left join
SELECT*FROM Customers c left join Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL

--not in
SELECT*FROM Customers
WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders)

/*16.Cho biết sản phẩm nào có đơn giá bán cao nhất trong số những sản phẩm
có đơn vị tính có chứa chữ ‘box’ .*/

SELECT TOP 1*FROM Products
WHERE UnitPrice IN (SELECT UnitPrice FROM Products WHERE QuantityPerUnit like '%box%')
ORDER BY UnitPrice desc

/*17. Danh sách các Products có tổng số lượng (Quantity) bán được lớn nhất.*/

SELECT TOP 1*FROM Products p join [Order Details] od ON p.ProductID = od.ProductID
WHERE Quantity IN (SELECT Quantity FROM [Order Details])
ORDER BY Quantity desc
/*18.Bạn hãy mô tả kết quả của các câu truy vấn sau ?
Select ProductID, ProductName, UnitPrice From [Products]
Where Unitprice>ALL (Select Unitprice from [Products] where
ProductName like ‘N%’)*/

--Cho biết danh sách các Products có đơn giá bán cao hơn đơn giá bán của tất cả các Product có tên bắt đầu là N

/*Select ProductId, ProductName, UnitPrice from [Products]
Where Unitprice>ANY (Select Unitprice from [Products] where
ProductName like ‘N%’)*/

--Cho biết danh sách các Products có đơn giá bán cao hơn đơn giá bán của bất kỳ các Product có tên bắt đầu là N

/*Select ProductId, ProductName, UnitPrice from [Products]
Where Unitprice=ANY (Select Unitprice from [Products] where
ProductName like ‘N%’)*/

--Cho biết danh sách các Products có đơn giá bán bằng đơn giá bán của bất kỳ các Product có tên bắt đầu là N

/*Select ProductId, ProductName, UnitPrice from [Products]
Where ProductName like ‘N%’ and
Unitprice>=ALL (Select Unitprice from [Products] where
ProductName like ‘N%’)*/
