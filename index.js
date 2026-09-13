const { REST, Routes, SlashCommandBuilder, Client, GatewayIntentBits } = require('discord.js');
const axios = require('axios');
const http = require('http');

// ==========================================
// CẤU HÌNH THÔNG TIN JSONBIN VÀ OWNER ID
// ==========================================
const JSONBIN_BIN_ID = "6aa55a28ac6210605ac4b26e";
const JSONBIN_API_KEY = "$2a$10$adrN3wpxWwuHIHdAvesvRek4PCzGcV1Y8bpU2Ptv15ZP9c5MMpgRC";
const OWNER_ID = "1543895645365080104"; // ID Discord của bạn

// Lấy Token, Client ID và Port từ biến môi trường của Render
const TOKEN = process.env.DISCORD_TOKEN;
const CLIENT_ID = process.env.CLIENT_ID;
const PORT = process.env.PORT || 3000;

// ==========================================
// TẠO CỔNG ẢO HTTP SERVER CHO RENDER
// ==========================================
http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('Bot Discord Key System is running online!\n');
}).listen(PORT, () => {
    console.log(`🌐 Cổng ảo đang lắng nghe trên cổng: ${PORT}`);
});

// ==========================================
// CÁC HÀM XỬ LÝ DỮ LIỆU KEY (JSONBIN API)
// ==========================================
async function getKeys() {
    try {
        let res = await axios.get(`https://api.jsonbin.io/v3/b/${JSONBIN_BIN_ID}/latest`, {
            headers: { "X-Master-Key": JSONBIN_API_KEY }
        });
        return res.data.record || [];
    } catch (e) {
        return [];
    }
}

async function saveKeys(keys) {
    try {
        await axios.put(`https://api.jsonbin.io/v3/b/${JSONBIN_BIN_ID}`, { record: keys }, {
            headers: { 
                "X-Master-Key": JSONBIN_API_KEY,
                "Content-Type": "application/json"
            }
        });
        return true;
    } catch (e) {
        return false;
    }
}

// 1. Lệnh /getkey (Ai cũng dùng được - Key hạn 24 giờ)
async function handleGetKeyCommand(quantity) {
    let keys = await getKeys();
    let newKeysList = [];
    let currentTime = Date.now();
    let expireTime = currentTime + (24 * 60 * 60 * 1000); // 24 giờ

    let amount = parseInt(quantity) || 1;

    for (let i = 0; i < amount; i++) {
        let randomKey = "KEY_" + Math.random().toString(36).substring(2, 10).toUpperCase();
        keys.push({ key: randomKey, expireAt: expireTime });
        newKeysList.push(randomKey);
    }

    let success = await saveKeys(keys);
    if (success) {
        return `✅ Đã tạo thành công ${amount} key (Hạn 24h):\n\`\`\`${newKeysList.join("\n")}\`\`\``;
    } else {
        return "❌ Lỗi khi lưu key lên hệ thống!";
    }
}

// 2. Lệnh /keyinftime (Chỉ Owner - Key vĩnh viễn hạn ~100 năm)
async function handleKeyInfTimeCommand(userId, quantity) {
    if (userId !== OWNER_ID) {
        return "⛔ Bạn không có quyền sử dụng lệnh này! Lệnh này chỉ dành riêng cho Owner.";
    }

    let keys = await getKeys();
    let newKeysList = [];
    let currentTime = Date.now();
    let expireTime = currentTime + (100 * 365 * 24 * 60 * 60 * 1000); // Vĩnh viễn

    let amount = parseInt(quantity) || 1;

    for (let i = 0; i < amount; i++) {
        let randomKey = "INFKEY_" + Math.random().toString(36).substring(2, 10).toUpperCase();
        keys.push({ key: randomKey, expireAt: expireTime });
        newKeysList.push(randomKey);
    }

    let success = await saveKeys(keys);
    if (success) {
        return `👑 [OWNER] Đã tạo thành công ${amount} key vĩnh viễn:\n\`\`\`${newKeysList.join("\n")}\`\`\``;
    } else {
        return "❌ Lỗi khi lưu key lên hệ thống!";
    }
}

// 3. Lệnh /keysuper (Chỉ Owner - Key Super đặc biệt hạn 7 ngày / tùy chỉnh)
async function handleKeySuperCommand(userId, quantity) {
    if (userId !== OWNER_ID) {
        return "⛔ Bạn không có quyền sử dụng lệnh này! Lệnh này chỉ dành riêng cho Owner.";
    }

    let keys = await getKeys();
    let newKeysList = [];
    let currentTime = Date.now();
    let expireTime = currentTime + (7 * 24 * 60 * 60 * 1000); // Hạn 7 ngày cho Super Key

    let amount = parseInt(quantity) || 1;

    for (let i = 0; i < amount; i++) {
        let randomKey = "SUPER_" + Math.random().toString(36).substring(2, 10).toUpperCase();
        keys.push({ key: randomKey, expireAt: expireTime });
        newKeysList.push(randomKey);
    }

    let success = await saveKeys(keys);
    if (success) {
        return `⚡ [SUPER KEY] Đã tạo thành công ${amount} Super Key (Hạn 7 ngày):\n\`\`\`${newKeysList.join("\n")}\`\`\``;
    } else {
        return "❌ Lỗi khi lưu key lên hệ thống!";
    }
}

