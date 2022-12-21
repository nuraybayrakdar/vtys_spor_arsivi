
-- Parametre olarak verilen ülke adýna göre oyuncularýn ortalama yaþýný getiren fonksiyon

USE SPOR_ARSIVI
GO

IF OBJECT_ID('dbo.AvgAge_eachCountry') IS NOT NULL
  BEGIN
    DROP FUNCTION dbo.AvgAge_eachCountry
  END
GO

CREATE or ALTER FUNCTION dbo.AvgAge_eachCountry(@ulke varchar(16))  
RETURNS int   
    AS 
    BEGIN
        
        DECLARE @yas int = 0; 
        SELECT @yas =  AVG(DATEDIFF(yy,T1.DogumTarihi,GETDATE()))
        from Oyuncu t1
        left join ULKELER t2
        on (t1.UlkeID=t2.UlkeID)
        where t2.UlkeAdý = @ulke
    
        RETURN @yas; 
    END
 Go
