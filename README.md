# Kurs 6 Team 2 Infra

Detta repository innehåller grupp 2:s Terraform-baserade infrastruktur för Kurs
6, vecka 4 och 5: Blue Team.

Syftet är att arbeta med molninfrastruktur i Google Cloud Platform (GCP), granska Terraform-kod ur ett säkerhetsperspektiv och förbättra lösningen steg för steg via ett agilt arbetsflöde.

## Miljö

- GCP-projekt: `itsx25-lab`
- Team ID: `2`
- Subnet: `10.0.2.0/24`
- Region: `europe-north2`
- Terraform backend: Google Cloud Storage
- Repo: `Itzmejonny92/kurs6-team2-infra`

## Viktiga Filer

- [main.tf](main.tf): Teamets huvudinfrastruktur, bland annat subnet, jumphost, routes och firewall.
- [variables.tf](variables.tf): Variabler för team-modulen, inklusive OS Login-identiteter.
- [outputs.tf](outputs.tf): Outputs från team-modulen.
- [terraform.tfvars](terraform.tfvars): Teamets projekt- och teaminställningar. Fältet `ssh_users` är kvar som äldre konfiguration men används inte av jumphosten efter OS Login-migreringen.
- [backend.tf](backend.tf): Remote backend för teamets Terraform state.
- [bootstrap/main.tf](bootstrap/main.tf): Bootstrap-resurser, bland annat state-bucket och CI/CD service account.
- [bootstrap/terraform.tfvars](bootstrap/terraform.tfvars): Projekt- och team-id för bootstrap.
- [.github/workflows/pr-checks.yml](.github/workflows/pr-checks.yml): CI-kontroller för pull requests.
- [.github/workflows/deploy.yml](.github/workflows/deploy.yml): Deploy-pipeline för main.
- [docs/](docs/): Sammanfattningar, beslut och arbetsanteckningar.
- [docs/gemensam_anslutningsguide.md](docs/gemensam_anslutningsguide.md): Gemensam säker guide för Git, GCP, Terraform, SSH och proxyanslutning.
- [docs/product_backlog.md](docs/product_backlog.md): Backlog med säkerhetsrisker, förbättringar och status.
- [docs/team_work_summary_2026-09-08.md](docs/team_work_summary_2026-09-08.md): Gemensam sammanfattning av dagens arbete, verifieringar och nästa steg.
- [docs/team_work_summary_2026-09-14.md](docs/team_work_summary_2026-09-14.md): Gemensam sammanfattning av WIF, IAM, OS Login och övrigt säkerhetsarbete den 14 september.
- [docs/team_work_summary_2026-09-15.md](docs/team_work_summary_2026-09-15.md): Gemensam sammanfattning av Metadata Service, Headscale, Tailscale och brandväggsarbetet den 15 september.
- [docs/team_work_summary_2026-09-17.md](docs/team_work_summary_2026-09-17.md): Gemensam sammanfattning av `primary`, subnet routing, direkt routing och Split DNS den 17 september.
- [members/](members/): Personliga dokumentationsytor för gruppmedlemmarnas anteckningar, loggar och underlag.

## Arbetsflöde

Teamet arbetar enligt detta flöde:

1. Skapa eller välj en issue.
2. Arbeta från egen branch, till exempel `member/itzmejonny92`.
3. Gör en liten, tydlig ändring.
4. Kör lokala kontroller vid behov:

```bash
terraform fmt -recursive
terraform validate
```

5. Pusha branchen.
6. Skapa pull request mot `main`.
7. Vänta på CI-kontroller.
8. Låt minst två personer granska och godkänna.
9. Merga till `main`.

## Arbeta Med Backloggen

GitHub Issues är teamets källa för det dagliga arbetet. [Produktbackloggen](docs/product_backlog.md) ger gruppen och utbildaren en samlad översikt över prioritet, status och koppling till relevanta filer.

- Skapa eller uppdatera ett GitHub Issue när en risk, förbättring eller dokumentationsuppgift identifieras.
- Koppla större issues till ett PB-ID i produktbackloggen.
- Uppdatera backlogfilen när en viktig punkt tillkommer, byter prioritet eller går vidare till en ny status.
- Ändra status till `Done` först när arbetet är mergat och verifierat.
- Uppdateringar av backlogfilen görs via branch och pull request på samma sätt som övriga ändringar.

Backlogfilen synkroniseras inte automatiskt med GitHub Issues. Den som ändrar ett issue ansvarar därför för att kontrollera om även den sammanfattade backloggen behöver uppdateras.

## Brancher

Följande member-branches finns för gruppen:

- `member/itzmejonny92`
- `member/fajkzhupa-chas`
- `member/timrundquist`
- `member/larstorngrenchas`
- `member/aminmahamoud-arch`
- `member/willibroadngebi-lab`

## Säkerhetsfokus

Detta är ett Blue Team-arbete. Fokus är att identifiera, motivera och åtgärda säkerhetsrisker i infrastrukturen.

Exempel på säkerhetsområden att granska:

