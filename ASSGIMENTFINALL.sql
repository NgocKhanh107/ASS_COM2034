
----Bài 1: Triển khai 3 Store Proc cho 3 bảng sau thực hiện CRUD bảng:

--Bảng Nhân Viên

-- function id cửa hàng
GO
CREATE FUNCTION ID_CH(@MACH NVARCHAR(20))
RETURNS INT
AS
BEGIN
	RETURN (SELECT Id FROM CuaHang WHERE Ma = @MACH)
END

-- function id chức vụ
GO
CREATE FUNCTION ID_CV (@MACV NVARCHAR(20))
RETURNS INT
AS
BEGIN
	RETURN (SELECT Id FROM ChucVu WHERE Ma = @MACV)
END
--SELECT * FROM NhanVien
GO 
ALTER PROC SP_PROC_NHANVIEN (
  @ID INT,@MA VARCHAR(20), @Ten NVARCHAR(30), @TenDem NVARCHAR(30), @Ho NVARCHAR(30), @GioiTinh NVARCHAR(10), @NgaySinh DATE, 
  @DiaChi NVARCHAR(50),  @sdt char(15), @maCh NVARCHAR(30),   @maCv VARCHAR(30), @idGuiBC int,@trangThai int,@SQLTYPE VARCHAR(20)
)
AS
BEGIN
	IF @SQLTYPE = 'SELECT'
	BEGIN
        SELECT * FROM NhanVien      
    END

	IF @SQLTYPE = 'INSERT'
	BEGIN
	IF @ID IS NULL OR @MA IS NULL OR @Ten IS NULL OR @TenDem IS NULL OR @Ho IS NULL OR @GioiTinh IS NULL OR @NgaySinh IS NULL OR 
		@DiaChi IS NULL OR @sdt IS NULL OR  @maCh IS NULL OR  @maCv IS NULL  OR  @trangThai IS NULL 
		PRINT N'VUI LÒNG NHẬP DỮ LIỆU'
	ELSE
	BEGIN TRY
		INSERT INTO NhanVien
        VALUES(@ma, @Ten, @TenDem, @Ho, @GioiTinh, @NgaySinh, @DiaChi, @sdt, dbo.ID_CH(@maCh), dbo.ID_CV(@maCv), @idGuiBC, @trangThai)
	END TRY
    BEGIN CATCH
      PRINT N'Thông báo :' + CAST(ERROR_NUMBER() as NVARCHAR(30))  
      PRINT N'Thông báo :' + ERROR_MESSAGE()
      PRINT N'Thông báo :' + CAST(ERROR_SEVERITY() as NVARCHAR(30))  
      PRINT N'Thông báo :' + CAST(ERROR_STATE() as NVARCHAR(30))  
      PRINT N'Thông báo :' + ERROR_PROCEDURE()      
    END CATCH
	END

	IF @SQLTYPE = 'UPDATE'
	BEGIN
	BEGIN TRY
		UPDATE NhanVien
		SET Ma = @Ma,Ten = @Ten,TenDem = @TenDem,Ho = @Ho,GioiTinh = @GioiTinh,NgaySinh = @NgaySinh,DiaChi = @DiaChi,
		Sdt = @sdt,IdCH = dbo.ID_CH(@maCh) ,IdCV = dbo.ID_CV(@maCv),IdGuiBC = @idGuiBC,TrangThai = @trangThai 
		WHERE Id = @Id
	END TRY
    BEGIN CATCH
      PRINT N'Thông báo :' + CAST(ERROR_NUMBER() as NVARCHAR(30))  
      PRINT N'Thông báo :' + ERROR_MESSAGE()
      PRINT N'Thông báo :' + CAST(ERROR_SEVERITY() as NVARCHAR(30))  
      PRINT N'Thông báo :' + CAST(ERROR_STATE() as NVARCHAR(30))  
      PRINT N'Thông báo :' + ERROR_PROCEDURE()        
    END CATCH
	END

	IF @SQLTYPE = 'DELETE'
	BEGIN
        DELETE NhanVien WHERE Id = @Id
    END

END

EXEC SP_PROC_NHANVIEN @ID = 0,@Ma = '',@Ten = ' ',@Tendem = '',@Ho = '',@GioiTinh= '',@NgaySinh = '',@DiaChi='',@sdt = '',@maCh = '',@maCv = '',@idGuiBC = null,@trangThai= 1,@SQLTYPE = 'select'

