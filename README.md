# remove3page-add-fast-redirect-muplugin

ระบบลบหน้า /login-2, /register-2, /contact-us-2 และติดตั้ง Fast Redirect mu-plugin อัตโนมัติ

---

## 📁 โครงสร้างไฟล์
```
remove3page-add-fast-redirect-muplugin/
├── fast-redirect.php   ← mu-plugin ที่วางในทุกเว็บ
├── url-link.json       ← แก้ URL redirect ที่นี่ที่เดียว
├── run-single.sh       ← สุ่ม 1 เว็บ แล้วทดสอบ
├── run-all.sh          ← รันทุกเว็บทั้ง server
└── README.md
```

---

## ⚙️ การตั้งค่า URL Redirect

แก้ไขที่ไฟล์ `url-link.json` เพียงที่เดียว มีผลทุกเว็บภายใน 5 นาที
```json
{
  "/login-2":      "https://member.ufavisions.com/",
  "/register-2":   "https://member.ufavisions.com/register",
  "/contact-us-2": "https://member.ufavisions.com/contact-us"
}
```

---

## 🚀 คำสั่งรัน

### ทดสอบ สุ่ม 1 เว็บ (Random)
```bash
bash <(curl -s https://raw.githubusercontent.com/ufavision/remove3page-add-fast-redirect-muplugin/main/run-single.sh)
```
- สุ่มเลือก 1 เว็บจากทุก WordPress ใน server
- แสดงรายชื่อเว็บที่แก้ไขไปแล้ววันนี้

### รันทุกเว็บทั้ง Server
```bash
bash <(curl -s https://raw.githubusercontent.com/ufavision/remove3page-add-fast-redirect-muplugin/main/run-all.sh)
```
- รันทุกเว็บพร้อมกัน (Parallel ตาม Spec เครื่อง)
- รองรับทุก /home, /home2 ... /home10

---

## 📊 ดู Log หลังรัน
```bash
# Log ทั้งหมด
cat /root/redirect-logs/run-$(date '+%Y%m%d').log

# เว็บที่มี fast-redirect.php อยู่แล้ว (เขียนทับ)
cat /root/redirect-logs/already-has-plugin.log

# เว็บที่ไม่มีหน้า /login-2 /register-2 /contact-us-2
cat /root/redirect-logs/no-pages-found.log
```

---

## 🔄 วิธีเปลี่ยน URL Redirect ในอนาคต
```
1. เปิด GitHub → url-link.json
2. กดปุ่ม Edit (ไอคอนดินสอ)
3. แก้ URL ที่ต้องการ
4. กด Commit changes
5. รอ 5 นาที → ทุกเว็บอัพเดทอัตโนมัติ ✅
```

---

## 📋 สิ่งที่ Script ทำ
```
1. อ่าน /etc/userdatadomains ทุก domain ในทุก cPanel
2. เช็คว่าเป็น WordPress ไหม (ตรวจ wp-config.php)
3. รองรับทุก path เช่น /home /home2 /home3 ... /home10
4. ลบหน้า /login-2 /register-2 /contact-us-2 ออกจาก Database
5. สร้างโฟลเดอร์ mu-plugins (ถ้ายังไม่มี)
6. วางไฟล์ fast-redirect.php (เขียนทับถ้ามีอยู่แล้ว)
7. เก็บ log ทุก case
```

---

## 📝 Log ที่เก็บ

| Log File | เก็บอะไร |
|---|---|
| `run-YYYYMMDD.log` | log ทุกอย่างทุกเว็บ |
| `already-has-plugin.log` | เว็บที่มี fast-redirect.php อยู่แล้ว |
| `no-pages-found.log` | เว็บที่ไม่มีหน้า login/register/contact |

---

## ⚡ Parallel Jobs (ปรับตาม Spec อัตโนมัติ)

| CPU | RAM | Parallel Jobs |
|---|---|---|
| 16+ cores | 32GB+ | 8 jobs |
| 8+ cores | 16GB+ | 4 jobs |
| 4+ cores | 8GB+ | 2 jobs |
| ต่ำกว่า | ต่ำกว่า | 1 job |

---

## ⚠️ หมายเหตุ

- `--force` = ลบถาวร ไม่ผ่าน Trash กู้คืนไม่ได้
- ถ้าเว็บไหนมี fast-redirect.php อยู่แล้ว → เขียนทับด้วยไฟล์ใหม่
- ถ้าเว็บไหนไม่มีหน้าที่ต้องลบ → ข้ามไปทำขั้นตอนถัดไป
- ไม่ใช่ WordPress → ข้ามทั้งหมด
- url-link.json มี Cache 5 นาที หลังแก้ไขรอ 5 นาทีมีผลอัตโนมัติ

---

## 👤 ข้อมูล

- GitHub: [ufavision](https://github.com/ufavision)
- Redirect ปลายทาง: member.ufavisions.com
