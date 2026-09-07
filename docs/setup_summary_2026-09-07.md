# Setup Summary 2026-09-07

## Syfte

Denna sammanfattning beskriver vad som har satts upp för grupp 2:s infra-repo under starten av vecka 4: Blue Team Start.

## Genomfört Arbete

- Packade upp kursens Terraform-underlag.
- Rensade bort en dubbel `team/team`-mapp från tidigare uppackning.
- Arbetet flyttades till korrekt arbetsmapp: `/home/jonny-nguyen/team`.
- Satte `project_id` till `itsx25-lab`.
- Satte `team_id` till `2`.
- Bekräftade att teamets subnet blir `10.0.2.0/24`.
- Lade in Jonnys publika SSH-nyckel i `terraform.tfvars`.
- Fixade ett syntaxfel i `bootstrap/main.tf`.
- Körde `terraform fmt -recursive`.
- Körde `terraform init` och `terraform validate`.
- Körde `terraform plan` för bootstrap.
- Skapade bootstrap-resurser i GCP.
- Aktiverade GCS-backend för bootstrap state.
- Lade till `backend.tf` för teamets Terraform state.
- Skapade publikt GitHub-repo: `Itzmejonny92/kurs6-team2-infra`.
- Pushade Terraform-koden till GitHub.
- Lade till `GCP_SA_KEY` som GitHub Secret.
- Verifierade att GitHub Actions deploy gick igenom.
- Aktiverade branch protection på `main`.
- Skapade member-branches för gruppmedlemmarna.
- Bjöd in gruppmedlemmar till repot med write access.
- Uppdaterade `.gitignore` för att skydda mot state-, plan- och credential-filer.
- Lasse pushade en säkerhetsförbättring på `member/larstorngrenchas`.
- Lasses ändring föreslår att state-bucketen får `public_access_prevention = "enforced"`.
- Lasses ändring föreslår också att bucket-läsning begränsas till CI/CD-service accountet i stället för `allAuthenticatedUsers`.

## Viktiga Beslut

- Repot är publikt enligt lärarens instruktion.
- Teamet arbetar från egna member-branches och skapar pull requests mot `main`.
- `main` skyddas med branch protection.
- Pull requests kräver två approvals.
- CI-checken `Format & Validate` måste gå igenom innan merge.
- `GCP_SA_KEY` används just nu för GitHub Actions, men bör senare ersättas med Workload Identity Federation.
- Säkerhetsförbättringar ska göras via member-branches och pull requests, även när ändringen är liten.

## Nuvarande Risker Att Följa Upp

- Bootstrap-koden innehåller en bred IAM-roll: `roles/editor`.
- Bootstrap-koden skapar en långlivad service account key.
- State-bucketen har i nuvarande `main` en IAM-regel med `allAuthenticatedUsers`.
- Lasses branch innehåller ett förslag som åtgärdar bucketens publika åtkomstrisk, men ändringen behöver granskas via pull request innan den räknas som officiell.
- Teamets firewall tillåter all trafik från `0.0.0.0/0`.
- Service account key bör ersättas av Workload Identity Federation enligt workshopmaterialet.

## Nästa Steg

- Skapa issues för identifierade säkerhetsrisker.
- Testa PR-flödet med en liten, ofarlig ändring.
- Låta två gruppmedlemmar approve:a en PR.
- Granska Lasses säkerhetsförbättring i en pull request.
- Börja granska Terraform-koden systematiskt ur Blue Team-perspektiv.
- Förbereda migrering från service account key till Workload Identity Federation.
