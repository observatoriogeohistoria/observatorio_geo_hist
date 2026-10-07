const IMAGE =
  'https://png.pngtree.com/thumb_back/fh260/background/20230527/pngtree-nature-wallpapers-image_2683049.jpg';
const BROKEN_IMAGE = 'https://example.com/imagem-que-nao-existe.jpg';
const PDF = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';

const HISTORY = 'historia';
const GEOGRAPHY = 'geografia';

// O conteúdo rico do painel é um Delta do Quill gravado como texto.
const delta = (...ops) => JSON.stringify(ops);
const paragraph = (text) => ({ insert: `${text}\n` });
const line = (text, attributes) => [{ insert: text }, { insert: '\n', attributes }];

const lorem =
  'O ensino de História e Geografia na educação básica envolve escolhas sobre o que ensinar, ' +
  'como ensinar e para quem ensinar. Este texto existe apenas para testar a apresentação do site ' +
  'com parágrafos de tamanho real, quebras de linha e leitura confortável em telas pequenas.';

export const categories = [
  {
    key: 'seed-ensino-de-historia',
    title: 'Ensino de História',
    description:
      'Publicações sobre práticas, currículo e materiais para o ensino de História na escola.',
    areas: [HISTORY],
    hasCollaborateOption: true,
  },
  {
    key: 'seed-ensino-de-geografia',
    title: 'Ensino de Geografia',
    description: 'Publicações sobre cartografia escolar, território e o ensino de Geografia.',
    areas: [GEOGRAPHY],
    hasCollaborateOption: false,
  },
  {
    key: 'seed-interdisciplinar',
    title: 'Diálogos interdisciplinares entre História, Geografia e outras áreas do conhecimento',
    description:
      'Categoria nas duas áreas e com título longo, para conferir quebra de linha nos menus e cabeçalhos.',
    areas: [HISTORY, GEOGRAPHY],
    hasCollaborateOption: true,
  },
].map((category) => ({
  ...category,
  title_lower: category.title.toLowerCase(),
  backgroundImgUrl: IMAGE,
}));

const [historyCategory, geographyCategory, bothCategory] = categories.map((c) => c.key);