- IAM-roller och för breda behörigheter
- Service account keys
- Terraform state och backend-säkerhet
- Brandväggsregler
- Publik åtkomst
- SSH-åtkomst
- CI/CD-secrets
- Kodgranskning och branch protection

## Nuvarande Status

- Bootstrap-resurser har skapats i GCP.
- Terraform state-bucket finns: `team2-tfstate-dd541fba`.
- GitHub Actions autentiserar mot GCP med WIF och deploy har verifierats utan
  långlivade service account-nycklar.
- Inga användarhanterade nycklar finns kvar för `team2-cicd`.
- State-bucketens tidigare publika `allAuthenticatedUsers`-bindning är
  borttagen.
- Headscale-porten är begränsad till utbildarens reverse proxy och SSH-porten
  till instruktörsnätet. Intern trafik tillåts från Team 2:s subnet.
- Jumphosten använder OS Login och blockerar projektets metadatahanterade
  SSH-nycklar. Amin behöver läggas till och behovet av `osAdminLogin` ska
  följas upp i issue #15.
- Ett dedikerat jumphost-service account är kopplat till VM:n. Kontot hade inga
  projektroller vid kontrollen den 2026-09-14.
- Headscale och dagens medlemsanslutningar är verifierade. Den manuella
  serverinstallationen följs upp i issue #41 för reproducerbarhet.
- Branch protection är aktiverad på `main`.
- Pull requests kräver två approvals.
- `Format & Validate` krävs som statuscheck.
- Gruppens member-branches finns på GitHub.

## Viktigt

Terraform state, credentials, privata nycklar och planfiler ska inte commitas.

`.gitignore` skyddar mot vanliga Terraform- och credential-filer, men varje teammedlem ansvarar fortfarande för att kontrollera `git status` innan commit.

## Hantering av SSH-åtkomst och nycklar

För att upprätthålla säkerheten i vår infrastruktur gäller följande rutin för nya användare och SSH-nycklar:

Den fullständiga rutinen finns i
[Team 2:s gemensamma anslutningsguide](docs/gemensam_anslutningsguide.md).

1. **Personlig identitet:** Varje medlem loggar in med sitt eget Chas
   Academy-konto via `gcloud auth login`.
2. **Egen SSH-nyckel:** Medlemmen skapar vid behov ett personligt nyckelpar med
   `ssh-keygen -t ed25519` och registrerar den publika nyckeln i sin OS
   Login-profil.
3. **IAM via kod:** Medlemmens e-postadress läggs till i `os_admin_users` via
   branch, pull request och granskning. Teamet ska först bedöma om
   `roles/compute.osLogin` räcker eller om administrativ
   `roles/compute.osAdminLogin` verkligen behövs.
4. **Anslutning:** Efter Tailnet-registrering sker medlemmarnas SSH via
   jumphostens Tailscale-adress enligt den gemensamma guiden. Publik SSH är
   begränsad till instruktörsnätet.
5. **Privata nycklar:** Den privata nyckeln får aldrig delas, skickas i chattar
   eller commitas till GitHub.

## Aktuell status: Headscale och Tailscale

- Headscale `v0.29.3` är installerat och aktivt på jumphosten.
- Headscale använder `https://team2.itsx25.chas-lab.dev` som serveradress,
  lyssnar på `0.0.0.0:8080` bakom utbildarens reverse proxy och använder
  `team2.arpa` som intern basdomän.
- Personliga Headscale-användare finns för Jonny, Lasse, Fajk, Tim och
  Willibroad. Amin återstår eftersom han inte deltog den 2026-09-15.
- Tailscale är installerat på jumphosten. Noden `team2-jumphost` är registrerad
  och online i teamets Tailnet.
- De verifierade medlemsnoderna `jonny-workstation`, `recharge`, `fajk`,
  `macbook-air-som-tillhor-tim` och `willibroad` är registrerade under rätt
  personliga användare och var online vid slutkontrollen den 2026-09-15.
- Terraform begränsar åtkomst till Headscale-porten till instruktörens reverse
  proxy på `10.0.0.2/32`.
- Terraform begränsar SSH på port 22 till instruktörsnätet `10.0.0.0/24`.
  Jonnys SSH-åtkomst via Tailnet till `team2-jumphost` har verifierats.
- Workshopens steg 6 är mergat, driftsatt och liveverifierat.
- `team2-primary` kör som `e2-micro` på `10.0.2.3` utan extern IP och använder
  OS Login.
- Subnet-rutterna `10.0.2.0/24` och `10.0.0.2/32` är annonserade, godkända och
  verifierade från Jonnys klient.
- Direkt routing utan subnet-router-SNAT är verifierad. `primary` såg klientens
  Tailnet-IP `100.64.0.3`.
- Spectre svarar via både `10.0.0.2` och
  `spectre.itsx25.chas-lab.dev`. Split DNS går genom `dnsmasq` på jumphosten.
- Workshopens steg 7 och PB-13 är slutförda. Nästa moment är ACL-policy i
  PB-14/issue #52.
