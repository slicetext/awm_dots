url=$(playerctl metadata mpris:artUrl)
curl $url -o ~/.config/awesome/cache/album.png
