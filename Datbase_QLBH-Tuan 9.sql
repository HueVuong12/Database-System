use Northwind
go

 --- BAI TAP TUAN 9 ---
create database QLBH5
ON PRIMARY
(
	NAME = 'QuanlyBH',
	FILENAME = 'c:\2020\QLBH5.mdf',
	SIZE = 10MB,
	FILEGROWTH = 20%,
	MAXSIZE = 50MB
)
	LOG ON
	(
	NAME = 'QLBH_log',
	FILENAME = 'c:\2020\QLBH5.ldf',
	SIZE = 10MB,
	FILEGROWTH = 10%,
	MAXSIZE = 20MB
)
use QLBH5
create table NhomSanPham
(	MaNhom int Not null primary key,
	TenNhom Nvarchar(15)
)
exec sp_helpconstraint Nhomsanpham
create table NhaCungCap
(	MaNCC Int Not null primary key,
	TenNcc Nvarchar(40) Not Null,
	Diachi Nvarchar(60),
	Phone NVarchar(24),
	SoFax NVarchar(24),
	DCMail NVarchar(50)
)
create table SanPham
(
	MaSp int Not null primary key,
	TenSp nvarchar(40) Not null,
	MaNCC Int,
	MoTa nvarchar(50),
	MaNhom int,
	Đonvitinh nvarchar(20),
	GiaGoc Money ,
	SLTON Int,
	foreign key (MaNCC) references NhaCungCap (MANCC), 
	foreign key (MaNhom) references Nhomsanpham (MaNhom) 
)
create table KhachHang
(
	MaKh NChar(5) primary key Not null,
	TenKh Nvarchar(40) Not null,
	LoaiKh Nvarchar(3),
	DiaChi Nvarchar(60),
	Phone NVarchar(24)
)
create table Nhanvien
(
	MaNV NChar(5) Not null primary key,
	TenNV Nvarchar(40) Not null,
	DiaChi Nvarchar(60),
	Dienthoai NVarchar(24)
)
create table HoaDon
(
	MaHD int not null primary key,
	NgayLapHD DateTime,
	NgayGiao DateTime,
	Noichuyen NVarchar(60) Not Null,
	MaNV Nchar(5),
	MaKh Nchar(5),
	foreign key (MaNV) references Nhanvien (Manv), 
	foreign key (Makh) references Khachhang (makh), 

)
create table CT_HoaDon
(
	MaHD Int Not null,
	MaSp int Not null,
	Soluong SmallInt check (soluong>0) ,
	Dongia Money,
	ChietKhau Money check (chietkhau>=0), 
	primary key (MaHD, Masp),
	foreign key (Mahd) references Hoadon (Mahd), 
	foreign key (Masp) references Sanpham (masp) 

)
exec sp_helpconstraint Sanpham
alter table Sanpham add constraint Sanpham_ck check (giagoc>0)
alter table Sanpham add constraint Sanpham_ck1 check (slton>0)
select getdate()

--HoaDon:
exec sp_helpconstraint Hoadon
--o NgayLapHD >=Ngày hiện hành (Check constraint)
alter table Hoadon add constraint HD_ck check (NgayLapHD>=getdate())

--o Giá trị mặc định là ngày hiện hành (Default constraint)
alter table Hoadon add constraint HD_df default getdate() for NgayLapHD
--• Sanpham:
--o Giagoc và SlTong>0 (Check constraint)
alter table Sanpham add constraint sp_ck check (SlTong>0)
--• Khachhang:
--o LoaiKH: bao gồm các giá trị: VIP, TV, VL (Check constraint)
alter table Khachhang add constraint kh_ck check (LoaiKH in ('VIP', 'TV', 'VL'))
-- Insert dữ liệu 


insert into NhomSanPham values (4,N'Mỹ Phẩm ')
insert into NhomSanPham values (2,N'Do gia dung')
insert into NhomSanPham values (1,N'Do gia dung')
insert into NhomSanPham values (1,N'Do gia dung')
select * from NhomSanPham