EXEC SP_PROC_NHANVIEN @ID = 30,@Ma = 'NV30',@Ten = N'Khánh',@Tendem = N'Ngọc',@Ho = N'Đỗ',@GioiTinh= 'Nam',@NgaySinh = '2002-10-07',@DiaChi=N'Thanh Hoá',@sdt = '0971063180',@maCh = 'CH10',@maCv = 'NV',@idGuiBC = null,@trangThai= 1,@SQLTYPE = 'INSERT'
SELECT * FROM NhanVien
---Bảng Khách Hàng
GO 
CREATE PROC SP_KHACH_HANG(
	@ID INT,@MA CHAR(10),@TEN NVARCHAR(20),@TEN_DEM NVARCHAR(20),@HO NVARCHAR(20),@NGAY_SINH DATE,@SDT CHAR(10),@DIACHI NVARCHAR(50),
	@THANH_PHO NVARCHAR(50),@QUOC_GIA NVARCHAR(50),@SQLTYPE VARCHAR(20)
)
AS
BEGIN
	IF @SQLTYPE = 'SELECT'
	BEGIN
	SELECT * FROM KhachHang
	END

	IF @SQLTYPE = 'INSERT'
	BEGIN
		IF @MA IS NULL OR @TEN IS NULL OR @TEN_DEM IS NULL OR @HO IS NULL OR  @NGAY_SINH IS NULL OR @SDT IS NULL
	    OR @DIACHI IS NULL OR @THANH_PHO IS NULL OR @QUOC_GIA IS NULL  
		PRINT N'VUI LÒNG NHẬP ĐỦ DỮ LIỆU'
		ELSE
		BEGIN TRY
			INSERT INTO KhachHang
			VALUES (@MA,@TEN,@TEN_DEM,@HO,@NGAY_SINH,@SDT,@DIACHI,@THANH_PHO,@QUOC_GIA)
		END TRY
		BEGIN CATCH
      PRINT N'Thông báo :' + CAST(ERROR_NUMBER() AS NVARCHAR(30))  
      PRINT N'Thông báo :' + ERROR_MESSAGE()
      PRINT N'Thông báo :' + CAST(ERROR_SEVERITY() AS NVARCHAR(30))  
      PRINT N'Thông báo :' + CAST(ERROR_STATE() AS NVARCHAR(30))  
      PRINT N'Thông báo :' + ERROR_PROCEDURE()      
    END CATCH
	END

	IF @SQLTYPE = 'UPDATE'
	BEGIN
	BEGIN TRY
	UPDATE KhachHang
	SET Ma=@MA, Ten=@TEN, TenDem=@TEN_DEM, HO=@HO, NgaySinh =@NGAY_SINH, Sdt=@SDT, DiaChi=@DIACHI, ThanhPho=@THANH_PHO,QuocGia=@QUOC_GIA
	WHERE Id = @ID
	END TRY
    BEGIN CATCH
      PRINT N'Thông báo :' + CAST(ERROR_NUMBER() as NVARCHAR(30))  
      PRINT N'Thông báo :' + ERROR_MESSAGE()
      PRINT N'Thông báo :' + CAST(ERROR_SEVERITY() as NVARCHAR(30))  
      PRINT N'Thông báo :' + CAST(ERROR_STATE() as NVARCHAR(30))  
      PRINT N'Thông báo :' + ERROR_PROCEDURE()        
    END CATCH
	END

	IF @SQLTYPE = 'DELETE'
	BEGIN
        DELETE KhachHang WHERE Id = @id
    END
END

EXEC SP_KHACH_HANG @ID =0,@MA ='',@TEN='',@TEN_DEM = '',@HO = '',@NGAY_SINH = '',@SDT = '',@DIACHI='',@THANH_PHO ='',@QUOC_GIA ='',@SQLTYPE ='SELECT'
EXEC SP_KHACH_HANG @ID =22,@MA ='KH22',@TEN=N'Khánh',@TEN_DEM = N'Ngọc',@HO = N'Đỗ',@NGAY_SINH = '2001-10-07',@SDT = '0971063180',@DIACHI=N'Thanh Hoá',@THANH_PHO =N'Thanh Hoá',@QUOC_GIA =N'Việt Nam',@SQLTYPE ='INSERT'
SELECT * FROM KhachHang
--Bảng Chi Tiết Sản Phẩm
--TẠO HÀM IDSP
GO
CREATE FUNCTION IDSP(@MASP NVARCHAR(20))
RETURNS INT
AS
BEGIN
    RETURN (SELECT Id FROM SanPham WHERE Ma = @MASP)  
