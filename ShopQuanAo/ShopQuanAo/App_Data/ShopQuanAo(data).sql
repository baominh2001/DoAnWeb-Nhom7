USE [master]
GO
/****** Object:  Database [ShopQuanAo]    Script Date: 01/09/2021 14:02:11 ******/
CREATE DATABASE [ShopQuanAo]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ShopQuanAo', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\ShopQuanAo.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ShopQuanAo_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\ShopQuanAo_log.ldf' , SIZE = 3456KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [ShopQuanAo] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ShopQuanAo].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ShopQuanAo] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ShopQuanAo] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ShopQuanAo] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ShopQuanAo] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ShopQuanAo] SET ARITHABORT OFF 
GO
ALTER DATABASE [ShopQuanAo] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ShopQuanAo] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [ShopQuanAo] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ShopQuanAo] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ShopQuanAo] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ShopQuanAo] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ShopQuanAo] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ShopQuanAo] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ShopQuanAo] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ShopQuanAo] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ShopQuanAo] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ShopQuanAo] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ShopQuanAo] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ShopQuanAo] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ShopQuanAo] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ShopQuanAo] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ShopQuanAo] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ShopQuanAo] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ShopQuanAo] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ShopQuanAo] SET  MULTI_USER 
GO
ALTER DATABASE [ShopQuanAo] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ShopQuanAo] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ShopQuanAo] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ShopQuanAo] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [ShopQuanAo]
GO
/****** Object:  StoredProcedure [dbo].[CapNhatSoLuong]    Script Date: 01/09/2021 14:02:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[CapNhatSoLuong](@MaHD int ,@MaSP int, @MaSize int , @SoLuong int,@DonGia int,@flag int)
as
	declare @soluongsp int,@soluongmua int
	select @soluongsp = t1.SoLuong
	from SanPham_Size t1
	where t1.MaSP = @MaSP and t1.MaSize = @MaSize
	if(@soluongsp = 0)
		begin
			return;
		end
	set @soluongmua = @SoLuong
	
	if(@soluongsp < @soluongmua)
		begin
			set @soluongmua = @soluongsp
			set @soluongsp = 0
		end
	else
		begin
			set @soluongsp = @soluongsp - @soluongmua
		end
	if(@flag = 0)
		begin
			insert into ChiTiet_HoaDon values(@MaHD,@MaSP,@MaSize,@soluongmua,@DonGia)
		end
	if(@flag = 1)
		begin
			update ChiTiet_HoaDon 
			set SoLuong = @soluongmua 
			where MaHD = @MaHD 
			and MaSP = @MaSP 
			and MaSize = @MaSize
		end
	update SanPham_Size
	set SoLuongTam = @soluongsp
	where MaSP = @MaSP and MaSize = @MaSize
	


GO
/****** Object:  StoredProcedure [dbo].[SUASP]    Script Date: 01/09/2021 14:02:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[SUASP](@MaSP int,@TenSP nvarchar(255),@GiaMua int ,@GiaBan int,@LoaiSP int,@ChuDe int,@ThongTin nvarchar(255),@GioiTinh int,@NgayNhapHang date,@HinhAnh nvarchar(255),@MaSize int ,@SoLuong int)
as
	if(Exists(select MASP from SANPHAM where MaSP = @MaSP))
		begin
			Update SANPHAM 
			Set TenSP = @TenSP,
			GiaMua = @GiaMua,GiaBan = @GiaBan,
			LoaiSP = @LoaiSP,ChuDe = @ChuDe,
			ThongTin = @ThongTin,
			GioiTinh = @GioiTinh,
			HinhAnh = @HinhAnh
			where MaSP = @MaSP
		end
	if(exists(select * from SanPham_Size where MaSP = @MaSP and MaSize = @MaSize))
		begin
			Update SanPham_Size
			set SoLuong = @SoLuong
			where MaSP = @MaSP and MaSize = @MaSize
		end
		
GO
/****** Object:  StoredProcedure [dbo].[THEMSP]    Script Date: 01/09/2021 14:02:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
		
create proc [dbo].[THEMSP](@MaSP int,@TenSP nvarchar(255),@GiaMua int ,@GiaBan int,@LoaiSP int,@ChuDe int,@ThongTin nvarchar(255),@GioiTinh int,@NgayNhapHang date,@HinhAnh nvarchar(255),@MaSize int ,@SoLuong int)
as
	insert into SANPHAM(TenSP,GiaMua,GiaBan,LoaiSP,ChuDe,ThongTin,GioiTinh,NgayNhapHang,HinhAnh)
	values(@TenSP,@GiaMua,@GiaBan,@LoaiSP,@ChuDe,@ThongTin,@GioiTinh,@NgayNhapHang,@HinhAnh)
	insert into SANPHAM_SIZE(MaSP,MaSize,SoLuong) values(@MaSP,@MaSize,@SoLuong)

GO
/****** Object:  StoredProcedure [dbo].[XOAKH]    Script Date: 01/09/2021 14:02:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[XOAKH] @MaKH int
as
	if(exists(select * from KhachHang where MaKH = @MaKH))
		begin
			--Bo cac rang buoc
			Alter table ChiTiet_HoaDon nocheck constraint all
			Alter table HoaDon nocheck constraint all
			Alter table BinhLuan nocheck constraint all
			--xoa du lieu trong bang KH
			delete from KhachHang
			where MaKH = @MaKH
			--Nap lai cac rang buoc
			Alter table ChiTiet_HoaDon check constraint all
			Alter table HoaDon check constraint all
			Alter table BinhLuan check constraint all
		end	
	else
		return
GO
/****** Object:  StoredProcedure [dbo].[XOASP]    Script Date: 01/09/2021 14:02:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[XOASP](@MaSP int)
as
	if(exists(select * from SANPHAM where MaSP = @MaSP))
		begin
			--vo hieu hoa cac rang buoc lien quan den bang SANPHAM
			alter table ChiTiet_HoaDon nocheck Constraint all
			alter table SanPham_Size nocheck Constraint all
			alter table BinhLuan nocheck Constraint all
			--thuc thi trigger
			Delete from SANPHAM
			where MaSP = @MaSP
			--kich hoat lai cac rang buoc
			alter table ChiTiet_HoaDon check Constraint all
			alter table SanPham_Size check Constraint all
			alter table BinhLuan check Constraint all
		end
	else
		return
GO
/****** Object:  Table [dbo].[BinhLuan]    Script Date: 01/09/2021 14:02:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BinhLuan](
	[MaBinhLuan] [int] IDENTITY(1,1) NOT NULL,
	[TieuDe] [nvarchar](255) NULL,
	[NoiDung] [text] NULL,
	[NgayBL] [date] NULL,
	[MaKH] [int] NOT NULL,
	[MaSP] [int] NOT NULL,
	[TrangThai] [bit] NULL,
 CONSTRAINT [PK_bl1] PRIMARY KEY CLUSTERED 
(
	[MaBinhLuan] ASC,
	[MaKH] ASC,
	[MaSP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ChiTiet_HoaDon]    Script Date: 01/09/2021 14:02:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTiet_HoaDon](
	[MaHD] [int] NOT NULL,
	[MaSP] [int] NOT NULL,
	[MaSize] [int] NOT NULL,
	[SoLuong] [int] NOT NULL,
	[DonGia] [int] NULL,
 CONSTRAINT [PK_ChiTiet_HoaDon] PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC,
	[MaSP] ASC,
	[MaSize] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HoaDon]    Script Date: 01/09/2021 14:02:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HoaDon](
	[MaHD] [int] NOT NULL,
	[NgayLapHD] [date] NULL,
	[NgayGiaoHang] [date] NULL,
	[MaKH] [int] NULL,
	[DiaChiGiaoHang] [nvarchar](255) NULL,
	[TrangThai] [bit] NULL,
 CONSTRAINT [PK_HoaDon] PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[KhachHang]    Script Date: 01/09/2021 14:02:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KhachHang](
	[MaKH] [int] IDENTITY(1,1) NOT NULL,
	[TenDangNhap] [nvarchar](50) NOT NULL,
	[MatKhau] [nvarchar](50) NOT NULL,
	[HoTen] [nvarchar](50) NOT NULL,
	[GioiTinh] [int] NOT NULL,
	[DiaChi] [text] NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[SoDienThoai] [nvarchar](11) NOT NULL,
	[LaAdmin] [bit] NULL,
 CONSTRAINT [PK_KhachHang] PRIMARY KEY CLUSTERED 
(
	[MaKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SanPham]    Script Date: 01/09/2021 14:02:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SanPham](
	[MaSP] [int] NOT NULL,
	[TenSP] [nvarchar](255) NULL,
	[GiaMua] [bigint] NULL,
	[GiaBan] [bigint] NULL,
	[LoaiSP] [int] NULL,
	[ChuDe] [int] NULL,
	[ThongTin] [nvarchar](255) NULL,
	[GioiTinh] [int] NULL,
	[NgayNhapHang] [date] NULL,
	[HinhAnh] [nvarchar](255) NULL,
 CONSTRAINT [PK_SanPham1] PRIMARY KEY CLUSTERED 
(
	[MaSP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SanPham_Size]    Script Date: 01/09/2021 14:02:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SanPham_Size](
	[MaSP] [int] NOT NULL,
	[MaSize] [int] NOT NULL,
	[SoLuong] [int] NULL,
	[SoLuongTam] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaSP] ASC,
	[MaSize] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Size]    Script Date: 01/09/2021 14:02:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Size](
	[MaSize] [int] NOT NULL,
	[Size] [nchar](3) NULL,
 CONSTRAINT [PK_Size] PRIMARY KEY CLUSTERED 
(
	[MaSize] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[BinhLuan] ON 

INSERT [dbo].[BinhLuan] ([MaBinhLuan], [TieuDe], [NoiDung], [NgayBL], [MaKH], [MaSP], [TrangThai]) VALUES (10, N'Áo khoác n? KN', N'ao dep qua !voteao dep qua !voteao dep qua !voteao dep qua !voteao dep qua !voteao dep qua !voteao dep qua !voteao dep qua !voteao dep qua !voteao dep qua !voteao dep qua !voteao dep qua !voteao dep qua !voteao dep qua !voteao dep qua !vote', CAST(N'2012-10-31' AS Date), 1, 34, 1)
INSERT [dbo].[BinhLuan] ([MaBinhLuan], [TieuDe], [NoiDung], [NgayBL], [MaKH], [MaSP], [TrangThai]) VALUES (21, N'abc', N'abc', CAST(N'2012-10-31' AS Date), 1, 34, 1)
INSERT [dbo].[BinhLuan] ([MaBinhLuan], [TieuDe], [NoiDung], [NgayBL], [MaKH], [MaSP], [TrangThai]) VALUES (22, N'as', N'as', CAST(N'2012-10-31' AS Date), 1, 34, 1)
INSERT [dbo].[BinhLuan] ([MaBinhLuan], [TieuDe], [NoiDung], [NgayBL], [MaKH], [MaSP], [TrangThai]) VALUES (23, N'as', N'as', CAST(N'2012-10-31' AS Date), 1, 34, 1)
INSERT [dbo].[BinhLuan] ([MaBinhLuan], [TieuDe], [NoiDung], [NgayBL], [MaKH], [MaSP], [TrangThai]) VALUES (24, N'asdasd', N'asdd', CAST(N'2012-10-31' AS Date), 1, 34, 1)
INSERT [dbo].[BinhLuan] ([MaBinhLuan], [TieuDe], [NoiDung], [NgayBL], [MaKH], [MaSP], [TrangThai]) VALUES (25, N' Ð?ng h? kute ', N'd?p quá', CAST(N'2012-11-11' AS Date), 1, 52, 1)
INSERT [dbo].[BinhLuan] ([MaBinhLuan], [TieuDe], [NoiDung], [NgayBL], [MaKH], [MaSP], [TrangThai]) VALUES (27, N'test', N'test', CAST(N'2012-11-18' AS Date), 1, 39, 1)
INSERT [dbo].[BinhLuan] ([MaBinhLuan], [TieuDe], [NoiDung], [NgayBL], [MaKH], [MaSP], [TrangThai]) VALUES (29, N'Qu?n Jean AX', N'test', CAST(N'2012-11-19' AS Date), 2, 39, 1)
INSERT [dbo].[BinhLuan] ([MaBinhLuan], [TieuDe], [NoiDung], [NgayBL], [MaKH], [MaSP], [TrangThai]) VALUES (30, N'abc', N'xin chao', CAST(N'2012-11-23' AS Date), 2, 42, 1)
INSERT [dbo].[BinhLuan] ([MaBinhLuan], [TieuDe], [NoiDung], [NgayBL], [MaKH], [MaSP], [TrangThai]) VALUES (31, N'binh luan', N'binh luan', CAST(N'2012-11-24' AS Date), 2, 39, 1)
INSERT [dbo].[BinhLuan] ([MaBinhLuan], [TieuDe], [NoiDung], [NgayBL], [MaKH], [MaSP], [TrangThai]) VALUES (32, N'abc', N'bc', CAST(N'2012-11-24' AS Date), 2, 26, 0)
INSERT [dbo].[BinhLuan] ([MaBinhLuan], [TieuDe], [NoiDung], [NgayBL], [MaKH], [MaSP], [TrangThai]) VALUES (33, N'ádasd', N'nhan an âcc', CAST(N'2012-11-29' AS Date), 2, 47, 1)
SET IDENTITY_INSERT [dbo].[BinhLuan] OFF
INSERT [dbo].[ChiTiet_HoaDon] ([MaHD], [MaSP], [MaSize], [SoLuong], [DonGia]) VALUES (247343, 42, 3, 14, 50000)
INSERT [dbo].[ChiTiet_HoaDon] ([MaHD], [MaSP], [MaSize], [SoLuong], [DonGia]) VALUES (347231, 18, 4, 10, 120000)
INSERT [dbo].[ChiTiet_HoaDon] ([MaHD], [MaSP], [MaSize], [SoLuong], [DonGia]) VALUES (347231, 22, 1, 12, 100000)
INSERT [dbo].[ChiTiet_HoaDon] ([MaHD], [MaSP], [MaSize], [SoLuong], [DonGia]) VALUES (347231, 39, 4, 12, 50000)
INSERT [dbo].[ChiTiet_HoaDon] ([MaHD], [MaSP], [MaSize], [SoLuong], [DonGia]) VALUES (347231, 52, 4, 12, 100000)
INSERT [dbo].[ChiTiet_HoaDon] ([MaHD], [MaSP], [MaSize], [SoLuong], [DonGia]) VALUES (602441, 18, 4, 100, 120000)
INSERT [dbo].[ChiTiet_HoaDon] ([MaHD], [MaSP], [MaSize], [SoLuong], [DonGia]) VALUES (904319, 42, 3, 13, 50000)
INSERT [dbo].[ChiTiet_HoaDon] ([MaHD], [MaSP], [MaSize], [SoLuong], [DonGia]) VALUES (1112815, 30, 1, 1, 10000)
INSERT [dbo].[HoaDon] ([MaHD], [NgayLapHD], [NgayGiaoHang], [MaKH], [DiaChiGiaoHang], [TrangThai]) VALUES (100, CAST(N'2012-11-13' AS Date), CAST(N'2012-11-13' AS Date), 1, N'cach mang thang 82', 1)
INSERT [dbo].[HoaDon] ([MaHD], [NgayLapHD], [NgayGiaoHang], [MaKH], [DiaChiGiaoHang], [TrangThai]) VALUES (101, CAST(N'2012-11-13' AS Date), CAST(N'2012-11-13' AS Date), 1, N'hai ba trung', 1)
INSERT [dbo].[HoaDon] ([MaHD], [NgayLapHD], [NgayGiaoHang], [MaKH], [DiaChiGiaoHang], [TrangThai]) VALUES (4188, CAST(N'2012-11-12' AS Date), CAST(N'2012-10-10' AS Date), 1, N'cong hoa', 1)
INSERT [dbo].[HoaDon] ([MaHD], [NgayLapHD], [NgayGiaoHang], [MaKH], [DiaChiGiaoHang], [TrangThai]) VALUES (241389, CAST(N'2012-11-12' AS Date), CAST(N'2012-10-10' AS Date), 1, N'nguyen phuc nguyen', 1)
INSERT [dbo].[HoaDon] ([MaHD], [NgayLapHD], [NgayGiaoHang], [MaKH], [DiaChiGiaoHang], [TrangThai]) VALUES (247343, CAST(N'2012-11-23' AS Date), CAST(N'2012-12-30' AS Date), 2, N'cmt1', 1)
INSERT [dbo].[HoaDon] ([MaHD], [NgayLapHD], [NgayGiaoHang], [MaKH], [DiaChiGiaoHang], [TrangThai]) VALUES (347231, CAST(N'2012-11-18' AS Date), CAST(N'2012-12-30' AS Date), 2, N'888 cmt8 p15 quan 10 tphcm', 1)
INSERT [dbo].[HoaDon] ([MaHD], [NgayLapHD], [NgayGiaoHang], [MaKH], [DiaChiGiaoHang], [TrangThai]) VALUES (602441, CAST(N'2012-11-24' AS Date), CAST(N'2012-12-23' AS Date), 2, N'asdasd', 1)
INSERT [dbo].[HoaDon] ([MaHD], [NgayLapHD], [NgayGiaoHang], [MaKH], [DiaChiGiaoHang], [TrangThai]) VALUES (904319, CAST(N'2012-11-24' AS Date), CAST(N'2012-12-30' AS Date), 2, N'abc', 1)
INSERT [dbo].[HoaDon] ([MaHD], [NgayLapHD], [NgayGiaoHang], [MaKH], [DiaChiGiaoHang], [TrangThai]) VALUES (1112815, CAST(N'2012-11-12' AS Date), CAST(N'2012-10-10' AS Date), 1, N'Le loi', 1)
INSERT [dbo].[HoaDon] ([MaHD], [NgayLapHD], [NgayGiaoHang], [MaKH], [DiaChiGiaoHang], [TrangThai]) VALUES (4292855, CAST(N'2012-11-13' AS Date), CAST(N'2012-12-30' AS Date), 1, N'', 1)
INSERT [dbo].[HoaDon] ([MaHD], [NgayLapHD], [NgayGiaoHang], [MaKH], [DiaChiGiaoHang], [TrangThai]) VALUES (5053950, CAST(N'2012-11-13' AS Date), CAST(N'2012-11-14' AS Date), 1, N'abc1', 1)
INSERT [dbo].[HoaDon] ([MaHD], [NgayLapHD], [NgayGiaoHang], [MaKH], [DiaChiGiaoHang], [TrangThai]) VALUES (6683242, CAST(N'2012-11-13' AS Date), CAST(N'2012-12-30' AS Date), 1, N'bc', 0)
INSERT [dbo].[HoaDon] ([MaHD], [NgayLapHD], [NgayGiaoHang], [MaKH], [DiaChiGiaoHang], [TrangThai]) VALUES (9392139, CAST(N'2012-11-13' AS Date), CAST(N'2012-12-30' AS Date), 1, N'abc', 0)
SET IDENTITY_INSERT [dbo].[KhachHang] ON 

INSERT [dbo].[KhachHang] ([MaKH], [TenDangNhap], [MatKhau], [HoTen], [GioiTinh], [DiaChi], [Email], [SoDienThoai], [LaAdmin]) VALUES (1, N'admin', N'admin', N'1237', 1, N'cmt8', N'dangcap@yahoo.com', N'0127588127', 1)
INSERT [dbo].[KhachHang] ([MaKH], [TenDangNhap], [MatKhau], [HoTen], [GioiTinh], [DiaChi], [Email], [SoDienThoai], [LaAdmin]) VALUES (2, N'test', N'123456', N'test24', 0, N'nguyen thi minh khai', N'test@yahoo.com', N'012345667', 0)
INSERT [dbo].[KhachHang] ([MaKH], [TenDangNhap], [MatKhau], [HoTen], [GioiTinh], [DiaChi], [Email], [SoDienThoai], [LaAdmin]) VALUES (14, N'test2', N'123', N'nguyen van a', 1, N'sg', N'sg@yahoo.com', N'123213', 0)
INSERT [dbo].[KhachHang] ([MaKH], [TenDangNhap], [MatKhau], [HoTen], [GioiTinh], [DiaChi], [Email], [SoDienThoai], [LaAdmin]) VALUES (17, N'minh1503', N'123456', N'B?o Minh', 1, N'123 trong tan', N'bao@gmail.com', N'0701351854', 0)
SET IDENTITY_INSERT [dbo].[KhachHang] OFF
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (18, N'Áo thun nam trắng', 50000, 120000, 0, 0, N'Áo thun trắng  được làm từ Poly cotton mềm mịn giúp thấm hút hiệu quả, tạo cảm giác thoải mái cho người mặc. Ngoài ra, chất liệu này bạn có thể giặt áo dễ dàng, ngăn ngừa nấm mốc gây hại cho da.', 1, CAST(N'2012-10-10' AS Date), N'images/SanPham/ThunNamTrang.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (19, N'Áo thun nam nâu', 10000, 2000000, 0, 0, N'Áo được sản xuất cẩn thận từng chi tiết, mang lại form dáng đẹp cho người dùng. Ngoài ra, áo có nhiều size phù hợp với tất cả mọi người.Tính linh hoạt trong phối đồ cũng là 1 điểm cộng để sản phẩm này được khách hàng yêu thích', 1, CAST(N'2012-10-10' AS Date), N'images/SanPham/ThunNamNau.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (20, N'Áo thun nữ hình thỏ', 50000, 120000, 0, 3, N'Áo thun nữ phong cách đơn giản nhẹ nhàng: vải thun Cotton 100% thoáng mát, dễ chịu lúc mặc.Phong cách đơn giản thiết kế cổ tròn, tay lửng giúp bạn gái trông thật năng động và xinh đẹp.', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/ThunNuTho.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (21, N'Áo thun nữ in chữ HADES', 50000, 100000, 0, 0, N'Áo thun nữ phong cách đơn giản nhẹ nhàng: vải thun Cotton 100% thoáng mát, dễ chịu lúc mặc.Phong cách đơn giản thiết kế cổ tròn, tay lửng giúp bạn gái trông thật năng động và xinh đẹp.', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/ThunNuHADES.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (22, N'Áo thun nữ sọc ngang', 50000, 100000, 0, 3, N'Áo thun nữ phong cách đơn giản nhẹ nhàng: vải thun Cotton 100% thoáng mát, dễ chịu lúc mặc.Phong cách đơn giản thiết kế cổ tròn, tay lửng giúp bạn gái trông thật năng động và xinh đẹp.', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/ThunNuSocNgang.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (23, N'Áo thun nữ thêu hình tim', 50000, 100000, 0, 3, N'Áo thun nữ phong cách đơn giản nhẹ nhàng: vải thun Cotton 100% thoáng mát, dễ chịu lúc mặc.Phong cách đơn giản thiết kế cổ tròn, tay lửng giúp bạn gái trông thật năng động và xinh đẹp.', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/ThunNuTheuTim.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (24, N'Áo thun nữ tay ngắn', 50000, 100000, 0, 3, N'Áo thun nữ phong cách đơn giản nhẹ nhàng: vải thun Cotton 100% thoáng mát, dễ chịu lúc mặc.Phong cách đơn giản thiết kế cổ tròn, tay lửng giúp bạn gái trông thật năng động và xinh đẹp.', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/ThunNuTayNgan.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (25, N'Áo thun nữ tay lỡ', 50000, 100000, 0, 0, N'Áo thun nữ phong cách đơn giản nhẹ nhàng: vải thun Cotton 100% thoáng mát, dễ chịu lúc mặc.Phong cách đơn giản thiết kế cổ tròn, tay lửng giúp bạn gái trông thật năng động và xinh đẹp.', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/ThunNuTayLo.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (26, N'Áo sơ mi đen', 50000, 100000, 1, 1, N'Với thiết kế này, chiếc sơ mi hàng hiệu mang lại sự mềm mại, tinh khôi và duyên dáng cho những quý cô nữ tính, dịu dàng. Bên cạnh đó, với thiết kế mới lạ vạt chéo tạo cổ hình chữ V sâu tạo thêm nét quyến rũ cho người mặc', 1, CAST(N'2012-10-10' AS Date), N'images/SanPham/SoMiDen.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (27, N'Áo sơ mi hàn quốc ', 50000, 100000, 1, 0, N'Với thiết kế này, chiếc sơ mi hàng hiệu mang lại sự mềm mại, tinh khôi và duyên dáng cho những quý cô nữ tính, dịu dàng. Bên cạnh đó, với thiết kế mới lạ vạt chéo tạo cổ hình chữ V sâu tạo thêm nét quyến rũ cho người mặc', 1, CAST(N'2012-10-10' AS Date), N'images/SanPham/SoMiHQ.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (28, N'Áo sơ mi khoác ngoài', 50000, 100000, 1, 2, N'Với thiết kế này, chiếc sơ mi hàng hiệu mang lại sự mềm mại, tinh khôi và duyên dáng cho những quý cô nữ tính, dịu dàng. Bên cạnh đó, với thiết kế mới lạ vạt chéo tạo cổ hình chữ V sâu tạo thêm nét quyến rũ cho người mặc', 1, CAST(N'2012-10-10' AS Date), N'images/SanPham/SoMiKhoacNgoai.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (29, N'Áo sơ mi chấm bi cổ V', 50000, 100000, 1, 2, N'Với thiết kế này, chiếc sơ mi hàng hiệu mang lại sự mềm mại, tinh khôi và duyên dáng cho những quý cô nữ tính, dịu dàng. Bên cạnh đó, với thiết kế mới lạ vạt chéo tạo cổ hình chữ V sâu tạo thêm nét quyến rũ cho người mặc', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/SoMiCoV.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (30, N'Áo sơ mi nữ nơ đính hạt', 50000, 100000, 1, 2, N'Với thiết kế này, chiếc sơ mi hàng hiệu mang lại sự mềm mại, tinh khôi và duyên dáng cho những quý cô nữ tính, dịu dàng. Bên cạnh đó, với thiết kế mới lạ vạt chéo tạo cổ hình chữ V sâu tạo thêm nét quyến rũ cho người mặc', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/SoMiDinhHat.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (31, N'Áo Sơmi nữ công sở', 50000, 50000, 1, 0, N'Với thiết kế này, chiếc sơ mi hàng hiệu mang lại sự mềm mại, tinh khôi và duyên dáng cho những quý cô nữ tính, dịu dàng. Bên cạnh đó, với thiết kế mới lạ vạt chéo tạo cổ hình chữ V sâu tạo thêm nét quyến rũ cho người mặc', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/SoMiCongSo.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (32, N'Áo khoác jean', 50000, 50000, 2, 0, N'áo khoác thun nữ đẹp ngoài tác dụng chống nắng còn giúp các bạn nữ tạo nên phong cách thời trang ấn tượng cho chính bản thân mình. ', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/AoKhoacJEAN.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (33, N'Áo khoác kaki nữ ', 50000, 50000, 2, 0, N'áo khoác thun nữ đẹp ngoài tác dụng chống nắng còn giúp các bạn nữ tạo nên phong cách thời trang ấn tượng cho chính bản thân mình. ', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/AoKhoacKAKI.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (34, N'Áo khoác kaki 2 lớp nữ', 50000, 50000, 2, 1, N'áo khoác thun nữ đẹp ngoài tác dụng chống nắng còn giúp các bạn nữ tạo nên phong cách thời trang ấn tượng cho chính bản thân mình. ', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/AoKhoacKAKI2LOP.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (35, N'Áo khoác gió', 50000, 50000, 2, 0, N'Form chuẩn Unisex Nam Nữ Couple đều mặc được.Thích hợp sử dụng khi đi chơi, dã ngoại , dạo, phố……Đường kim mũi chỉ kép cực tinh tế, đường may kỹ. ', 1, CAST(N'2012-10-10' AS Date), N'images/SanPham/AoKhoacGio.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (36, N'Áo khoác nam Bomber', 50000, 50000, 2, 0, N'Form chuẩn Unisex Nam Nữ Couple đều mặc được.Thích hợp sử dụng khi đi chơi, dã ngoại , dạo, phố……Đường kim mũi chỉ kép cực tinh tế, đường may kỹ. ', 1, CAST(N'2012-10-10' AS Date), N'images/SanPham/AoKhoacBomber.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (37, N'Áo khoác Hàn Quốc', 50000, 50000, 2, 0, N'Form chuẩn Unisex Nam Nữ Couple đều mặc được.Thích hợp sử dụng khi đi chơi, dã ngoại , dạo, phố……Đường kim mũi chỉ kép cực tinh tế, đường may kỹ. ', 1, CAST(N'2012-10-10' AS Date), N'images/SanPham/AoKhoacHQ.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (38, N'Quần Jean nam ống suông', 50000, 50000, 3, 0, N'giúp người mặc thoải mái khi vận động, ngoài tác dụng bảo vệ cơ thể chống bụi, bẩn, quần jean nam rách gối cá tính còn là món đồ không thể thiếu của các bạn nam mỗi khi đi chơi, hội họp...', 1, CAST(N'2012-10-10' AS Date), N'images/SanPham/JeanOngSuong.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (39, N'Quần Jean nam xám đen', 50000, 50000, 3, 1, N'giúp người mặc thoải mái khi vận động, ngoài tác dụng bảo vệ cơ thể chống bụi, bẩn, quần jean nam rách gối cá tính còn là món đồ không thể thiếu của các bạn nam mỗi khi đi chơi, hội họp...', 1, CAST(N'2012-10-10' AS Date), N'images/SanPham/JeanXamDen.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (40, N'Quần Jean nam trơn co giãn', 50000, 50000, 3, 0, N'giúp người mặc thoải mái khi vận động, ngoài tác dụng bảo vệ cơ thể chống bụi, bẩn, quần jean nam rách gối cá tính còn là món đồ không thể thiếu của các bạn nam mỗi khi đi chơi, hội họp...', 1, CAST(N'2012-10-10' AS Date), N'images/SanPham/JeanTronCoGian.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (41, N'Quần Jean nữ 9 tấc', 50000, 50000, 3, 0, N'luôn là một siêu phẩm hot nhất hiện nay, đây là mẫu mới ra, chất vải mới nhé mọi người. Hứa hẹn sẽ làm điên đảo các cô nàng.', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/Jean9Tac.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (42, N'Quần Jean baggy nữ ống rộng', 50000, 50000, 3, 1, N'luôn là một siêu phẩm hot nhất hiện nay, đây là mẫu mới ra, chất vải mới nhé mọi người. Hứa hẹn sẽ làm điên đảo các cô nàng.', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/JeanOngRong.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (43, N'Quần Jean nữ ôm sát lưng', 50000, 50000, 3, 0, N'luôn là một siêu phẩm hot nhất hiện nay, đây là mẫu mới ra, chất vải mới nhé mọi người. Hứa hẹn sẽ làm điên đảo các cô nàng.', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/JeanOmSatLung.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (44, N'Quần kaki Aristino', 50000, 50000, 4, 0, N'Quần kaki nam ZARA form trẻ trung, với 2 túi trước và 1 túi mổ đơn giản phía sau rất thuận tiện cho quá trình sử dụng. Chất liệu vải kaki cao cấp, không nhăn sau khi giặt, thoáng mát và co dãn khi mặc.', 1, CAST(N'2012-10-10' AS Date), N'images/SanPham/AristinoKaki.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (45, N'Quần kaki Hàn Quốc', 50000, 50000, 4, 0, N'Quần kaki nam ZARA form trẻ trung, với 2 túi trước và 1 túi mổ đơn giản phía sau rất thuận tiện cho quá trình sử dụng. Chất liệu vải kaki cao cấp, không nhăn sau khi giặt, thoáng mát và co dãn khi mặc.', 1, CAST(N'2012-10-10' AS Date), N'images/SanPham/KakiHQ.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (46, N'Quần kaki Uniqlo', 50000, 50000, 4, 0, N'Quần kaki nam ZARA form trẻ trung, với 2 túi trước và 1 túi mổ đơn giản phía sau rất thuận tiện cho quá trình sử dụng. Chất liệu vải kaki cao cấp, không nhăn sau khi giặt, thoáng mát và co dãn khi mặc.', 1, CAST(N'2012-10-10' AS Date), N'images/SanPham/KakiUniqlo.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (47, N'Váy nữ Pháp', 50000, 100000, 5, 1, N'Trong cuộc sống của mỗi phụ nữ, diễn ra trang trọng, lãng mạn, chính thức và sự kiện kinh doanh và các cuộc họp diễn ra, mà trên đó cô ấy phải nhìn không thể cưỡng lại, phong cách và nữ tính.', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/VayPhap.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (48, N'Váy nữ trễ vai', 50000, 100000, 5, 0, N'Trong cuộc sống của mỗi phụ nữ, diễn ra trang trọng, lãng mạn, chính thức và sự kiện kinh doanh và các cuộc họp diễn ra, mà trên đó cô ấy phải nhìn không thể cưỡng lại, phong cách và nữ tính.', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/VayTreVai.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (49, N'Váy nữ mùa hè', 50000, 100000, 5, 0, N'Trong cuộc sống của mỗi phụ nữ, diễn ra trang trọng, lãng mạn, chính thức và sự kiện kinh doanh và các cuộc họp diễn ra, mà trên đó cô ấy phải nhìn không thể cưỡng lại, phong cách và nữ tính.', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/VayMuaHe.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (52, N'Đồng hồ kute', 50000, 100000, 6, 0, N'phong phú và đa dạng gắn liền với các hoạt động thể thao và các ngôi sao ', 0, CAST(N'2012-10-10' AS Date), N'images/SanPham/d02.jpg')
INSERT [dbo].[SanPham] ([MaSP], [TenSP], [GiaMua], [GiaBan], [LoaiSP], [ChuDe], [ThongTin], [GioiTinh], [NgayNhapHang], [HinhAnh]) VALUES (53, N'Thắt lưng nam', 50000, 100000, 7, 0, N'phong phú và bắt mắt', 1, CAST(N'2012-10-10' AS Date), N'images/SanPham/ThatLung.jpg')
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (18, 4, 4912, 4912)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (19, 2, 10000, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (20, 1, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (21, 1, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (22, 1, 14, 14)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (23, 1, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (24, 3, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (25, 4, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (26, 1, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (26, 2, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (26, 3, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (27, 1, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (28, 4, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (29, 1, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (29, 2, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (29, 3, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (29, 4, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (30, 1, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (31, 2, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (33, 3, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (34, 4, 14, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (35, 3, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (36, 1, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (37, 2, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (38, 3, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (39, 4, 0, 0)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (40, 1, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (41, 2, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (42, 3, 0, 0)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (43, 2, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (44, 1, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (45, 4, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (46, 2, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (47, 2, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (48, 1, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (49, 3, 15, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (52, 4, 14, 14)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (100, 0, 20, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (100, 1, 20, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (100, 2, 2, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (100, 3, 2, NULL)
INSERT [dbo].[SanPham_Size] ([MaSP], [MaSize], [SoLuong], [SoLuongTam]) VALUES (100, 4, 2, NULL)
INSERT [dbo].[Size] ([MaSize], [Size]) VALUES (0, N's  ')
INSERT [dbo].[Size] ([MaSize], [Size]) VALUES (1, N'm  ')
INSERT [dbo].[Size] ([MaSize], [Size]) VALUES (2, N'l  ')
INSERT [dbo].[Size] ([MaSize], [Size]) VALUES (3, N'xl ')
INSERT [dbo].[Size] ([MaSize], [Size]) VALUES (4, N'xxl')
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_KH_Email]    Script Date: 01/09/2021 14:02:11 ******/
ALTER TABLE [dbo].[KhachHang] ADD  CONSTRAINT [UQ_KH_Email] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ_KH_Username]    Script Date: 01/09/2021 14:02:11 ******/
ALTER TABLE [dbo].[KhachHang] ADD  CONSTRAINT [UQ_KH_Username] UNIQUE NONCLUSTERED 
(
	[TenDangNhap] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BinhLuan]  WITH NOCHECK ADD  CONSTRAINT [FK_BinhLuan_KH] FOREIGN KEY([MaKH])
