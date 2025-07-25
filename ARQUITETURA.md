# Documentação da Arquitetura do Projeto Observatório Geo-Hist

## Visão Geral

O projeto **Observatório Geo-Hist** é uma aplicação Flutter que implementa uma arquitetura robusta baseada em **Clean Architecture** e **Domain-Driven Design (DDD)**, organizada em camadas bem definidas e com separação clara de responsabilidades. A aplicação utiliza Firebase como backend e implementa padrões de injeção de dependência para facilitar testes e manutenção.

## Estrutura de Diretórios

```
lib/
├── main.dart                          # Ponto de entrada da aplicação
├── firebase_options.dart              # Configurações do Firebase
└── app/
    ├── app_setup.dart                 # Configuração principal de DI
    ├── app_widget.dart                # Widget raiz da aplicação
    ├── router/                        # Sistema de roteamento
    ├── theme/                         # Configurações de tema
    ├── core/                          # Camada compartilhada
    └── features/                      # Funcionalidades específicas
```

## Arquitetura em Camadas

### 1. Camada de Apresentação (Presentation Layer)

**Localização:** `lib/app/features/{feature}/presentation/`

Esta camada é responsável pela interface do usuário e contém:

- **Pages:** Telas principais da aplicação
- **Components:** Widgets reutilizáveis específicos da feature
- **Stores:** Gerenciamento de estado usando MobX
- **Stores/States:** Estados específicos para cada operação

**Exemplo de estrutura:**
```
presentation/
├── pages/
│   ├── home_page.dart
│   └── post_detailed_page.dart
├── components/
│   ├── post_card.dart
│   └── category_filter.dart
└── stores/
    ├── fetch_posts_store.dart
    └── states/
        └── fetch_posts_states.dart
```

### 2Camada de Infraestrutura (Infrastructure Layer)

**Localização:** `lib/app/features/{feature}/infra/`

Esta camada implementa a comunicação com serviços externos:

- **Datasources:** Implementação concreta de acesso a dados
- **Repositories:** Implementação concreta dos repositórios
- **Models:** Modelos de dados específicos da feature
- **Errors:** Tratamento de erros específicos

**Exemplo de estrutura:**
```
infra/
├── datasources/
│   ├── fetch_posts_datasource.dart
│   └── firebase_auth_datasource.dart
├── repositories/
│   └── fetch_posts_repository.dart
├── models/
│   └── library_document_model.dart
└── errors/
    └── fetch_posts_failures.dart
```

### 3. Camada Core (Shared Layer)

**Localização:** `lib/app/core/`

Esta camada contém componentes compartilhados por toda a aplicação:

#### 3.1Componentes Reutilizáveis (`core/components/`)
```
components/
├── buttons/           # Botões customizados
├── card/             # Cards reutilizáveis
├── dialog/           # Diálogos e modais
├── field/            # Campos de formulário
├── image/            # Componentes de imagem
├── loading/          # Indicadores de carregamento
├── navbar/           # Navegação
├── quill/            # Editor de texto rico
├── scroll/           # Componentes de scroll
├── skeleton/         # Placeholders de carregamento
├── text/             # Componentes de texto
└── video_player/     # Player de vídeo
```

#### 30.2Modelos Compartilhados (`core/models/`)
```
models/
├── post_model.dart           # Modelo principal de posts
├── category_model.dart       # Modelo de categorias
├── academic_production_model.dart
├── article_model.dart
├── book_model.dart
├── document_model.dart
├── event_model.dart
├── film_model.dart
├── magazine_model.dart
├── music_model.dart
├── podcast_model.dart
├── search_model.dart
├── artist_model.dart
├── image_model.dart
├── navbutton_item.dart
├── general_state.dart
└── paginated/              # Modelos de paginação
```

#### 3.3Utilitários (`core/utils/`)
```
utils/
├── constants/        # Constantes da aplicação
├── device/          # Utilitários de dispositivo
├── enums/           # Enums compartilhados
├── extensions/      # Extensões de classes
├── formatters/      # Formatadores
├── generator/       # Geradores de ID
├── image/           # Utilitários de imagem
├── messenger/       # Sistema de mensagens
├── strings/         # Utilitários de string
├── transitions/     # Transições de tela
├── url/             # Utilitários de URL
└── validators/      # Validadores
```

#### 3.4nfraestrutura Compartilhada (`core/infra/`)
```
infra/
├── datasources/     # Datasources compartilhados
├── repositories/    # Repositórios compartilhados
└── services/        # Serviços compartilhados
    └── logger_service/
```

