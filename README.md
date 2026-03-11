<div align="center">

# 📅 Daily Commit Reminder

### Automated Daily Learning Reminder with Telegram Notifications
### تذكير يومي تلقائي بالالتزامات مع إشعارات تلجرام

[![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Telegram](https://img.shields.io/badge/Telegram_Bot-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://core.telegram.org/bots)
[![Cron](https://img.shields.io/badge/Cron_Job-000000?style=for-the-badge&logo=linux&logoColor=white)](https://man7.org/linux/man-pages/man5/crontab.5.html)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](LICENSE)

<img src="https://readme-typing-svg.herokuapp.com?font=Fira+Code&weight=600&size=20&pause=1000&color=00D4FF&center=true&vCenter=true&random=false&width=500&lines=Keep+Your+GitHub+Graph+Green!;Daily+Commit+Reminders+via+Telegram;Maintain+Your+Learning+Streak+🔥" alt="Typing SVG" />

**[English](#-overview) | [العربية](#-نظرة-عامة)**

</div>

---

# 🇬🇧 English

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Configuration](#-configuration)
- [Telegram Bot Setup](#-telegram-bot-setup)
- [Usage](#-usage)
- [Cron Schedule](#-cron-schedule)
- [Uninstall](#-uninstall)
- [Contributing](#-contributing)

---

## 🔍 Overview

**Daily Commit Reminder** is a Bash automation tool designed to help maintain an active GitHub contribution graph. It monitors your specified Git repository for daily commits and sends intelligent Telegram notifications as reminders.

> **Why?** Consistent daily contributions demonstrate dedication and build strong habits. This script ensures you never forget to log your learning!

---

## ✨ Features

| Feature | Description |
| :--- | :--- |
| 🔔 **Telegram Notifications** | Smart notifications with urgency levels based on time of day |
| 🔥 **Streak Tracking** | Tracks your consecutive commit streak |
| ⏰ **3x Daily Reminders** | Morning (10 AM), Afternoon (4 PM), Evening (9 PM) |
| 📊 **Status Dashboard** | Quick command to check your current stats |
| 🧪 **Test Mode** | Verify your Telegram setup with a test message |
| 📝 **Comprehensive Logging** | All activities logged for troubleshooting |
| 🇸🇦 **Arabic Support** | Notifications in Arabic for native speakers |
| 🔧 **Easy Setup** | Interactive setup script with guided configuration |
| 🗑️ **Clean Uninstall** | Full removal with one command |

---

## 🏗️ Architecture

```text
daily-commit-reminder/
├── daily-commit-reminder.sh    # Main reminder script
├── setup.sh                    # Interactive setup & installation
├── uninstall.sh                # Clean removal script
├── README.md                   # This file
└── LICENSE                     # MIT License
```

### How It Works

```text
┌─────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  Cron Job   │────▶│  Check Git Log   │────▶│  Has Commits?   │
│  (3x/day)   │     │  for Today       │     │  Today?         │
└─────────────┘     └──────────────────┘     └────────┬────────┘
                                                       │
                                              ┌────────┴────────┐
                                              │                 │
                                         ✅ Yes            ❌ No
                                              │                 │
                                    ┌─────────▼──┐    ┌────────▼────────┐
                                    │  Log Only   │    │  Send Telegram  │
                                    │  (End of    │    │  Reminder with  │
                                    │   day: ✅)  │    │  Urgency Level  │
                                    └────────────┘    └─────────────────┘
```

---

## 📋 Prerequisites

- **Linux** server (Ubuntu/Debian recommended)
- **Git** installed and configured
- **curl** for Telegram API calls
- **cron** for scheduled execution
- A **Telegram Bot** (free to create)

---

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/mmsal512/daily-commit-reminder.git
cd daily-commit-reminder
```

### 2. Make Scripts Executable

```bash
chmod +x daily-commit-reminder.sh setup.sh uninstall.sh
```

### 3. Run Setup

```bash
./setup.sh
```

The setup script will guide you through:
- 📱 Telegram Bot configuration
- 📂 Repository path selection
- ⏰ Cron job installation
- 🧪 Test notification

---

## ⚙️ Configuration

### Environment Variables

| Variable | Description | Default |
| :--- | :--- | :--- |
| `TELEGRAM_TOKEN` | Your Telegram Bot API Token | _(required)_ |
| `TELEGRAM_CHAT_ID` | Your Telegram Chat ID | _(required)_ |
| `REPO_DIR` | Path to monitored repository | `~/devops-learning-journal` |
| `ENABLE_TELEGRAM` | Enable/disable Telegram notifications | `true` |
| `ENABLE_TERMINAL` | Enable/disable terminal output | `true` |
| `LOG_DIR` | Log file directory | `/var/log` |

### Configuration File

After setup, your config is stored at:
```bash
~/.daily-commit-reminder.env
```

Edit it anytime:
```bash
nano ~/.daily-commit-reminder.env
```

---

## 📱 Telegram Bot Setup

<details>
<summary>📖 Step-by-Step Guide (Click to expand)</summary>

### Step 1: Create a Bot

1. Open Telegram and search for **@BotFather**
2. Send `/newbot`
3. Choose a name: `Daily Commit Reminder`
4. Choose a username: `your_commit_reminder_bot`
5. **Copy the API token** provided

### Step 2: Get Your Chat ID

1. Start a chat with your new bot (send any message)
2. Open this URL in your browser (replace `<TOKEN>`):
   ```
   https://api.telegram.org/bot<TOKEN>/getUpdates
   ```
3. Find `"chat":{"id":` in the response — that's your Chat ID

### Step 3: Configure

```bash
export TELEGRAM_TOKEN="your_bot_token_here"
export TELEGRAM_CHAT_ID="your_chat_id_here"
```

### Step 4: Test

```bash
./daily-commit-reminder.sh --test
```

</details>

---

## 📖 Usage

### Check Current Status
```bash
./daily-commit-reminder.sh --status
```

**Output:**
```
📊 Repository Status:
  📂 Path: /home/user/devops-learning-journal
  📝 Last commit: 2026-03-10 - Update daily log
  📅 Today's commits: 2
  🔥 Current streak: 15 days
```

### Run Manual Check
```bash
source ~/.daily-commit-reminder.env
./daily-commit-reminder.sh
```

### Send Test Notification
```bash
./daily-commit-reminder.sh --test
```

### View Help
```bash
./daily-commit-reminder.sh --help
```

---

## ⏰ Cron Schedule

The script runs **3 times daily** with increasing urgency:

| Time | Urgency | Emoji | Description |
| :--- | :--- | :--- | :--- |
| **10:00 AM** | Normal | ⏰ | Morning reminder — start your day |
| **04:00 PM** | Important | ⚠️ | Afternoon check — time is running |
| **09:00 PM** | Urgent | 🚨 | Evening alert — last chance today! |

### Manual Cron Setup

If you skipped cron during setup:
```bash
crontab -e
```

Add these lines:
```cron
# Daily Commit Reminder
0 10 * * * source ~/.daily-commit-reminder.env && ~/.local/bin/daily-commit-reminder.sh
0 16 * * * source ~/.daily-commit-reminder.env && ~/.local/bin/daily-commit-reminder.sh
0 21 * * * source ~/.daily-commit-reminder.env && ~/.local/bin/daily-commit-reminder.sh
```

---

## 🗑️ Uninstall

```bash
./uninstall.sh
```

This removes:
- ✅ Cron jobs
- ✅ Installed script
- ❓ Configuration file (asks for confirmation)

---

## 🤝 Contributing

Contributions are welcome! Feel free to:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<br>

# 🇸🇦 العربية

## 📋 جدول المحتويات

- [نظرة عامة](#-نظرة-عامة)
- [المميزات](#-المميزات)
- [الهيكل](#-الهيكل)
- [المتطلبات](#-المتطلبات)
- [البدء السريع](#-البدء-السريع)
- [الإعدادات](#-الإعدادات)
- [إعداد بوت تلجرام](#-إعداد-بوت-تلجرام)
- [الاستخدام](#-الاستخدام)
- [جدول التذكير](#-جدول-التذكير)
- [إلغاء التثبيت](#-إلغاء-التثبيت)

---

## 🔍 نظرة عامة

**سكربت التذكير اليومي** هو أداة أتمتة مبنية بـ Bash مصممة للمساعدة في الحفاظ على رسم بياني نشط للمساهمات على GitHub. يراقب السكربت مستودع Git المحدد للتحقق من الالتزامات اليومية ويرسل إشعارات ذكية عبر تلجرام كتذكيرات.

> **لماذا؟** المساهمات اليومية المستمرة تُظهر الالتزام وتبني عادات قوية. هذا السكربت يضمن أنك لن تنسى أبداً تسجيل تعلمك!

---

## ✨ المميزات

| الميزة | الوصف |
| :--- | :--- |
| 🔔 **إشعارات تلجرام** | إشعارات ذكية بمستويات إلحاح مختلفة حسب وقت اليوم |
| 🔥 **تتبع السلسلة** | يتتبع سلسلة الالتزامات المتتالية |
| ⏰ **3 تذكيرات يومية** | صباحاً (10 ص)، ظهراً (4 م)، مساءً (9 م) |
| 📊 **لوحة الحالة** | أمر سريع للتحقق من إحصائياتك الحالية |
| 🧪 **وضع الاختبار** | تحقق من إعداد تلجرام برسالة اختبارية |
| 📝 **سجل شامل** | جميع الأنشطة مسجلة لتسهيل استكشاف الأخطاء |
| 🇸🇦 **دعم اللغة العربية** | الإشعارات باللغة العربية |
| 🔧 **إعداد سهل** | سكربت إعداد تفاعلي مع توجيه مفصل |
| 🗑️ **إلغاء تثبيت نظيف** | إزالة كاملة بأمر واحد |

---

## 🏗️ الهيكل

```text
daily-commit-reminder/
├── daily-commit-reminder.sh    # سكربت التذكير الرئيسي
├── setup.sh                    # سكربت الإعداد والتثبيت التفاعلي
├── uninstall.sh                # سكربت الإزالة النظيفة
├── README.md                   # هذا الملف
└── LICENSE                     # ترخيص MIT
```

### كيف يعمل

```text
┌─────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  مهمة Cron  │────▶│  فحص سجل Git    │────▶│  هل يوجد        │
│  (3 مرات)   │     │  لليوم           │     │  التزامات؟      │
└─────────────┘     └──────────────────┘     └────────┬────────┘
                                                       │
                                              ┌────────┴────────┐
                                              │                 │
                                         ✅ نعم           ❌ لا
                                              │                 │
                                    ┌─────────▼──┐    ┌────────▼────────┐
                                    │ تسجيل فقط  │    │  إرسال تذكير   │
                                    │ (نهاية     │    │  عبر تلجرام    │
                                    │  اليوم: ✅) │    │  بمستوى إلحاح  │
                                    └────────────┘    └─────────────────┘
```

---

## 📋 المتطلبات

- خادم **Linux** (يُنصح بـ Ubuntu/Debian)
- تثبيت وتكوين **Git**
- **curl** لاستدعاءات Telegram API
- **cron** للتنفيذ المجدول
- **بوت تلجرام** (مجاني الإنشاء)

---

## 🚀 البدء السريع

### 1. استنساخ المستودع

```bash
git clone https://github.com/mmsal512/daily-commit-reminder.git
cd daily-commit-reminder
```

### 2. جعل السكربتات قابلة للتنفيذ

```bash
chmod +x daily-commit-reminder.sh setup.sh uninstall.sh
```

### 3. تشغيل الإعداد

```bash
./setup.sh
```

سيرشدك سكربت الإعداد خلال:
- 📱 إعداد بوت تلجرام
- 📂 اختيار مسار المستودع
- ⏰ تثبيت مهام Cron
- 🧪 إرسال إشعار تجريبي

---

## ⚙️ الإعدادات

### المتغيرات البيئية

| المتغير | الوصف | القيمة الافتراضية |
| :--- | :--- | :--- |
| `TELEGRAM_TOKEN` | رمز API لبوت تلجرام | _(مطلوب)_ |
| `TELEGRAM_CHAT_ID` | معرف محادثة تلجرام | _(مطلوب)_ |
| `REPO_DIR` | مسار المستودع المُراقب | `~/devops-learning-journal` |
| `ENABLE_TELEGRAM` | تفعيل/تعطيل إشعارات تلجرام | `true` |
| `ENABLE_TERMINAL` | تفعيل/تعطيل مخرجات الطرفية | `true` |
| `LOG_DIR` | مجلد ملفات السجل | `/var/log` |

### ملف الإعدادات

بعد الإعداد، يتم حفظ إعداداتك في:
```bash
~/.daily-commit-reminder.env
```

يمكنك تعديله في أي وقت:
```bash
nano ~/.daily-commit-reminder.env
```

---

## 📱 إعداد بوت تلجرام

<details>
<summary>📖 دليل خطوة بخطوة (اضغط للتوسيع)</summary>

### الخطوة 1: إنشاء بوت

1. افتح تلجرام وابحث عن **@BotFather**
2. أرسل `/newbot`
3. اختر اسماً: `Daily Commit Reminder`
4. اختر معرفاً: `your_commit_reminder_bot`
5. **انسخ رمز API** المُقدم

### الخطوة 2: الحصول على معرف المحادثة

1. ابدأ محادثة مع بوتك الجديد (أرسل أي رسالة)
2. افتح هذا الرابط في متصفحك (استبدل `<TOKEN>`):
   ```
   https://api.telegram.org/bot<TOKEN>/getUpdates
   ```
3. ابحث عن `"chat":{"id":` في الاستجابة — هذا هو معرف المحادثة

### الخطوة 3: التكوين

```bash
export TELEGRAM_TOKEN="رمز_البوت_هنا"
export TELEGRAM_CHAT_ID="معرف_المحادثة_هنا"
```

### الخطوة 4: الاختبار

```bash
./daily-commit-reminder.sh --test
```

</details>

---

## 📖 الاستخدام

### التحقق من الحالة الحالية
```bash
./daily-commit-reminder.sh --status
```

**المخرجات:**
```
📊 حالة المستودع:
  📂 المسار: /home/user/devops-learning-journal
  📝 آخر التزام: 2026-03-10 - تحديث السجل اليومي
  📅 التزامات اليوم: 2
  🔥 السلسلة الحالية: 15 يوم
```

### تشغيل فحص يدوي
```bash
source ~/.daily-commit-reminder.env
./daily-commit-reminder.sh
```

### إرسال إشعار تجريبي
```bash
./daily-commit-reminder.sh --test
```

### عرض المساعدة
```bash
./daily-commit-reminder.sh --help
```

---

## ⏰ جدول التذكير

يعمل السكربت **3 مرات يومياً** بمستويات إلحاح متصاعدة:

| الوقت | الإلحاح | الرمز | الوصف |
| :--- | :--- | :--- | :--- |
| **10:00 ص** | عادي | ⏰ | تذكير صباحي — ابدأ يومك |
| **04:00 م** | مهم | ⚠️ | فحص بعد الظهر — الوقت يمر |
| **09:00 م** | عاجل | 🚨 | تنبيه مسائي — فرصتك الأخيرة اليوم! |

### إعداد Cron يدوياً

إذا تخطيت إعداد cron أثناء التثبيت:
```bash
crontab -e
```

أضف هذه السطور:
```cron
# تذكير يومي بالالتزامات
0 10 * * * source ~/.daily-commit-reminder.env && ~/.local/bin/daily-commit-reminder.sh
0 16 * * * source ~/.daily-commit-reminder.env && ~/.local/bin/daily-commit-reminder.sh
0 21 * * * source ~/.daily-commit-reminder.env && ~/.local/bin/daily-commit-reminder.sh
```

---

## 🗑️ إلغاء التثبيت

```bash
./uninstall.sh
```

يتم إزالة:
- ✅ مهام Cron
- ✅ السكربت المُثبّت
- ❓ ملف الإعدادات (يطلب تأكيد)

---

<div align="center">

**صُنع بـ ❤️ بواسطة [محمد العفاري](https://github.com/mmsal512)**

*حافظ على رسمك البياني أخضر في GitHub! 🟩*

</div>
