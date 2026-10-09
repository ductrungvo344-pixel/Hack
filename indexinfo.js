const { Client, GatewayIntentBits } = require('discord.js');
const http = require('http');

// 1. Tạo cổng HTTP để Render làm Health Check (Tránh lỗi timeout service)
const PORT = process.env.PORT || 3000;
http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('Info Bot Discord dang chay ngon lanh!\n');
}).listen(PORT, () => {
    console.log(`🌐 Cổng HTTP Health Check đang chạy trên port ${PORT}`);
});

// 2. Khởi động Bot Discord Info
const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMembers // Bắt buộc để đếm số lượng member và bot
    ]
});

const TOKEN = process.env.DISCORD_TOKEN_INFO;
const GUILD_ID = process.env.DISCORD_GUILD_ID;

client.once('ready', async () => {
    console.log(`[Info Bot] Đã đăng nhập thành công: ${client.user.tag}`);

    if (!GUILD_ID) {
        console.log("⚠️ Chưa cấu hình DISCORD_GUILD_ID trong biến môi trường!");
        return;
    }

    // Cập nhật thống kê định kỳ mỗi 30 giây
    setInterval(updateStatsChannels, 30000);
    updateStatsChannels();
});

async function updateStatsChannels() {
    try {
        const guild = await client.guilds.fetch(GUILD_ID);
        if (!guild) return;

        const members = await guild.members.fetch();
        const botCount = members.filter(m => m.user.bot).size;
        const memberCount = members.size - botCount;

        const botChannelName = `🤖│Bot: ${botCount}`;
        const memberChannelName = `👤│Member: ${memberCount}`;

        let botChan = guild.channels.cache.find(c => c.name.startsWith("🤖│Bot:") && c.type === 2);
        let memberChan = guild.channels.cache.find(c => c.name.startsWith("👤│Member:") && c.type === 2);

        // Tạo hoặc đổi tên kênh Bot
        if (!botChan) {
            botChan = await guild.channels.create({
                name: botChannelName,
                type: 2,
                permissionOverwrites: [{ id: guild.id, deny: ['Connect', 'Speak'] }]
            });
        } else if (botChan.name !== botChannelName) {
            await botChan.setName(botChannelName);
        }

        // Tạo hoặc đổi tên kênh Member
        if (!memberChan) {
            memberChan = await guild.channels.create({
                name: memberChannelName,
                type: 2,
                permissionOverwrites: [{ id: guild.id, deny: ['Connect', 'Speak'] }]
            });
        } else if (memberChan.name !== memberChannelName) {
            await memberChan.setName(memberChannelName);
        }

        console.log(`[Info Bot] Đã cập nhật -> Bot: ${botCount} | Member: ${memberCount}`);
    } catch (error) {
        console.error("[Info Bot] Lỗi cập nhật kênh:", error);
    }
}

client.login(TOKEN);
