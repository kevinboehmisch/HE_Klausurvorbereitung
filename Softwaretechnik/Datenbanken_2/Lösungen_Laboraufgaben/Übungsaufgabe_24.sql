SELECT 
    tt.name, sp.name, sp.vorname              
FROM 
    dbo.Boehmisch_wettkampf AS wt
	INNER JOIN dbo.Boehmisch_spieler AS sp
	ON sp.spielernr = wt.spielernr
	INNER JOIN dbo.Boehmisch_team AS tt
	ON wt.team_id = tt.id
WHERE (
    (
        -- Z�hlt die Anzahl der gewonnenen Spiele pro Spieler innerhalb des Teams
        SELECT COUNT(*)
        FROM dbo.Boehmisch_wettkampf AS wt2
        WHERE wt2.punktzahlspieler > wt2.punktzahlgegner  -- Nur gewonnene Spiele z�hlen
        AND wt2.spielernr = wt.spielernr                  -- Nur Spiele des aktuellen Spielers ber�cksichtigen
        AND wt2.team_id = wt.team_id                      -- Und nur Spiele innerhalb desselben Teams betrachten
    ) >
    (
        -- Berechnet den Durchschnitt der gewonnenen Spiele pro Spieler innerhalb des Teams
        (
            -- Z�hlt die Anzahl der gewonnenen Spiele des gesamten Teams
            SELECT COUNT(*)
            FROM dbo.Boehmisch_wettkampf AS wt2
            WHERE wt2.punktzahlspieler > wt2.punktzahlgegner -- Nur gewonnene Spiele z�hlen
            AND wt2.team_id = wt.team_id					 -- Nur Spiele dieses Teams z�hlen
        ) / -- f�r den Durchschnitt geteilt rechnen: gewonnene Spiele gesamt/Anzahl Spieler
        (
            -- Z�hlt die Anzahl der einzigartigen Spieler im Team, die am Wettkampf teilgenommen haben
            SELECT COUNT(DISTINCT wt4.spielernr) 
            FROM dbo.Boehmisch_wettkampf AS wt4
            WHERE wt4.team_id = wt.team_id					 -- Spieler innerhalb desselben Teams z�hlen
        )
    )
)
-- Gruppiert die Ergebnisse nach Teamname, Spielername und Vorname (vermeidet Duplikate)
GROUP BY tt.name, sp.name, sp.vorname
ORDER BY tt.name, sp.name, sp.vorname;
