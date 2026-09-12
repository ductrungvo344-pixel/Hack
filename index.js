const { Client, GatewayIntentBits, REST, Routes, SlashCommandBuilder } = require('discord.js');
const axios = require('axios');

// Khởi tạo Client cho Bot
const client = new Client({ intents: [GatewayIntentBits.Guilds] });

// --- CẤU HÌNH AN TOÀN QUA BIẾN MÔI TRƯỜNG ---
const TOKEN = process.env.DISCORD_TOKEN;
const CLIENT_ID = process.env.CLIENT_ID;
const JSONBIN_BIN_ID = "6aa55a28ac6210605ac4b26e";
const JSONBIN_API_KEY = "$2a$10$adrN3wpxWwuHIHdAvesvRek4PCzGcV1Y8bpU2Ptv15ZP9c5MMpgRC";

// Đăng ký lệnh Slash Command /getkey
const commands = [
    new SlashCommandBuilder()
        .setName('getkey')
        .setDescription('Nhận Key sử dụng Script 24 giờ')
].map(command => command.toJSON());

const rest = new REST({ version: '10' }).setToken(TOKEN);

// Sự kiện khi Bot khởi động để đăng ký lệnh
client.once('ready', async () => {
    console.log(`🤖 Bot đã đăng nhập thành công với tên: ${client.user.tag}`);
    try {
        await rest.put(Routes.applicationCommands(CLIENT_ID), { body: commands });
        console.log('✅ Đã đăng ký lệnh /getkey thành công lên Discord!');
    } catch (error) {
        console.error(error);
    }
});

// Hàm tạo Key ngẫu nhiên
function generateKey() {
    return 'KEY-' + Math.random().toString(36).substring(2, 10).toUpperCase();
}

// Xử lý khi người dùng gõ lệnh /getkey
client.on('interactionCreate', async interaction => {
    if (!interaction.isChatInputCommand()) return;

    if (interaction.commandName === 'getkey') {
        await interaction.deferReply({ ephemeral: true });

        try {
            // 1. Tải danh sách Key hiện tại từ JSONBin
            const getRes = await axios.get(`https://api.jsonbin.io/v3/b/${JSONBIN_BIN_ID}/latest`, {
                headers: { 'X-Master-Key': JSONBIN_API_KEY }
            });
            
            let keyList = getRes.data.record || [];
            const userId = interaction.user.id;
            const now = Date.now();
            
            // 2. Kiểm tra xem User đã có Key 24h còn hạn chưa
            let existingKey = keyList.find(k => k.discordId === userId && k.expireAt > now);

            if (existingKey) {
                return interaction.editReply(`🔑 Key của bạn vẫn còn hiệu lực 24h:\n\`${existingKey.key}\``);
            }

            // 3. Tạo Key 24h mới
            const newKey = generateKey();
            const expireAt = now + (24 * 60 * 60 * 1000); // 24 giờ

            keyList.push({
                key: newKey,
                discordId: userId,
                expireAt: expireAt
            });

            // 4. Lưu lại danh sách Key mới vào JSONBin
            await axios.put(`https://api.jsonbin.io/v3/b/${JSONBIN_BIN_ID}`, keyList, {
                headers: {
                    'Content-Type': 'application/json',
                    'X-Master-Key': JSONBIN_API_KEY
                }
            });

            interaction.editReply(`✅ **Tạo Key thành công!**\n🔑 Key của bạn: \`${newKey}\`\n⏳ Thời hạn: **24 Giờ**`);
        } catch (err) {
            console.error(err);
            interaction.editReply('❌ Đã xảy ra lỗi kết nối Database JSONBin!');
        }
    }
});

// Khởi chạy Bot bằng biến môi trường bảo mật
client.login(TOKEN);
