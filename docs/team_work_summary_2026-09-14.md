# Gemensam arbetssammanfattning - 2026-09-14

## Syfte

Team 2 har följt upp tidigare Blue Team-ändringar och slutfört migreringen från
långlivade Google service account-nycklar till Workload Identity Federation
(WIF). Arbetet har även verifierat brandvägg, IAM och åtkomst till Terraform
state samt förbättrat gruppens gemensamma anslutningsdokumentation.

## Närvaro och spårbarhet

Fysisk närvaro har inte registrerats i denna sammanfattning. GitHub-historiken
visar följande spårbara bidrag den 2026-09-14:

- Jonny Nguyen (`itzmejonny92`): IAM-korrigering, bootstrap-apply,
  WIF-verifiering, nyckelrensning, issues och dokumentation.
- Lars Törngren (`larstorngrenchas`): mergad uppdatering av backlogg och
  riskdokumentation via PR #35.

Pull request-granskningar och muntliga bidrag kan finnas utan att framgå av
commit-historiken.

## Genomfört arbete

### WIF och nyckelrensning

- WIF verifierades först från `member/itzmejonny92` och därefter från `main`.
- GitHub-hemligheten `GCP_SA_KEY` verifierades som borttagen.
- Två kvarvarande användarhanterade nycklar inaktiverades.
- En deploy från `main` lyckades medan nycklarna var inaktiverade.
- Nycklarna raderades permanent.
- En avslutande deploy från `main` lyckades efter raderingen.
- Issue #9 stängdes med verifieringsbevis.

### IAM

- CI/CD-kontot saknade rätt att skapa och ta bort brandväggsregler.
- En egen roll med tre brandväggsbehörigheter kunde inte skapas eftersom
  kurskontot saknar `iam.roles.create` i det delade projektet.
- Efter uttrycklig säkerhetsbedömning användes den inbyggda rollen
  `roles/compute.securityAdmin` via PR #36.
- Rollen är bredare än önskat och ska omprövas om utbildaren kan skapa en
  smalare projektspecifik roll.

### Brandvägg

- Den gamla regeln `team2-allow-traffic`, som tillät all trafik från
  `0.0.0.0/0`, togs bort.
- `team2-allow-ssh` tillåter TCP 22 till jumphosten.
- `team2-allow-internal` tillåter intern trafik från `10.0.2.0/24` till
  resurser med Team 2:s mål-taggar.
- Issue #8 stängdes efter kontroll av de aktiva reglerna i GCP.

### Terraform state

- Bootstrap-apply tog bort den tidigare publika
  `allAuthenticatedUsers`-bindningen.
- Live IAM-policy verifierades utan någon publik medlem.
- `team2-cicd` har explicit `roles/storage.objectAdmin` för state-bucketen.
- `public_access_prevention` återstår som separat uppföljning i issue #16.

### Dokumentation

- En gemensam anslutningsguide skapades för Git, personlig GCP-inloggning,
  Terraform, SSH, SOCKS5 och labbsidan.
- Guiden förbjuder lokala service account-nycklar och förklarar att CI/CD
  använder WIF.
- README, produktbacklogg och Jonnys personliga README uppdaterades.

## Pull requests och verifieringar

| Underlag | Resultat |
| --- | --- |
| [PR #34](https://github.com/Itzmejonny92/kurs6-team2-infra/pull/34) | Första försöket med minimal brandväggsroll |
| [PR #35](https://github.com/Itzmejonny92/kurs6-team2-infra/pull/35) | Backlogg och riskdokumentation |
| [PR #36](https://github.com/Itzmejonny92/kurs6-team2-infra/pull/36) | Tillgänglig inbyggd IAM-roll efter projektbegränsning |
| [Branch-deploy](https://github.com/Itzmejonny92/kurs6-team2-infra/actions/runs/34824365603) | WIF och brandväggsändring lyckades |
| [Deploy efter merge](https://github.com/Itzmejonny92/kurs6-team2-infra/actions/runs/34825510839) | `main` lyckades |
| [Test med inaktiverade nycklar](https://github.com/Itzmejonny92/kurs6-team2-infra/actions/runs/34825821057) | WIF fungerade utan användbara nycklar |
| [Sluttest efter radering](https://github.com/Itzmejonny92/kurs6-team2-infra/actions/runs/34826524653) | WIF fungerade utan användarhanterade nycklar |

## Aktuell säkerhetsstatus

| Område | Status | Uppföljning |
| --- | --- | --- |
| WIF | Done | Fortsätt använda kortlivad autentisering i Actions. |
| Service account-nycklar | Done | Skapa inte nya långlivade nycklar. |
| Brandvägg | Done för aktuell issue | Ompröva SSH-källan när en stabil tillåten CIDR finns. |
| State-bucket | Delvis klar | Följ upp public access prevention i issue #16. |
| CI/CD-IAM | Fungerande med känd avvägning | Be utbildaren om möjlighet till smalare custom role. |
| Anslutningsrutin | Dokumenterad | Låt medlemmarna testa guiden och rapportera oklarheter. |

## Nästa steg

1. Granska och merga dagens dokumentationsändringar.
2. Slutför granskningen av bucket-issues #6, #11 och #16.
3. Slutför rutinen för GitHub Actions secrets och variables i issue #10.
4. Låt gruppmedlemmarna testa den gemensamma anslutningsguiden.

## Säkerhetsprincip

Inga privata SSH-nycklar, service account-nycklar, credentials, Terraform
state, planfiler eller flaggvärden har lagts till i dokumentationen.
