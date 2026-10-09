const { Client, GatewayIntentBits } = require('discord.js');

// Khởi tạo bot với quyền truy cập Guild và Thành viên
const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMembers // Bắt buộc để bot đếm được số lượng Member và Bot trong server
    ]
});

-- Lấy token từ biến môi trường (Render hoặc file .env)
const TOKEN = process.env.DISCORD_TOKEN_INFO;
const GUILD_ID = process.env.DISCORD_GUILD_ID;

client.once('ready', async () => {
    console.log(`[Info Bot] Đã đăng nhập thành công với tên: ${client.user.tag}`);

    if (!GUILD_ID) {
        console.log("⚠️ Cảnh báo: Chưa cấu hình DISCORD_GUILD_ID trong biến môi trường!");
        return;
    }

    // Chạy vòng lặp tự động cập nhật thống kê mỗi 30 giây
    setInterval(updateStatsChannels, 30000);
    // Chạy ngay lần đầu tiên khi bot vừa khởi động
    updateStatsChannels();
});

async function updateStatsChannels() {
    try {
        const guild = await client.guilds.fetch(GUILD_ID);
        if (!guild) {
            console.log("[Info Bot] Không tìm thấy Server Discord với ID đã cung cấp!");
            return;
        }

        // Lấy toàn bộ thành viên trong server (cần bật Server Members Intent trên Discord Developer Portal)
        const members = await guild.members.fetch();
        const botCount = members.filter(m => m.user.bot).size;
        const memberCount = members.size - botCount;

        const botChannelName = `🤖│Bot: ${botCount}`;
        const memberChannelName = `👤│Member: ${memberCount}`;

        // Tìm 2 kênh voice đã có sẵn trong server dựa theo tên bắt đầu
        let botChan = guild.channels.cache.find(c => c.name.startsWith("🤖│Bot:") && c.type === 2);
        let memberChan = guild.channels.cache.find(c => c.name.startsWith("👤│Member:") && c.type === 2);

        // 1. Xử lý kênh Bot
        if (!botChan) {
            botChan = await guild.channels.create({
                name: botChannelName,
                type: 2, // Voice Channel
                permissionOverwrites: [
                    {
                        id: guild.id,
                        deny: ['Connect', 'Speak'], // Khóa không cho ai vào hay nói
                    }
                ]
            });
            console.log("[Info Bot] Đã tạo mới kênh Voice Bot.");
        } else if (botChan.name !== botChannelName) {
            await botChan.setName(botChannelName);
        }

        // 2. Xử lý kênh Member
        if (!memberChan) {
            memberChan = await guild.channels.create({
                name: memberChannelName,
                type: 2, // Voice Channel
                permissionOverwrites: [
                    {
                        id: guild.id,
                        deny: ['Connect', 'Speak'], // Khóa không cho ai vào hay nói
                    }
                ]
            });
            console.log("[Info Bot] Đã tạo mới kênh Voice Member.");
        } else if (memberChan.name !== memberChannelName) {
            await memberChan.setName(memberChannelName);
        }

        console.log(`[Info Bot] Đã cập nhật thành công -> Bot: ${botCount} | Member: ${memberCount}`);
    } catch (error) {
        console.error("[Info Bot] Lỗi cập nhật kênh thống kê:", error);
    }
}

// Đăng nhập bot bằng Token riêng của file info
client.login(TOKEN);
