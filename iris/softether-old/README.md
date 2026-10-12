# softether-old

2026-10-12 に撤去した SoftEther VPN Server(`/usr/local/vpnserver`)の設定の控え。

- `vpn_server.config`: サーバー設定。証明書・秘密鍵・パスワードハッシュ・IPsec 事前共有鍵・DDNS 鍵などは `<REDACTED>` に置き換えてある
- `vpnserver.service`: systemd ユニット
- `interfaces`: 撤去前の `/etc/network/interfaces`(br0 に enp3s0 と SoftEther のローカルブリッジ tap_ventrance をつないでいた)
- `lang.config`: 言語設定

秘密情報を含む原本(`/usr/local/vpnserver` 一式など)は、非公開の OneDrive の `iris-softether-old/vpnserver-20261012.tar.gz` に保管している。
