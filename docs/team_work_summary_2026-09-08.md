# Gemensam arbetssammanfattning - 2026-09-08

## Syfte

Grupp 2 har fortsatt etablera och säkra sin Terraform-baserade infrastruktur i
GCP. Dagens fokus har varit agilt Blue Team-arbete, WIF, SSH-åtkomst,
säkerhetsanalys och spårbar dokumentation.

## Närvaro

Följande gruppmedlemmar var närvarande under arbetet den 2026-09-08:

- Jonny Nguyen (`itzmejonny92`)
- Fajk Zhupa (`fajkzhupa-chas`)
- Lars Törngren (`larstorngrenchas`)
- Tim Rundquist (`timrundquist`)
- Willi Broad Ngebi (`willibroadngebi-lab`)

Amin Mahamoud (`aminmahamoud-arch`) var inte närvarande.

## Gemensamma resultat

### Backlogg och dokumentation

- Produktbackloggen har kopplats till konkreta GitHub Issues.
- Statusmodellen `Open`, `In progress`, `Review` och `Done` används för att
  skilja på påbörjat, granskat och verifierat arbete.
- README beskriver hur Issues och backloggfilen hålls synkroniserade.
- Dagens Blue Team-agenda och säkerhetsbedömning har granskats och mergats.
- Issue #14 har stängts efter verifierad merge.
- Personliga dokumentationsytor har skapats för samtliga sex gruppmedlemmar.

### Workload Identity Federation

- Lärarens WIF-underlag anpassades till teamets verkliga projekt och repo.
- WIF-pool, GitHub-provider och service account-koppling skapades i GCP.
- GitHub Repository Variables för WIF konfigurerades.
- Deploy-workflowet bytte från statisk service account-nyckel till GitHub OIDC
  och WIF.
- WIF testades först från en branch och därefter genom en lyckad deploy från
  `main`.
- PR #18 godkändes av två medlemmar innan merge.

### SSH och åtkomst

- PR #19 lade till publika SSH-uppgifter för Lasse, Willi, Tim och Fajk.
- Jonny fanns redan i konfigurationen.
- Amin saknas fortfarande och läggs till när hans publika SSH-nyckel finns.
- Privata SSH-nycklar ska alltid stanna på respektive medlems dator.

### Riskanalys

- PR #21 lade till gruppens analys av risker med statiska Google Service
  Account-nycklar.
- Följande prioriterade risker är fortsatt öppna:
  - bred åtkomst till Terraform state via `allAuthenticatedUsers`
  - långlivad service account-nyckel som återstår efter WIF-migreringen
  - bred IAM-roll genom `roles/editor`
  - brandväggsregel som tillåter all trafik från `0.0.0.0/0`
  - ofullständig SSH-rutin och saknad medlem

## Pull requests och verifiering

| PR | Resultat | Status |
| --- | --- | --- |
| [#17](https://github.com/Itzmejonny92/kurs6-team2-infra/pull/17) | Produktbacklogg och arbetsflöde | Mergad |
| [#18](https://github.com/Itzmejonny92/kurs6-team2-infra/pull/18) | Migrering till WIF | Mergad |
| [#19](https://github.com/Itzmejonny92/kurs6-team2-infra/pull/19) | Fyra nya SSH-användare | Mergad |
| [#20](https://github.com/Itzmejonny92/kurs6-team2-infra/pull/20) | Blue Team-agenda och backloggstatus | Mergad |
| [#21](https://github.com/Itzmejonny92/kurs6-team2-infra/pull/21) | Riskanalys för service account-nycklar | Mergad |
| [#22](https://github.com/Itzmejonny92/kurs6-team2-infra/pull/22) | Medlemsytor och avslutande backloggstatus | Under review |

Viktiga verifieringar:

- [WIF-test från member-branch](https://github.com/Itzmejonny92/kurs6-team2-infra/actions/runs/34228835871)
- [Första verifierade WIF-deployen från main](https://github.com/Itzmejonny92/kurs6-team2-infra/actions/runs/34231222239)
- [Deploy efter dokumentationsmerge](https://github.com/Itzmejonny92/kurs6-team2-infra/actions/runs/34232416714)

## Bidrag som syns i repot

- Jonny: backlogg, agenda, WIF-implementering, verifiering, branchsynkning,
  issue-status och medlemsytor.
- Lars: SSH-ändringar, analys av risker med service account-nycklar och reviews.
- Fajk, Lars, Tim och Willi: granskningar och godkännanden av dagens pull
  requests.

Denna lista beskriver spårbara bidrag i GitHub och ska inte tolkas som en
fullständig närvarolista eller som att odokumenterat arbete saknas.

## Aktuell säkerhetsstatus

| Område | Status | Nästa kontroll |
| --- | --- | --- |
| WIF på `main` | Verifierad | Ta bort gammal nyckel och `GCP_SA_KEY`. |
| Terraform state-bucket | Risk kvarstår | Ta bort `allAuthenticatedUsers` och inför public access prevention. |
| CI/CD-behörighet | Risk kvarstår | Ersätt `roles/editor` med minsta nödvändiga roller. |
| Brandvägg | Risk kvarstår | Begränsa protokoll, portar och källor utan att bryta labben. |
| SSH-användare | Delvis klar | Lägg till Amin och dokumentera åtkomstrutinen. |
| Dokumentation | Pågående | Merga PR #22 och fortsätt uppdatera efter beslut. |

## Nästa gemensamma steg

1. Granska och merga PR #22.
2. Genomför kontrollerad borttagning av den gamla service account-nyckeln.
3. Stäng issue #9 och markera PB-03 som `Done` efter verifierad nyckelrensning.
4. Prioritera bucket-issues #6, #13 och #16 som nästa säkerhetsåtgärd.
5. Fortsätt därefter med IAM, brandvägg, SSH-rutin och dokumentation.

## Säkerhetsprincip

Gruppen arbetar iterativt: varje ändring görs i branch, verifieras med Terraform
och GitHub Actions, granskas av minst två medlemmar och mergas därefter till
`main`. Credentials, privata nycklar, state och planfiler får inte commitas.
