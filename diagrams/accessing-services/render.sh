#!/usr/bin/env sh

# Renders the accessing services diagram and updates its videos and posters in docs/assets/accessing-services.
#
# Requires Node.js, Docker, ffmpeg, and cwebp. On NixOS:
#   nix shell nixpkgs#nodejs_22 nixpkgs#ffmpeg nixpkgs#libwebp -c diagrams/accessing-services/render.sh

set -o errexit
set -o nounset

cd "$(dirname "$0")"
output=../../docs/assets/accessing-services
mkdir -p renders "$output"

# Opt out of HyperFrames' telemetry and update check, since its version is pinned in package.json.
# Renders run the CLI again inside a container that doesn't get our environment, so docker is
# wrapped to pass these variables into the container as well.
export HYPERFRAMES_NO_TELEMETRY=1 HYPERFRAMES_NO_UPDATE_CHECK=1
docker=$(command -v docker)
bin=$(mktemp -d)
trap 'rm -rf "$bin"' EXIT
cat > "$bin/docker" <<EOF
#!/usr/bin/env sh
if [ "\$1" = run ]; then
  shift
  exec "$docker" run --env HYPERFRAMES_NO_TELEMETRY --env HYPERFRAMES_NO_UPDATE_CHECK "\$@"
fi
exec "$docker" "\$@"
EOF
chmod +x "$bin/docker"
PATH=$bin:$PATH

for theme in light dark; do
  # The "all" scene is the full loop, which is only used for the overview image.
  for pair in all:overview 1:internet 2:local-network 3:vpn 4:internal-only 5:direct-https; do
    scene=${pair%%:*}
    name=${pair#*:}
    video=renders/$name-$theme.mp4

    echo "Rendering $name ($theme)"
    npm run --silent render -- --docker --quiet --fps 30 --workers 4 --strict-variables \
      --variables "{\"theme\": \"$theme\", \"scene\": \"$scene\"}" --output "$video" .

    # The first frame is shown as the poster until the video starts playing.
    ffmpeg -v error -y -i "$video" -frames:v 1 renders/poster.png
    cwebp -quiet -q 88 renders/poster.png -o "$output/$name-$theme.webp"

    if [ "$scene" != all ]; then
      ffmpeg -v error -y -i "$video" -c:v libx264 -preset slow -crf 23 -pix_fmt yuv420p \
        -movflags +faststart -an "$output/$name-$theme.mp4"
    fi
  done
done

rm renders/poster.png