END

--TẠO HÀM NSX
GO
CREATE FUNCTION IDNSX(@MANSX NVARCHAR(20))
RETURNS INT
AS
BEGIN
    RETURN (SELECT Id FROM NSX WHERE Ma = @MANSX)  
END

-- TẠO HÀM MÀU SẮC
GO
CREATE FUNCTION IDMS(@MAMS NVARCHAR(20))
RETURNS INT
AS
BEGIN
    RETURN (SELECT Id FROM MauSac WHERE Ma = @MAMS)  
END

--TẠO HÀM ĐỒNG SẢN PHẨM 
GO
CREATE FUNCTION IDDSP(@MADSP NVARCHAR(20))
RETURNS INT
AS
BEGIN
    RETURN (SELECT Id FROM DongSP WHERE Ma = @MADSP)  
END
-----
--SELECT * FROM ChiTietSP
GO 
CREATE PROC SP_SAN_PHAM(
	@ID INT,@MASP NVARCHAR(30),@MANSX NVARCHAR(30),@MAMS NVARCHAR(30),@MADSP NVARCHAR(30),@NAMBH INT,@MOTA NVARCHAR(50), @SL_TON INT,
    @GIA_NHAP DECIMAL(20,0),@GIA_BAN DECIMAL(20,0),@SQLTYPE NVARCHAR(30)  
)
AS
BEGIN
	IF @SQLTYPE = 'SELECT'
	BEGIN
		SELECT * FROM ChiTietSP
	END

	IF @SQLTYPE = 'INSERT'
	BEGIN
	IF dbo.IDSP(@MASP) IS NULL OR dbo.IDNSX(@MANSX)  IS NULL OR dbo.IDMS(@MAMS) IS NULL OR dbo.IDDSP(@MADSP) IS NULL
	  OR @SL_TON IS NULL 
	PRINT N'VUI LÒNG NHẬP ĐỦ DỮ LIỆU'
	ELSE
	BEGIN TRY
		INSERT INTO ChiTietSP
		VALUES (dbo.IDSP(@MASP),dbo.IDNSX(@MANSX),dbo.IDMS(@MAMS),dbo.IDDSP(@MADSP),@NAMBH,@MOTA,@SL_TON,@GIA_NHAP,@GIA_BAN)
	END TRY
	BEGIN CATCH
      PRINT N'Thông báo :' + CAST(ERROR_NUMBER() AS NVARCHAR(30))  
      PRINT N'Thông báo :' + ERROR_MESSAGE()
      PRINT N'Thông báo :' + CAST(ERROR_SEVERITY() AS NVARCHAR(30))  
      PRINT N'Thông báo :' + CAST(ERROR_STATE() AS NVARCHAR(30))  
      PRINT N'Thông báo :' + ERROR_PROCEDURE()      
    END CATCH
	END

	IF @SQLTYPE = 'UPDATE'
	BEGIN
	BEGIN TRY
	UPDATE ChiTietSP
	SET IdSP = dbo.IDSP(@MASP),IdNsx =dbo.IDNSX(@MANSX), IdMauSac=dbo.IDMS(@MAMS), IdDongSP=dbo.IDDSP(@MADSP),NamBH = @NAMBH,MoTa = @MOTA,
	SoLuongTon=@SL_TON,GiaBan=@GIA_BAN,GiaNhap=@GIA_NHAP
	WHERE Id = @ID
	END TRY
    BEGIN CATCH
      PRINT N'Thông báo :' + CAST(ERROR_NUMBER() as NVARCHAR(30))  
      PRINT N'Thông báo :' + ERROR_MESSAGE()
      PRINT N'Thông báo :' + CAST(ERROR_SEVERITY() as NVARCHAR(30))  
      PRINT N'Thông báo :' + CAST(ERROR_STATE() as NVARCHAR(30))  
      PRINT N'Thông báo :' + ERROR_PROCEDURE()        
    END CATCH
	END

	IF @SQLTYPE = 'DELETE'
    BEGIN
        DELETE ChiTietSP where Id = @id
    END
