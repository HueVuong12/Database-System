use Northwind
go
--1. Liệt kê các product có đơn giá bán lớn hơn đơn giá bán trung bình của
--các product. Thông tin gồm ProductID, ProductName, Unitprice .
select productID, productName, Unitprice
from Products 
where Unitprice > (select avg (UnitPrice) from Products)
--2. Liệt kê các product có đơn giá bán lớn hơn đơn giá bán trung bình của
--các product có ProductName bắt đầu là ‘N’
select productID, productName, Unitprice
from Products 
where Unitprice > (select avg (UnitPrice) from Products where productName like 'N%')
--3. Danh sách các products có đơn giá mua lớn hơn đơn giá mua nhỏ nhất
--của tất cả các products
SELECT*FROM Products
WHERE UnitPrice > (SELECT MIN(UnitPrice) FROM Products)
--4. Cho biết những product có đơn vị tính có chữ ‘box’ và có số lượng bán
--lớn hơn số lượng trung bình bán ra.
select distinct p.productID, productName, od.Quantity, QuantityPerUnit
from Products p join [Order Details] od on p.productid=od.productid
where  od.Quantity > (select avg (Quantity) from [Order Details] )and  QuantityPerUnit like '%box%'
--5. Cho biết những sản phẩm có tên bắt đầu bằng chữ N và đơn giá bán >
--đơn giá bán của (tất cả) những sản phẩm khác
select  productID, productName, UnitPrice
from products
where ProductName like 'T%' and unitprice > (select top 1 UnitPrice from products where productname like 'V%' order by UnitPrice desc) 
order by unitprice desc