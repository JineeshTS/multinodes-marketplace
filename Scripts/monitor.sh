#!/bin/bash
echo "📊 Multinodes Marketplace Monitor"
echo "==============================="
echo -e "\n🔍 Service Status:"
systemctl is-active --quiet nginx && echo "✅ Nginx: Running" || echo "❌ Nginx: Stopped"
pm2 list | grep -q "multinodes-marketplace" && echo "✅ Node.js: Running" || echo "❌ Node.js: Stopped"
echo -e "\n💾 Disk Usage:"; df -h / | grep -v Filesystem
echo -e "\n🧠 Memory Usage:"; free -h | grep Mem
echo -e "\n🚨 Recent Errors (last 10):"
pm2 logs multinodes-marketplace --err --lines 10 --nostream
echo -e "\n🏥 API Health:"
curl -s http://localhost:3001/api/health
echo -e "\n==============================="