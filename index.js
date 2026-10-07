const { Client, GatewayIntentBits, ActionRowBuilder, ButtonBuilder, ButtonStyle } = require('discord.js');
const axios = require('axios');
const http = require('http'); // Thêm thư viện http để tạo cổng ảo

const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent
    ]
});

const LOG_CHANNEL_ID = process.env.CHANNEL_ID;

client.once('ready', () => {
    console.log(`🤖 Bot đã khởi động thành công với tên: ${client.user.tag}`);
    if (!LOG_CHANNEL_ID) {
        console.warn("⚠️ Cảnh báo: Chưa cấu hình biến môi trường CHANNEL_ID trên Render!");
    }
});

client.on('messageCreate', async (message) => {
    if (LOG_CHANNEL_ID && message.channel.id === LOG_CHANNEL_ID && message.content.includes('🆔 **PlaceId:**')) {
        try {
            const match = message.content.match(/🆔 \*\*PlaceId:\*\* `(\d+)`|🆔 \*\*PlaceId:\*\* (\d+)/);
            if (!match) return;
            
            const placeId = match[1] || match[2];
            console.log(`[ScriptBlox Bot] Đã nhận PlaceId từ log: ${placeId}`);

            const response = await axios.get(`https://scriptblox.com/api/script/search?q=${placeId}`);
            const data = response.data;
            
            if (data && data.result && data.result.scripts && data.result.scripts.length > 0) {
                const scripts = data.result.scripts.slice(0, 5);
                const row = new ActionRowBuilder();
                
                scripts.forEach((script, index) => {
                    let title = script.title || `Script ${index + 1}`;
                    if (title.length > 80) title = title.substring(0, 77) + '...';
                    
                    const scriptUrl = `https://scriptblox.com/script/${script._id}`;
                    
                    row.addComponents(
                        new ButtonBuilder()
                            .setLabel(title)
                            .setStyle(ButtonStyle.Link)
                            .setURL(scriptUrl)
                    );
                });

                await message.channel.send({
                    content: `🔍 Tìm thấy **${data.result.scripts.length}** script cho PlaceId \`${placeId}\` trên ScriptBlox:`,
                    components: [row]
                });
            } else {
                await message.channel.send(`❌ Không tìm thấy script nào cho PlaceId \`${placeId}\` trên ScriptBlox.`);
            }

        } catch (error) {
            console.error('Lỗi khi gọi API ScriptBlox:', error);
            await message.channel.send(`⚠️ Đã xảy ra lỗi khi kết nối tới API ScriptBlox.`);
        }
    }
});

// --- TẠO MỘT WEB SERVER NHỎ ĐỂ MỞ CỔNG ẢO CHO RENDER ---
const PORT = process.env.PORT || 10000;
http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('Bot ScriptBlox is running!');
}).listen(PORT, '0.0.0.0', () => {
    console.log(`🌐 Cổng ảo đang chạy thành công trên cổng: ${PORT}`);
});

// Đăng nhập bot
client.login(process.env.DISCORD_TOKEN);