insert into KhachHang values ('KH01','ABC','TV','GO VAPXXDSRWDWYIWF',1247852)
insert into KhachHang  values ('KH02','ABD')
insert into KhachHang(MaKh,TenKH)  values ('KH02','ABD')
update khachhang set tenKH='xyz' where makh='A' 
 select * from KhachHang
 delete from KhachHang


 --- BAI TAP TUAN 9 ---

--1.	Xóa hết các dữ liệu đang có trong các Table của cơ sở dữ liệu QLBH bằng lệnh Delete. 
--Trong trường hợp nào thì không xóa được dữ liệu bảng SanPham khi chưa xóa dữ liệu bảng con của SanPham? 
--Nếu bạn muốn xóa bất kỳ Bảng cha thì xóa luôn các bảng quan hệ thì bạn phải làm gì? Bạn thực hiện một ví dụ minh họa

delete from Nhanvien
delete from HoaDon

--2.	Dùng lệnh Insert thêm vào mỗi bảng của CSDL QLBH 5 record với nội dung do sinh viên tự nghĩ. 
insert into NhomSanPham(Manhom) values (6)
insert into NhanVien values ('A2','Nguyen Thi Hong', '12 Nguyen Van Bao',123456)
insert into NhanVien(MaNV,TenNV)  values ('A1','Nguyen Thi Hoa')
select * from Nhanvien
select * from NhomSanPham 
--3.	Dùng câu lệnh INSERT … SELECT với các cột chọn cần thiết để đưa (nhớ kiểm tra kết quả sau mỗi lần thực hiện):
--1	Các khách hàng có trong bảng Customers trong NorthWind vào bảng KhachHang trong QLBH.
 --   Insert  KhachHang(MaKh,TenKh)
	--go
	--insert table  khachhang 
	--go 
	delete from khachhang 
	select CustomerID,CompanyName 
	into khachhang2  
	from Northwind.dbo.customers 
	select * from KhachHang2
--- insert vào bảng đã tạo 
-- tao bang 
create table Nhanvien_3
(
	MaNV NChar(5)
	)

insert nhanvien_3(MaNV)
select [CustomerID]
from [Northwind].[dbo].[Customers]

select * from nhanvien_3

--- insert vào bảng chưa  tạo 
select [CustomerID]
into  nhanvien_4
from [Northwind].[dbo].[Customers]


select * from nhanvien_4


	delete from Nhanvien_3
	select * from Nhanvien_3
--2. Các sản phẩm có SupplierID từ 4 đến 29 ở bảng Products trong CSDL NorthWind vào bảng Sanpham trong QLBH.
		delete from Nhacungcap

	Insert  NhaCungCap(MaNCC,TenNcc)
	select supplierID, CompanyName
	---into nhacc429
	 from Northwind.dbo.Suppliers 
	where SupplierID <29 and SupplierID>4

	select * from NhaCungCap
	select * from nhacc429

--	Danh sách tất cả các hoá đơn có OrderID nằm trong khoảng 10248 đến 10350 trong bảng Orders trong Northwind vào bảng HoaDon,
-- các hoá đơn này được xem là hoá đơn xuất - tức LoaiHD là ‘X’
	alter table HoaDon add LoaiHD char(1)
	delete from hoadon 
	Insert  HoaDon(MaHD,Noichuyen,LoaiHD)
	select   OrderID,'OK', 'x'  from Northwind.dbo.Orders
	where OrderID<10350 and orderID>10248
	select * from hoadon 
----	Danh sách tất cả các hoá đơn có OrderID nằm trong khoảng 10351 đến 10446 trong bảng Orders trong Northwind vào bảng HoaDon, 
---các hoá đơn này được xem là hoá đơn nhập - tức LoaiHD là ‘N’

	Insert  HoaDon(MaHD,Noichuyen,LoaiHD)
	select   OrderID,'---', 'N'  from Northwind.dbo.Orders
	where OrderID<10446 and orderID>10351
