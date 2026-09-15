# Product Backlog

Denna backlog används för grupp 2:s Blue Team-arbete i infra-repot.

Syftet är att samla säkerhetsrisker, förbättringar och dokumentationsbehov på ett spårbart sätt. GitHub Issues används för det praktiska arbetet, medan denna fil ger en sammanfattad översikt för gruppen och utbildaren.

## Statusförklaring

| Status | Betydelse |
| --- | --- |
| Open | Behöver göras eller undersökas. |
| In progress | Någon arbetar aktivt med punkten. |
| Review | Ändring finns i pull request och behöver granskas. |
| Done | Klart och verifierat. |

## Backlog

| ID | GitHub Issue | Titel | Prioritet | Status | Koppling |
| --- | --- | --- | --- | --- | --- |
| PB-01 | [#1](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/1) | Verifiera PR-flöde och CI-checks | Hög | Done | GitHub Actions, branch protection |
| PB-02 | [#6](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/6), [#13](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/13) | Begränsa åtkomst till Terraform state-bucket | Hög | In progress | `bootstrap/main.tf` |
| PB-03 | [#9](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/9) | Ersätt `GCP_SA_KEY` med Workload Identity Federation | Hög | Done | `.github/workflows/deploy.yml`, `bootstrap/` |
| PB-04 | [#7](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/7) | Minska behörighet för CI/CD service account | Hög | Done | `bootstrap/main.tf`, IAM |
| PB-05 | [#8](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/8) | Begränsa firewall-regeln från `0.0.0.0/0` | Hög | Done | `main.tf`, nätverk |
| PB-06 | [#12](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/12) | Dokumentera säker hantering av Terraform state och credentials | Medel | Done | `docs/`, `.gitignore` |
| PB-07 | [#11](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/11) | Granska Lasses föreslagna bucket-fix | Hög | Done | `member/larstorngrenchas` |
| PB-08 | [#10](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/10) | Skapa tydlig rutin för secrets och variabler i GitHub Actions | Medel | In progress | GitHub Actions, repo settings |
| PB-09 | [#15](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/15) | Kontrollera SSH-användare och åtkomstmodell | Hög | In progress | `variables.tf`, OS Login, Compute IAM |
| PB-10 | [#14](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/14) | Dokumentera dagens Blue Team-beslut efter workshop | Medel | Done | `docs/blue_team_agenda_2026-09-08.md` |
| PB-11 | [#16](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/16) | Granska och dokumentera uniform bucket-level access | Medel | Open | `bootstrap/main.tf`, GCS IAM |
| PB-12 | [#41](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/41) | Dokumentera och gör Headscale-installationen reproducerbar | Medel | Open | Jumphost, Headscale, `docs/` |

## Första Prioritering

Nuvarande prioritering är PB-02, PB-08, PB-09, PB-11 och PB-12 eftersom övriga
punkter är klara och dessa fortfarande berör åtkomst, autentisering eller
reproducerbar drift.

PB-02 har två GitHub issues eftersom Lasse också skapade en mer konkret observation om `allAuthenticatedUsers` i issue #13. Den bör hanteras tillsammans med PB-02/PB-07 i reviewarbetet.

PB-11 är en granskningspunkt. Inställningen `uniform_bucket_level_access = true` är normalt en säkerhetsförbättring eftersom åtkomst då styrs enhetligt via IAM, men teamet ska verifiera och dokumentera hur den samverkar med bucketens övriga behörigheter.

## Statusuppdatering 2026-09-08

- PB-03: WIF infördes via [PR #18](https://github.com/Itzmejonny92/kurs6-team2-infra/pull/18), godkändes av två granskare och verifierades genom en [lyckad deploy från `main`](https://github.com/Itzmejonny92/kurs6-team2-infra/actions/runs/34231222239). Punkten är fortfarande `In progress` tills service account-nyckeln och `GCP_SA_KEY` har tagits bort och verifierats.
- PB-08: Repository Variables för WIF är konfigurerade. En fullständig rutin för secrets och variables behöver fortfarande dokumenteras.
- PB-09: SSH-användarna Jonny, Lasse, Willi, Tim och Fajk finns i `terraform.tfvars`. Amin saknas fortfarande och den gemensamma åtkomstrutinen återstår.
- PB-10: Dagens agenda och säkerhetsbedömning mergades till `main` via [PR #20](https://github.com/Itzmejonny92/kurs6-team2-infra/pull/20) efter gruppens granskning.

## Statusuppdatering 2026-09-10

- PB-03: Borttagningen av den långlivade service account-nyckeln och dess
  känsliga Terraform-output är förberedd för granskning. Bootstrap-konfigurationen
  är validerad och planen visar `0 to add, 0 to change, 1 to destroy`, där den
  enda resursen som tas bort är `google_service_account_key.cicd`. Punkten
  markeras som `Done` först efter mergad PR, genomförd bootstrap-apply, borttagen
  GitHub-hemlighet `GCP_SA_KEY` och en ny lyckad WIF-deploy från `main`.
- PB-02, PB-04 och PB-05: Kodändringarna för explicit stateåtkomst,
  least privilege och begränsade brandväggsregler är mergade. WIF når nu
  state-backenden, men apply stoppas eftersom `compute.networkAdmin` saknar
  `compute.firewalls.create`, `compute.firewalls.delete` och
  `compute.firewalls.update`. En snäv projektspecifik roll med endast dessa tre
  rättigheter är förberedd för granskning. Punkterna står kvar i `Review` tills
  bootstrap har applicerats och en deploy från `main` är verifierad.

## Statusuppdatering 2026-09-14

- PB-03 är `Done`. `GCP_SA_KEY` saknas i GitHub Secrets och alla
  användarhanterade nycklar för `team2-cicd` har inaktiverats, testats och
  raderats. En avslutande [deploy från `main`](https://github.com/Itzmejonny92/kurs6-team2-infra/actions/runs/34826524653)
  lyckades med WIF efter raderingen.
- PB-04 är `Done`. Den tidigare rollen `roles/editor` är borttagen. CI/CD har
  separata Compute-roller och explicit åtkomst till state-bucketen. Projektet
  tillät inte en egen minimal brandväggsroll, så `roles/compute.securityAdmin`
  används efter dokumenterad säkerhetsbedömning. Rollen bör omprövas om
  utbildaren kan tillhandahålla en smalare roll.
- PB-05 är `Done`. Den breda regeln `team2-allow-traffic` är borttagen. Endast
  SSH på TCP 22 till jumphosten och intern trafik från `10.0.2.0/24` finns i
  Team 2:s brandväggsregler.
- PB-09 markerades först som `Done` efter den metadatahanterade SSH-rutinen. Den
  har återgått till `In progress` efter OS Login-migreringen i PR #39. Tim och
  Amin saknas i `os_admin_users`, och behovet av administrativ OS Login ska
  bedömas. Issue #15 har återöppnats.
- PB-07 är `Done`. Lasses ändring i PR #27 klarade kontroller, fick två
  approvals, mergades och verifierades i GCP. Issue #11 är stängt.
- PB-02 är fortsatt `In progress`. Den publika `allAuthenticatedUsers`-bindningen
  är borttagen och verifierad, men åtkomsten via projektets grundroller behöver
  fortfarande bedömas i issue #6. `public_access_prevention` följs upp separat
  i PB-11/issue #16.
- Dokumentations-PR #37 mergades och efterföljande
  [deploy från `main`](https://github.com/Itzmejonny92/kurs6-team2-infra/actions/runs/34828593323)
  lyckades.
- PR #39 migrerade jumphosten till OS Login, blockerade metadatahanterade
  SSH-nycklar och kopplade ett dedikerat service account till VM:n. Efterföljande
  [deploy från `main`](https://github.com/Itzmejonny92/kurs6-team2-infra/actions/runs/34831901973)
  lyckades. Livekontrollen visade att service accountet inte har några
  projektroller.
- PR #40 lade till Willis arbetsanteckningar om proxy, VM-start och en manuellt
  installerad Headscale-version. Installationen följs upp som PB-12/issue #41
  eftersom driftstatus, installationskälla och reproducerbarhet behöver
  verifieras och dokumenteras.

## Arbetsflöde

1. Välj en backlogpunkt.
2. Skapa eller använd motsvarande GitHub Issue.
3. Arbeta från egen member-branch.
4. Gör en liten, tydlig ändring.
5. Kör:

```bash
terraform fmt -recursive
terraform validate
```

6. Pusha branchen.
7. Skapa pull request mot `main`.
8. Låt två personer granska och approve:a.
9. Uppdatera backlogstatus när ändringen är mergad.