END
EXEC  SP_SAN_PHAM @ID =0,@MASP ='',@MANSX='',@MAMS='',@MADSP='',@NAMBH=NULL,@MOTA='',@SL_TON =0,@GIA_NHAP =0,@GIA_BAN =0,@SQLTYPE = 'select'
EXEC SP_SAN_PHAM @ID =23,@MASP ='SP10',@MANSX='MSI',@MAMS='MS2',@MADSP='DSP2',@NAMBH=6,@MOTA='',@SL_TON ='30',@GIA_NHAP =13000000,@GIA_BAN =15000000,@SQLTYPE = 'INSERT'
EXEC SP_SAN_PHAM @ID =24,@MASP ='SP11',@MANSX='AS',@MAMS='MS9',@MADSP='DSP13',@NAMBH=4,@MOTA='',@SL_TON ='30',@GIA_NHAP =13000000,@GIA_BAN =15000000,@SQLTYPE = 'INSERT'

SELECT * FROM ChiTietSP
--BAI 2
--BÀI 2.1
--SELECT * FROM ChiTietSP
GO
CREATE TRIGGER TR_BAI2 ON ChiTietSP FOR INSERT, UPDATE
AS
IF(SELECT SoLuongTon FROM inserted) < 0
	BEGIN
		PRINT N'SỐ LƯỢNG TỒN KHÔNG ĐƯỢC NHỎ HƠN 0'
		ROLLBACK TRANSACTION
	END
ELSE IF (SELECT GiaNhap FROM inserted) < 500000
	BEGIN
		PRINT N'GIÁ NHẬP KO ĐC NHỎ HƠN 50000'
		ROLLBACK TRANSACTION
	END

ELSE IF (SELECT NamBH FROM inserted) <1
	BEGIN
		PRINT N'NĂM BẢO HÀNH PHẢI LỚN HƠN NĂM HIỆN TẠI'
		ROLLBACK TRANSACTION
	END

--INSERT INTO ChiTietSP
--VALUES ('1','2','1','20',2,'',-2,22000000,23000000);
UPDATE ChiTietSP SET GiaNhap = 10000 WHERE IdSP ='2'

--BÀI 2.2: TD2 Tạo 1 Trigger Delete cho bảng nhân viên cho phép xóa nhân viên kể cả khi nhân viên đó đang có liên kết khóa phụ với bảng khác.
--SELECT * FROM NhanVien

GO
ALTER TRIGGER TR_DELETE ON NhanVien
INSTEAD OF DELETE
AS
BEGIN
	DELETE FROM HoaDon WHERE IdNV IN (SELECT IdNV FROM deleted)
	DELETE FROM NhanVien WHERE Id IN(SELECT Id FROM deleted)
	
END
DELETE FROM NhanVien where Id = 10
DELETE FROM HoaDon WHERE IdNV =10

--BAI3
--Hàm 1 tính tuổi
GO
CREATE FUNCTION Tuoi (@NS DATE)
RETURNS INT
AS
BEGIN
	RETURN YEAR(GETDATE()) - YEAR(@NS)
END

--Viết hàm tính số lượng nhân viên theo giới tính là tham số truyền vào của hàm.
--Kết quả hàm trả ra số lượng nhân viên tương ứng với giới tính đó.
go
CREATE FUNCTION countNV (@gt NVARCHAR(10))
RETURNS INT
BEGIN
    RETURN (SELECT COUNT(Ma)
    FROM NhanVien 
    WHERE GioiTinh = @gt)
END
GO
--SELECT dbo.countNV(N'Nữ')
DECLARE @tongNV INT
SET @tongNV = (SELECT COUNT(*)
FROM NhanVien)
PRINT N'Tổng số lượng nhân viên '+CAST(@tongNV AS NVARCHAR(10)) + N' có ' + CAST(dbo.countNv('Nam') AS NVARCHAR(30))
+ N' nhân viên nam ' +  N'và ' +  CAST(dbo.countNv(N'Nữ') AS NVARCHAR(30)) + N' nhân viên nữ'

--Viết hàm tính tổng doanh thu của một sản phẩm trong khoảng thời gian chỉ định.

