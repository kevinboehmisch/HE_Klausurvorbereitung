 SELECT spielernr, name, vorname, strasse, ort 
FROM dbo.Boehmisch_spieler
 WHERE 
strasse NOT LIKE '%g�rten' AND
 ort='G�ppingen' OR spielernr=28