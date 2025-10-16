echo "───────────────────────────────────────────────"
echo "Now we are going to open the necessary ports for Decidim to work."
echo
echo "To handle the SSL certificate we will have to open the port 80 and the port 443"
echo

if ! command -v ufw; then
  echo "UFW nos intalled. We are going to install it to allow openning ports 80 and 443 on this machine."
  sudo apt install ufw
fi

sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable

echo "───────────────────────────────────────────────"
