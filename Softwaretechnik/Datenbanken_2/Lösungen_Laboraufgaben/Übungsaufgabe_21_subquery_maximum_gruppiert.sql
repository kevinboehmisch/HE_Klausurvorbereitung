-- Das Ergebnis der �u�eren Query zeigt die Anzahl der Wettk�mpfe pro Spieler
SELECT sp.geschlecht AS 'geschlecht', sp.name AS 'name', sp.vorname AS 'vorname', count(wt.spielernr) AS 'Anzahl Spiele'
FROM dbo.Boehmisch_spieler AS sp
INNER JOIN dbo.Boehmisch_wettkampf AS wt
ON sp.spielernr = wt.spielernr
GROUP BY sp.geschlecht, sp.name, sp.vorname
-- Having-Klausel filtert Spieler mit maximalen Anzahl Wettk�mpfe pro Geschlecht
HAVING COUNT(wt.spielernr) = (
	-- Subquery ermittelt f�r jedes Geschlecht maximale Anzahl Wettk�mpfe mit MAX(Anzahl_Spiele)
	SELECT MAX(Anzahl_Spiele)
	FROM (
		-- Innerhalb Subquery werden Wettk�mpfe gez�hlt und nach geschlecht gruppiert
		SELECT sp2.geschlecht, sp2.name, sp2.vorname, COUNT(wt2.spielernr) AS Anzahl_Spiele
        FROM dbo.Boehmisch_spieler AS sp2
        INNER JOIN dbo.Boehmisch_wettkampf AS wt2
        ON sp2.spielernr = wt2.spielernr
		-- hierdurch durch diese WHERE-Clausel wird sichergestellt, dass sich MAX(Anzahl_Spiele) 
		-- nicht auf beide Geschlechter gleichzeitig (m,w) bezieht, sondern immer nur jeweils separat
		-- BSP: sp2.geschlecht='m' und sp.geschlecht='m' -> da sp2.geschlecht=sp.geschlecht wird das MAX(Anzahl_spiele) 
		--      nur auf 'm' (M�nner) angewendet und nicht auf die 'w' Frauen
		--      -> Frauen werden nur mit Frauen und M�nner nur mit M�nnern auf die maximale Anzahl der Spiele verglichen
		--      -> Subquery wird nur f�r Spieler des gleichen Geschlechts ausgef�hrt 
        WHERE sp2.geschlecht = sp.geschlecht -- <-- das ist die entscheidende Zeile!
        GROUP BY sp2.geschlecht, sp2.name, sp2.vorname
	) AS Subquery
); 