go
CREATE FUNCTION F_TONGTIEN(@masp NVARCHAR(20),@NG_BĐ DATE,@NG_KT DATE)
RETURNS NVARCHAR(100)
BEGIN
	DECLARE @TIEN DECIMAL(20,0)
    SET @TIEN = (SELECT SUM(HDCT.SoLuong*HDCT.DonGia)
    FROM SanPham SP JOIN ChiTietSP CTSP ON SP.Id = CTSP.IdSP JOIN HoaDonChiTiet HDCT ON CTSP.Id = HDCT.IdChiTietSP 
	JOIN HoaDon HD ON HD.Id = HDCT.IdHoaDon WHERE SP.Ma = @masp AND DAY(NgayThanhToan) BETWEEN DAY(@NG_BĐ) AND DAY(@NG_KT)
    GROUP BY SP.Id )
	 
    IF @masp NOT IN (SELECT Ma FROM SanPham)
        BEGIN
            RETURN N'Không có mã sản phẩm'
        END 
    ELSE 
	BEGIN
            RETURN @masp +' '+(select Ten from SanPham where @masp = SanPham.Ma)+ ' ' +CAST(@TIEN as nvarchar(20))
            +' '+cast( ( SELECT SUM(SoLuong*GiaNhap)
            FROM SanPham JOIN ChiTietSP on SanPham.Id = ChiTietSP.IdSP join HoaDonChiTiet on HoaDonChiTiet.IdChiTietSP = ChiTietSP.Id
            WHERE Ma = @masp
            GROUP BY Ma ) as nvarchar(30))

        END 
		    return @TIEN
END

PRINT dbo.F_TONGTIEN('sp3','2022-01-01','2022-02-22')

---BÀI 4

--VIEW 1
GO
CREATE VIEW KHACH_HANG
AS
SELECT KH.Ma,KH.Ho+''+KH.TenDem+''+KH.Ten AS [HỌ TÊN], KH.NgaySinh,KH.Sdt,KH.DiaChi,KH.ThanhPho,SUM(HDCT.SoLuong) AS[SL_BÁN],
SUM(HDCT.SoLuong * HDCT.DonGia) AS [TỔNG TIỀN]
FROM KhachHang KH JOIN HoaDon HD ON KH.Id = HD.IdKH
JOIN HoaDonChiTiet HDCT ON HD.Id = HDCT.IdHoaDon
GROUP BY KH.Ma,KH.Ho+''+KH.TenDem+''+KH.Ten , KH.NgaySinh,KH.Sdt,KH.DiaChi,KH.ThanhPho
SELECT * FROM KHACH_HANG

--VIEW 2
GO
CREATE VIEW NHAN_VIEN
AS
SELECT NV.Ma,NV.Ho +' '+ NV.TenDem +' '+ NV.Ten AS [HỌ TÊN], NV.NgaySinh,dbo.Tuoi(NgaySinh) as [TUỔI],NV.Sdt,NV.DiaChi,NV.GioiTinh,CV.Ten,
SUM(HDCT.SoLuong) AS [SL_BÁN], SUM(HDCT.SoLuong* HDCT.DonGia) AS [TỔNG TỀN]
FROM NhanVien NV JOIN ChucVu CV ON NV.IdCV = CV.Id
JOIN HoaDon HD ON NV.Id = HD.IdNV
JOIN HoaDonChiTiet HDCT ON HD.DiaChi = HDCT.IdHoaDon
GROUP BY NV.Ma,NV.Ho +' '+ NV.TenDem +' '+ NV.Ten , NV.NgaySinh,dbo.Tuoi(NgaySinh) ,NV.Sdt,NV.DiaChi,NV.GioiTinh,CV.Ten
--SELECT * FROM NHAN_VIEN

---VIEW 3

GO
CREATE VIEW BAO_CAO
AS
SELECT HD.Id,NV.Ma,NV.Ten AS [TÊN_NV],HD.NgayTao,HD.NgayShip,DAY(NgayNhan) - DAY(NgayShip) AS [NGÀY CHẬM],KH.Ten AS [TÊN_KH],KH.Sdt,CH.Ten AS [TÊN _CH]
FROM HoaDon HD JOIN KhachHang KH ON HD.IdKH = KH.Id
JOIN NhanVien NV ON HD.IdNV = NV.Id
JOIN CuaHang CH ON NV.IdCH = CH.Id
SELECT * FROM BAO_CAO

--CÂU 10Đ
GO
update NhanVien
set Ten = Ten +'+3 TR'
where Id in (select NV.Id from NhanVien NV join HoaDon HD on NV.Id = HD.IdNV join HoaDonChiTiet HDCT on HDCT.IdHoaDon = HD.Id
group by NV.Id
having COUNT(HDCT.SoLuong) >=3)
