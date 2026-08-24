import assert from 'node:assert/strict';
import test from 'node:test';
import { readFile } from 'node:fs/promises';

test('strips application prefixes before proxying SSR pages and static assets', async () => {
  const nginxConfig = await readFile(new URL('../nginx.conf', import.meta.url), 'utf8');

  assert.match(nginxConfig, /location \^~ \/usuarios\/ \{\s*proxy_pass http:\/\/usuarios-ssr:4000\//s);
  assert.match(nginxConfig, /location \^~ \/productos\/ \{\s*proxy_pass http:\/\/productos-ssr:4000\//s);
});
