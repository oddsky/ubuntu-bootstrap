// ═══════════════════════════════════════════════════════════════════════════
// CONFIG — edit this section to tune behavior
// ═══════════════════════════════════════════════════════════════════════════

const CONFIG = {
  enabled: true,
  minDuration: 0, // seconds; skip "complete" for sessions shorter than this
  events: {
    permission: true,
    complete: true,
    subagent_complete: false,
    error: true,
    question: true,
    plan_exit: true,
  },
  messages: {
    permission:        "🔒 <b>Permission needed</b>\n<b>{projectName}</b> — {sessionTitle}",
    complete:          "✅ <b>Session complete</b>\n<b>{projectName}</b> — {sessionTitle}",
    subagent_complete: "🤖 <b>Subagent complete</b>\n<b>{projectName}</b> — {sessionTitle}",
    error:             "❌ <b>Error</b>\n<b>{projectName}</b> — {sessionTitle}",
    question:          "❓ <b>Question</b>\n<b>{projectName}</b> — {sessionTitle}",
    plan_exit:         "📋 <b>Plan ready</b>\n<b>{projectName}</b> — {sessionTitle}",
  },
}

// ═══════════════════════════════════════════════════════════════════════════
// LOGIC — do not edit unless you know what you're doing
// ═══════════════════════════════════════════════════════════════════════════

type EventType =
  | "permission"
  | "complete"
  | "subagent_complete"
  | "error"
  | "question"
  | "plan_exit"

const IDLE_DEBOUNCE_MS = 350
const FETCH_TIMEOUT_MS = 10_000

const pendingIdleTimers = new Map<string, ReturnType<typeof setTimeout>>()
const subagentSessionIds = new Set<string>()
const sessionPromptAt = new Map<string, number>()

let credentialsWarned = false

function getEnv(name: string): string | undefined {
  const value = process.env[name]
  if (typeof value === "string" && value.length > 0) {
    return value
  }
  return undefined
}

function getCredentials(): { token: string; chatId: string } | null {
  const token = getEnv("TELEGRAM_BOT_TOKEN")
  const chatId = getEnv("TELEGRAM_CHAT_ID")
  if (!token || !chatId) {
    if (!credentialsWarned) {
      credentialsWarned = true
      console.warn(
        `[telegram-notify] TELEGRAM_BOT_TOKEN or TELEGRAM_CHAT_ID not set in env — plugin is a no-op.`
      )
    }
    return null
  }
  return { token, chatId }
}

function interpolate(
  template: string,
  ctx: { projectName: string | null; sessionTitle: string | null }
): string {
  let out = template
  out = out.replaceAll("{projectName}", ctx.projectName ?? "")
  out = out.replaceAll("{sessionTitle}", ctx.sessionTitle ?? "")
  // Clean trailing separators left by empty placeholders
  out = out.replace(/\s*[:\-|—]\s*$/, "").trim()
  out = out.replace(/\s{2,}/g, " ")
  return out
}

async function sendTelegram(text: string): Promise<void> {
  const creds = getCredentials()
  if (!creds) return

  const url = `https://api.telegram.org/bot${creds.token}/sendMessage`
  const controller = new AbortController()
  const timer = setTimeout(() => controller.abort(), FETCH_TIMEOUT_MS)

  try {
    const response = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        chat_id: creds.chatId,
        text,
        parse_mode: "HTML",
        disable_web_page_preview: true,
      }),
      signal: controller.signal,
    })

    if (!response.ok) {
      const body = await response.text().catch(() => "<no body>")
      console.warn(
        `[telegram-notify] Telegram API error ${response.status}: ${body}`
      )
    }
  } catch (err) {
    const msg = err instanceof Error ? err.message : String(err)
    console.warn(`[telegram-notify] failed to send message: ${msg}`)
  } finally {
    clearTimeout(timer)
  }
}

function getStringField(record: any, key: string): string | null {
  if (!record || typeof record !== "object") return null
  const value = record[key]
  return typeof value === "string" && value.length > 0 ? value : null
}

function getSessionIDFromEvent(event: any): string | null {
  return getStringField(event?.properties, "sessionID")
}

async function getSessionInfo(
  client: any,
  sessionID: string
): Promise<{ title: string | null; parentID: string | null; isChild: boolean }> {
  try {
    const response = await client.session.get({ path: { id: sessionID } })
    const data = response?.data
    const title = getStringField(data, "title")
    const parentID = getStringField(data, "parentID")
    return { title, parentID, isChild: !!parentID }
  } catch {
    return { title: null, parentID: null, isChild: false }
  }
}

async function getLastPromptElapsed(
  client: any,
  sessionID: string,
  nowMs: number = Date.now()
): Promise<number | null> {
  try {
    const response = await client.session.messages({ path: { id: sessionID } })
    const messages = response?.data ?? []
    let lastUserTime: number | null = null
    for (const msg of messages) {
      const role = msg?.info?.role
      const created = msg?.info?.time?.created
      if (role === "user" && typeof created === "number") {
        if (lastUserTime === null || created > lastUserTime) {
          lastUserTime = created
        }
      }
    }
    if (lastUserTime !== null) {
      return (nowMs - lastUserTime) / 1000
    }
  } catch {}
  return null
}

async function handleEvent(
  client: any,
  projectName: string | null,
  eventType: EventType,
  sessionID?: string | null,
  preloadedTitle?: string | null
): Promise<void> {
  if (!CONFIG.enabled) return
  if (!CONFIG.events[eventType]) return

  let sessionTitle: string | null = preloadedTitle ?? null
  if (sessionID && !sessionTitle) {
    const info = await getSessionInfo(client, sessionID)
    sessionTitle = info.title
  }

  const message = interpolate(CONFIG.messages[eventType], {
    projectName,
    sessionTitle,
  })

  await sendTelegram(message)
}

