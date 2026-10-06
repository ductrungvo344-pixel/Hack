const { Client, GatewayIntentBits, ActionRowBuilder, ButtonBuilder, ButtonStyle } = require('discord.js');
const express = require('express');

const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent
    ]
});

const app = express();
app.use(express.json());

const TOKEN = process.env.DISCORD_TOKEN;
const CHANNEL_ID = process.env.CHANNEL_ID;
const PORT = process.env.PORT || 10000;

client.once('ready', () => {
    console.log(`🤖 Bot đã sẵn sàng với tên: ${client.user.tag}`);
});

// Thêm trang chủ để UptimeRobot truy cập không bị lỗi 404 Not Found
app.get('/', (req, res) => {
    res.status(200).send('Roblox Discord Bot is alive and running!');
});

// Endpoint nhận dữ liệu từ script Roblox
app.post('/send-game-log', async (req, res) => {
    try {
        const { gameName, placeId, universeId, scriptBloxUrl } = req.body;
        const channel = await client.channels.fetch(CHANNEL_ID);
        
        if (!channel) {
            return res.status(404).send({ error: "Không tìm thấy kênh Discord!" });
        }

        const row = new ActionRowBuilder()
            .addComponents(
                new ButtonBuilder()
                    .setLabel('🔍 Tìm Script trên ScriptBlox')
                    .setStyle(ButtonStyle.Link)
                    .setURL(scriptBloxUrl)
            );

        await channel.send({
            content: `🕹️ **[ROBLOX BOT - TP-LOG-2]**\n📌 **Tên Game:** \`${gameName}\`\n🆔 **Game ID:** \`${placeId}\`\n🌐 **Universe ID:** \`${universeId}\``,
            components: [row]
        });

        res.status(200).send({ success: true, message: "Đã gửi log thành công!" });
    } catch (error) {
        console.error(error);
        res.status(500).send({ error: error.message });
    }
});

app.listen(PORT, () => {
    console.log(`🌐 Server đang chạy trên cổng ${PORT}`);
});

client.login(TOKEN);
