const { Client, GatewayIntentBits, EmbedBuilder } = require('discord.js');
const axios = require('axios');

// 1. Khởi tạo Client với đầy đủ Intents cần thiết
const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent // BẮT BUỘC: Cho phép bot đọc nội dung tin nhắn & Webhook
    ]
});

// TOKEN BOT DISCORD (Thay bằng Token thật của bạn hoặc cấu hình qua Environment Variable)
const BOT_TOKEN = process.env.DISCORD_TOKEN || "YOUR_BOT_TOKEN_HERE";

// ID Kênh tp-log-2 (Kênh nhận Webhook từ Game)
const TARGET_CHANNEL_ID = "1556970046679547924";

// 2. Lắng nghe khi Bot khởi chạy thành công
client.once('ready', () => {
    console.log(`===========================================`);
    console.log(`✅ Bot Discord đã hoạt động: ${client.user.tag}`);
    console.log(`📡 Đang lắng nghe kênh ID: ${TARGET_CHANNEL_ID}`);
    console.log(`===========================================`);
});

// 3. Hàm tìm kiếm script từ cả 2 nguồn: ScriptBlox & Rscripts
async function searchAllScripts(gameName) {
    let combinedScripts = [];

    // --- Nguồn 1: ScriptBlox API ---
    try {
        const sbRes = await axios.get(`https://scriptblox.com/api/script/search?q=${encodeURIComponent(gameName)}&max=2`, { timeout: 5000 });
        if (sbRes.data && sbRes.data.result && sbRes.data.result.scripts) {
            sbRes.data.result.scripts.forEach(s => {
                combinedScripts.push({
                    title: s.title || "Untitled Script",
                    source: "ScriptBlox",
                    script: s.script || "N/A",
                    isPatched: s.isPatched || false
                });
            });
        }
    } catch (e) {
        console.log("⚠️ Lỗi gọi ScriptBlox API:", e.message);
    }

    // --- Nguồn 2: Rscripts API ---
    try {
        const rsRes = await axios.get(`https://rscripts.net/api/v2/scripts?q=${encodeURIComponent(gameName)}`, { timeout: 5000 });
        if (rsRes.data && rsRes.data.scripts) {
            rsRes.data.scripts.slice(0, 2).forEach(s => {
                combinedScripts.push({
                    title: s.title || "Untitled Script",
                    source: "Rscripts",
                    script: s.script || s.link || "N/A",
                    isPatched: s.verified === false ? true : false
                });
            });
        }
    } catch (e) {
        console.log("⚠️ Lỗi gọi Rscripts API:", e.message);
    }

    return combinedScripts;
}

// 4. Sự kiện khi có tin nhắn hoặc Webhook mới gửi tới
client.on('messageCreate', async (message) => {
    // Chỉ lọc tin nhắn trong đúng kênh chỉ định
    if (message.channelId !== TARGET_CHANNEL_ID) return;

    // Tránh việc Bot tự đọc tin nhắn của chính nó
    if (message.author.id === client.user.id) return;

    console.log("📩 Nhận tin nhắn/log mới trong kênh tp-log-2...");

    let gameName = "";

    // Bóc tách tên game từ dạng Embed hoặc Content
    if (message.embeds.length > 0) {
        const embed = message.embeds[0];
        const gameField = embed.fields?.find(f => f.name.includes("Game Name") || f.name.includes("Game"));
        if (gameField) {
            gameName = gameField.value.replace(/`/g, "").trim();
        } else if (embed.description) {
            const match = embed.description.match(/Game Name:\s*`?([^`\n]+)`?/i);
            if (match) gameName = match[1].trim();
        }
    } else if (message.content) {
        const match = message.content.match(/Game Name \(Gốc\):\s*`?([^`\n]+)`?/i) 
                   || message.content.match(/Game Name:\s*`?([^`\n]+)`?/i);
        if (match) {
            gameName = match[1].trim();
        } else if (message.content.startsWith("!search")) {
            gameName = message.content.replace("!search", "").trim();
        }
    }

    // Nếu không tìm thấy tên game hợp lệ thì dừng
    if (!gameName || gameName === "Unknown Game") {
        console.log("⚠️ Không phát hiện Tên Game Gốc trong log.");
        return;
    }

    console.log(`🔍 Đang quét ScriptBlox & Rscripts cho game: "${gameName}"...`);

    try {
        // Tìm kiếm đa nguồn
        const scripts = await searchAllScripts(gameName);

        if (!scripts || scripts.length === 0) {
            return message.channel.send(`❌ Không tìm thấy script nào từ **ScriptBlox** & **Rscripts** cho game: **${gameName}**`);
        }

        // Tạo bảng Embed hiển thị kết quả
        const replyEmbed = new EmbedBuilder()
            .setTitle(`🎉 Kết Quả Tìm Kiếm Script: ${gameName}`)
            .setDescription(`Tìm thấy **${scripts.length}** script từ các nền tảng:`)
            .setColor(0x00FF99)
            .setTimestamp()
            .setFooter({ text: "Bot Tìm Script Tự Động • ScriptBlox & Rscripts" });

        scripts.forEach((script, index) => {
            const scriptCode = script.script;
            // Rút gọn đoạn code nếu dài hơn 200 ký tự
            const formattedCode = scriptCode.length > 200 ? scriptCode.substring(0, 197) + "..." : scriptCode;

            replyEmbed.addFields({
                name: `${index + 1}. [${script.source}] ${script.title} (${script.isPatched ? "❌ Patched" : "✅ Working"})`,
                value: `📜 **Code:**\n\`\`\`lua\n${formattedCode}\n\`\`\``
            });
        });

        // Gửi kết quả về Discord
        await message.channel.send({ embeds: [replyEmbed] });
        console.log(`✅ Đã gửi phản hồi thành công cho game: ${gameName}`);

    } catch (error) {
        console.error("❌ Lỗi hệ thống:", error.message);
        message.channel.send(`⚠️ Lỗi khi lấy dữ liệu script cho game: **${gameName}**`);
    }
});

// 5. Đăng nhập Bot
client.login(BOT_TOKEN);
