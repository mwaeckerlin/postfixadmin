2026-10-22  Marc Wäckerlin

	* Die Versionslinie 2 wird wieder gebaut und veröffentlicht, als
	  mwaeckerlin/postfixadmin:2, bei jedem Push auf diesen Branch und jede
	  Woche mit dem Lauf auf master. Bisher bekam sie keinen Neubau und damit
	  keine Sicherheitskorrektur ihres Basis-Images, zuletzt die
	  Gegenmassnahmen gegen CVE-2026-109618 und CVE-2026-109619 aus
	  mwaeckerlin/php-fpm. Ein Test prüft, dass sie im Image wirken.

2026-06-12  Marc Wäckerlin

	* Eigene Konfiguration wird neu über eine separate lokale Konfigurationsdatei
	  ergänzt statt die Hauptkonfiguration zu ersetzen. Dadurch bleiben die
	  Standardwerte des Pakets (unter anderem die DKIM-Einstellung) erhalten;
	  bisher führte das Ersetzen zu einem Absturz beim Einrichtungsassistenten.
	* PHP-Fehlerausgabe im FPM-Pool abgeschaltet, damit Warnungen nicht mehr in
	  die HTML- und JSON-Antworten geschrieben werden und diese zerstören.
	* Umgebungsvariablen werden an den FPM-Worker durchgereicht, sodass die
	  Datenbank- und Setup-Konfiguration zur Laufzeit korrekt greift.
