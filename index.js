const puppeteer = require('puppeteer')
const fs = require('fs')
const path = require('path')
const bunyan = require('bunyan')
const BunyanFormat = require('bunyan-format')

const PAGE_LOAD_TIME = 10 * 60 * 1000
const STATUS_CODE = {
  OK: 0,
  ERROR: 111
}

const log = bunyan.createLogger({
  name: 'xhtml-validate',
  level: process.env.LOG_LEVEL || 'debug',
  stream: new BunyanFormat({outputMode: process.env.LOG_FORMAT || 'short'})
})

const name = process.argv[2]
const inFile = path.resolve(`./${name}.html`)
const outFile = path.resolve(`./${name}.out.xhtml`)

const url = `file://${inFile}`;

(async () => {
  const browser = await puppeteer.launch({ args: ['--no-sandbox'] })
  const page = await browser.newPage()
  await page.setRequestInterception(true)
  page.on('request', (interceptedRequest) => {
    const url = interceptedRequest.url().split('#')[0].split('?')[0]
    if (url.startsWith('file:') && (url.endsWith('.xhtml') || url.endsWith('.html') || url.endsWith('.css'))) {
      return interceptedRequest.continue()
    }
    interceptedRequest.abort()
  })
  const browserLog = log.child({browser: 'console'})
  page.on('console', msg => {
    switch (msg.type()) {
      case 'error':
        const text = msg.text()
        if (!text.match(/Failed to load resource: net::(ERR_FILE_NOT_FOUND|ERR_FAILED)/)) {
          browserLog.error(msg.text())
        }
        break
      case 'warning':
        browserLog.warn(msg.text())
        break
      case 'info':
        browserLog.info(msg.text())
        break
      case 'log':
        browserLog.debug(msg.text())
        break
      default:
        browserLog.error(msg.type(), msg.text())
        break
    }
  })
  page.on('pageerror', msgText => {
    log.fatal('browser-ERROR', msgText)
    return STATUS_CODE.ERROR
  })

  log.info('Opening XHTML file')
  await page.goto(url, {
    timeout: PAGE_LOAD_TIME
  })
  log.debug('Serializing')
  const pageContent = await page.evaluate(() => {
    const serializer = new window.XMLSerializer()
    return serializer.serializeToString(document.documentElement)
  })
  log.debug('Writing file')
  fs.writeFileSync(outFile, pageContent)
  await browser.close()
})().catch(err => {
  log.fatal(err)
  process.exit(111)
})
