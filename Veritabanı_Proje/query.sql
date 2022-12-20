USE SPOR_ARSIVI
GO

-- 1) A oyuncusunun çýktýðý B oyuncusunun girdiði maçlarda toplam gösterilen kýrmýzý kart sayýsý
-- Yani oyuncu deðiþimi olan maçlarda gösterilen toplam kýrmýzý kart sayýsý

Select liste.MacID,Count(OlayTuruID) as kýrmýzý FROM
   (Select MacID,OlayTuruID,Oyuncu1ID,Oyuncu2ID FROM MACOLAYI M INNER JOIN OLAYTURU O
       ON M.OlayTuruID = O.Olay_id
	     WHERE O.Ad ='KýrmýzýKart'
            EXCEPT
   SELECT MacID,OlayTuruID,Oyuncu1ID,Oyuncu2ID FROM MACOLAYI M INNER JOIN OLAYTURU O
       ON M.OlayTuruID = O.Olay_id
          WHERE O.Ad = 'OyuncuDeðiþimi' ) 
              as liste Group by MacID,OlayTuruID
  

-- 2) Son 3 sezonda hiç kýrmýzý kart yememiþ oyunculardan hangileri hem X hem de Y takýmýnda oynamýþtýr
-- Hiç kýrmýzý kart yememiþ oyuncular
SELECT M.OlayTuruID, M.MacID, O.OyuncuAdi, O.OyuncuSoyadi
   FROM MACOLAYI M
     INNER JOIN OYUNCU O
	   ON M.Oyuncu1ID = O.OyuncuID
	     WHERE M.OlayTuruID NOT IN (4)

-- 3) Türpaþýn sponsor olduðu takýmlara son 2 yýlda ödediði toplam fiyat

SELECT SUM(SO.YýllýFiyat) AS TOPLAM
   FROM SponsorOlur SO INNER JOIN Sponsor S 
      ON S.SponsorID = SO.SponsorID
	     WHERE S.SponsorAdý = 'Türpaþ' AND 
		   (SO.SözleþmeBaþT >= '2020' AND SO.SözleþmeBitT <='2022')

-- 4) Eskiþehir Spor takýmýnýn oynadýðý maçlarýn idleri, sezonun adý, stadyumun adý , maçýn yapýldýðý þehri , puanýný ve ülkesini getiriniz.

Select  Distinct M.MacID, M.Mac_Tarihi, SN.SezonAdý, S.StadyumAdi, SH.Sehýr_Adý, TSO.Puan, U.UlkeAdý
From TAKIM T inner join STADYUM S
    on T.Takým_ID = S.TakimID inner join MAC M
        on T.Takým_ID = M.TakýmEID inner join SEZON SN
           on SN.SezonID = M.Sezon_id inner join SEHIR SH
              on SH.Plaka = T.Plaka_shr inner join TAKIMSEZONDAOYNAR TSO
                 on T.Takým_ID = TSO.Takým_ID inner join ULKELER U
                    on U.UlkeID = SH.Ulke_Adý

where T.Takým_Adý = 'Eskisehir Spor'


--5) Kýrmýzý kart alan oyuncularý yaþýný küçükten büyüðe sýralayýnýz.

SELECT O.OyuncuAdi, O.OyuncuSoyadi, MO.MacID, O.OyuncuID , DATEDIFF(YEAR,O.DogumTarihi,GETDATE()) YAÞ 
  FROM OYUNCU O INNER JOIN MACOLAYI MO
    ON O.OyuncuID = MO.Oyuncu1ID INNER JOIN OLAYTURU OT
       ON OT.Olay_id = MO.OlayTuruID
         WHERE OT.Ad ='KýrmýzýKart'
		   ORDER BY YAÞ


