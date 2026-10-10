const { Client, GatewayIntentBits, EmbedBuilder } = require('discord.js');
const axios = require('axios');
const http = require('http');

// 1. Tạo cổng HTTP gọn nhẹ cho Render Health Check và cron-job ping chống ngủ đông
const PORT = process.env.PORT || 3000;
const server = http.createServer((req, res) => {
    if (req.url === '/ping' || req.url === '/') {
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('OK');
        return;
    }

    res.writeHead(404, { 'Content-Type': 'text/plain' });
    res.end('Not Found');
});

server.listen(PORT, () => {
    console.log(`🌐 Cổng HTTP Health Check đang chạy trên port ${PORT}`);
});

// 2. Khởi động Bot Discord tìm kiếm script
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

// Hàm tìm kiếm script từ ScriptBlox
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

// Hàm tìm kiếm script từ Rscripts
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
    // CHỈ BỎ QUA Bot thường, CHO PHÉP tin nhắn từ Webhook đi qua
    if (message.author.bot && !message.webhookId) return;

    const isCorrectChannel = TARGET_CHANNEL_ID === "" || message.channel.id === TARGET_CHANNEL_ID;
    const isSearchCommand = message.content.startsWith('!search');

    if (!isCorrectChannel && !isSearchCommand) return;

    if (isSearchCommand || message.content.includes('[ScriptBlox Bot Trigger]')) {
        let originalQuery = "";
        let englishQuery = "";

        if (isSearchCommand) {
            originalQuery = message.content.replace('!search', '').trim();
            englishQuery = originalQuery;
        } else {
            const lines = message.content.split('\n');
            for (let line of lines) {
                if (line.includes('Game Name:')) {
                    const parts = line.split('`');
                    if (parts.length >= 2) originalQuery = parts[1].trim();
                }
                if (line.includes('English Query:')) {
                    const parts = line.split('`');
                    if (parts.length >= 2) englishQuery = parts[1].trim();
                }
            }
        }

        if (!originalQuery) return;
        if (!englishQuery) englishQuery = originalQuery;

        await message.channel.send(`🔍 Đang quét script cho từ khóa gốc: \`${originalQuery}\`${originalQuery !== englishQuery ? ` | Tiếng Anh: \`${englishQuery}\`` : ''}...`);

        // Gom danh sách từ khóa cần tìm kiếm
        let queriesToSearch = [originalQuery];
        if (englishQuery !== originalQuery) {
            queriesToSearch.push(englishQuery);
        }

        let allScripts = [];
        for (let q of queriesToSearch) {
            const [sbRes, rsRes] = await Promise.all([fetchScriptBlox(q), fetchRscripts(q)]);
            allScripts = [...allScripts, ...sbRes, ...rsRes];
        }

        // Loại bỏ kết quả trùng lặp theo URL
        const uniqueScripts = Array.from(new Map(allScripts.map(item => [item.url, item])).values());

        if (uniqueScripts.length === 0) return message.channel.send(`❌ Không tìm thấy script nào cho từ khóa: \`${originalQuery}\``);

        const embed = new EmbedBuilder()
            .setTitle(`📜 Kết quả tìm kiếm Script: ${originalQuery}`)
            .setColor(0x00FF99)
            .setTimestamp();

        if (originalQuery !== englishQuery) {
            embed.setDescription(`Từ khóa tiếng Anh đã thử quét: \`${englishQuery}\``);
        }

        uniqueScripts.slice(0, 6).forEach((s, index) => {
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
