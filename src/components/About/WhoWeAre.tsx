import { Box, Typography } from "@mui/material";
import { styled } from "@mui/system";
import React from "react";
import WhoWeAreImage from "../../assets/about/who-we-are.png";

const Section = styled(Box)(({ theme }) => ({
  height: `calc(100vh - 144px)`,

  backgroundSize: "cover",
  backgroundPosition: "center",

  display: "flex",
  flexDirection: "column",
  justifyContent: "center",
  alignItems: "center",

  textAlign: "center",

  "&::before": {
    content: '""',
    position: "absolute",
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundImage: `url(${WhoWeAreImage})`,
    backgroundSize: "cover",
    backgroundPosition: "center",
    opacity: 0.4,
    zIndex: -1,
  },
}));

const CustomTypography = styled(Typography)(({ theme }) => ({
  color: theme.palette.primary.contrastText,
}));

const Text = styled(Typography)(({ theme }) => ({
  margin: `${theme.spacing(4)} auto`,
  maxWidth: "800px",
  color: theme.palette.secondary.main,
  fontWeight: (theme.typography as any).fontWeightMedium,
  textAlign: "justify",
}));

const WhoWeAre: React.FC = () => {
  return (
    <Section id="WhoWeAre">
      <CustomTypography variant="h2">QUEM SOMOS</CustomTypography>
      <Text variant="body1">
        O Observatório de Ensino de História e Geografia é um espaço digital que
        possibilita o acesso, compartilhamento, a colaboração e a produção de
        conhecimentos. Nosso objetivo é oferecer um espaço/tempo que facilite o
        acesso a uma plataforma que congregue narrativas, dados, documentos,
        pesquisas, experiências didáticas e materiais diversos sobre o ensino e
        a aprendizagem de História e Geografia. O Observatório é destinado a
        professores, pesquisadores e estudantes que queiram conhecer e se
        aprofundar em discussões sobre práticas e saberes educativos. Nossa
        missão é promover a divulgação de conhecimentos relevantes e a
        circulação de saberes que contribuam para a formação permanente de
        professores e profissionais que atuam no campo do ensino de História,
        Geografia e áreas afins.
      </Text>
    </Section>
  );
};

export default WhoWeAre;