const posts = [
  {
    id: 'seed-artigo-completo',
    categoryId: historyCategory,
    areas: [HISTORY],
    type: 'article',
    isHighlighted: true,
    body: {
      title: 'A escravidão nos livros didáticos: o que mudou depois da Lei 10.639',
      subtitle: 'Artigo com todos os elementos do editor: títulos, listas, citação, link e imagem.',
      authors: ['Maria Aparecida da Silva', 'João Pedro Oliveira'],
      date: '12/09/2026',
      image: IMAGE,
      imageCaption: 'Paisagem usada como imagem de capa. Foto: banco de imagens.',
      content: delta(
        paragraph(lorem),
        ...line('Contexto da pesquisa', { header: 2 }),
        { insert: 'Texto com ' },
        { insert: 'negrito', attributes: { bold: true } },
        { insert: ', ' },
        { insert: 'itálico', attributes: { italic: true } },
        { insert: ' e um ' },
        { insert: 'link externo', attributes: { link: 'https://www.ufu.br' } },
        { insert: '. Cores e tamanhos do editor devem ser ignorados: ' },
        { insert: 'isto estava em vermelho', attributes: { color: '#ff0000', size: 'large' } },
        { insert: '.\n' },
        ...line('Primeiro item da lista', { list: 'bullet' }),
        ...line('Segundo item da lista, um pouco mais longo para quebrar a linha no celular', {
          list: 'bullet',
        }),
        ...line('Terceiro item', { list: 'bullet' }),
        ...line('Metodologia', { header: 3 }),
        ...line('Levantamento das coleções aprovadas no PNLD', { list: 'ordered' }),
        ...line('Análise dos capítulos sobre o período colonial', { list: 'ordered' }),
        ...line('Entrevistas com docentes', { list: 'ordered' }),
        ...line('A memória é um campo de disputa, e a escola é um dos lugares onde ela se forma.', {
          blockquote: true,
        }),
        { insert: { image: IMAGE } },
        { insert: '\n' },
        paragraph(lorem),
        paragraph(lorem),
      ),
      observation: delta(
        { insert: 'Texto publicado originalmente nos anais do ' },
        { insert: 'Encontro Nacional de Ensino de História', attributes: { italic: true } },
        { insert: '.\n' },
      ),
    },
  },
  {
    id: 'seed-artigo-sem-imagem',
    categoryId: bothCategory,
    areas: [HISTORY, GEOGRAPHY],
    type: 'article',
    body: {
      title:
        'Um título de artigo propositalmente muito longo para conferir como o cabeçalho, o card e a navegação se comportam com várias linhas',
      subtitle: '',
      authors: [
        'Ana Beatriz Nascimento',
        'Carlos Eduardo Ferreira',
        'Luíza Helena Tavares',
        'Rafael Augusto Moreira Lima',
      ],
      date: '01/03/2025',
      image: '',
      imageCaption: '',
      content: delta(paragraph(lorem), paragraph(lorem)),
      observation: null,
    },
  },
  {
    id: 'seed-artigo-imagem-quebrada',
    categoryId: geographyCategory,
    areas: [GEOGRAPHY],
    type: 'article',
    body: {
      title: 'Cartografia social com estudantes do ensino médio',
      subtitle: 'A imagem de capa aponta para um endereço que não existe.',
      authors: ['Fernanda Rocha'],
      date: '20/06/2026',
      image: BROKEN_IMAGE,
      imageCaption: 'Legenda de uma imagem que não carrega.',
      content: delta(paragraph(lorem)),
      observation: null,
    },
  },
  {
    id: 'seed-artigo-rascunho',
    categoryId: historyCategory,
    areas: [HISTORY],
    type: 'article',
    isPublished: false,
    body: {
      title: 'Rascunho não publicado (não deve aparecer no site)',
      subtitle: '',
      authors: ['Equipe do Observatório'],
      date: '',
      image: IMAGE,
      imageCaption: '',
      content: delta(paragraph(lorem)),
      observation: null,
    },
  },

  ...['thesis', 'dissertation', 'monography', 'article'].map((category, index) => ({
    id: `seed-producao-${category}`,
    categoryId: index % 2 ? geographyCategory : historyCategory,
    areas: [index % 2 ? GEOGRAPHY : HISTORY],
    type: 'academicProduction',
    isHighlighted: index === 0,
    body: {
      title: [
        'Narrativas indígenas no currículo de História de Minas Gerais',
        'O lugar e a paisagem no ensino de Geografia dos anos iniciais',
        'Patrimônio e memória no ensino de História local',
        'Mapas mentais como avaliação em Geografia',
      ][index],
      category,
      author: ['Juliana Prado', 'Marcos Vinícius Teixeira', 'Patrícia Gomes', 'Tiago Andrade'][
        index
      ],
      advisor: index === 3 ? '' : 'Profa. Dra. Helena Martins',
      institution: 'Universidade Federal de Uberlândia',
      yearAndCity: `Uberlândia, ${2020 + index}`,
      summary: `${lorem}\n\n${lorem}`,
      keywords: 'ensino de história; currículo, formação docente; educação básica.',
      link: index === 2 ? '' : PDF,
      image: IMAGE,
    },
  })),

  {
    id: 'seed-livro',
    categoryId: historyCategory,
    areas: [HISTORY],
    type: 'book',
    body: {
      title: 'Didática da História: fundamentos e práticas',
      category: 'book',
      author: 'Selva Guimarães e outros',
      year: 2019,
      publisher: 'Editora da Universidade',
      synopsis: `${lorem}\n\n${lorem}`,
      link: 'https://www.ufu.br',
      image: IMAGE,
    },
  },
  {
    id: 'seed-ebook',
    categoryId: geographyCategory,
    areas: [GEOGRAPHY],
    type: 'book',
    body: {
      title: 'Geografia escolar e cidadania',
      category: 'ebook',
      author: 'Lana de Souza Cavalcanti',
      year: 0,
      publisher: 'Edição independente',
      synopsis: 'Ebook sem ano informado e sem capa.',
      link: PDF,
      image: '',
    },
  },

  ...[
    ['decree', 'Decreto nº 11.556/2023 — Programa Escola em Tempo Integral', HISTORY],
    ['deliberation', 'Deliberação CEE sobre o currículo do ensino médio', GEOGRAPHY],
    ['normativeDocument', 'Base Nacional Comum Curricular (BNCC)', HISTORY],
    ['law', 'Lei nº 10.639/2003 — História e Cultura Afro-Brasileira', HISTORY],
    ['provisionalMeasure', 'Medida Provisória nº 746/2016 — Reforma do Ensino Médio', GEOGRAPHY],
    ['opinion', 'Parecer CNE/CP nº 3/2004', HISTORY],
    ['ordinance', 'Portaria MEC nº 1.432/2018', GEOGRAPHY],
    ['regiment', 'Regimento interno do Observatório', HISTORY],
    ['regulation', 'Regulamento de estágio supervisionado', GEOGRAPHY],
    ['resolution', 'Resolução CNE/CP nº 2/2019 — Formação de professores', HISTORY],
    ['summary', 'Súmula de jurisprudência sobre educação', GEOGRAPHY],
    ['guide', 'Guia do PNLD 2024 — Ciências Humanas', GEOGRAPHY],
    ['website', 'Portal do Instituto Brasileiro de Geografia e Estatística', GEOGRAPHY],
  ].map(([category, title, area], index) => ({
    id: `seed-documento-${category}`,
    categoryId: area === HISTORY ? historyCategory : geographyCategory,
    areas: [area],
    type: 'document',
    isHighlighted: index === 3,
    body: {
      title,
      category,
      description:
        index % 2
          ? delta(paragraph('Descrição curta em texto rico.'))
          : delta(
              { insert: 'Documento de referência. ' },
              { insert: 'Leitura obrigatória', attributes: { bold: true } },
              { insert: ' para quem atua na educação básica.\n' },
              ...line('Item de destaque', { list: 'bullet' }),
              ...line('Outro item', { list: 'bullet' }),
            ),
      link: category === 'website' ? 'https://www.ibge.gov.br' : PDF,
      image: IMAGE,
    },
  })),

  {
    id: 'seed-evento-nacional',
    categoryId: historyCategory,
    areas: [HISTORY],
    type: 'event',
    isHighlighted: true,
    body: {
      title: 'XIV Encontro Nacional Perspectivas do Ensino de História',
      scope: 'national',
      link: 'https://www.ufu.br',
      location: 'Campus Santa Mônica, Bloco 5O',
      city: 'Uberlândia (MG)',
      date: '14/11/2026',
      time: '8h às 18h',
      details: `${lorem}\n\nInscrições abertas até 30/10.`,
      image: IMAGE,
    },
  },
  {
    id: 'seed-evento-internacional',
    categoryId: geographyCategory,
    areas: [GEOGRAPHY],
    type: 'event',
    body: {
      title: 'Colóquio Internacional de Cartografia Escolar',
      scope: 'international',
      link: 'https://www.ufu.br',
      location: 'Online',
      city: 'Lisboa (Portugal)',
      date: '06 a 10 de julho de 2027',
      time: null,
      details: null,
      image: IMAGE,
    },
  },
  {
    id: 'seed-evento-data-livre',
    categoryId: bothCategory,
    areas: [HISTORY, GEOGRAPHY],
    type: 'event',
    body: {
      title: 'Roda de conversa sem data definida',
      scope: 'national',
      link: '',
      location: 'A definir',
      city: 'Uberlândia (MG)',
      date: 'Segundo semestre de 2027',
      time: '',
      details: 'Data em texto livre que não vira caixa de dia e mês.',
      image: '',
    },
  },

  ...['movie', 'documentary', 'shortFilm', 'series'].map((category, index) => ({
    id: `seed-filme-${category}`,
    categoryId: index % 2 ? geographyCategory : historyCategory,
    areas: [index % 2 ? GEOGRAPHY : HISTORY],
    type: 'film',
    isHighlighted: index === 1,
    body: {
      title: ['Narradores de Javé', 'Ilha das Flores', 'Vida Maria', 'Guerras do Brasil.doc'][index],
      category,
      releaseYear: [2003, 1989, 2006, 2018][index],
      duration: ['1h40', '13 min', '9 min', '5 episódios'][index],
      director: ['Eliane Caffé', 'Jorge Furtado', 'Márcio Ramos', 'Luiz Bolognesi'][index],
      country: 'Brasil',
      synopsis:
        index === 0
          ? delta(
              paragraph(lorem),
              { insert: 'Indicado para ' },
              { insert: 'ensino médio', attributes: { bold: true } },
              { insert: '.\n' },
            )
          : `Sinopse em texto simples (registros antigos). ${lorem}`,
      link: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      image: index === 3 ? '' : IMAGE,
    },
  })),

  {
    id: 'seed-revista',
    categoryId: historyCategory,
    areas: [HISTORY],
    type: 'magazine',
    body: {
      title: 'Revista Ensino em Re-Vista',
      category: 'magazine',
      teaser: 'Periódico da Faculdade de Educação da UFU.',
      description: `${lorem}\n\n${lorem}`,
      link: 'https://seer.ufu.br',
      image: IMAGE,
    },
  },
  {
    id: 'seed-dossie',
    categoryId: geographyCategory,
    areas: [GEOGRAPHY],
    type: 'magazine',
    body: {
      title: 'Dossiê: Geografia escolar e mudanças climáticas',
      category: 'dossier',
      teaser: null,
      description: 'Dossiê sem chamada (teaser).',
      link: '',
      image: IMAGE,
    },
  },

  {
    id: 'seed-musica-com-letra',
    categoryId: historyCategory,
    areas: [HISTORY],
    type: 'music',
    body: {
      title: 'Canção do Exílio (versão popular)',
      artistName: 'Artista de Teste',
      description: 'Música para discutir identidade nacional e romantismo em sala de aula.',
      lyrics: delta(
        paragraph('Minha terra tem palmeiras'),
        paragraph('Onde canta o sabiá'),
        paragraph('As aves que aqui gorjeiam'),
        paragraph('Não gorjeiam como lá'),
        { insert: 'Refrão em itálico\n', attributes: { italic: true } },
      ),
      link: 'https://open.spotify.com/track/4uLU6hMCjMI75M1A2tKUQC',
      image: IMAGE,
    },
  },
  {
    id: 'seed-musica-sem-letra',
    categoryId: geographyCategory,
    areas: [GEOGRAPHY],
    type: 'music',
    body: {
      title: 'Asa Branca',
      artistName: 'Luiz Gonzaga e Humberto Teixeira',
      description: 'Seca, migração e o sertão nordestino na música popular.',
      lyrics: null,
      link: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      image: '',
    },
  },

  {
    id: 'seed-podcast-historia',
    categoryId: historyCategory,
    areas: [HISTORY],
    type: 'podcast',
    body: {
      title: 'Episódio 12: Ensinar a ditadura militar na escola',
      description: `${lorem}\n\nParticipação de professoras da rede municipal.`,
      link: 'https://open.spotify.com/episode/7makk4oTQel546B0PZlDM5',
      image: IMAGE,
    },
  },
  {
    id: 'seed-podcast-geografia',
    categoryId: geographyCategory,
    areas: [GEOGRAPHY],
    type: 'podcast',
    body: {
      title: 'Episódio 3: Cidades, mobilidade e o lugar do estudante',
      description: 'Podcast sem link, para conferir o estado sem botão de ouvir.',
      link: '',
      image: IMAGE,
    },
  },

  {
    id: 'seed-pesquisa-andamento',
    categoryId: geographyCategory,
    areas: [GEOGRAPHY],
    type: 'search',
    isHighlighted: true,
    body: {
      title: 'Observatório das práticas de ensino de Geografia no Triângulo Mineiro',
      state: 'inProgress',
      image: IMAGE,
      imageCaption: 'Mapa da região estudada.',
      description: delta(
        paragraph(lorem),
        ...line('Objetivos', { header: 3 }),
        ...line('Mapear as práticas docentes', { list: 'bullet' }),
        ...line('Produzir materiais didáticos', { list: 'bullet' }),
      ),
      coordinator: 'Profa. Dra. Helena Martins',
      researcher: 'Juliana Prado',
      advisor: 'Prof. Dr. Roberto Campos',
      coAdvisor: 'Profa. Dra. Sílvia Mendes',
      members:
        'Ana Beatriz Nascimento, Carlos Eduardo Ferreira, Luíza Helena Tavares, Rafael Augusto Moreira Lima, Tiago Andrade',
      financier: 'FAPEMIG',
    },
  },
  {
    id: 'seed-pesquisa-concluida',
    categoryId: historyCategory,
    areas: [HISTORY],
    type: 'search',
    body: {
      title: 'Memórias de professores de História (1980–2000)',
      state: 'completed',
      image: '',
      imageCaption: '',
      description: delta(paragraph('Pesquisa concluída, só com os campos obrigatórios.')),
      coordinator: null,
      researcher: null,
      advisor: null,
      coAdvisor: null,
      members: null,
      financier: null,
    },
  },
];

