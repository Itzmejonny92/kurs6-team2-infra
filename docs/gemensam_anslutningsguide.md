# Gemensam anslutningsguide för Team 2

Den här guiden beskriver hur gruppmedlemmar arbetar med repot, autentiserar sig
mot GCP, ansluter till Team 2:s Tailnet och når labbsidan via jumphosten. Guiden
innehåller inga hemligheter. Ersätt platshållare med dina egna lokala uppgifter.

## Säkerhetsregler

- Använd aldrig en lokal service account-nyckel för `team2-cicd`.
- GitHub Actions autentiserar sig automatiskt med Workload Identity Federation
  (WIF). En medlem behöver därför inte skapa eller spara `GCP_SA_KEY`.
- Logga in lokalt med ditt eget Chas Academy-konto.
- Den privata SSH-nyckeln ska endast finnas på din egen dator.
- Auth-id:n från Headscale är tillfälliga och får inte delas eller sparas i
  repot.
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
git clone https://github.com/itsx25-team2/kurs6-team2-infra.git
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

Registrera den publika nyckeln i din personliga OS Login-profil:

```bash
gcloud compute os-login ssh-keys add \
  --key-file="$HOME/.ssh/id_ed25519.pub"
```

Din Chas Academy-adress måste även finnas i `os_admin_users` i
`variables.tf`. Ändringen ska gå via branch, pull request och granskning. Amin
saknades i listan vid kontrollen den 2026-09-15 och följs upp i issue #15.

`roles/compute.osAdminLogin` ger administrativ åtkomst på VM:n. Teamet ska
bedöma om en medlem bara behöver `roles/compute.osLogin` innan behörighet
läggs till.

## 6. Hämta jumphostens adress

Efter `terraform init` kan adressen hämtas utan att läsa state-filen direkt:

```bash
JUMPHOST_IP=$(terraform output -raw jumphost_external_ip)
printf '%s\n' "$JUMPHOST_IP"
```

Skriv inte ut eller dela andra värden från Terraform state.

## 7. Anslut till jumphosten

Efter att steg 6 driftsattes den 2026-09-15 är publik SSH begränsad till
instruktörsnätet. En medlem ansluter därför normalt via Tailnet efter att den
egna klienten registrerats enligt steg 8-11.

Ta fram ditt OS Login-användarnamn:

```bash
gcloud compute os-login describe-profile \
  --format="value(posixAccounts[0].username)"
```

Anslut därefter till jumphosten via dess Tailnet-adress:

```bash
ssh -i "$HOME/.ssh/id_ed25519" DIN_OS_LOGIN_ANVANDARE@100.64.0.2
```

Om nyckeln har en lösenfras kan den låsas upp lokalt först:

```bash
ssh-add "$HOME/.ssh/id_ed25519"
```

Skicka aldrig lösenfrasen till någon annan.

## 8. Installera Tailscale lokalt

Headscale-servern installeras och administreras gemensamt på jumphosten. Varje
medlem installerar däremot Tailscale-klienten på sin egen arbetsstation eller
WSL-miljö.

På Ubuntu eller WSL kan det officiella installationsskriptet hämtas och köras
så här:

```bash
curl -fsSL https://tailscale.com/install.sh -o /tmp/tailscale-install.sh
sudo sh /tmp/tailscale-install.sh
```

Verifiera installationen och tjänsten:

```bash
tailscale version
systemctl is-active tailscaled
```

## 9. Skapa en personlig Headscale-användare

Detta moment görs en gång per medlem av en administratör på jumphosten. Börja
med att kontrollera vilka användare som redan finns:

```bash
sudo headscale users list
```

Skapa därefter användaren om den saknas:

```bash
sudo headscale users create PERSONLIGT_NAMN
```

Använd korta och tydliga namn, exempelvis `jonny`, `fajk` eller `tim`. Skapa
inte samma användare flera gånger.

## 10. Anslut arbetsstationen till Headscale

Kör lokalt på medlemmens arbetsstation eller i WSL:

```bash
sudo tailscale up \
  --login-server https://team2.itsx25.chas-lab.dev \
  --hostname PERSONLIGT_ENHETSNAMN
```

Kommandot visar en tillfällig registreringsadress. Öppna adressen i
webbläsaren. Sidan visar ett kommando med ett auth-id. Kör kommandot på
jumphosten, ersätt `USERNAME` med den personliga Headscale-användaren och
behåll auth-id:t oförändrat:

```bash
sudo headscale auth register --auth-id AUTH_ID --user USERNAME
```

Kommandot ovan gäller Headscale `0.29.3`. Auth-id:t ska inte skickas i chatt,
läggas i dokumentation eller committas.

## 11. Verifiera Tailnet-anslutningen

Kör lokalt:

```bash
tailscale status
tailscale ping team2-jumphost
```

