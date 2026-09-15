# Individuell arbetssammanfattning - Lars Törngren - 2026-09-08

## Kortfattat

Arbetat med Blue Team, genomgång av repository för att hitta säkerhetsproblem, lagt till alla gruppmedlemmar som SSH_Users i terraform.tfvars, dokumentera problem med användning av Service Account Key. Fördjupa förståelsen för arbetsgången i GitHub och dokumentera vad jag gör. Bistå Jonny med att införa Workload Identity Federation (WIF). Lade ner en hel del arbete på att hitta flaggorna, och att få proxy att fungera.

## Genomfört arbete
- Konstaterade att den stora risken med det ursprungliga repot är blocket som innehåller allAuthenticatedUsers. Skapade en issue med förslag på åtgärder.
- Samlade in alla medlemmarnas publika SSH-nycklar och lade in dessa i terraform.tfvars, så att alla får möjlighet att logga in via jumpservern.
- Genomförde i samband med detta pull request #19.
- Dokumenterade risker med Google Service Account Key om den hamnar på avvägar, exempelvis datastöld, spionage, ransomware eller obehörig kryptoutvinning via Google Cloud.
- Fick slutligen proxy att fungera i Google Chrome via ett terminalkommando. I Firefox gick det inte att få till, trots att det fungerat tidigare. Lyckades alltså slutligen få till en SOCKS5-proxy med dynamisk port forwarding över SSH och kunde ansluta till jumpervern.
- Hittade filen `terraform.tfstate.backup` i den zip-fil vi fick från Dennis. När vi avkodade Base64-koden fick vi till slut fram flaggan.
- Insåg att det var något av formulären i Spectre-admin som innebar säkerhetsrisken genom någon slags ”injection” och där hittade Jonny till slut den andra flaggan. En grundregel för alla slags formulär som användare på en webbplats kan mata in information i, ska ”tvättas” på något sätt. Det vill säga att inmatningen gås igenom och verifieras enligt förutbestämda regler för vad som är giltig inmatning.

