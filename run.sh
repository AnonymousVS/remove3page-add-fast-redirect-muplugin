#!/bin/bash
GITHUB_RAW="https://raw.githubusercontent.com/ufavision/remove3page-add-fast-redirect-muplugin/main"
SUCCESS=0
FAILED=0
SKIPPED=0

echo "======================================"
echo "🚀 เริ่มรันทุก cPanel"
echo "======================================"

while IFS= read -r line; do
  DOMAIN=$(echo "$line" | awk -F': ' '{print $1}' | tr -d ' ')
  USERNAME=$(echo "$line" | awk -F'==' '{print $1}' | awk -F': ' '{print $2}' | tr -d ' ')
  WP_PATH="/home/$USERNAME/public_html"

  if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "⏭️ ข้าม (ไม่ใช่ WordPress): $DOMAIN"
    ((SKIPPED++))
    continue
  fi

  echo ""
  echo "▶ กำลังทำ: $DOMAIN ($USERNAME)"

  for SLUG in "login-2" "register-2" "contact-us-2"; do
    PAGE_ID=$(wp post list --post_type=page --name="$SLUG" --field=ID --path="$WP_PATH" --allow-root 2>/dev/null)
    if [ -n "$PAGE_ID" ]; then
      wp post delete "$PAGE_ID" --force --path="$WP_PATH" --allow-root
      echo "  🗑️ ลบแล้ว: /$SLUG"
    fi
  done

  MU_DIR="$WP_PATH/wp-content/mu-plugins"
  mkdir -p "$MU_DIR"
  curl -s "$GITHUB_RAW/fast-redirect.php" -o "$MU_DIR/fast-redirect.php"

  if [ -f "$MU_DIR/fast-redirect.php" ]; then
    echo "  ✅ สำเร็จ: $DOMAIN"
    ((SUCCESS++))
  else
    echo "  ❌ ไม่สำเร็จ: $DOMAIN"
    ((FAILED++))
  fi

done < /etc/userdatadomains

echo ""
echo "======================================"
echo "📊 สรุปผล"
echo "======================================"
echo "✅ สำเร็จ   : $SUCCESS เว็บ"
echo "❌ ไม่สำเร็จ : $FAILED เว็บ"
echo "⏭️ ข้าม     : $SKIPPED เว็บ"