Den personliga enheten ska visas under rätt användare och jumphosten ska svara
på `100.64.0.2`. En anslutning via en DERP-reläserver är fortfarande krypterad
och godkänd för grundverifieringen, även om en direktanslutning är effektivare.

En administratör kan kontrollera registreringen på jumphosten:

```bash
sudo headscale nodes list
```

## 12. Acceptera subnet-rutter

Varje medlem behöver aktivera annonserade rutter på sin egen klient. På Linux
eller WSL:

```bash
sudo tailscale set --accept-routes=true
tailscale status
```

På macOS används samma `tailscale set`-kommando, med `sudo` om klienten kräver
det. Inställningen är lokal och behöver därför verifieras av varje medlem.

## 13. Verifiera privata resurser och Split DNS

Kontrollera först den privata `primary`-instansen:

```bash
ping 10.0.2.3
ssh DIN_OS_LOGIN_ANVANDARE@10.0.2.3
```

Kontrollera därefter Spectre via både IP och DNS:

```bash
ping 10.0.0.2
getent ahostsv4 spectre.itsx25.chas-lab.dev
ping spectre.itsx25.chas-lab.dev
```

Namnet ska lösas till `10.0.0.2`. Teamets jumphost annonserar
`10.0.2.0/24` och `10.0.0.2/32`. Split DNS skickar endast frågor för
`itsx25.chas-lab.dev` till DNS-proxyn på jumphostens Tailnet-IP
`100.64.0.2`.

Teamets gemensamma NAT-test behöver bara genomföras en gång. Med SNAT
aktiverat såg `primary` källan `10.0.2.2`. Efter att
`--snat-subnet-routes=false` aktiverats såg servern klientens riktiga
Tailnet-IP `100.64.0.3`.

## 14. Starta en SOCKS5-tunnel

```bash
ssh -i "$HOME/.ssh/id_ed25519" \
  -N -D 127.0.0.1:1080 \
  DIN_OS_LOGIN_ANVANDARE@100.64.0.2
```

Låt terminalen vara öppen. Att inget nytt skrivs ut är normalt: processen
håller tunneln aktiv. Första gången kan SSH fråga om jumphostens host key;
kontrollera fingeravtrycket med teamet innan du godkänner det.

## 15. Kontrollera den lokala proxyn

Linux eller macOS:

```bash
ss -ltn | grep ':1080'
```

Windows PowerShell:

```powershell
Test-NetConnection 127.0.0.1 -Port 1080
```

På Windows betyder `TcpTestSucceeded : True` att den lokala SOCKS5-porten är
öppen. Om Windows inte når WSL-tunneln via `127.0.0.1`, hämta WSL-adressen med
`hostname -I` och använd den adressen som proxyvärd.

## 16. Starta webbläsaren via proxyn

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

## 17. Avsluta SOCKS5-tunneln säkert

1. Stäng webbläsarens separata labbprofil.
2. Gå tillbaka till terminalen som kör SSH-tunneln.
3. Tryck `Ctrl+C`.
4. Kontrollera vid behov att port `1080` inte längre är öppen.

## Felsökning

- **`Permission denied (publickey)`:** kontrollera att du är inloggad med rätt
  Google-konto, att din publika nyckel finns i OS Login och att adressen finns
  i `os_admin_users`.
- **Publik `gcloud compute ssh` fungerar inte hemifrån:** detta är förväntat
  efter steg 6. Starta Tailscale och anslut via jumphostens Tailnet-adress.
- **Terraform kan inte läsa backend:** kör båda `gcloud auth`-kommandona igen
  och kontrollera valt projekt.
- **Port 1080 används redan:** stäng en gammal tunnel eller välj samma nya port
  i både SSH-kommandot och webbläsarens proxyinställning.
- **Headscale returnerar `403`:** kontrollera att klienten använder
  `https://team2.itsx25.chas-lab.dev`, inte Spectre-portalens adress.
- **`Unable to read/write to headscale socket`:** kör Headscale-kommandot på
  jumphosten med `sudo`.
- **En Headscale-användare saknar enhet:** användaren är bara skapad. Medlemmen
  måste även köra `tailscale up` och en administratör måste godkänna auth-id:t.
- **En registrerad enhet är offline:** starta `tailscaled` och kör
  `sudo tailscale up` på den aktuella arbetsstationen.
- **`10.0.2.3` timear ut:** kontrollera att klienten är online och att
  `--accept-routes=true` är aktiverat.
- **Spectre fungerar via IP men inte via namn:** kontrollera att Headscale har
  distribuerat Split DNS och att `dnsmasq` är aktivt på jumphosten.
- **Labbsidan laddas inte:** kontrollera att SSH-terminalen är öppen och att
  webbläsaren verkligen startades med den separata proxyprofilen.
- **Fel team visas:** stäng andra proxy- eller VPN-anslutningar och verifiera
  att trafiken går genom Team 2:s jumphost.

Vid problem ska endast felmeddelanden utan credentials eller nyckelmaterial
delas i gruppen.
