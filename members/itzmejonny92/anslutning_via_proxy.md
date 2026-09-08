# Anslutning till labbsidan via proxy

Den här instruktionen beskriver hur jag ansluter till labbsidan via Team 2:s
jumphost och en lokal SOCKS5-proxy.

## 1. Starta SSH-tunneln

Gå till repots rot och hämta jumphostens aktuella IP-adress från Terraform:

```bash
cd /home/jonny-nguyen/team
JUMPHOST_IP=$(terraform output -raw jumphost_external_ip)
printf '%s\n' "$JUMPHOST_IP"
```

Starta sedan tunneln och låt terminalen vara öppen:

```bash
ssh -N -D 1080 jonny@"$JUMPHOST_IP"
```

Att terminalen inte visar någon ny text är normalt. SSH väntar då och håller
tunneln öppen. Vid dokumentationstillfället var adressen `34.51.183.245`, men
Terraform-outputen ska användas om adressen ändras.

## 2. Kontrollera proxyn i Windows

Kör i Windows PowerShell:

```powershell
Test-NetConnection 127.0.0.1 -Port 1080
```

`TcpTestSucceeded : True` betyder att Windows når SOCKS5-proxyn.

## 3. Starta Opera GX med proxyn

Kör följande i Windows CMD:

```cmd
"C:\Users\Jonny\AppData\Local\Programs\Opera GX\opera.exe" --user-data-dir="C:\Users\Jonny\AppData\Local\Temp\opera-gx-spectre" --proxy-server="socks5://127.0.0.1:1080" --host-resolver-rules="MAP * ~NOTFOUND, EXCLUDE 127.0.0.1"
```

Kommandot öppnar en separat Opera GX-profil. Endast den profilen använder
labbsidans proxy.

## 4. Öppna labbsidan

```text
https://spectre.itsx25.chas-lab.dev
```

Kontrollera att sidan identifierar anslutningen som Team 2.

## 5. Avsluta

1. Stäng det separata Opera GX-fönstret.
2. Gå tillbaka till SSH-terminalen.
3. Tryck `Ctrl+C` för att stänga tunneln.

## Felsökning

- Kontrollera att SSH-terminalen fortfarande är öppen.
- Kör portkontrollen igen och verifiera att resultatet är `True`.
- Kontrollera att Opera GX startades med den separata profilen och proxyflaggorna.
- Dela aldrig privata SSH-nycklar, autentiseringsuppgifter eller innehåll från
  Terraform state.
