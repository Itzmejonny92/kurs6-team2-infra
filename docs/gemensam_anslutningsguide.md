# Gemensam anslutningsguide för Team 2

Den här guiden beskriver hur gruppmedlemmar arbetar med repot, autentiserar sig
mot GCP och ansluter till labbsidan via Team 2:s jumphost. Guiden innehåller
inga hemligheter. Ersätt platshållare med dina egna lokala uppgifter.

## Säkerhetsregler

- Använd aldrig en lokal service account-nyckel för `team2-cicd`.
- GitHub Actions autentiserar sig automatiskt med Workload Identity Federation
  (WIF). En medlem behöver därför inte skapa eller spara `GCP_SA_KEY`.
- Logga in lokalt med ditt eget Chas Academy-konto.
- Den privata SSH-nyckeln ska endast finnas på din egen dator.
- Commita aldrig credentials, privata nycklar, Terraform state eller planfiler.
- Kontrollera alltid `git status` innan du committar.

## 1. Förbered verktygen

Kontrollera att Git, Google Cloud CLI, Terraform och SSH finns installerade:

```bash
git --version
gcloud --version
terraform version
ssh -V
```

## 2. Klona repot och välj din branch

```bash
git clone https://github.com/Itzmejonny92/kurs6-team2-infra.git
cd kurs6-team2-infra
git fetch origin
git switch member/DIN_GITHUB_ANVANDARE
git pull --ff-only origin main
```

Ersätt `DIN_GITHUB_ANVANDARE` med namnet på din member-branch. Gör ändringar i
din egen branch och använd en pull request för att föra dem till `main`.

## 3. Logga in lokalt i GCP

Använd ditt eget skolkonto:

```bash
gcloud auth login
gcloud auth application-default login
gcloud config set project itsx25-lab
gcloud auth list
```

`gcloud auth login` används av Google Cloud CLI. Application Default
Credentials används av Terraform lokalt. Detta är personliga, lokala
inloggningar och inte en service account-nyckel.

## 4. Initiera och kontrollera Terraform

Kör från repots rot:

```bash
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
```

Läs alltid planen innan en ändring appliceras. Teamets normala driftsättning
sker efter granskad pull request genom GitHub Actions och WIF. Kör inte
`terraform apply` lokalt utan att gruppen har kommit överens om det.

## 5. Kontrollera din SSH-åtkomst

Skapa ett eget SSH-nyckelpar om du saknar ett:

```bash
ssh-keygen -t ed25519 -C "DIN_CHAS_EPOST"
```

Dela endast innehållet i den publika filen, normalt
`~/.ssh/id_ed25519.pub`. Dela aldrig `~/.ssh/id_ed25519`.

Din publika nyckel och ditt SSH-användarnamn måste finnas i teamets
`ssh_users`-konfiguration innan du kan ansluta. Ändringen ska granskas och
mergas på vanligt sätt.

## 6. Hämta jumphostens adress

Efter `terraform init` kan adressen hämtas utan att läsa state-filen direkt:

```bash
JUMPHOST_IP=$(terraform output -raw jumphost_external_ip)
printf '%s\n' "$JUMPHOST_IP"
```

Skriv inte ut eller dela andra värden från Terraform state.

## 7. Starta en SOCKS5-tunnel

Ersätt `DITT_SSH_NAMN` med användarnamnet som finns i `ssh_users`:

```bash
ssh -N -D 1080 DITT_SSH_NAMN@"$JUMPHOST_IP"
```

Låt terminalen vara öppen. Att inget nytt skrivs ut är normalt: processen
håller tunneln aktiv. Första gången kan SSH fråga om jumphostens host key;
kontrollera fingeravtrycket med teamet innan du godkänner det.

## 8. Kontrollera den lokala proxyn

Linux eller macOS:

```bash
ss -ltn | grep ':1080'
```

Windows PowerShell:

```powershell
Test-NetConnection 127.0.0.1 -Port 1080
```

På Windows betyder `TcpTestSucceeded : True` att den lokala SOCKS5-porten är
öppen.

## 9. Starta webbläsaren via proxyn

Starta en separat webbläsarprofil med följande inställningar:

```text
Proxy: socks5://127.0.0.1:1080
DNS/hostnames: löses via proxyn
```

Exempel för en Chromium-baserad webbläsare:

```text
WEBBLASARE --user-data-dir=TEMP_PROFIL --proxy-server=socks5://127.0.0.1:1080 --host-resolver-rules="MAP * ~NOTFOUND, EXCLUDE 127.0.0.1"
```

`WEBBLASARE` och `TEMP_PROFIL` beror på operativsystem och installation. En
separat profil gör att endast labbfönstret använder proxyn.

Öppna därefter:

```text
https://spectre.itsx25.chas-lab.dev
```

Kontrollera att sidan identifierar anslutningen som Team 2.

## 10. Avsluta säkert

1. Stäng webbläsarens separata labbprofil.
2. Gå tillbaka till terminalen som kör SSH-tunneln.
3. Tryck `Ctrl+C`.
4. Kontrollera vid behov att port `1080` inte längre är öppen.

## Felsökning

- **`Permission denied (publickey)`:** kontrollera SSH-användarnamn, privat
  nyckel och att den publika nyckeln är driftsatt.
- **Terraform kan inte läsa backend:** kör båda `gcloud auth`-kommandona igen
  och kontrollera valt projekt.
- **Port 1080 används redan:** stäng en gammal tunnel eller välj samma nya port
  i både SSH-kommandot och webbläsarens proxyinställning.
- **Labbsidan laddas inte:** kontrollera att SSH-terminalen är öppen och att
  webbläsaren verkligen startades med den separata proxyprofilen.
- **Fel team visas:** stäng andra proxy- eller VPN-anslutningar och verifiera
  att trafiken går genom Team 2:s jumphost.

Vid problem ska endast felmeddelanden utan credentials eller nyckelmaterial
delas i gruppen.
