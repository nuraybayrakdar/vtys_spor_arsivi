USE SPOR_ARSIVI
GO


--1)Oyuncu tablomuzdan yaþý 22 den küçük oyuncularýmýzý siliyoruz.?
DELETE MO
 FROM OYUNCU O INNER JOIN MACOLAYI MO
   ON O.OyuncuID = MO.Oyuncu1ID 
     WHERE DATEDIFF(YEAR,DogumTarihi,GETDATE()) < 22


--2)yýllýk sözleþme fiyatlarý 500000 ile 700000 arasý olan verileri siliniz.
DELETE 
FROM SOZLESME 
WHERE YýllýkÜcret BETWEEN 50000 AND 200000


--3)2019 sezon yýlý þampiyonasýnda 4 puan alan takýmý takým þampiyona tablomuzdan çýkarýyoruz.
DELETE 
 FROM TAKIMSEZONDAOYNAR
  WHERE Sezon_ID = (SELECT Sezon_ID 
   FROM SEZON 
    WHERE SezonAdý = 'Süper Lig') AND Puan > 4


--4)Maç tablosundan sezon adý La Liga olan maçlarý siliyoruz.?
DELETE Y
FROM MAC M INNER JOIN YONETIR Y
  ON M.MacID = Y.MacID
    WHERE Sezon_id = (SELECT SezonID FROM SEZON WHERE SezonAdý = 'La Liga')


--5)Yýllýk sözleþme fiyatý 200.000'den az olan takým sponsorluklarýný siliniz.
DELETE SO 
 FROM Takým T INNER JOIN SponsorOlur SO 
  ON T.Takým_ID = SO.Takým_ID
   WHERE SO.Takým_ID IN (SELECT T.Takým_ID 
    FROM Takým T INNER JOIN SponsorOlur TS 
     ON T.Takým_ID = TS.Takým_ID 
      WHERE TS.YýllýFiyat < 200.000) 