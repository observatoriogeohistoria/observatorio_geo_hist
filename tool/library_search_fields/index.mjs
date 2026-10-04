// Preenche title_lower, author_lower e institution_lower nos documentos da biblioteca.
// Sem --write só mostra o que mudaria.
import { initializeApp, applicationDefault } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';

const args = process.argv.slice(2);
const project = args[args.indexOf('--project') + 1];
const write = args.includes('--write');

if (!args.includes('--project') || !project || project.startsWith('--')) {
  console.error('Uso: node index.mjs --project <id do projeto> [--write]');
  process.exit(1);
}

initializeApp({ credential: applicationDefault(), projectId: project });
const db = getFirestore();

const lower = (value) => (typeof value === 'string' ? value.toLowerCase() : null);

const snapshot = await db.collection('library').get();
const pending = [];

for (const doc of snapshot.docs) {
  const data = doc.data();
  const fields = {
    title_lower: lower(data.title),
    author_lower: lower(data.author),
    institution_lower: lower(data.institution),
  };
  const changed = Object.entries(fields).some(([key, value]) => data[key] !== value);
  if (changed) pending.push({ ref: doc.ref, fields });
}

console.log(`${project}: ${snapshot.size} documentos, ${pending.length} a atualizar.`);
if (!write) {
  if (pending.length) console.log('Nada foi gravado. Rode de novo com --write para aplicar.');
  process.exit(0);
}

// O Firestore aceita até 500 operações por lote.
for (let start = 0; start < pending.length; start += 400) {
  const batch = db.batch();
  for (const { ref, fields } of pending.slice(start, start + 400)) batch.update(ref, fields);
  await batch.commit();
}
console.log(`${pending.length} documentos atualizados.`);
