import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';

/// A ordem do enum é a ordem de exibição no site.
enum Partner {
  ufu(
    acronym: 'UFU',
    fullName: 'Universidade Federal de Uberlândia',
    url: 'https://ufu.br',
  ),
  fapemig(
    acronym: 'FAPEMIG',
    fullName: 'Fundação de Amparo à Pesquisa do Estado de Minas Gerais',
    url: 'https://fapemig.br',
  ),
  cnpq(
    acronym: 'CNPq',
    fullName: 'Conselho Nacional de Desenvolvimento Científico e Tecnológico',
    url: 'https://www.gov.br/cnpq',
  ),
  capes(
    acronym: 'CAPES',
    fullName: 'Coordenação de Aperfeiçoamento de Pessoal de Nível Superior',
    url: 'https://www.gov.br/capes',
  ),
  faced(
    acronym: 'FACED',
    fullName: 'Faculdade de Educação da UFU',
    url: 'https://faced.ufu.br',
  ),
  ppged(
    acronym: 'PPGED',
    fullName: 'Programa de Pós-Graduação em Educação da UFU',
    url: 'https://ppged.faced.ufu.br',
  ),
  proexc(
    acronym: 'PROEXC',
    fullName: 'Pró-Reitoria de Extensão e Cultura da UFU',
    url: 'https://proexc.ufu.br',
  ),
  propp(
    acronym: 'PROPP',
    fullName: 'Pró-Reitoria de Pesquisa e Pós-Graduação da UFU',
    url: 'https://propp.ufu.br',
  ),
  uniube(
    acronym: 'UNIUBE',
    fullName: 'Universidade de Uberaba',
    url: 'https://uniube.br',
  );

  const Partner({required this.acronym, required this.fullName, this.url});

  final String acronym;

  final String fullName;

  final String? url;

  String get assetPath => '${AppAssets.partners}/$name.webp';
}
