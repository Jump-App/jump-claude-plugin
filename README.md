# Jump for Financial Advisors

Claude skills for financial advisors who use [Jump](https://jumpapp.com). They answer everyday questions about client meetings and follow-ups using Jump's connector.

For financial professional use only; not investment, legal, or tax advice.

## Skills

| Skill | Ask Claude |
|---|---|
| `client-commitments` | "What have I promised the Reynolds that isn't done?" / "What did I commit to this week?" |
| `decision-log` | "What did we decide with the Lees about their Roth conversion?" |
| `last-meeting-recap` | "Where did we leave off with the Kims?" |
| `client-meeting-history` | "Pull up all our meetings with the Reynolds." / "What have we discussed with the Lees across our meetings?" |
| `week-in-review` | "Recap my week: who I met, what I promised, what's due." |
| `yesterday` | "Overview of yesterday's meetings and takeaways." |
| `recap-email` | "Draft a recap email for my meeting with Joe Smith yesterday." |
| `document-lookup` | "Find the Smiths' latest brokerage statement." |

## What the skills can access

- Read-only access to the signed-in advisor's Jump meetings, contacts, tasks and documents. Nothing is written back to Jump or any other system.
- Full meeting transcripts and recordings are not available through the connector. The skills work from meeting summaries, notes, tasks and documents.
- Answers link each meeting, task and document back to Jump and say which meetings or dates were checked.
- Recap emails are drafts for the advisor to review and send. The skills never send email.
- The plugin stores no client data.

## Requirements

- A Claude surface that supports plugins (Claude Code, Claude Desktop or claude.ai).
- A Jump account with the MCP Client(s) setting turned on by the firm (Settings → Compliance → Access Restrictions).
- The Jump connector (`https://my.jumpapp.com/mcp`), authorized with the advisor's Jump login.

## Installing

Install the plugin from the Claude plugin directory. It includes the Jump connector, so Claude asks you to sign in to Jump the first time a skill needs it.

To try it locally in Claude Code, clone this repository and run:

```sh
claude --plugin-dir .
```

Then authorize the connector with `/mcp`.

## Support

- Help center: https://help.jumpapp.com
- Email: support@jumpapp.com

## Development

Check the plugin before every commit:

```sh
scripts/check-skills.sh
```

It validates the manifests, each skill's frontmatter, the Jump tool names the skills mention, that no skill asks for a full transcript, that no `.DS_Store` files are left, and that `.mcp.json` points to production.

To try the skills against a local Jump server, change the URL in `.mcp.json` to `http://localhost:4000/mcp` without committing it, then run `claude --plugin-dir .` and authorize the connector with `/mcp`.
