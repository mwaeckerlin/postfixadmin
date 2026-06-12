2026-06-12  Marc Wäckerlin

	* Eigene Konfiguration wird neu über eine separate lokale Konfigurationsdatei
	  ergänzt statt die Hauptkonfiguration zu ersetzen. Dadurch bleiben die
	  Standardwerte des Pakets (unter anderem die DKIM-Einstellung) erhalten;
	  bisher führte das Ersetzen zu einem Absturz beim Einrichtungsassistenten.
	* PHP-Fehlerausgabe im FPM-Pool abgeschaltet, damit Warnungen nicht mehr in
	  die HTML- und JSON-Antworten geschrieben werden und diese zerstören.
	* Umgebungsvariablen werden an den FPM-Worker durchgereicht, sodass die
	  Datenbank- und Setup-Konfiguration zur Laufzeit korrekt greift.
