## 测试是否可用
## curl "https://api.telegram.org/bot1655555505:ddddddwwwwwww/sendMessage" -d "chat_id=444444444&text=开始编译"  改为自己的反代地址和bot信息，ssh命令返回成功即可
## curl "https://cloudflare的反代地址/botTOKEN/sendMessage" -d "chat_id=TGID&text=开始编译" 
## 比如我的是 curl "https://silent-term-lang.2794375.workers.dev/bot162258593:AAGeQmivyLJjVC5iydQkq/sendMessage" -d "chat_id=12090858&text=开始编译"

const whitelist = ["/bot"];
const tg_host = "api.telegram.org";

addEventListener('fetch', event => {
    event.respondWith(handleRequest(event.request))
})

function validate(path) {
    for (var i = 0; i < whitelist.length; i++) {
        if (path.startsWith(whitelist[i]))
            return true; 
    }
    return false;
}

async function handleRequest(request) {
    var u = new URL(request.url);
    u.host = tg_host;
    if (!validate(u.pathname))
        return new Response('Unauthorized', {
            status: 403
        });
    var req = new Request(u, {
        method: request.method,
        headers: request.headers,
        body: request.body
    });
    const result = await fetch(req);
    return result;
}