function clearIdleTimer(sessionID: string): void {
  const timer = pendingIdleTimers.get(sessionID)
  if (timer) {
    clearTimeout(timer)
    pendingIdleTimers.delete(sessionID)
  }
}

function scheduleIdle(
  client: any,
  projectName: string | null,
  sessionID: string
): void {
  clearIdleTimer(sessionID)
  const receivedAt = Date.now()

  const timer = setTimeout(() => {
    pendingIdleTimers.delete(sessionID)
    void processIdle(client, projectName, sessionID, receivedAt).catch(() => {})
  }, IDLE_DEBOUNCE_MS)

  pendingIdleTimers.set(sessionID, timer)
}

async function processIdle(
  client: any,
  projectName: string | null,
  sessionID: string,
  receivedAtMs: number
): Promise<void> {
  // Fast path: already known subagent from session lifecycle tracking
  if (subagentSessionIds.has(sessionID)) {
    await handleComplete(client, projectName, sessionID, receivedAtMs, true)
    return
  }

  const info = await getSessionInfo(client, sessionID)
  if (info.isChild) {
    subagentSessionIds.add(sessionID)
    await handleComplete(client, projectName, sessionID, receivedAtMs, true, info.title)
  } else {
    await handleComplete(client, projectName, sessionID, receivedAtMs, false, info.title)
  }
}

async function handleComplete(
  client: any,
  projectName: string | null,
  sessionID: string,
  receivedAtMs: number,
  isSubagent: boolean,
  preloadedTitle?: string | null
): Promise<void> {
  const eventType: EventType = isSubagent ? "subagent_complete" : "complete"
  if (!CONFIG.events[eventType]) return

  if (CONFIG.minDuration > 0) {
    const elapsed = await getLastPromptElapsed(client, sessionID, receivedAtMs)
    if (elapsed !== null && elapsed < CONFIG.minDuration) {
      return
    }
  }

  await handleEvent(client, projectName, eventType, sessionID, preloadedTitle ?? null)
}

// ═══════════════════════════════════════════════════════════════════════════
// PLUGIN EXPORT
// ═══════════════════════════════════════════════════════════════════════════

export const TelegramNotify = async (ctx: any) => {
  const client = ctx.client
  const directory: string | undefined = ctx.directory
  const projectName = directory ? directory.split("/").pop() ?? null : null

  // Memory cleanup every 5 minutes (unref so it doesn't keep the process alive)
  const cleanup = setInterval(() => {
    const cutoff = Date.now() - 5 * 60 * 1000
    for (const [id] of pendingIdleTimers) {
      // keep; nothing to do, timers self-clean
    }
    for (const [id, ts] of sessionPromptAt) {
      if (ts < cutoff) sessionPromptAt.delete(id)
    }
  }, 5 * 60 * 1000)
  cleanup.unref?.()

  return {
    event: async ({ event }: { event: any }) => {
      try {
        // Track subagent sessions from lifecycle events
        if (event.type === "session.created" || event.type === "session.updated") {
          const info = event?.properties?.info
          if (info?.parentID && info?.id) {
            subagentSessionIds.add(info.id)
          }
        }

        if (event.type === "session.deleted") {
          const info = event?.properties?.info
          if (info?.id) {
            subagentSessionIds.delete(info.id)
            clearIdleTimer(info.id)
            sessionPromptAt.delete(info.id)
          }
        }

        // Permission needed (event-based)
        if (event.type === "permission.asked") {
          const sessionID = getSessionIDFromEvent(event)
          await handleEvent(client, projectName, "permission", sessionID)
        }

        // Session idle → complete or subagent_complete (debounced)
        if (event.type === "session.idle") {
          const sessionID = getSessionIDFromEvent(event)
          if (sessionID) {
            scheduleIdle(client, projectName, sessionID)
          } else {
            await handleEvent(client, projectName, "complete")
          }
        }

        // Session busy → cancel pending idle timer (false alarm)
        if (event.type === "session.status" && event?.properties?.status?.type === "busy") {
          const sessionID = getSessionIDFromEvent(event)
          if (sessionID) clearIdleTimer(sessionID)
        }

        // Session error
        if (event.type === "session.error") {
          const errorName = event?.properties?.error?.name
          // MessageAbortedError = user pressed ESC, not a real error
          if (errorName === "MessageAbortedError") return

          const sessionID = getSessionIDFromEvent(event)
          clearIdleTimer(sessionID) // error supersedes completion
          await handleEvent(client, projectName, "error", sessionID)
        }
      } catch (err) {
        const msg = err instanceof Error ? err.message : String(err)
        console.warn(`[telegram-notify] event handler error: ${msg}`)
      }
    },

    "permission.ask": async () => {
      try {
        await handleEvent(client, projectName, "permission")
      } catch (err) {
        const msg = err instanceof Error ? err.message : String(err)
        console.warn(`[telegram-notify] permission.ask handler error: ${msg}`)
      }
    },

    "tool.execute.before": async (input: any) => {
      try {
        const tool = input?.tool
        if (tool === "question") {
          await handleEvent(client, projectName, "question")
        } else if (tool === "plan_exit") {
          await handleEvent(client, projectName, "plan_exit")
        }
      } catch (err) {
        const msg = err instanceof Error ? err.message : String(err)
        console.warn(`[telegram-notify] tool.execute.before handler error: ${msg}`)
      }
    },
  }
}

export default TelegramNotify
