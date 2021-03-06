USE [master]
GO
/****** Object:  Database [gsmOtomasyonDB]    Script Date: 30.06.2021 13:34:37 ******/
CREATE DATABASE [gsmOtomasyonDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'gsmOtomasyon', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\gsmOtomasyon.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'gsmOtomasyon_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\gsmOtomasyon_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [gsmOtomasyonDB] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [gsmOtomasyonDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [gsmOtomasyonDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [gsmOtomasyonDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [gsmOtomasyonDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [gsmOtomasyonDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [gsmOtomasyonDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [gsmOtomasyonDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [gsmOtomasyonDB] SET  MULTI_USER 
GO
ALTER DATABASE [gsmOtomasyonDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [gsmOtomasyonDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [gsmOtomasyonDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [gsmOtomasyonDB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [gsmOtomasyonDB]
GO
/****** Object:  StoredProcedure [dbo].[iadeYap]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[iadeYap]
@satisID int
as
delete from Satislar
where @satisID=id
GO
/****** Object:  StoredProcedure [dbo].[musteriEkle]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[musteriEkle]
@musteriAdiSoyadi varchar(30), 
@musteriTelefon varchar(30), 
@MusteriAdres varchar(30),
@MusteriMail varchar(30)
as
insert into 
Musteri (adiSoyadi, telefon, adres, email) 
values (@musteriAdiSoyadi, @musteriTelefon, @MusteriAdres, @MusteriMail)
GO
/****** Object:  StoredProcedure [dbo].[musteriSil]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[musteriSil]
@musteriNo int
as
delete from Musteri
where @musteriNo=id
GO
/****** Object:  StoredProcedure [dbo].[SatislariGoster]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SatislariGoster]
as
Select s.id, m2.MarkaAdi, m1.ModelAdi, m3.adiSoyadi as Müşteri, 
s2.SubeAdi, k.adiSoyadi as Kasiyer, s.satisFiyati, s.satisTarihi
From Satislar s
INNER JOIN Urun u
On s.UrunID=u.id
INNER JOIN Model m1
ON m1.id=u.modelNo
INNER JOIN Marka m2
ON m2.id= m1.MarkaID
INNER JOIN Kullanici k
ON k.id= s.kullaniciNo
INNER JOIN Gorevler g
ON g.id=k.gorevID
INNER JOIN Subeler s2
ON s2.id=s.subeNo
INNER JOIN Musteri m3
ON s.musteriNo=m3.id
GO
/****** Object:  StoredProcedure [dbo].[satisYap]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[satisYap]
@musteriNo int,
@urunID int,
@fiyat money
as
begin try
begin transaction
insert into 
Satislar(musteriNo, UrunID, subeNo,kullaniciNo, satisFiyati, satisTarihi)
values (@musteriNo,@urunID,1,1,@fiyat,GETDATE())
commit transaction
end try 
begin catch
rollback tran 
print 'Satış yapılırken beklenmeyen bir hata oluştu'
end catch
GO
/****** Object:  StoredProcedure [dbo].[telefonlariGetir]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[telefonlariGetir]
as
Select u.id, m3.MarkaAdi,m2.ModelAdi, s.miktar,u.Cozunurluk, u.hafiza, u.renk,  m2.cikisTarihi
from Urun u INNER JOIN Model m2
ON u.modelNo=m2.id
INNER JOIN Marka m3
ON M2.MarkaID=m3.id
INNER JOIN Stok s
ON s.urunID=u.id
GO
/****** Object:  StoredProcedure [dbo].[yapilanSatislar]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[yapilanSatislar]
@musteriNo int
as
Select s.id, m.adiSoyadi as AdıSoyadı, m1.MarkaAdi, m2.ModelAdi, s.satisTarihi, s.satisFiyati
FROM Satislar s INNER JOIN Musteri m
ON s.musteriNo= m.id
INNER JOIN Urun u
ON s.UrunID=u.id
INNER JOIN Model m2
ON u.modelNo = m2.id
INNER JOIN Marka m1
ON m2.MarkaID= m1.id
Where @musteriNo=m.id
GO
/****** Object:  UserDefinedFunction [dbo].[SatisMiktari]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create function [dbo].[SatisMiktari]()
returns int
as
begin
declare @miktar int
select @miktar = Count(id) from Satislar
return @miktar
end
GO
/****** Object:  UserDefinedFunction [dbo].[stokSayisi]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create function [dbo].[stokSayisi]()
returns int
as
begin
declare @miktar int
select @miktar = SUM(miktar) from Stok
return @miktar
end
GO
/****** Object:  Table [dbo].[Gorevler]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Gorevler](
	[id] [int] NOT NULL,
	[GorevAdi] [varchar](50) NULL,
 CONSTRAINT [PK_Gorevler] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[iadeler]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iadeler](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[iadeUrunu] [varchar](50) NULL,
	[iadeMusterisi] [varchar](50) NULL,
	[iadeTutari] [int] NULL,
	[iadeTarihi] [date] NULL,
 CONSTRAINT [PK_iadeler] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Kullanici]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Kullanici](
	[id] [int] NOT NULL,
	[adiSoyadi] [varchar](50) NULL,
	[telefon] [varchar](50) NULL,
	[adres] [varchar](50) NULL,
	[email] [varchar](50) NULL,
	[gorevID] [int] NULL,
	[kullaniciAdi] [varchar](50) NULL,
	[sifre] [varchar](50) NULL,
 CONSTRAINT [PK_Kullanici] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Marka]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Marka](
	[id] [int] NOT NULL,
	[MarkaAdi] [varchar](50) NULL,
 CONSTRAINT [PK_Marka] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Model]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Model](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[MarkaID] [int] NOT NULL,
	[ModelAdi] [varchar](50) NULL,
	[cikisTarihi] [date] NULL,
 CONSTRAINT [PK_Model] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Musteri]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Musteri](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[adiSoyadi] [varchar](50) NULL,
	[telefonNumarasi] [varchar](50) NULL,
	[adres] [varchar](50) NULL,
	[email] [varchar](50) NULL,
 CONSTRAINT [PK_Musteri] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Satislar]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Satislar](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[iadeNo] [int] NULL,
	[UrunID] [int] NOT NULL,
	[musteriNo] [int] NOT NULL,
	[subeNo] [int] NOT NULL,
	[kullaniciNo] [int] NULL,
	[satisFiyati] [money] NULL,
	[satisTarihi] [date] NULL,
 CONSTRAINT [PK_Satislar] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Stok]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stok](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[urunID] [int] NOT NULL,
	[miktar] [int] NOT NULL,
	[alisTarihi] [date] NULL,
	[alisFiyatı] [money] NULL,
 CONSTRAINT [PK_Stok] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Subeler]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Subeler](
	[id] [int] NOT NULL,
	[SubeAdi] [varchar](50) NULL,
	[SubeAdresi] [varchar](50) NULL,
	[SubeTelNo] [varchar](50) NULL,
 CONSTRAINT [PK_Fatura] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Urun]    Script Date: 30.06.2021 13:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Urun](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[hafiza] [varchar](50) NULL,
	[Cozunurluk] [varchar](50) NULL,
	[renk] [varchar](50) NULL,
	[modelNo] [int] NULL,
 CONSTRAINT [PK_Urun] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Kullanici]  WITH CHECK ADD  CONSTRAINT [FK_Kullanici_Gorevler] FOREIGN KEY([gorevID])
REFERENCES [dbo].[Gorevler] ([id])
GO
ALTER TABLE [dbo].[Kullanici] CHECK CONSTRAINT [FK_Kullanici_Gorevler]
GO
ALTER TABLE [dbo].[Model]  WITH CHECK ADD  CONSTRAINT [FK_Model_Marka] FOREIGN KEY([MarkaID])
REFERENCES [dbo].[Marka] ([id])
GO
ALTER TABLE [dbo].[Model] CHECK CONSTRAINT [FK_Model_Marka]
GO
ALTER TABLE [dbo].[Satislar]  WITH CHECK ADD  CONSTRAINT [FK_Satislar_Fatura] FOREIGN KEY([subeNo])
REFERENCES [dbo].[Subeler] ([id])
GO
ALTER TABLE [dbo].[Satislar] CHECK CONSTRAINT [FK_Satislar_Fatura]
GO
ALTER TABLE [dbo].[Satislar]  WITH CHECK ADD  CONSTRAINT [FK_Satislar_iadeler] FOREIGN KEY([iadeNo])
REFERENCES [dbo].[iadeler] ([id])
GO
ALTER TABLE [dbo].[Satislar] CHECK CONSTRAINT [FK_Satislar_iadeler]
GO
ALTER TABLE [dbo].[Satislar]  WITH CHECK ADD  CONSTRAINT [FK_Satislar_Kullanici] FOREIGN KEY([kullaniciNo])
REFERENCES [dbo].[Kullanici] ([id])
GO
ALTER TABLE [dbo].[Satislar] CHECK CONSTRAINT [FK_Satislar_Kullanici]
GO
ALTER TABLE [dbo].[Satislar]  WITH CHECK ADD  CONSTRAINT [FK_Satislar_Musteri] FOREIGN KEY([musteriNo])
REFERENCES [dbo].[Musteri] ([id])
GO
ALTER TABLE [dbo].[Satislar] CHECK CONSTRAINT [FK_Satislar_Musteri]
GO
ALTER TABLE [dbo].[Satislar]  WITH CHECK ADD  CONSTRAINT [FK_Satislar_Urun] FOREIGN KEY([UrunID])
REFERENCES [dbo].[Urun] ([id])
GO
ALTER TABLE [dbo].[Satislar] CHECK CONSTRAINT [FK_Satislar_Urun]
GO
ALTER TABLE [dbo].[Stok]  WITH CHECK ADD  CONSTRAINT [FK_Stok_Urun] FOREIGN KEY([urunID])
REFERENCES [dbo].[Urun] ([id])
GO
ALTER TABLE [dbo].[Stok] CHECK CONSTRAINT [FK_Stok_Urun]
GO
ALTER TABLE [dbo].[Urun]  WITH CHECK ADD  CONSTRAINT [FK_Urun_Model] FOREIGN KEY([modelNo])
REFERENCES [dbo].[Model] ([id])
GO
ALTER TABLE [dbo].[Urun] CHECK CONSTRAINT [FK_Urun_Model]
GO
USE [master]
GO
ALTER DATABASE [gsmOtomasyonDB] SET  READ_WRITE 
GO
