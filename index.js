const { Client, GatewayIntentBits, EmbedBuilder } = require('discord.js');
const axios = require('axios');
const http = require('http');

// 1. Tạo cổng ảo HTTP cho Render
const PORT = process.env.PORT || 3000;
http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('Bot Discord dang chay ngon lanh!\n');
}).listen(PORT, () => {
    console.log(`🌐 Cổng ảo HTTP đang chạy trên port ${PORT}`);
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
    console.log(`🎯 Kênh đang giám sát CHANNEL_ID: ${TARGET_CHANNEL_ID || 'Chưa bật (Nhận mọi kênh)'}`);
});

// 3. Hàm tìm kiếm script từ ScriptBlox API
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
    } catch (error) {
        console.error('Lỗi khi fetch ScriptBlox:', error.message);
    }
    return [];
}

// 4. Hàm tìm kiếm script từ Rscripts.net API
async function fetchRscripts(gameName) {
    try {
        const response = await axios.get(`https://rscripts.net/api/scripts?q=${encodeURIComponent(gameName)}`);
        if (response.data && response.data.scripts) {
            return response.data.scripts.slice(0, 3).map(s => ({
                source: 'Rscripts.net',
                title: s.title || 'No Title',
                game: s.game || 'Unknown Game',
                verified: s.verified ? '✅' : '❌',
                key: s.key ? '🔑 Có Key' : '🔓 Không Key',
                url: `https://rscripts.net/script/${s.slug}`
            }));
        }
    } catch (error) {
        console.error('Lỗi khi fetch Rscripts:', error.message);
    }
    return [];
}

client.on('messageCreate', async message => {
    // In log kiểm tra mọi tin nhắn bot nhìn thấy trên kênh
    console.log(`[NHẬN TIN] Kênh: ${message.channel.id} | Tác giả: ${message.author.tag} | WebhookID: ${message.webhookId || 'Không'}`);
    console.log(`[NỘI DUNG]: ${message.content}`);

    // Cho phép đọc tin nhắn từ Webhook (Roblox gửi lên) hoặc lệnh !search
    if (message.author.bot && !message.webhookId) return;

    // Kiểm tra kênh
    const isCorrectChannel = TARGET_CHANNEL_ID === "" || message.channel.id === TARGET_CHANNEL_ID;
    const isSearchCommand = message.content.startsWith('!search');

    if (!isCorrectChannel && !isSearchCommand) {
        console.log(`[BỎ QUA] Tin nhắn không đúng kênh cấu hình.`);
        return;
    }

    if (isSearchCommand || message.content.includes('[ScriptBlox Bot Trigger]')) {
        let query = "";
        
        if (isSearchCommand) {
            query = message.content.replace('!search', '').trim();
        } else if (message.content.includes('[ScriptBlox Bot Trigger]')) {
            // Tách dòng an toàn để lấy tên game nằm trong cặp dấu `...`
            const lines = message.content.split('\n');
            for (let line of lines) {
                if (line.includes('Game Name:')) {
                    const parts = line.split('`');
                    if (parts.length >= 2) {
                        query = parts[1].trim();
                    }
                }
            }
        }

        if (!query) {
            console.log("[LỖI] Không thể trích xuất được tên game từ nội dung tin nhắn!");
            return;
        }

        console.log(`[ĐANG TÌM KIẾM] Từ khóa game: ${query}`);
        await message.channel.send(`🔍 Đang quét script từ **ScriptBlox** và **Rscripts.net** cho từ khóa: \`${query}\`...`);

        const [scriptBloxResults, rscriptsResults] = await Promise.all([
            fetchScriptBlox(query),
            fetchRscripts(query)
        ]);

        const allScripts = [...scriptBloxResults, ...rscriptsResults];

        if (allScripts.length === 0) {
            return message.channel.send(`❌ Không tìm thấy script nào cho game: \`${query}\``);
        }

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
        console.log(`[THÀNH CÔNG] Đã gửi kết quả tìm kiếm lên Discord!`);
    }
});

client.login(TOKEN);
