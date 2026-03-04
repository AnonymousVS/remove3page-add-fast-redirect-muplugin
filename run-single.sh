#!/bin/bash
DOMAIN=${1:-"fifa8989.co"}
GITHUB_RAW="https://raw.githubusercontent.com/ufavision/remove3page-add-fast-redirect-muplugin/main"

echo "======================================"
echo "🚀 เริ่มทำงาน: $DOMAIN"
echo "======================================"

USERNAME=$(grep "$DOMAIN" /etc/userdatadomains | awk -F'==' '{print $1}' | awk -F': ' '{print $2}' | tr -d ' ')

if [ -z "$USERNAME" ]; then
  echo "❌ หา username ไม่เจอ: $DOMAIN"
  exit 1
fi

WP_PATH="/home/$USERNAME/public_html"

if [ ! -f "$WP_PATH/wp-config.php" ]; then
  echo "❌ ไม่พบ wp-config.php ที่ $WP_PATH"
  exit 1
fi

echo "✅ username : $USERNAME"
echo "✅ path     : $WP_PATH"

echo ""
echo "🗑️ กำลังลบ Pages..."
for SLUG in "login-2" "register-2" "contact-us-2"; do
  PAGE_ID=$(wp post list --post_type=page --name="$SLUG" --field=ID --path="$WP_PATH" --allow-root 2>/dev/null)
  if [ -n "$PAGE_ID" ]; then
    wp post delete "$PAGE_ID" --force --path="$WP_PATH" --allow-root
    echo "✅ ลบแล้ว: /$SLUG (ID: $PAGE_ID)"
  else
    echo "⚠️ ไม่พบ page: /$SLUG"
  fi
done

MU_DIR="$WP_PATH/wp-content/mu-plugins"
mkdir -p "$MU_DIR"
curl -s "$GITHUB_RAW/fast-redirect.php" -o "$MU_DIR/fast-redirect.php"

echo ""
echo "✅ วางไฟล์ fast-redirect.php สำเร็จ"
echo "📁 ไฟล์ใน mu-plugins:"
ls -la "$MU_DIR/"
echo ""
echo "🎯 ทดสอบได้ที่:"
echo "   https://$DOMAIN/login-2"
echo "   https://$DOMAIN/register-2"
echo "   https://$DOMAIN/contact-us-2"
