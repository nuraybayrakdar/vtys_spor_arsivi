USE SPOR_ARSIVI
GO 

--1) Stadyum tablosundan stadyum kapasitesini deðiþtirelim.
UPDATE STADYUM 
SET Kapasite = 52000
WHERE Kapasite = 37000

--2-) Mesut Özil adlý oyuncunun forma numarasýný 10'dan 7 yap.
UPDATE OYUNCU
SET FormaNumarasi = 7
WHERE OyuncuAdi = 'Mesut' AND OyuncuSoyadi = 'Özil'

--3-) Beko sponsorunun takýmý ile olan yýllýk sözleþme fiyatýný 100.000 tl arttýr.
UPDATE SponsorOlur
SET YýllýFiyat = 720.000
FROM SponsorOlur
INNER JOIN Sponsor ON SponsorOlur.SponsorID = Sponsor.SponsorID
WHERE Sponsor.SponsorAdý = 'Beko'

 --4-) Yönetir tablosunda MacID = 1 olan maçýn hakemini deðiþtirelim
 UPDATE YONETIR
 SET Hakem_ID = 7
 FROM YONETIR WHERE MacID = 1

 --5-) Sponsor tablosunda Opet sponsorunun adýný deðiþtirelim
 UPDATE Sponsor
 SET SponsorAdý = 'Opet A.Þ'
 FROM Sponsor WHERE SponsorAdý = 'Opet'
