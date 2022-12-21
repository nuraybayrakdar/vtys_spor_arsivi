USE SPOR_ARSIVI
GO

--!!!!!!  ÖNEMLÝ  !!!!!
--TRIGGER'dan önce Takým adlý tabloya DegisiklikTarihi kolonunu ekliyoruz.
ALTER TABLE Takým
ADD DegisiklikTarihi DATE
GO

IF OBJECT_ID ('trgtakimDuzenle') IS NOT NULL
	BEGIN
		DROP TRIGGER trgtakimDuzenle
	END
GO

/* Takýmlarýn kuruluþ tarihi günümüzden ileri bir tarih olmasý durumunda yeni bir takým eklenmesi veya takýmlarýn güncellenmesini engelleyen triggerý yazýnýz.
Eðer doðru tarih ile veri eklenir veya güncellenirse bu iþlemin yapýldýðý tarihi getiriniz. */

CREATE OR ALTER TRIGGER trgtakimDuzenle ON TAKIM FOR INSERT , UPDATE  AS

DECLARE @TakýmID TABLE ( ID INT )
DECLARE @KurulusTarihi DATE = (SELECT Kurulus_Tarýhý FROM inserted)

INSERT INTO @TakýmID SELECT Takým_ID FROM inserted

IF (@KurulusTarihi > GETDATE())
	BEGIN
		ROLLBACK	 
		PRINT('Kuruluþ tarihi günümüz tarihinden sonra olamaz.')
	END
ELSE
	UPDATE Takým SET DegisiklikTarihi = GETDATE() WHERE Takým_ID IN (SELECT ID FROM @TakýmID)
GO

-- Öncelikle doðru bir örnek deneyelim. Burada veri yine ayný þekilde tabloya eklenir ve deðiþiklik tarihi de kolonuna yazýlýr.

EXEC takimDuzenle 'Galatasaray', '1905-10-01', 'Ýstanbul'
GO
select * from TAKIM
-- Þimdi ise Kurulus_Tarýhý sütununa günümüzden ileri bir tarih yazarak yanlýþ bir örnek deneyelim.

EXEC takimDuzenle 'Galatasaray', '2023-12-30', 'Ýstanbul'
GO