// Datas espaçadas de um dia mantêm a ordem da lista (mais novo primeiro) previsível.
const now = Date.now();
export const seedPosts = posts.map((post, index) => {
  const date = new Date(now - index * 24 * 60 * 60 * 1000).toISOString();
  return {
    ...post,
    body: { ...post.body, title_lower: post.body.title.toLowerCase() },
    createdAt: date,
    updatedAt: date,
    isPublished: post.isPublished ?? true,
    isHighlighted: post.isHighlighted ?? false,
  };
});

const geographyLibrary = [
  'Avaliação',
  'Conceitos geográficos',
  'Currículo e políticas públicas',
  'Ensino de Geografia e diversidade',
  'Ensino de Geografia e inclusão',
  'Formação de professores',
  'Linguagem Cartográfica',
  'Livro didático e História da Geografia escolar',
  'Metodologia práticas e linguagens',
  'Natureza e meio ambiente',
];
const historyLibrary = [
  'Currículo',
  'Formação e prática docente',
  'Juventude e identidade',
  'Linguagens',
  'Livro didático',
  'Relações étnico-raciais',
];
const institutions = [
  'Universidade Federal de Uberlândia',
  'Universidade de São Paulo',
  'Universidade Federal de Minas Gerais',
  'Universidade Estadual de Campinas',
];
const authors = [
  'Juliana Prado',
  'Marcos Vinícius Teixeira',
  'Patrícia Gomes',
  'Tiago Andrade',
  'Fernanda Rocha',
  'Ana Beatriz Nascimento',
];

