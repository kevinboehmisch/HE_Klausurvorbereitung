SELECT count(spielernr) AS 'Spieler zw. 20 und 30'FROM dbo.Boehmisch_spieler
WHERE datediff(yy, geboren, beitritt) BETWEEN 20 AND 30;
