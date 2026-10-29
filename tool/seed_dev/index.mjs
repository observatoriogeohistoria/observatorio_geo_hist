// Writes (or deletes, with --clean) test data in the dev Firestore.
// Without --write it only shows what it would do.
import { readFileSync } from 'node:fs';
import { initializeApp, applicationDefault } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import { categories, seedLibrary, seedPosts, seedTeam } from './data.mjs';

const PROJECT = 'observatorio-geo-hist-dev';
const PREFIX = 'seed-';

const args = process.argv.slice(2);
const write = args.includes('--write');
const clean = args.includes('--clean');

// The project is fixed, but a production key passed by mistake would only fail when writing.
const keyPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;
if (!keyPath) {
  console.error('Defina GOOGLE_APPLICATION_CREDENTIALS com a chave da conta de serviço do dev.');
  process.exit(1);
}
const keyProject = JSON.parse(readFileSync(keyPath, 'utf8')).project_id;
if (keyProject !== PROJECT) {
  console.error(`A chave é do projeto "${keyProject}". Este script só roda em ${PROJECT}.`);
  process.exit(1);
}

initializeApp({ credential: applicationDefault(), projectId: PROJECT });
const db = getFirestore();

const writes = [
  ...categories.map((data) => ({ ref: db.collection('posts').doc(data.key), data })),
  ...seedPosts.map((data) => ({
    ref: db.collection('posts').doc(data.categoryId).collection('category_posts').doc(data.id),
    data,
  })),
  ...seedLibrary.map((data) => ({ ref: db.collection('library').doc(data.id), data })),
  ...seedTeam.map((data) => ({ ref: db.collection('team').doc(data.id), data })),
];

async function seedRefsInDatabase() {
  const refs = [];
  const bySeedId = (doc) => doc.id.startsWith(PREFIX);

  const categoryDocs = (await db.collection('posts').get()).docs.filter(bySeedId);
  for (const category of categoryDocs) {
    const postDocs = await category.ref.collection('category_posts').get();
    refs.push(...postDocs.docs.map((doc) => doc.ref));
  }
  refs.push(...categoryDocs.map((doc) => doc.ref));

  for (const name of ['library', 'team']) {
    refs.push(...(await db.collection(name).get()).docs.filter(bySeedId).map((doc) => doc.ref));
  }
  return refs;
}

async function commitInBatches(operations, apply) {
  // Firestore accepts up to 500 operations per batch.
  for (let start = 0; start < operations.length; start += 400) {
    const batch = db.batch();
    for (const operation of operations.slice(start, start + 400)) apply(batch, operation);
    await batch.commit();
  }
}

if (clean) {
  const refs = await seedRefsInDatabase();
  console.log(`${PROJECT}: ${refs.length} documentos de teste (id começando com "${PREFIX}").`);
  if (!write) {
    refs.forEach((ref) => console.log(`  ${ref.path}`));
    if (refs.length) console.log('Nada foi apagado. Rode de novo com --write para apagar.');
    process.exit(0);
  }
  await commitInBatches(refs, (batch, ref) => batch.delete(ref));
  console.log(`${refs.length} documentos apagados.`);
  process.exit(0);
}

const count = (path) => writes.filter(({ ref }) => ref.path.startsWith(path)).length;
console.log(`${PROJECT}:`);
console.log(`  ${categories.length} categorias`);
console.log(`  ${seedPosts.length} posts`);
console.log(`  ${count('library/')} documentos da biblioteca`);
console.log(`  ${count('team/')} membros da equipe`);

if (!write) {
  writes.forEach(({ ref }) => console.log(`  ${ref.path}`));
  console.log('Nada foi gravado. Rode de novo com --write para gravar.');
  process.exit(0);
}

// set without merge: running again resets each test document to the script's state.
await commitInBatches(writes, (batch, { ref, data }) => batch.set(ref, data));
console.log(`${writes.length} documentos gravados.`);
