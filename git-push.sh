#!/bin/bash

echo "📦 Tüm dosyalar ekleniyor..."
git add .

echo "📝 Commit mesajı girin:"
read mesaj
git commit -m "$mesaj"

echo "🚀 Github'a gönderiliyor..."
git push

echo "✅ Bitti!"