const libraryEntry = (area, category, index) => ({
  id: `seed-biblioteca-${area === 'Geografia' ? 'geo' : 'hist'}-${index + 1}`,
  area,
  title: `${category}: um estudo sobre o ensino de ${area} na educação básica`,
  author: authors[index % authors.length],
  type: index % 2 ? 'Dissertação' : 'Tese',
  category: [category],
  documentUrl: PDF,
  institution: institutions[index % institutions.length],
  year: 2010 + index,
  status: null,
});

const library = [
  ...geographyLibrary.map((category, index) => libraryEntry('Geografia', category, index)),
  ...historyLibrary.map((category, index) => libraryEntry('História', category, index)),
  {
    id: 'seed-biblioteca-varias-categorias',
    area: 'Geografia',
    title: 'Documento em várias categorias ao mesmo tempo',
    author: 'Rafael Augusto Moreira Lima',
    type: 'Tese',
    category: ['Avaliação', 'Formação de professores', 'Linguagem Cartográfica'],
    documentUrl: PDF,
    institution: 'Universidade Federal de Uberlândia',
    year: 2024,
    status: null,
  },
  {
    id: 'seed-biblioteca-sem-arquivo',
    area: 'História',
    title:
      'Documento sem arquivo, sem instituição, sem ano e com um título bem longo para conferir a quebra de linha na lista e no detalhe',
    author: 'Luíza Helena Tavares',
    type: 'Dissertação',
    category: ['Relações étnico-raciais', 'Currículo'],
    documentUrl: null,
    institution: null,
    year: null,
    status: null,
  },
  {
    id: 'seed-biblioteca-sem-tipo',
    area: 'História',
    title: 'Documento sem tipo e sem categoria',
    author: 'Carlos Eduardo Ferreira',
    type: null,
    category: [],
    documentUrl: PDF,
    institution: 'Universidade de São Paulo',
    year: 2008,
    status: null,
  },
];

