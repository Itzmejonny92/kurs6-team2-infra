# Kurs 6 Team 2 Infra

Detta repository innehåller grupp 2:s Terraform-baserade infrastruktur för Kurs 6, vecka 4: Blue Team Start.

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
- [variables.tf](variables.tf): Variabler för team-modulen.
- [outputs.tf](outputs.tf): Outputs från team-modulen.
- [terraform.tfvars](terraform.tfvars): Teamets projekt-, team- och SSH-inställningar.
- [backend.tf](backend.tf): Remote backend för teamets Terraform state.
- [bootstrap/main.tf](bootstrap/main.tf): Bootstrap-resurser, bland annat state-bucket och CI/CD service account.
- [bootstrap/terraform.tfvars](bootstrap/terraform.tfvars): Projekt- och team-id för bootstrap.
- [.github/workflows/pr-checks.yml](.github/workflows/pr-checks.yml): CI-kontroller för pull requests.
- [.github/workflows/deploy.yml](.github/workflows/deploy.yml): Deploy-pipeline för main.
- [docs/](docs/): Sammanfattningar, beslut och arbetsanteckningar.
- [docs/product_backlog.md](docs/product_backlog.md): Backlog med säkerhetsrisker, förbättringar och status.

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
- GitHub Actions deploy har körts framgångsrikt.
- Branch protection är aktiverad på `main`.
- Pull requests kräver två approvals.
- `Format & Validate` krävs som statuscheck.
- Gruppens member-branches finns på GitHub.

## Viktigt

Terraform state, credentials, privata nycklar och planfiler ska inte commitas.

`.gitignore` skyddar mot vanliga Terraform- och credential-filer, men varje teammedlem ansvarar fortfarande för att kontrollera `git status` innan commit.