---	Danh sách tất cả các chi tiết hoá đơn có OderID nằm trong khoảng 10248 đến 10270 trong bảng 
---Order Detail trong NorthWind vào bảng CT_HoaDon.
	insert  SanPham(MaSP,TenSp)
	select productID,ProductName from Northwind.dbo.Products

			
	Insert  CT_HoaDon(MaHD,MaSp)
	select   OrderID,ProductID from Northwind.dbo.[Order Details]
	where OrderID>10248 and orderID<10270

	select * from [Order Details]
	where OrderID<10248 and orderID>10270
--Chú ý: các ràng buộc khóa chính, khóa ngoại và các ràng buộc khác. Chỉ lấy các cột tương ứng với các bảng trong CSDL QLBH


---BÀI TẬP 2: LỆNH UPDATE
--1.	Cập nhật đơn giá bán 100000 cho mã sản phẩm có tên bắt đầu bằng chữ T
select * from KhachHang

select CustomerID,CompanyName 
	into khachhang3  
	from Northwind.dbo.customers 
	select * from khachhang3

update KhachHang3  set  CompanyName='viet tien'   where CustomerID='ALFKI'

		update [Products]  set  UnitPrice=100000 where productName like 'T%'
	
	--- nhap san pham tu bang product cua Northwind	
		
	insert  SanPham(MaSP,TenSp)
	select productID,ProductName from Northwind.dbo.Products
		update SanPham  set Mota='abcd' 
		select * from SanPham
			update SanPham  set Mota='HKkkkk' where Masp=1 
delete from sanpham
--2.	Cập nhật số lượng tồn = 50% số lượng tồn hiện có cho những sản phẩm có đơn vị tính có chữ box 
		update [Products]  set [UnitsInStock]=0.5* [UnitsInStock] where [QuantityPerUnit] like '%box%'
	
--3.	Cập nhật mã nhà cung cấp là 1 trong bảng NHACUNGCAP thành 100? Bạn có cập nhật được hay không?. Vì sao?. 

		---không  vì có khóa ngoại bảng san pham 
--4.	Tăng điểm tích lũy lên 100 cho những khách hàng mua hàng trong tháng 7 năm 1997
--5.	Giảm 10% đơn giá bán cho những sản phẩm có số lượng tồn <10. 
---6.	Cập nhật giá bán trong bảng CT_HoaDon bằng với đơn giá mua trong bảng SanPham của các sản phẩm do nhà cung cấp có mã là 4 hay 7. 

---BÀI TẬP 3: LỆNH DELETE
--Lưu ý, việc xóa dữ liệu là công việc cần thận trọng, nên chúng ta ít thao tác trên CSDL với lệnh DELETE,
--- trừ khi loại bỏ dữ liệu tạm. Nên phần này yêu cầu chúng ta phải sao chép dữ liệu trước khi thực hiện các công việc sau:

--1.	Xóa các hóa đơn được lập trong tháng 7 năm 1996. Bạn có thực hiện được không? Vì sao? 
delete  from Orders where month(OrderDate)=7 and year(orderdate)=1996

---không do xung đột khóa ngoại

--2.	Xóa các hóa đơn của các khách hàng có loại là VL mua hàng trong năm 1996.
delete  from Customers 
where 
 go

--3.	Xóa các sản phẩm chưa bán được trong năm 1996. 
--4.	Xóa các khách hàng vãng lai. Lưu ý khi xóa xong thì phải xóa luôn các hóa đơn và các chi tiết của các hóa đơn này trong bảng HoaDon và bảng CTHoaDon
--5.	Tạo bảng HoaDon797 chứa các hóa đơn được lập trong tháng 7 năm 1997. Sau đó xóa toàn bộ dữ liệu của bảng này bằng lệnh Truncate
 
