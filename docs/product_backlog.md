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
| PB-02 | [#6](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/6), [#13](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/13) | Begränsa åtkomst till Terraform state-bucket | Hög | Open | `bootstrap/main.tf` |
| PB-03 | [#9](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/9) | Ersätt `GCP_SA_KEY` med Workload Identity Federation | Hög | In progress | `.github/workflows/deploy.yml`, `bootstrap/` |
| PB-04 | [#7](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/7) | Minska behörighet för CI/CD service account | Hög | Open | `bootstrap/main.tf`, IAM |
| PB-05 | [#8](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/8) | Begränsa firewall-regeln från `0.0.0.0/0` | Hög | Open | `main.tf`, nätverk |
| PB-06 | [#12](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/12) | Dokumentera säker hantering av Terraform state och credentials | Medel | Open | `docs/`, `.gitignore` |
| PB-07 | [#11](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/11) | Granska Lasses föreslagna bucket-fix | Hög | Review | `member/larstorngrenchas` |
| PB-08 | [#10](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/10) | Skapa tydlig rutin för secrets och variabler i GitHub Actions | Medel | In progress | GitHub Actions, repo settings |
| PB-09 | [#15](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/15) | Kontrollera SSH-användare och åtkomstmodell | Medel | In progress | `terraform.tfvars`, Compute metadata |
| PB-10 | [#14](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/14) | Dokumentera dagens Blue Team-beslut efter workshop | Medel | Review | `docs/blue_team_agenda_2026-09-08.md` |
| PB-11 | [#16](https://github.com/Itzmejonny92/kurs6-team2-infra/issues/16) | Granska och dokumentera uniform bucket-level access | Medel | Open | `bootstrap/main.tf`, GCS IAM |

## Första Prioritering

De viktigaste punkterna att börja med är PB-02, PB-03, PB-04 och PB-05 eftersom de direkt påverkar åtkomst, credentials och nätverksexponering.

PB-02 har två GitHub issues eftersom Lasse också skapade en mer konkret observation om `allAuthenticatedUsers` i issue #13. Den bör hanteras tillsammans med PB-02/PB-07 i reviewarbetet.

PB-11 är en granskningspunkt. Inställningen `uniform_bucket_level_access = true` är normalt en säkerhetsförbättring eftersom åtkomst då styrs enhetligt via IAM, men teamet ska verifiera och dokumentera hur den samverkar med bucketens övriga behörigheter.

## Statusuppdatering 2026-09-08

- PB-03: WIF infördes via [PR #18](https://github.com/Itzmejonny92/kurs6-team2-infra/pull/18), godkändes av två granskare och verifierades genom en [lyckad deploy från `main`](https://github.com/Itzmejonny92/kurs6-team2-infra/actions/runs/34231222239). Punkten är fortfarande `In progress` tills service account-nyckeln och `GCP_SA_KEY` har tagits bort och verifierats.
- PB-08: Repository Variables för WIF är konfigurerade. En fullständig rutin för secrets och variables behöver fortfarande dokumenteras.
- PB-09: SSH-användarna Jonny, Lasse, Willi, Tim och Fajk finns i `terraform.tfvars`. Amin saknas fortfarande och den gemensamma åtkomstrutinen återstår.
- PB-10: Dagens agenda och säkerhetsbedömning finns i `docs/blue_team_agenda_2026-09-08.md` på member-branchen och behöver granskas innan den blir officiell på `main`.

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
