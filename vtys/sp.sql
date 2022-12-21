USE SPOR_ARSIVI
GO

IF OBJECT_ID('dbo.takimDuzenle') IS NOT NULL
	BEGIN
		DROP PROCEDURE takimDuzenle
	END
GO

-- Tabloda bulunan herhangi bir takýmý düzenlemek için bir procedur yazýnýz. Eðer düzenlenmek istenen takým tabloda yoksa ekleyiniz. 

CREATE or ALTER PROCEDURE takimDuzenle(
@takimAdi VARCHAR(30),
@takimlkKurulusYili DATE,
@sehirAdi VARCHAR(30))
AS 
BEGIN
SET NOCOUNT ON; 
 
 BEGIN TRAN
   BEGIN TRY       
			  --Kullanýcýnýn verdiði takým adý db'de var mý kontrol ediliyor.
					IF @takimAdi NOT IN (SELECT T.Takým_Adý FROM Takým T WHERE T.Takým_Adý= @takimAdi)
					BEGIN
						--Kullanýcýnýn verdiði þehir adý db'de var mý kontrol ediliyor.
						IF @sehirAdi NOT IN (SELECT S.Sehýr_Adý FROM SEHIR S WHERE S.Sehýr_Adý= @sehirAdi)
						BEGIN
						--Kullanýcýnýn verdiði þehir adý db'de yoksa yeni bir þehir olarak insert ediliyor.
						INSERT INTO SEHIR(Sehýr_Adý)
						VALUES(@sehirAdi)
						END

						--Kullanýcýnýn verdiði þehir adý db'de var fakat takýmýn adý db'de bulunmadýðý için kullanýcýnýn verdiði bilgiler doðrultusunda takým db'ye insert ediliyor.
						DECLARE @sehirPlaka int
						SET @sehirPlaka = (SELECT s.Plaka FROM SEHIR S WHERE S.Sehýr_Adý = @sehirAdi)
							INSERT INTO Takým (Takým_Adý,Kurulus_Tarýhý,Plaka_shr)
							VALUES (@takimAdi,@takimlkKurulusYili,@sehirPlaka);
					END

					--Kullanýcýnýn verdiði takým adý db'de varsa else kýsmý çalýþýyor.
					ELSE BEGIN

					--Kullanýcýnýn verdiði ülke adý db'de var mý kontrol ediliyor.
					IF @sehirAdi NOT IN (SELECT S.Sehýr_Adý FROM SEHIR S WHERE S.Sehýr_Adý= @sehirAdi)
						BEGIN
						INSERT INTO SEHIR (Sehýr_Adý)
						VALUES(@sehirAdi)
						END
					
					--Kullanýcýnýn verdiði  bilgiler doðrultusunda takým db'de update ediliyor.
					UPDATE Takým
					SET Kurulus_Tarýhý = @takimlkKurulusYili , Plaka_shr = (SELECT S.Plaka FROM SEHIR S WHERE S.Sehýr_Adý = @sehirAdi)
					WHERE Takým_Adý = @takimAdi
					END
               
			   --Hata olmadýðý takdirde bu iþlemler commit edilir.
              COMMIT TRANSACTION
       END TRY
       BEGIN CATCH
			--Hata yakalanýldýðý takdirde rollback ile iþlemler geri alýnýr.
              ROLLBACK TRANSACTION
       END CATCH
END
GO

-- Takým tablosundaki PSV takýmýnýn ilk katýlým tarihi ve þehri deðiþtirildi.

select * from SEHIR
EXEC takimDuzenle 'PSV', '1991-12-12', 'Selanik'
GO

-- Takým tablosunda bulunmayan Medipol Baþakþehir takýmý tabloya eklendi. 

EXEC takimDuzenle 'Medipol Baþakþehir', '1982-12-10', 'Ýstanbul'
GO

-- Takým tablosunda bulunmayan Adana spor takýmý tabloya eklendi ve þehir tablosunda bulunmayan Adana tabloya eklendi.

EXEC takimDuzenle 'Adana Spor', '1951-12-10', 'Adana'
GO
