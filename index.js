const { Client, GatewayIntentBits, EmbedBuilder } = require('discord.js');
const axios = require('axios');

const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent
    ]
});

const TOKEN = 'ĐIỀN_TOKEN_BOT_DISCORD_CỦA_CẬU'; // Thay token bot của cậu vào đây

client.once('ready', () => {
    console.log(`🤖 Bot Discord đã sẵn sàng! Đăng nhập với tên: ${client.user.tag}`);
});

// 1. Hàm tìm kiếm script từ ScriptBlox API
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

// 2. Hàm tìm kiếm script từ Rscripts.net API (MỚI THÊM)
async function fetchRscripts(gameName) {
    try {
        // Rscripts cung cấp endpoint tìm kiếm công khai
        const response = await axios.get(`https://rscripts.net/api/scripts?q=${encodeURIComponent(gameName)}`);
        if (response.data && response.data.scripts) {
            // Lấy tối đa 3 kết quả đầu tiên
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
    if (message.author.bot) return;

    // Lắng nghe tin nhắn từ kênh tp-log-2 (nơi nhận trigger từ Roblox)
    // Hoặc cậu có thể dùng lệnh chat trực tiếp trên Discord tuỳ ý
    if (message.content.startsWith('!search') || message.channel.name === 'tp-log-2') {
        // Lấy tên game từ nội dung hoặc từ payload gửi lên
        let query = message.content.replace('!search', '').trim();
        
        // Nếu bot nhận log tự động từ Roblox (định dạng như code Lua trước gửi lên)
        if (message.content.includes('[ScriptBlox Bot Trigger]')) {
            // Tách lấy tên game từ dòng `🗺️ Game Name: Tên_Game`
            const match = message.content.match(/🗺️ \*\*Game Name:\*\* `([^`]+)`/);
            if (match && match[1]) {
                query = match[1];
            }
        }

        if (!query) return;

        await message.channel.send(`🔍 Đang quét script từ **ScriptBlox** và **Rscripts.net** cho từ khóa: \`${query}\`...`);

        // Gọi đồng thời cả 2 nguồn để tối ưu tốc độ
        const [scriptBloxResults, rscriptsResults] = await Promise.all([
            fetchScriptBlox(query),
            fetchRscripts(query)
        ]);

        const allScripts = [...scriptBloxResults, ...rscriptsResults];

        if (allScripts.length === 0) {
            return message.channel.send(`❌ Không tìm thấy script nào cho game: \`${query}\``);
        }

        // Tạo Embed hiển thị kết quả đẹp mắt
        const embed = new EmbedBuilder()
            .setTitle(`📜 Kế quả tìm kiếm Script: ${query}`)
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
