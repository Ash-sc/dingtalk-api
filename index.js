const Koa = require('koa')
const json = require('koa-json')
const logger = require('koa-logger')
const koaRouter = require('koa-router')
const koaBodyparser = require('koa-bodyparser')
const rp = require('request-promise')

const app = new Koa()
const router = koaRouter()

app.use(koaBodyparser())
app.use(json())
app.use(logger())

app.use(async function(ctx, next) {
  let start = new Date()
  await next()
  let ms = new Date() - start
  console.log('%s %s - %s', ctx.method, ctx.url, ms)
})

app.use(async ctx => {
    console.log(ctx)
    const resp = await rp({
        url: `https://oapi.dingtalk.com${ctx.originalUrl}`,
        method: ctx.method,
        body: ctx.request.body || {},
        json: true
    })
    ctx.body = resp
})

app.on('error', function (err, ctx) {
  console.log('server error', err)
})

app.use(router.routes())

app.listen(3000)