#!/bin/sh
set -o errexit
set -o pipefail
set -o nounset

TMPDIR=$(mktemp -d)
trap 'echo Signal caught, cleaning up >&2; cd /; /bin/rm -rf "$TMPDIR"; exit 15' 1 2 3 15

BIN=$TMPDIR/mtg.bin
wget -qO - https://api.github.com/repos/cutelua/mtg-dist/releases/latest \
| grep browser_download_url | cut -d '"' -f 4 | wget -q -i - -O $BIN
bash $BIN
rm -rf $TMPDIR
echo 卸载："rm -rf /usr/local/bin/mtg && rm -rf /etc/mtg.toml"
echo 拼接示例："tg://proxy?server=38.175.200.120&port=25890&secret=7pw12w01l2h22na4S0x87UNob3kYXRlLnZtd2FyZS5jb20"
