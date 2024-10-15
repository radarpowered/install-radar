# Install Radar

We recommend doing it from the dashboard (https://radar.sryden.com). But in the case that you don't trust your keys are safe with us for whatever reason (fair) then you can do it the manual way.
1. Get your panel URL, key, public & private webhooks ready
2. Run this command with the fields filled out:
```
bash <(curl -s https://raw.githubusercontent.com/radarpowered/install-radar/refs/heads/main/install.sh) --node-name "Example Node" --public-whook "" --private-whook "" --panel "https://panel.example.com" --key "ptla_xxxxxxxxxxxxxxxx"
```
