
-- Ülkelere göre ortalama yaþý ve ortalama yaþa baðlý olarak oyuncularýn durumunu belirtir

USE SPOR_ARSIVI
Go 

IF OBJECT_ID('dbo.OyuncuYasDurumu') IS NOT NULL
	BEGIN
		DROP VIEW OyuncuYasDurumu
	END
GO
Create or Alter View OyuncuYasDurumu As 
  Select t1.*,

CASE 
     WHEN OyuncununYasý>OrtalamaYas then 'Yaþlý'
     WHEN OyuncununYasý<OrtalamaYas then 'Genç'
     WHEN OyuncununYasý=OrtalamaYas then 'Eþit' 
 End As YaþDurumu
     From (
	    Select t1.*, 
		       t2.UlkeAdý , 
			   DATEDIFF(yy,T1.DogumTarihi,GETDATE()) as OyuncununYasý,
			   dbo.AvgAge_eachCountry(t2.UlkeAdý) as OrtalamaYas 
		from dbo.OYUNCU t1 
		     left join dbo.ULKELER t2  
			   on t1.UlkeID = t2.UlkeID) t1