export const seedLibrary = library.map((doc, index) => ({
  ...doc,
  title_lower: doc.title.toLowerCase(),
  author_lower: doc.author.toLowerCase(),
  institution_lower: doc.institution?.toLowerCase() ?? null,
  createdAt: new Date(now - index * 24 * 60 * 60 * 1000).toISOString(),
}));

// Só quem tem descrição ganha página; sem descrição, o card leva ao Lattes, se houver.
export const seedTeam = [
  {
    id: 'seed-membro-coordenadora',
    name: 'Helena Martins',
    role: 'Coordenadora',
    description: `${lorem}\n\nPossui doutorado em Educação e atua na formação de professores de História desde 2005.`,
    lattesUrl: 'http://lattes.cnpq.br/0000000000000000',
    image: IMAGE,
  },
  {
    id: 'seed-membro-sem-foto',
    name: 'Ângela Ribeiro dos Santos',
    role: 'Pesquisadora',
    description: 'Membro com descrição e sem foto: tem página própria e avatar de placeholder.',
    lattesUrl: '',
    image: null,
  },
  {
    id: 'seed-membro-so-lattes',
    name: 'Bruno Carvalho',
    role: 'Bolsista de Iniciação Científica',
    description: '',
    lattesUrl: 'http://lattes.cnpq.br/0000000000000001',
    image: IMAGE,
  },
  {
    id: 'seed-membro-sem-link',
    name: 'Érica Lima',
    role: 'Colaboradora externa',
    description: '',
    lattesUrl: '',
    image: BROKEN_IMAGE,
  },
  {
    id: 'seed-membro-nome-longo',
    name: 'Maria Eduarda Albuquerque de Vasconcelos Figueiredo',
    role: 'Professora da Educação Básica e Mestranda em Ensino de Geografia',
    description: 'Nome e função longos para conferir quebra de linha no card e na página.',
    lattesUrl: 'http://lattes.cnpq.br/0000000000000002',
    image: IMAGE,
  },
];
