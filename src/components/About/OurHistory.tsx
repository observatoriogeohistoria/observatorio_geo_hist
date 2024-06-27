import React from "react";
import { Box, Typography } from "@mui/material";
import { styled } from "@mui/system";
import HistoryImage from "../../assets/about/history.png";

const Section = styled(Box)(({ theme }) => ({
  padding: theme.spacing(4),
  textAlign: "center",
}));

const Text = styled(Typography)(({ theme }) => ({
  margin: theme.spacing(2, 0),
  maxWidth: "800px",
  marginLeft: "auto",
  marginRight: "auto",
}));

const Image = styled("img")(({ theme }) => ({
  width: "100%",
  maxWidth: "800px",
  margin: theme.spacing(2, 0),
}));

const OurHistory: React.FC = () => {
  return (
    <Section>
      <Typography variant="h3">NOSSA HISTÓRIA</Typography>
      <Text variant="body1">
        O Observatório do Ensino de História e Geografia nasce da confluência
        entre o espírito acadêmico e o desejo de construir pontes entre
        pesquisadores, professores, estudantes e a sociedade brasileira, dentro
        e fora dos muros escolares e universitários. O Observatório foi
        idealizado e criado pelo Grupo de Estudos e Pesquisas em Ensino de
        Geografia – GEPEGH/UFU, vinculado à Linha de Pesquisa “Saberes e
        Práticas Educativas” do Programa de Pós-Graduação em Educação da
        Universidade Federal de Uberlândia, Minas Gerais, Brasil. O Observatório
        é um espaço formativo e colaborativo, fruto do Projeto de Pesquisa
        Coletivo, financiado pela FAPEMIG (2016-2018), intitulado “Observatório
        do Ensino de História e Geografia em Minas Gerais: políticas
        educacionais, formação docente e produção de conhecimentos”. O projeto
        foi desenvolvido por pesquisadores de diferentes níveis (IC, Mestrado e
        Doutorado), apoiado por diversas instituições.
      </Text>
      <Image src={HistoryImage} alt="Nossa História" />
      <Text variant="body1">
        A investigação realizada se deteve no estudo das três dimensões do
        ensino de História e Geografia em Minas, as quais se refletiram na
        concepção deste Observatório: as políticas públicas educacionais
        voltadas para o desenvolvimento do ensino e aprendizagem de História e
        Geografia implementadas pela Secretaria de Educação do estado (SEE/MG);
        a produção acadêmica (teses e dissertações) das Instituições de Ensino
        Superior (IES) públicas que focalizam o ensino de História e Geografia;
        e, por fim, o lugar do ensino de História e Geografia nos cursos de
        formação inicial de professores das IES públicas.
      </Text>
      <Text variant="body1">
        Embora o foco inicial seja o nosso estado de Minas Gerais, entendemos
        que a missão deste espaço – que é, sobretudo, uma ferramenta para
        divulgação científica –, ultrapassa qualquer fronteira geográfica.
        Concebemos um Observatório capaz de interconectar diversas dimensões e
        realidades que permeiam a educação brasileira e o ensino de História e
        Geografia, congregando saberes, projetos, opiniões, experiências
        educativas e protagonistas de diferentes lugares. Para tanto,
        valorizamos e incentivamos a participação de todos e contamos com o
        poder multiplicador de cada pessoa, seja ela pesquisador, professor ou
        estudante.
      </Text>
    </Section>
  );
};

export default OurHistory;