// 4. Lệnh /checkkey
async function handleCheckKeyCommand(inputKey) {
    let keys = await getKeys();
    let currentTime = Date.now();
    
    let found = keys.find(k => k.key === inputKey);
    if (!found) return "❌ Key không tồn tại trên hệ thống!";

    if (found.expireAt > currentTime) {
        let diffHours = Math.floor((found.expireAt - currentTime) / 1000 / 60 / 60);
        if (diffHours > 800000) {
            return `✅ Key hợp lệ! Đây là **Key Vĩnh Viễn** (Inf Time).`;
        }
        return `✅ Key hợp lệ! Còn lại khoảng ${Math.floor(diffHours)} giờ sử dụng.`;
    } else {
        return "⚠️ Key này đã hết hạn sử dụng!";
    }
}

// 5. Lệnh /delkey (Chỉ Owner)
async function handleDeleteKeyCommand(userId, targetKey) {
    if (userId !== OWNER_ID) return "⛔ Bạn không có quyền xóa key!";

    let keys = await getKeys();
    let initialLength = keys.length;
    
    keys = keys.filter(k => k.key !== targetKey);

    if (keys.length < initialLength) {
        await saveKeys(keys);
        return `✅ Đã xóa thành công key: \`${targetKey}\``;
    } else {
        return "❌ Không tìm thấy key cần xóa!";
    }
}

// ==========================================
// ĐĂNG KÝ LỆNH SLASH COMMANDS VÀ KHỞI ĐỘNG BOT
// ==========================================
const commands = [
    new SlashCommandBuilder()
        .setName('getkey')
        .setDescription('Tạo key miễn phí (Hạn 24h)')
        .addIntegerOption(option => 
            option.setName('soluong')
                .setDescription('Số lượng key cần tạo')
                .setRequired(true)),

    new SlashCommandBuilder()
        .setName('keyinftime')
        .setDescription('Tạo key vĩnh viễn (Chỉ Owner)')
        .addIntegerOption(option => 
            option.setName('soluong')
                .setDescription('Số lượng key vĩnh viễn cần tạo')
                .setRequired(true)),

    new SlashCommandBuilder()
        .setName('keysuper')
        .setDescription('Tạo Super Key đặc biệt (Chỉ Owner)')
        .addIntegerOption(option => 
            option.setName('soluong')
                .setDescription('Số lượng super key cần tạo')
                .setRequired(true)),

    new SlashCommandBuilder()
        .setName('checkkey')
        .setDescription('Kiểm tra trạng thái của một key')
        .addStringOption(option => 
            option.setName('key')
                .setDescription('Nhập key cần kiểm tra')
                .setRequired(true)),

    new SlashCommandBuilder()
        .setName('delkey')
        .setDescription('Xóa một key khỏi hệ thống (Chỉ Owner)')
        .addStringOption(option => 
            option.setName('key')
                .setDescription('Nhập key cần xóa')
                .setRequired(true))
].map(command => command.toJSON());

const rest = new REST({ version: '10' }).setToken(TOKEN);

(async () => {
    try {
        console.log('🔄 Đang đồng bộ Slash Commands với Discord...');
        await rest.put(Routes.applicationCommands(CLIENT_ID), { body: commands });
        console.log('✨ Đăng ký lệnh thành công!');
    } catch (error) {
        console.error('Lỗi đăng ký lệnh:', error);
    }
})();

const client = new Client({ intents: [GatewayIntentBits.Guilds] });

client.once('ready', () => {
    console.log(`🚀 Bot đã sẵn sàng và hoạt động với tên: ${client.user.tag}`);
});

client.on('interactionCreate', async interaction => {
    if (!interaction.isChatInputCommand()) return;

    const { commandName } = interaction;
    const userId = interaction.user.id;

    if (commandName === 'getkey') {
        const quantity = interaction.options.getInteger('soluong');
        await interaction.deferReply({ ephemeral: true });
        let resultMessage = await handleGetKeyCommand(quantity);
        await interaction.editReply({ content: resultMessage });
    }

    else if (commandName === 'keyinftime') {
        const quantity = interaction.options.getInteger('soluong');
        await interaction.deferReply({ ephemeral: true });
        let resultMessage = await handleKeyInfTimeCommand(userId, quantity);
        await interaction.editReply({ content: resultMessage });
    }

    else if (commandName === 'keysuper') {
        const quantity = interaction.options.getInteger('soluong');
        await interaction.deferReply({ ephemeral: true });
        let resultMessage = await handleKeySuperCommand(userId, quantity);
        await interaction.editReply({ content: resultMessage });
    }

    else if (commandName === 'checkkey') {
        const inputKey = interaction.options.getString('key');
        await interaction.deferReply({ ephemeral: true });
        let resultMessage = await handleCheckKeyCommand(inputKey);
        await interaction.editReply({ content: resultMessage });
    }

    else if (commandName === 'delkey') {
        const targetKey = interaction.options.getString('key');
        await interaction.deferReply({ ephemeral: true });
        let resultMessage = await handleDeleteKeyCommand(userId, targetKey);
        await interaction.editReply({ content: resultMessage });
    }
});

client.login(TOKEN);
