import { Box, Typography } from "@mui/material";
import { styled } from "@mui/system";
import React from "react";

const Section = styled(Box)(({ theme }) => ({
  height: `calc(100vh - 144px)`,
  backgroundColor: theme.palette.primary.main,
}));

const Content = styled(Box)(({ theme }) => ({
  width: "90%",
  height: "100%",
  margin: `${theme.spacing(0)} auto`,
  display: "flex",
  flexDirection: "column",
  justifyContent: "center",
}));

const CustomTypography = styled(Typography)(({ theme }) => ({
  color: theme.palette.primary.contrastText,
  marginBottom: theme.spacing(8),
}));

const Row = styled(Box)(({ theme }) => ({
  width: "100%",
  display: "flex",
  flexDirection: "row",
  justifyContent: "space-between",
}));

const Text = styled("div")(({ theme }) => ({
  width: `calc((100vw - 20%) / 2)`,
  color: theme.palette.primary.contrastText,
  fontSize: (theme.typography as any).body1.fontSize,
  textAlign: "justify",
}));

const OurHistory: React.FC = () => {
  return (
    <Section id="OurHistory">
      <Content>
        <CustomTypography variant="h3">NOSSA HISTÓRIA</CustomTypography>
        <Row>
          <Text>
            O Observatório do Ensino de História e Geografia nasce da
            confluência entre o espírito acadêmico e o desejo de construir
            pontes entre pesquisadores, professores, estudantes e a sociedade
            brasileira, dentro e fora dos muros escolares e universitários. O
            Observatório foi idealizado e criado pelo Grupo de Estudos e
            Pesquisas em Ensino de Geografia – GEPEGH/UFU, vinculado à Linha de
            Pesquisa “Saberes e Práticas Educativas” do Programa de
            Pós-Graduação em Educação da Universidade Federal de Uberlândia,
            Minas Gerais, Brasil. O Observatório é um espaço formativo e
            colaborativo, fruto do Projeto de Pesquisa Coletivo, financiado pela
            FAPEMIG (2016-2018), intitulado “Observatório do Ensino de História
            e Geografia em Minas Gerais: políticas educacionais, formação
            docente e produção de conhecimentos”. O projeto foi desenvolvido por
            pesquisadores de diferentes níveis (IC, Mestrado e Doutorado),
            apoiado por diversas instituições.
          </Text>
          <Text>
            A investigação realizada se deteve no estudo das três dimensões do
            ensino de História e Geografia em Minas, as quais se refletiram na
            concepção deste Observatório: as políticas públicas educacionais
            voltadas para o desenvolvimento do ensino e aprendizagem de História
            e Geografia implementadas pela Secretaria de Educação do estado
            (SEE/MG); a produção acadêmica (teses e dissertações) das
            Instituições de Ensino Superior (IES) públicas que focalizam o
            ensino de História e Geografia; e, por fim, o lugar do ensino de
            História e Geografia nos cursos de formação inicial de professores
            das IES públicas.
            <br />
            <br />
            Embora o foco inicial seja o nosso estado de Minas Gerais,
            entendemos que a missão deste espaço – que é, sobretudo, uma
            ferramenta para divulgação científica –, ultrapassa qualquer
            fronteira geográfica. Concebemos um Observatório capaz de
            interconectar diversas dimensões e realidades que permeiam a
            educação brasileira e o ensino de História e Geografia, congregando
            saberes, projetos, opiniões, experiências educativas e protagonistas
            de diferentes lugares. Para tanto, valorizamos e incentivamos a
            participação de todos e contamos com o poder multiplicador de cada
            pessoa, seja ela pesquisador, professor ou estudante.
          </Text>
        </Row>
      </Content>
    </Section>
  );
};

export default OurHistory;