####35ciamento de Estado (`core/stores/`)
```
stores/
├── fetch_categories_store.dart
├── fetch_categories_store.g.dart
└── states/
    └── fetch_categories_states.dart
```

## Features (Funcionalidades)

### 1me (`features/home/`)
**Responsabilidade:** Página inicial da aplicação
- **Apresentação:** Componentes da home, equipe, destaques
- **Infraestrutura:** Busca de dados da equipe e destaques
- **Setup:** Configuração de DI específica

### 2. Posts (`features/posts/`)
**Responsabilidade:** Gerenciamento de posts e conteúdo
- **Apresentação:** Listagem, detalhes e colaboração
- **Infraestrutura:** Busca paginada e filtros
- **Setup:** Configuração de DI específica

### 3. Admin (`features/admin/`)
**Responsabilidade:** Painel administrativo
- **Subfeatures:**
  - **Login:** Autenticação de usuários
  - **Panel:** Gerenciamento de conteúdo
  - **Sidebar:** Navegação do painel
- **Setup:** Configuração de DI específica

### 4. Library (`features/libray/`)
**Responsabilidade:** Biblioteca de documentos
- **Apresentação:** Interface da biblioteca
- **Infraestrutura:** Busca e contagem de documentos
- **Setup:** Configuração de DI específica

### 5. Geoensine (`features/geoensine/`)
**Responsabilidade:** Seção específica do projeto Geoensine
- **Apresentação:** Páginas específicas do projeto

## Padrões Arquiteturais Implementados

### 1. Clean Architecture
- **Separação de responsabilidades** entre camadas
- **Independência de frameworks** externos
- **Testabilidade** facilitada pela injeção de dependência
- **Independência de UI** através de abstrações

### 2. Domain-Driven Design (DDD)
- **Features** como bounded contexts
- **Modelos** específicos para cada domínio
- **Linguagem ubíqua** através de enums e constantes

### 3. Dependency Injection
- **GetIt** como container de DI
- **Setup classes** para configuração de cada feature
- **LazySingleton** para serviços compartilhados
- **Factory** para instâncias que precisam ser recriadas

### 4. Repository Pattern
- **Abstrações** definem contratos
- **Implementações** concretas para Firebase
- **Tratamento de erros** através de Either (fpdart)

### 5. State Management
- **MobX** para gerenciamento de estado reativo
- **Stores** organizados por feature
- **States** específicos para cada operação

## Sistema de Roteamento

### GoRouter
- **Roteamento declarativo** com GoRouter
- **Proteção de rotas** com autenticação
- **Parâmetros dinâmicos** para posts e categorias
- **Redirecionamentos** automáticos

### Estrutura de Rotas
```dart
/                           # Home
/posts/:area/:category      # Lista de posts
/posts/:area/:category/:id  # Detalhes do post
/contato                    # Página de contato
/colaborar                  # Página de colaboração
/manifest                   # Manifesto
/admin                      # Login administrativo
/admin/painel/:tab          # Painel administrativo
/geoensine                  # Seção Geoensine
```

## Configuração e Setup

### AppSetup (`app_setup.dart`)
Configuração principal da aplicação:
- **Serviços compartilhados** (Logger, Firebase)
- **Features** através de setup específicos
- **Injeção de dependência** centralizada

### Feature Setup
Cada feature possui seu próprio setup:
- **AdminSetup:** Configuração de autenticação e painel
- **HomeSetup:** Configuração de busca de dados da home
- **PostsSetup:** Configuração de busca de posts

## Modelos de Dados

### PostModel (Polimórfico)
```dart
class PostModel {
  final PostType type;
  final PostBody? body;  // Implementação polimórfica
  // ... outros campos
}
```

### PostBody (Abstração)
```dart
abstract class PostBody {
  final String title;
  final ImageModel image;
  // Métodos abstratos
}
```

### Implementações Concretas
- **AcademicProductionModel**
- **ArticleModel**
- **BookModel**
- **DocumentModel**
- **EventModel**
- **FilmModel**
- **MagazineModel**
- **MusicModel**
- **PodcastModel**
- **SearchModel**

## Tratamento de Erros

### Failures Pattern
- **Failures** como classes de erro específicas
- **Either** para tratamento funcional de erros
- **Repository pattern** com Either<Failure, Success>

### Exemplo de Uso
```dart
Future<Either<Failure, PaginatedPosts>> fetchPosts(...) async {
  try [object Object]// Lógica de busca
    return Right(posts);
  } catch (error) [object Object] return const Left(FetchPostsFailure());
  }
}
```

## Componentes Reutilizáveis

