// wrangler.toml: name = "my-worker", compatibility_date = "2024-01-01"

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url)

    // Basic JSON response — sets Content-Type automatically
    if (url.pathname === '/api/ping') {
      return Response.json({ ok: true, ts: Date.now() })
    }

    // Custom status code
    if (url.pathname === '/api/created') {
      return Response.json({ id: 42, name: 'item' }, { status: 201 })
    }

    // Custom headers alongside JSON
    if (url.pathname === '/api/cached') {
      return Response.json(
        { data: 'hello' },
        {
          status: 200,
          headers: {
            'Cache-Control': 'public, max-age=60',
            'X-Worker-Region': request.cf?.colo ?? 'unknown',
          },
        }
      )
    }

    return Response.json({ error: 'Not Found' }, { status: 404 })
  },
}
