use Northwind
go

--Dùng lệnh Insert…Select…
--Lệnh INSERT … SELECT … cho phép truy vấn dữ liệu từ  bảng nguồn
--trong  một  CSDL,  tập  dữ  liệu  kết  quả  được nhập  (insert)  vào  bảng  đích
--trong cùng CSDL hay trong CSDL khác.  Lưu ý : tập dữ liệu lấy từ bảng 
--nguồn phải phù hợp kiểu dữ liệu, phù hợp  cấu trúc  và ràng buộc dữ liệu 
--trên bảng đích.
--Áp  dụng  lệnh  INSERT  …  SELECT  …  để  nhập  dữ  liệu  vào  các  bảng 
--trong csdl QLBH dựa trên dữ liệu trong csdl Northwind ? Kiểm tra kết quả 
--sau mỗi lần thực hiện ?
--a.  Insert  dữ liệu vào bảng KhachHang trong QLBH  với dữ liệu nguồn là 
--bảng Customers trong NorthWind.
insert into QLBH.[dbo].KhachHang(MaKH,TenKH)
select CustomerID,companyName, Address, Phone from Northwind.dbo.Customers

--b.  Insert dữ liệu vào  bảng Sanpham trong QLBH. Dữ liệu nguồn là các 
--sản  phẩm  có  SupplierID  từ  4  đến  29  trong  bảng 
--Northwind.dbo.Products 
insert into QLBH.dbo.sanpham(MaSP,TenSP)
select SupplierID,ProductName, null, null, QuantityPerUnit, UnitPrice, UnitsInStock from Northwind.dbo.Products
[SanPhamID]
where SupplierID >3 and SupplierID <30 and UnitsInStock>0

select * from sanpham
sp_help 'sanpham'
--c.  Insert dữ liệu vào  bảng  HoaDon  trong QLBH. Dữ liệu nguồn là  các 
--hoá  đơn  có  OrderID  nằm  trong  khoảng  10248  đến  10350  trong
--NorthWind.dbo.[Orders]
insert into QLBH.dbo.HoaDon(MaHD,NgayLapHD)
select OrderID,OrderDate from Northwind.dbo.Orders
where orderId >= 10248 and orderid <= 10350

--d.  Insert dữ liệu vào  bảng CT_HoaDon  trong QLBH. Dữ liệu nguồn là
--các chi tiết hoá đơn có OderID nằm trong  khoảng 10248 đến 10350 
--trong NorthWind.dbo.[Order Detail]
insert into QLBH.dbo.CT_HoaDon(MaHD,Dongia)
select OrderID,Quantity,UnitPrice from NorthWind.dbo.[Order Details]
where orderId >= 10248 and orderid <= 10350

--lenh update
UPDATE <table_name>
SET <column_name> = value , [, �]
FROM <table_name> [, �]
WHERE <condition>

--1
update [Order Details]
set Discount = 0.1
where OrderID =any (select OrderID from Orders where OrderDate = '1997-1-1')


--2
update [Order Details]
set Quantity = 17.5
where OrderID = (select OrderID from Orders where OrderID =11 and month(OrderDate) = 2 and year(OrderDate)=1997)

--3
update [Order Details]
set UnitPrice = p.Unitprice
from Products p join [Order Details] od on p.ProductID=od.ProductID join 
orders o on o.OrderID=od.OrderID
where (SupplierID = 4 or SupplierID = 7) and month(OrderDate) = 4 and year(orderdate)=1997
 
 --4 

 update Orders
 set Freight = Freight+Freight*0.2
 from [Order Details] od join Orders o on o.OrderID = od.OrderID
 where o.orderid =any (select o.OrderID from [Order Details] od join orders o on o.OrderID=od.OrderID
  where sum(UnitPrice*Quantity) >= 10000 and month (orderdate) = 1 and year (orderdate) =1997
  group by 
 
 )