REFERENCES [dbo].[KhachHang] ([MaKH])
GO
ALTER TABLE [dbo].[BinhLuan] CHECK CONSTRAINT [FK_BinhLuan_KH]
GO
ALTER TABLE [dbo].[BinhLuan]  WITH NOCHECK ADD  CONSTRAINT [FK_MaSP_BL] FOREIGN KEY([MaSP])
REFERENCES [dbo].[SanPham] ([MaSP])
GO
ALTER TABLE [dbo].[BinhLuan] CHECK CONSTRAINT [FK_MaSP_BL]
GO
ALTER TABLE [dbo].[ChiTiet_HoaDon]  WITH NOCHECK ADD  CONSTRAINT [FK_ChiTiet_HoaDon_HoaDon] FOREIGN KEY([MaHD])
REFERENCES [dbo].[HoaDon] ([MaHD])
GO
ALTER TABLE [dbo].[ChiTiet_HoaDon] CHECK CONSTRAINT [FK_ChiTiet_HoaDon_HoaDon]
GO
ALTER TABLE [dbo].[ChiTiet_HoaDon]  WITH NOCHECK ADD  CONSTRAINT [FK_ChiTiet_HoaDon_SanPham] FOREIGN KEY([MaSP])
REFERENCES [dbo].[SanPham] ([MaSP])
GO
ALTER TABLE [dbo].[ChiTiet_HoaDon] CHECK CONSTRAINT [FK_ChiTiet_HoaDon_SanPham]
GO
ALTER TABLE [dbo].[ChiTiet_HoaDon]  WITH NOCHECK ADD  CONSTRAINT [FK_ChiTiet_HoaDon_Size] FOREIGN KEY([MaSize])
REFERENCES [dbo].[Size] ([MaSize])
GO
ALTER TABLE [dbo].[ChiTiet_HoaDon] CHECK CONSTRAINT [FK_ChiTiet_HoaDon_Size]
GO
ALTER TABLE [dbo].[HoaDon]  WITH NOCHECK ADD  CONSTRAINT [FK_HoaDon_KhachHang] FOREIGN KEY([MaKH])
REFERENCES [dbo].[KhachHang] ([MaKH])
GO
ALTER TABLE [dbo].[HoaDon] CHECK CONSTRAINT [FK_HoaDon_KhachHang]
GO
ALTER TABLE [dbo].[SanPham_Size]  WITH NOCHECK ADD  CONSTRAINT [FK_MaSize_S] FOREIGN KEY([MaSize])
REFERENCES [dbo].[Size] ([MaSize])
GO
ALTER TABLE [dbo].[SanPham_Size] CHECK CONSTRAINT [FK_MaSize_S]
GO
ALTER TABLE [dbo].[SanPham_Size]  WITH NOCHECK ADD  CONSTRAINT [FK_SP_Size1] FOREIGN KEY([MaSP])
REFERENCES [dbo].[SanPham] ([MaSP])
GO
ALTER TABLE [dbo].[SanPham_Size] CHECK CONSTRAINT [FK_SP_Size1]
GO
USE [master]
GO
ALTER DATABASE [ShopQuanAo] SET  READ_WRITE 
GO
