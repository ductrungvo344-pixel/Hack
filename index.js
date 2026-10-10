const { Client, GatewayIntentBits, EmbedBuilder } = require('discord.js');
const axios = require('axios');
const http = require('http');

// Lưu tạm thời danh sách log tin nhắn (giữ tối đa 20 tin nhắn gần nhất)
let messageLogs = [];

// 1. Tạo cổng HTTP vừa làm Health Check, vừa làm API cho Roblox đọc log và chống lỗi cron-job
const PORT = process.env.PORT || 3000;
const server = http.createServer((req, res) => {
    // Endpoint /ping siêu gọn để né lỗi "output too large" từ các web auto-ping
    if (req.url === '/ping') {
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('OK');
        return;
    }

    // Xử lý endpoint API để script Roblox gọi vào lấy log: /api/logs
    if (req.url === '/api/logs') {
        res.writeHead(200, { 
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*' // Cho phép Roblox gọi qua HTTP request
        });
        res.end(JSON.stringify(messageLogs));
        return;
    }

    // Health check mặc định của Render
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('Bot Discord dang chay ngon lanh!\n');
});

server.listen(PORT, () => {
    console.log(`🌐 Cổng HTTP và API Log đang chạy trên port ${PORT}`);
});

// 2. Khởi động Bot Discord
const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent
    ]
});

const TOKEN = process.env.DISCORD_TOKEN ? process.env.DISCORD_TOKEN.trim() : '';
const TARGET_CHANNEL_ID = process.env.CHANNEL_ID ? process.env.CHANNEL_ID.trim() : '';

client.once('ready', () => {
    console.log(`🤖 Bot Discord đã sẵn sàng! Đăng nhập với tên: ${client.user.tag}`);
});

// Hàm tìm kiếm script ScriptBlox
async function fetchScriptBlox(gameName) {
    try {
        const response = await axios.get(`https://scriptblox.com/api/script/search?q=${encodeURIComponent(gameName)}&mode=free&max=3`);
        if (response.data && response.data.result && response.data.result.scripts) {
            return response.data.result.scripts.map(s => ({
                source: 'ScriptBlox',
                title: s.title || 'No Title',
                game: s.game?.name || 'Unknown Game',
                verified: s.verified ? '✅' : '❌',
                key: s.isKeySystem ? '🔑 Có Key' : '🔓 Không Key',
                url: `https://scriptblox.com/script/${s.slug}`
            }));
        }
    } catch (error) { console.error('Lỗi ScriptBlox:', error.message); }
    return [];
}

// Hàm tìm kiếm script Rscripts
async function fetchRscripts(gameName) {
    try {
        const response = await axios.get(`https://rscripts.net/api/scripts?q=${encodeURIComponent(gameName)}`);
        if (response.data && response.data.scripts) {
            return response.data.scripts.slice(0, 3).map(s => ({
                source: 'Rscripts.net',
                title: s.title || 'No Title',
                game: s.game || 'Unknown Game',
                verified: s.verified ? '✅' : '❌',
                key: s.key ? '🔑 Có Key' : '🔑 Có Key',
                url: `https://rscripts.net/script/${s.slug}`
            }));
        }
    } catch (error) { console.error('Lỗi Rscripts:', error.message); }
    return [];
}

client.on('messageCreate', async message => {
    if (message.author.bot && !message.webhookId) return;

    // Nếu tin nhắn gửi đến từ tính năng Nhắn tin từ xa (hoặc đúng nội dung webhook)
    if (message.content.includes('[Nhắn Tin Từ Xa]')) {
        // Lưu vào mảng log trung gian để cung cấp cho Roblox API
        messageLogs.push({
            content: message.content,
            timestamp: Date.now()
        });
        if (messageLogs.length > 20) messageLogs.shift(); // Giữ lại 20 tin nhắn mới nhất
    }

    // Logic xử lý bot tìm kiếm script cũ
    const isCorrectChannel = TARGET_CHANNEL_ID === "" || message.channel.id === TARGET_CHANNEL_ID;
    const isSearchCommand = message.content.startsWith('!search');

    if (!isCorrectChannel && !isSearchCommand) return;

    if (isSearchCommand || message.content.includes('[ScriptBlox Bot Trigger]')) {
        let query = "";
        if (isSearchCommand) {
            query = message.content.replace('!search', '').trim();
        } else {
            const lines = message.content.split('\n');
            for (let line of lines) {
                if (line.includes('Game Name:')) {
                    const parts = line.split('`');
                    if (parts.length >= 2) query = parts[1].trim();
                }
            }
        }

        if (!query) return;

        await message.channel.send(`🔍 Đang quét script từ **ScriptBlox** và **Rscripts.net** cho từ khóa: \`${query}\`...`);
        const [sbRes, rsRes] = await Promise.all([fetchScriptBlox(query), fetchRscripts(query)]);
        const allScripts = [...sbRes, ...rsRes];

        if (allScripts.length === 0) return message.channel.send(`❌ Không tìm thấy script cho: \`${query}\``);

        const embed = new EmbedBuilder()
            .setTitle(`📜 Kết quả tìm kiếm Script: ${query}`)
            .setColor(0x00FF99)
            .setTimestamp();

        allScripts.forEach((s, index) => {
            embed.addFields({
                name: `${index + 1}. [${s.source}] ${s.title}`,
                value: `🗺️ Game: **${s.game}**\n🛡️ Verified: ${s.verified} | 🔑 Key: ${s.key}\n🔗 [Xem Script](${s.url})`,
                inline: false
            });
        });

        await message.channel.send({ embeds: [embed] });
    }
});

client.login(TOKEN);
