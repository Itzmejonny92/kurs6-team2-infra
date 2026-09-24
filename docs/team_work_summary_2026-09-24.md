# Team 2 - arbetssammanfattning 2026-09-24

## Omfattning

Dagens infrastrukturdel av Workshop 3.5-4 fokuserade på att ge
`company-website` ett internt DNS-namn i Team 2:s Tailnet. Arbetet genomfördes
stegvis med skrivskyddade kontroller före varje serverändring.

## Utgångsläge

- Headscale kördes som en aktiv `systemd`-tjänst på `team2-jumphost`.
- Den aktiva konfigurationen låg i `/etc/headscale/config.yaml`.
- MagicDNS var redan aktiverat med `team2.arpa` som basdomän.
- Teamets primary-server hade den privata adressen `10.0.2.3`.
- `extra_records` innehöll ännu ingen post för applikationen.

## Genomfört arbete

1. GCP- och OS Login-åtkomst till jumphosten verifierades via IAP med Jonnys
   personliga SSH-nyckel.
2. Headscales DNS-block lästes och validerades med `headscale configtest`.
3. En tidsstämplad backup av konfigurationen skapades före ändringen.
4. Följande interna A-post lades till:

   ```text
   company-website.team2.arpa -> 10.0.2.3
   ```

5. Headscale startades om och kontrollerades som aktiv.
6. Den gemensamma anslutningsguiden kompletterades med verifierings- och
   felsökningssteg.

## Viktig observation

`systemctl reload headscale` skickade `SIGHUP`, men loggen visade att den
installerade Headscale-versionen endast läste om ACL-policyn. För att läsa in
ändringen i `extra_records` krävdes därför en fullständig omstart av
Headscale-tjänsten.

## Verifiering

Efter omstart verifierades posten från Jonnys WSL-klient:

```text
company-website.team2.arpa -> 10.0.2.3
2 paket skickade, 2 mottagna, 0 procent paketförlust
```

Senare verifierades även HTTP-routning till applikationen via samma namn med
status `200` efter att Ingress hade konfigurerats i applikationsrepot.

## Säkerhet och återställning

- Inga tokens, privata nycklar eller credentials dokumenterades.
- Serverkonfigurationen validerades före omstart.
- En tidsstämplad backup sparades på jumphosten för återställning.
- DNS-posten pekar endast mot primary-serverns privata IP och kräver Tailnet-
  samt subnet-åtkomst.

## Git-status

- Commit `8dc6f19` dokumenterar DNS-posten och felsökningen i den gemensamma
  anslutningsguiden.
- Ändringen ligger på `member/itzmejonny92` och ska granskas via pull request
  innan den blir en del av `main`.

## Uppföljning

- Varje medlem bör verifiera att Tailscale DNS och subnet-rutter är aktiverade.
- Testa `company-website.team2.arpa` från minst en ytterligare medlems klient.
- Flytta på sikt den manuella Headscale-konfigurationen till en reproducerbar
  och versionshanterad installationsrutin.

Applikationens Ingress-, image- och Cosign-arbete dokumenteras i det separata
[`company-website`](https://github.com/itsx25-team2/company-website)-repot.
