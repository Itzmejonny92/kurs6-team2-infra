# Blue Team Agenda 2026-09-08

## Syfte

Dagens arbete fokuserar på del 6 i workshopmaterialet: att säkra upp infrastrukturen och dokumentera risker kopplade till service account key, Terraform state, IAM och CI/CD.

Arbetet ska göras defensivt. Vi ska förstå riskerna, dokumentera dem tydligt och prioritera säkra åtgärder. Vi ska inte beskriva praktiska steg för hur en läckt nyckel kan användas för obehörig åtkomst.

## Dagens Agenda

- Fortsätta från `member/itzmejonny92`.
- Kontrollera nuläget i repot efter gårdagens setup.
- Fokusera på frågorna i del 6: Säkra upp.
- Dokumentera hur service account key fungerar som risk.
- Dokumentera varför nyckeln bör inaktiveras först.
- Dokumentera att nyckeln bör tas bort när Workload Identity Federation fungerar korrekt.
- Använda `docs/product_backlog.md` och GitHub Issues för att prioritera arbetet.
- Skapa underlag som gruppmedlemmar och utbildare kan läsa i efterhand.

## Nuläge I Repot

- GitHub-repot är publikt enligt lärarens instruktion.
- `main` har branch protection.
- Pull requests kräver två approvals.
- `Format & Validate` krävs som statuscheck.
- GitHub Actions deploy har fungerat med `GCP_SA_KEY`.
- `GCP_SA_KEY` används fortfarande som GitHub Secret.
- Bootstrap-state ligger i GCS-backend.
- Teamets Terraform-kod ligger i rooten av repot.
- Dokumentation ligger i `docs/`.

## Viktiga Filer Att Granska

| Fil | Varför Den Är Viktig |
| --- | --- |
| `bootstrap/main.tf` | Skapar state-bucket, CI/CD service account, IAM-roll och service account key. |
| `main.tf` | Skapar teamets nätverk, jumphost, route och firewall-regler. |
| `backend.tf` | Pekar Terraform state till GCS-bucket. |
| `.github/workflows/deploy.yml` | Använder `GCP_SA_KEY` för att autentisera GitHub Actions mot GCP. |
| `.github/workflows/pr-checks.yml` | Kör format- och valideringskontroller på pull requests. |
| `.gitignore` | Skyddar mot att state, planfiler och credentials råkar commitas. |

## Service Account Key

En service account key är en långlivad credential. I praktiken fungerar den som en maskinidentitet som kan användas för att autentisera mot GCP.

I vårt repo används nyckeln just nu som GitHub Secret med namnet `GCP_SA_KEY`. Den behövs för att GitHub Actions ska kunna köra Terraform mot GCP.

### Risk

Om nyckeln läcker kan någon försöka använda den utanför den tänkta CI/CD-miljön. Risken blir extra stor eftersom service accountet i nuvarande bootstrap-kod har rollen `roles/editor`, vilket är en bred behörighet.

### Defensiv Bedömning

Nyckeln ska betraktas som känslig information. Den ska inte skrivas ut i terminal, inte sparas i repo, inte delas i chatt och inte lagras i vanliga dokument.

Det räcker för vår analys att förstå att nyckeln är en base64-kodad JSON-credential i Terraform-outputen och att GitHub Actions kan använda den via `secrets.GCP_SA_KEY`.

## Rekommenderad Åtgärdsordning

| Steg | Åtgärd | Motivering |
| --- | --- | --- |
| 1 | Dokumentera nuvarande risk | Gör det tydligt varför `GCP_SA_KEY` är en risk. |
| 2 | Inaktivera service account key | Minskar risken direkt utan att nödvändigtvis ta bort historik eller Terraform-resurs direkt. |
| 3 | Inför Workload Identity Federation | Ersätter långlivad nyckel med federerad autentisering mellan GitHub och GCP. |
| 4 | Verifiera att GitHub Actions fungerar med WIF | Säkerställer att deploy fortfarande fungerar utan statisk nyckel. |
| 5 | Ta bort den gamla service account key | Slutlig städning när WIF är bekräftat. |
| 6 | Ta bort `GCP_SA_KEY` från GitHub Secrets | Secret behövs inte längre när WIF är i drift. |

## Frågor För Gruppen

- Vilka resurser kan CI/CD-service accountet påverka med rollen `roles/editor`?
- Behöver service accountet verkligen Editor, eller räcker mer begränsade roller?
- Är state-bucketens åtkomst korrekt begränsad?
- Ska Lasses föreslagna bucket-fix prioriteras först?
- Vilka risker finns med firewall-regeln som tillåter all trafik från `0.0.0.0/0`?
- Hur verifierar vi att Workload Identity Federation fungerar innan nyckeln tas bort?

## Föreslagna Issues

Backloggen finns i `docs/product_backlog.md`. Den filen länkar vidare till motsvarande GitHub Issues.

| Issue | Prioritet | Beskrivning |
| --- | --- | --- |
| Begränsa åtkomst till Terraform state-bucket | Hög | Nuvarande `main` innehåller bred bucket-åtkomst via `allAuthenticatedUsers`. |
| Ersätt `GCP_SA_KEY` med Workload Identity Federation | Hög | Minskar risken med långlivade credentials. |
| Minska behörighet för CI/CD service account | Hög | `roles/editor` är bredare än vad en pipeline normalt bör ha. |
| Begränsa firewall-regeln `0.0.0.0/0` | Hög | All trafik från internet är en tydlig nätverksrisk. |
| Dokumentera säker hantering av Terraform state | Medel | Gruppen behöver gemensam rutin för state och credentials. |

## Viktigt För Redovisning

När vi redovisar arbetet bör vi visa:

- Vilka risker vi hittade.
- Var i repot riskerna finns.
- Varför riskerna är viktiga.
- Vilken ordning vi prioriterar åtgärderna i.
- Hur PR-flöde och branch protection stödjer säkert samarbete.
- Att vi arbetar defensivt och inte använder ATT&CK eller credentials som angreppsinstruktioner.

## Nästa Praktiska Steg

1. Skapa issues för riskerna ovan.
2. Granska Lasses branch som redan föreslår förbättring av state-bucketen.
3. Förbereda WIF-ändringen när `wif.patch` ska användas.
4. Verifiera pipeline efter varje ändring.
5. Uppdatera dokumentationen efter varje beslut.