### Design System
- **AppColors:** Paleta de cores consistente
- **AppTypography:** Tipografia padronizada
- **AppDimensions:** Dimensões responsivas
- **AppTheme:** Tema unificado

### Componentes Base
- **AppButton:** Botões padronizados
- **AppCard:** Cards reutilizáveis
- **AppTextField:** Campos de texto
- **AppLoading:** Indicadores de carregamento
- **AppError:** Tratamento de erros

## Firebase Integration

### Serviços Utilizados
- **Firestore:** Banco de dados NoSQL
- **Firebase Auth:** Autenticação
- **Firebase Storage:** Armazenamento de arquivos

### Padrões de Query
- **Collection Groups:** Para busca em subcoleções
- **Paginação:** Com DocumentSnapshot
- **Filtros:** Where clauses otimizadas
- **Agregações:** Count() para contagens

## Vantagens da Arquitetura

1. **Escalabilidade:** Fácil adição de novas features
2**Testabilidade:** Separação clara facilita testes unitários
3. **Manutenibilidade:** Código organizado e bem estruturado4 **Reutilização:** Componentes compartilhados
5**Flexibilidade:** Mudanças isoladas por feature
6. **Performance:** Lazy loading e otimizações

## Considerações de Performance
1nação:** Implementada em todas as listas2 **Lazy Loading:** Componentes carregados sob demanda
3. **Caching:** Firebase SDK gerencia cache automaticamente
4**Otimização de Queries:** Índices e filtros otimizados
5. **Componentes Otimizados:** Skeleton loading e estados de erro

## Tecnologias e Bibliotecas Principais

### Core
- **Flutter:** Framework de desenvolvimento
- **Dart:** Linguagem de programação
- **GetIt:** Injeção de dependência
- **MobX:** Gerenciamento de estado
- **fpdart:** Programação funcional (Either)

### Firebase
- **cloud_firestore:** Banco de dados
- **firebase_auth:** Autenticação
- **firebase_storage:** Armazenamento

### UI/UX
- **go_router:** Roteamento
- **flutter_quill:** Editor de texto rico
- **video_player:** Player de vídeo
- **url_launcher:** Abertura de URLs

### Utilitários
- **equatable:** Comparação de objetos
- **intl:** Internacionalização
- **image_picker:** Seleção de imagens

## Convenções de Nomenclatura

### Arquivos e Pastas
- **snake_case:** Para nomes de arquivos e pastas
- **PascalCase:** Para nomes de classes
- **camelCase:** Para variáveis e métodos

### Padrões de Nomenclatura
- **Datasource:** `{Feature}Datasource`
- **Repository:** `{Feature}Repository`
- **Store:** `{Feature}Store`
- **Model:** `{Feature}Model`
- **Page:** `{Feature}Page`
- **Component:** `{Feature}Component`

## Fluxo de Dados

###1resentação → Store
```dart
// Widget chama método do store
store.fetchPosts(category);
```

### 2. Store → Repository
```dart
// Store chama repository
final result = await repository.fetchPosts(category);
```

### 3. Repository → Datasource
```dart
// Repository chama datasource
final posts = await datasource.fetchPosts(category);
```

### 4. Datasource → Firebase
```dart
// Datasource faz query no Firebase
final snapshot = await firestore.collection('posts').get();
```

## Testes

### Estrutura de Testes
```
test/
├── unit/              # Testes unitários
├── widget/            # Testes de widget
└── integration/       # Testes de integração
```

### Padrões de Teste
- **Mock:** Para dependências externas
- **Fake:** Para implementações simples
- **Stub:** Para dados de teste
- **Spy:** Para verificar chamadas

## Deploy e CI/CD

### Configurações
- **Firebase Hosting:** Para web
- **GitHub Actions:** Para CI/CD
- **FVM:** Para versionamento do Flutter

### Processo de Deploy
1 **Build:** Compilação para web2**Test:** Execução de testes
3. **Deploy:** Publicação no Firebase Hosting

## Manutenção e Evolução

### Adicionando Novas Features
1Criar estrutura de pastas em `features/`
2mplementar camadas (presentation, infra)
3. Configurar DI no setup da feature
4Adicionar rotas no router
5. Implementar testes

### Refatorações Comuns
- **Extração de componentes:** Para reutilização
- **Separação de responsabilidades:** Para manutenibilidade
- **Otimização de queries:** Para performance
- **Melhoria de UX:** Para experiência do usuário

---

Esta arquitetura proporciona uma base sólida para o crescimento e manutenção do projeto, seguindo as melhores práticas de desenvolvimento Flutter e Clean Architecture. 